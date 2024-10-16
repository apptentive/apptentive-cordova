package com.apptentive.cordova

import android.app.Activity
import android.content.Context
import apptentive.com.android.feedback.Apptentive
import apptentive.com.android.feedback.ApptentiveActivityInfo
import apptentive.com.android.feedback.ApptentiveConfiguration
import apptentive.com.android.feedback.EngagementResult
import apptentive.com.android.feedback.model.EventNotification
import apptentive.com.android.feedback.model.MessageCenterNotification
import apptentive.com.android.feedback.RegisterResult
import apptentive.com.android.util.InternalUseOnly
import apptentive.com.android.util.Log
import apptentive.com.android.util.LogLevel
import apptentive.com.android.util.LogTag
import org.apache.cordova.CallbackContext
import org.apache.cordova.CordovaPlugin
import org.apache.cordova.PluginResult
import org.json.JSONArray
import org.json.JSONException

@OptIn(InternalUseOnly::class)
class ApptentiveBridge : CordovaPlugin(), ApptentiveActivityInfo {

  private var isApptentiveRegistered = false

  private var unreadCallbackContext: CallbackContext? = null
  private var surveyCallbackContext: CallbackContext? = null

  override fun onResume(multitasking: Boolean) {
    super.onResume(multitasking)
    if (isApptentiveRegistered) {
      Log.d(CORDOVA_TAG, "Registering ApptentiveInfoCallback")
      Apptentive.registerApptentiveActivityInfoCallback(this)
    }
  }

  override fun onDestroy() {
    super.onDestroy()
    android.util.Log.d("Apptentive", "[CORDOVA] Unregistering observers")
    Apptentive.messageCenterNotificationObservable.removeObserver(::observeUnreadMessageListener)
    Apptentive.eventNotificationObservable.removeObserver(::observeSurveyFinishedListener)
    unreadCallbackContext = null
    surveyCallbackContext = null
  }

