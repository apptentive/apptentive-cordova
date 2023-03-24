package com.apptentive.cordova

import android.app.Activity
import android.content.Context
import android.os.Bundle
import apptentive.com.android.feedback.Apptentive
import apptentive.com.android.feedback.ApptentiveActivityInfo
import apptentive.com.android.feedback.ApptentiveConfiguration
import apptentive.com.android.feedback.EngagementResult
import apptentive.com.android.feedback.RegisterResult
import apptentive.com.android.util.InternalUseOnly
import apptentive.com.android.util.Log
import apptentive.com.android.util.LogLevel
import apptentive.com.android.util.LogTag
import org.apache.cordova.CallbackContext
import org.apache.cordova.CordovaPlugin
import org.apache.cordova.PluginResult
import org.json.JSONArray
import java.util.Locale

@OptIn(InternalUseOnly::class)
class ApptentiveBridge : CordovaPlugin(), ApptentiveActivityInfo {

  private var isApptentiveRegistered = false

  override fun onResume(multitasking: Boolean) {
    super.onResume(multitasking)
    if (isApptentiveRegistered) {
      Log.d(CORDOVA_TAG, "Registering ApptentiveInfoCallback")
      Apptentive.registerApptentiveActivityInfoCallback(this)
    }
  }

  override fun execute(action: String, args: JSONArray, callbackContext: CallbackContext): Boolean {
    android.util.Log.d("Apptentive", "[CORDOVA] Executing action: $action")

    when (action) {
      ACTION_DEVICE_READY -> {
        val currentActivity = cordova.getActivity()
        if (currentActivity != null && !Apptentive.registered) {
          val configuration = resolveConfiguration(currentActivity.application)

          Apptentive.register(currentActivity.application, configuration) {
            if (it == RegisterResult.Success) {
              Log.d(CORDOVA_TAG, "Register Apptentive: Success")
              isApptentiveRegistered = true

              handlePostRegister()
            } else Log.d(CORDOVA_TAG, "Register Apptentive: Fail")
          }
        }
        callbackContext.success()
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

        when (val value: Any = args.get(1)) {
          is String -> Apptentive.addCustomDeviceData(key, value)
          is Number -> Apptentive.addCustomDeviceData(key, value)
          is Boolean -> Apptentive.addCustomDeviceData(key, value)
          else -> {
            callbackContext.error("Custom Device Data Type not supported: ${value::class.java}")
            return false
          }
        }
        callbackContext.success()
        return true
      }
      ACTION_ADD_CUSTOM_PERSON_DATA -> {
        val key = args.getString(0)
        when (val value: Any = args.get(1)) {
          is String -> Apptentive.addCustomPersonData(key, value)
          is Number -> Apptentive.addCustomPersonData(key, value)
          is Boolean -> Apptentive.addCustomPersonData(key, value)
          else -> {
            callbackContext.error("Custom Person Data Type not supported: ${value::class.java}")
            return false
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

        callbackContext.success()
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
          Apptentive.messageCenterNotificationObservable.observe { notification ->
            Log.v(CORDOVA_TAG, "Message Center notification received: $notification")
            val result = PluginResult(PluginResult.Status.OK, notification?.unreadMessageCount ?: 0)
            result.setKeepCallback(true)
            callbackContext.sendPluginResult(result)
          }
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
        return if (isApptentiveRegistered) {
          Log.d(CORDOVA_TAG, "Observing Survey finished notification")
          Apptentive.eventNotificationObservable.observe { notification ->
            if (notification?.interaction == "Survey" && notification.name == "submit") {
              Log.v(CORDOVA_TAG, "Survey finished notification received: $notification")
              val result = PluginResult(PluginResult.Status.OK, true)
              result.setKeepCallback(true)
              callbackContext.sendPluginResult(result)
            }
          }
          true
        } else {
          android.util.Log.e("Apptentive", "[CORDOVA] Could not observe Survey finish " +
              "notification because Apptentive is not registered. Please register Apptentive with " +
              "the `deviceReady` or `registerWithLogs` function and then try again."
          )
          false
        }
      }
      else -> {
        android.util.Log.e("Apptentive", "[CORDOVA] Unhandled action in ApptentiveBridge: $action")
        callbackContext.error("Unhandled action in ApptentiveBridge: $action")
        return false
      }
    }
  }

  private fun resolveConfiguration(context: Context): ApptentiveConfiguration {
    val apptentiveKey = Util.getManifestMetadataString(context, MANIFEST_KEY_APPTENTIVE_KEY)
      ?: throw IllegalStateException("Unable to initialize Apptentive SDK: '$MANIFEST_KEY_APPTENTIVE_KEY' manifest key is missing")

    val apptentiveSignature = Util.getManifestMetadataString(context, MANIFEST_KEY_APPTENTIVE_SIGNATURE)
      ?: throw IllegalStateException("Unable to initialize Apptentive SDK: '$MANIFEST_KEY_APPTENTIVE_SIGNATURE' manifest key is missing")

    val shouldEncryptStorageString = Util.getManifestMetadataString(context, "apptentive_uses_encryption")
    val shouldEncryptStorage = shouldEncryptStorageString?.lowercase(Locale.getDefault()) == "true" ||
        shouldEncryptStorageString?.lowercase(Locale.getDefault()) == "yes" ||
        shouldEncryptStorageString?.lowercase(Locale.getDefault()) == "1"

    val configuration = ApptentiveConfiguration(apptentiveKey, apptentiveSignature).apply {
      this.shouldEncryptStorage = shouldEncryptStorage
    }

    Util.getManifestMetadataString(context, MANIFEST_KEY_APPTENTIVE_LOG_LEVEL)?.let {
      configuration.logLevel = parseLogLevel(it)
    }

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

  private companion object {
    val CORDOVA_TAG = LogTag("CORDOVA")

    const val MANIFEST_KEY_APPTENTIVE_LOG_LEVEL = "apptentive_log_level"
    const val MANIFEST_KEY_APPTENTIVE_KEY = "apptentive_key"
    const val MANIFEST_KEY_APPTENTIVE_SIGNATURE = "apptentive_signature"

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
  }

  override fun getApptentiveActivityInfo(): Activity {
    return cordova.getActivity()
      ?: throw IllegalStateException("Activity could not be retrieved from Cordova.")
  }
}