  override fun execute(action: String, args: JSONArray, callbackContext: CallbackContext): Boolean {
    android.util.Log.d("Apptentive", "[CORDOVA] Executing action: $action")

    val currentActivity = cordova.getActivity()
    if (currentActivity == null) {
      android.util.Log.e("Apptentive", "[CORDOVA] Current activity is null. Cannot execute action: $action")
      callbackContext.error("Current activity is null. Cannot execute action: $action")
      return true
    }

    when (action) {
      ACTION_DEVICE_READY -> {
        
        if (currentActivity != null && !Apptentive.registered) {

          // Parse log level
          val logLevel = try {
            args.getString(1)
          } catch (e: JSONException) {
            null
          }

          val distributionVersion = try {
            args.getString(0)
          } catch (e: JSONException) {
            callbackContext.error("Internal Error: Missing or invalid distribution_version")
            "0.0.0"
          }

          val configuration = resolveConfiguration(currentActivity.application, logLevel, distributionVersion)

          configuration?.let {
            Apptentive.register(currentActivity.application, configuration) {
              if (it == RegisterResult.Success) {
                Log.d(CORDOVA_TAG, "Register Apptentive: Success")
                isApptentiveRegistered = true

                handlePostRegister()
                callbackContext.success()
              } else {
                android.util.Log.e("Apptentive", "[CORDOVA] Register Apptentive Fail: $it")
                callbackContext.error("Register Apptentive Fail: $it")
              }
            }
          } ?: run {
            android.util.Log.e("Apptentive", "[CORDOVA] Register Apptentive: Fail")
            callbackContext.error("Register Apptentive: Fail")
          }
        }
        return true
      }
      ACTION_CAN_SHOW_MESSAGE_CENTER -> {
        Apptentive.canShowMessageCenter { canShowMessageCenter ->
          val result = PluginResult(PluginResult.Status.OK, canShowMessageCenter)
          callbackContext.sendPluginResult(result)
        }
        return true
      }
      ACTION_SHOW_MESSAGE_CENTER -> {
        if (args.length() > 0) {
          val customData = JsonHelper.toMap(args.getJSONObject(0))
          Apptentive.showMessageCenter(customData)
        } else Apptentive.showMessageCenter()
        callbackContext.success()
        return true
      }
      ACTION_ADD_CUSTOM_DEVICE_DATA -> {
        val key = args.getString(0)

        when (val value = args.get(1)) {
          is String -> Apptentive.addCustomDeviceData(key, value)
          is Number -> Apptentive.addCustomDeviceData(key, value)
          is Boolean -> Apptentive.addCustomDeviceData(key, value)
          else -> {
            callbackContext.error("Custom Device Data Type not supported: ${value::class.java}")
          }
        }
        callbackContext.success()
        return true
      }
      ACTION_ADD_CUSTOM_PERSON_DATA -> {
        val key = args.getString(0)
        when (val value = args.get(1)) {
          is String -> Apptentive.addCustomPersonData(key, value)
          is Number -> Apptentive.addCustomPersonData(key, value)
          is Boolean -> Apptentive.addCustomPersonData(key, value)
          else -> {
            callbackContext.error("Custom Person Data Type not supported: ${value::class.java}")
          }
        }
        callbackContext.success()
        return true
      }
      ACTION_CAN_SHOW_INTERACTION -> {
        val eventId = args.getString(0)
        val canShow = Apptentive.canShowInteraction(eventId)
        val result = PluginResult(PluginResult.Status.OK, canShow)
        callbackContext.sendPluginResult(result)
        return true
      }
      ACTION_ENGAGE -> {
        val eventId = args.getString(0)
        val customData = if (args.length() > 1) JsonHelper.toMap(args.getJSONObject(1)) else null

        Apptentive.engage(eventId, customData) {
          val interactionShown = it is EngagementResult.InteractionShown
          val result = PluginResult(PluginResult.Status.OK, interactionShown)
          callbackContext.sendPluginResult(result)
        }

        return true
      }
      ACTION_GET_UNREAD_MESSAGE_COUNT -> {
        val unreadMessageCount = Apptentive.getUnreadMessageCount()
        val result = PluginResult(PluginResult.Status.OK, unreadMessageCount)
        callbackContext.sendPluginResult(result)
        return true
      }
      ACTION_REMOVE_CUSTOM_DEVICE_DATA -> {
        val key = args.getString(0)
        Apptentive.removeCustomDeviceData(key)
        callbackContext.success()
        return true
      }
      ACTION_REMOVE_CUSTOM_PERSON_DATA -> {
        val key = args.getString(0)
        Apptentive.removeCustomPersonData(key)
        callbackContext.success()
        return true
      }
      ACTION_SEND_ATTACHMENT_FILE_URI -> {
        val uri = args.getString(0)
        Apptentive.sendAttachmentFile(uri)
        return true
      }
      ACTION_SEND_ATTACHMENT_FILE -> {
        val content = args.getString(0).toByteArray()
        val mimeType = args.getString(1)
        Apptentive.sendAttachmentFile(content, mimeType)
        return true
      }
      ACTION_SEND_ATTACHMENT_TEXT -> {
        val text = args.getString(0)
        Apptentive.sendAttachmentText(text)
        callbackContext.success()
        return true
      }
      ACTION_GET_PERSON_EMAIL -> {
        val email = Apptentive.getPersonEmail()
        val result = PluginResult(PluginResult.Status.OK, email)
        callbackContext.sendPluginResult(result)
        return true
      }
      ACTION_SET_PERSON_EMAIL -> {
        val email = args.getString(0)
        Apptentive.setPersonEmail(email)
        callbackContext.success()
        return true
      }
      ACTION_GET_PERSON_NAME -> {
        val name = Apptentive.getPersonName()
        val result = PluginResult(PluginResult.Status.OK, name)
        callbackContext.sendPluginResult(result)
        return true
      }
      ACTION_SET_PERSON_NAME -> {
        val name = args.getString(0)
        Apptentive.setPersonName(name)
        callbackContext.success()
        return true
      }
      ACTION_ADD_UNREAD_MESSAGES_LISTENER -> {
        return if (isApptentiveRegistered) {
          Log.d(CORDOVA_TAG, "Observing Message Center Notification")
          unreadCallbackContext = callbackContext
          Apptentive.messageCenterNotificationObservable.observe(::observeUnreadMessageListener)
          true
        } else {
          android.util.Log.e("Apptentive", "[CORDOVA] Could not observe Message Center " +
              "unread messages because Apptentive is not registered. Please register Apptentive " +
              "with the `deviceReady` or `registerWithLogs` function and then try again."
          )
          false
        }
      }
      ACTION_SET_ON_SURVEY_FINISHED_LISTENER -> {
        if (isApptentiveRegistered) {
          Log.d(CORDOVA_TAG, "Observing Survey finished notification")
          surveyCallbackContext = callbackContext
          Apptentive.eventNotificationObservable.observe(::observeSurveyFinishedListener)
        } else {
          android.util.Log.e("Apptentive", "[CORDOVA] Could not observe Survey finish " +
              "notification because Apptentive is not registered. Please register Apptentive with " +
              "the `deviceReady` or `registerWithLogs` function and then try again."
          )
        }
        return true
      }
      ACTION_SET_PUSH_NOTIFICATION_INTEGRATION -> {
        if (isApptentiveRegistered) {
          val provider = parsePushProvider("apptentive")
          android.util.Log.d("Apptentive", "[CORDOVA] Provider is set to $provider")
          val token = args.getString(0)
          Apptentive.setPushNotificationIntegration(currentActivity.application, provider, token)
        } else 
            android.util.Log.d("Apptentive", "[CORDOVA] Apptentive is not registered, push notification is not integerated")
        return true
      }
      else -> {
        android.util.Log.e("Apptentive", "[CORDOVA] Unhandled action in ApptentiveBridge: $action")
        callbackContext.error("Unhandled action in ApptentiveBridge: $action")
        return false
      }
    }
  }

  private fun resolveConfiguration(context: Context, logLevel: String?, distributionVersion: String): ApptentiveConfiguration? {
    val apptentiveKey = Util.getManifestMetadataString(context, MANIFEST_KEY_APPTENTIVE_KEY)
      ?: run {
        android.util.Log.e("Apptentive", "[CORDOVA] Unable to initialize Apptentive SDK: '$MANIFEST_KEY_APPTENTIVE_KEY' manifest key is missing")
        return null
      }

    val apptentiveSignature = Util.getManifestMetadataString(context, MANIFEST_KEY_APPTENTIVE_SIGNATURE)
      ?: run {
        android.util.Log.e("Apptentive", "[CORDOVA] Unable to initialize Apptentive SDK: '$MANIFEST_KEY_APPTENTIVE_SIGNATURE' manifest signature is missing")
        return null
      }

    val configuration = ApptentiveConfiguration(apptentiveKey, apptentiveSignature).apply {
      this.distributionName = "Cordova"
      this.distributionVersion = distributionVersion
    }

    val logLevelString = Util.getManifestMetadataString(context, MANIFEST_KEY_APPTENTIVE_LOG_LEVEL)
    android.util.Log.d("Apptentive", "[CORDOVA] Log Level: $logLevelString")
    if (logLevelString != null) configuration.logLevel = parseLogLevel(logLevel ?: logLevelString)

    configuration.shouldEncryptStorage = Util.getManifestMetadataBoolean(context, MANIFEST_KEY_APPTENTIVE_SHOULD_ENCRYPT_STORAGE, configuration.shouldEncryptStorage)
    android.util.Log.d("Apptentive", "[CORDOVA] Encryption: ${configuration.shouldEncryptStorage}")

    configuration.shouldInheritAppTheme = Util.getManifestMetadataBoolean(context, MANIFEST_KEY_APPTENTIVE_SHOULD_INHERIT_APP_THEME, configuration.shouldInheritAppTheme)
    android.util.Log.d("Apptentive", "[CORDOVA] Inherit App Theme: ${configuration.shouldInheritAppTheme}")

    configuration.shouldSanitizeLogMessages = Util.getManifestMetadataBoolean(context, MANIFEST_KEY_APPTENTIVE_SHOULD_SANITIZE_LOG_MESSAGES, configuration.shouldSanitizeLogMessages)
    android.util.Log.d("Apptentive", "[CORDOVA] Sanitize Log Messages: ${configuration.shouldSanitizeLogMessages}")

    val ratingInteractionThrottleLength = Util.getManifestMetadataInt(context, MANIFEST_KEY_APPTENTIVE_RATING_INTERACTION_THROTTLE_LENGTH)
    android.util.Log.d("Apptentive", "[CORDOVA] Rating Interaction Throttle Length: $ratingInteractionThrottleLength")
    if (ratingInteractionThrottleLength != null && ratingInteractionThrottleLength != 0) configuration.ratingInteractionThrottleLength = ratingInteractionThrottleLength.toLong()

    val customAppStoreURL = Util.getManifestMetadataString(context, MANIFEST_KEY_APPTENTIVE_CUSTOM_APP_STORE_URL)
    android.util.Log.d("Apptentive", "[CORDOVA] Custom App Store URL: $customAppStoreURL")
    if (!customAppStoreURL.isNullOrBlank()) configuration.customAppStoreURL = customAppStoreURL

    return configuration
  }

  private fun parseLogLevel(logLevel: String): LogLevel {
    return when (logLevel) {
      "verbose" -> LogLevel.Verbose
      "debug" -> LogLevel.Debug
      "info" -> LogLevel.Info
      "warn" -> LogLevel.Warning
      "error" -> LogLevel.Error
      else -> LogLevel.Info
    }
  }

  private fun handlePostRegister() {
    // We also do this in onResume, but doing it here as well might help
    //   avoid some race conditions that we've encountered before.
    Log.d(CORDOVA_TAG, "Registering ApptentiveInfoCallback")
    Apptentive.registerApptentiveActivityInfoCallback(this)
  }

    // Handle new message center notification
  private fun observeUnreadMessageListener(notification: MessageCenterNotification?) {
    Log.v(CORDOVA_TAG, "Message Center notification received: $notification")
    val result = PluginResult(PluginResult.Status.OK, notification?.unreadMessageCount ?: 0)
    result.setKeepCallback(true)
    unreadCallbackContext?.sendPluginResult(result)
  }

  // Handle survey listener notification
  private fun observeSurveyFinishedListener(notification: EventNotification?) {
    if (notification?.interaction == "Survey" && notification.name == "submit") {
      Log.v(CORDOVA_TAG, "Survey finished notification received: $notification")
      val result = PluginResult(PluginResult.Status.OK, true)
      result.setKeepCallback(true)
      surveyCallbackContext?.sendPluginResult(result)
    }
  }

  private fun parsePushProvider(pushProvider: String): Int {
    when {
        pushProvider.contains("apptentive") -> { return Apptentive.PUSH_PROVIDER_APPTENTIVE }
        pushProvider.contains("amazon") -> { return Apptentive.PUSH_PROVIDER_AMAZON_AWS_SNS }
        pushProvider.contains("parse") -> { return Apptentive.PUSH_PROVIDER_PARSE }
        pushProvider.contains("urban_airship") -> { return Apptentive.PUSH_PROVIDER_URBAN_AIRSHIP }
        else -> throw IllegalArgumentException("Unknown push provider: $pushProvider")
    }
  }

  private companion object {
    val CORDOVA_TAG = LogTag("CORDOVA")

    const val MANIFEST_KEY_APPTENTIVE_KEY = "apptentive_key"
    const val MANIFEST_KEY_APPTENTIVE_SIGNATURE = "apptentive_signature"

    const val MANIFEST_KEY_APPTENTIVE_LOG_LEVEL = "apptentive_log_level"
    const val MANIFEST_KEY_APPTENTIVE_SHOULD_ENCRYPT_STORAGE = "apptentive_uses_encryption"
    const val MANIFEST_KEY_APPTENTIVE_SHOULD_INHERIT_APP_THEME = "apptentive_inherit_app_theme"
    const val MANIFEST_KEY_APPTENTIVE_SHOULD_SANITIZE_LOG_MESSAGES = "apptentive_sanitize_log_messages"
    const val MANIFEST_KEY_APPTENTIVE_RATING_INTERACTION_THROTTLE_LENGTH = "apptentive_rating_interaction_throttle_length"
    const val MANIFEST_KEY_APPTENTIVE_CUSTOM_APP_STORE_URL = "apptentive_custom_app_store_url"

    const val ACTION_DEVICE_READY = "deviceReady"
    const val ACTION_ADD_CUSTOM_DEVICE_DATA = "addCustomDeviceData"
    const val ACTION_ADD_CUSTOM_PERSON_DATA = "addCustomPersonData"
    const val ACTION_ENGAGE = "engage"
    const val ACTION_GET_UNREAD_MESSAGE_COUNT = "getUnreadMessageCount"
    const val ACTION_REMOVE_CUSTOM_DEVICE_DATA = "removeCustomDeviceData"
    const val ACTION_REMOVE_CUSTOM_PERSON_DATA = "removeCustomPersonData"
    const val ACTION_SEND_ATTACHMENT_FILE_URI = "sendAttachmentFileUri"
    const val ACTION_SEND_ATTACHMENT_FILE = "sendAttachmentFile"
    const val ACTION_SEND_ATTACHMENT_TEXT = "sendAttachmentText"
    const val ACTION_GET_PERSON_EMAIL = "getPersonEmail"
    const val ACTION_SET_PERSON_EMAIL = "setPersonEmail"
    const val ACTION_GET_PERSON_NAME = "getPersonName"
    const val ACTION_SET_PERSON_NAME = "setPersonName"
    const val ACTION_ADD_UNREAD_MESSAGES_LISTENER = "addUnreadMessagesListener"
    const val ACTION_SET_ON_SURVEY_FINISHED_LISTENER = "setOnSurveyFinishedListener"
    const val ACTION_SHOW_MESSAGE_CENTER = "showMessageCenter"
    const val ACTION_CAN_SHOW_MESSAGE_CENTER = "canShowMessageCenter"
    const val ACTION_CAN_SHOW_INTERACTION = "canShowInteraction"
    const val ACTION_SET_PUSH_NOTIFICATION_INTEGRATION = "setPushNotificationIntegration"
  }

  override fun getApptentiveActivityInfo(): Activity? {
    return cordova.getActivity()
  }
}