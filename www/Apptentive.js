var Apptentive = {
  distributionVersion: "6.9.0",

  addCustomDeviceData: function (successCallback, errorCallback, key, value) {
    cordova.exec(
      successCallback,
      errorCallback,
      "ApptentiveBridge",
      "addCustomDeviceData",
      [key, value]
    );
  },

  addCustomPersonData: function (successCallback, errorCallback, key, value) {
    cordova.exec(
      successCallback,
      errorCallback,
      "ApptentiveBridge",
      "addCustomPersonData",
      [key, value]
    );
  },

  deviceReady: function (successCallback, errorCallback) {
    console.log("Apptentive.deviceReady()");
    this.registerWithLogs(successCallback, errorCallback, "Info", null);
  },

  registerWithLogs: function (successCallback, errorCallback, loglevel, apiBaseURL = null) {
    console.log("Apptentive.registerWithLogs()");
    cordova.exec(
      successCallback,
      errorCallback,
      "ApptentiveBridge",
      "deviceReady",
      [this.distributionVersion, loglevel, apiBaseURL]
    );
  },

  engage: function (successCallback, errorCallback, eventName, customData) {
    if (customData && typeof customData === "object") {
      cordova.exec(
        successCallback,
        errorCallback,
        "ApptentiveBridge",
        "engage",
        [eventName, customData]
      );
    } else {
      cordova.exec(
        successCallback,
        errorCallback,
        "ApptentiveBridge",
        "engage",
        [eventName]
      );
    }
  },

  getUnreadMessageCount: function (successCallback, errorCallback) {
    cordova.exec(
      successCallback,
      errorCallback,
      "ApptentiveBridge",
      "getUnreadMessageCount",
      []
    );
  },

  putRatingProviderArg: function (successCallback, errorCallback, key, value) {
    cordova.exec(
      successCallback,
      errorCallback,
      "ApptentiveBridge",
      "putRatingProviderArg",
      [key, value]
    );
  },

  removeCustomDeviceData: function (successCallback, errorCallback, key) {
    cordova.exec(
      successCallback,
      errorCallback,
      "ApptentiveBridge",
      "removeCustomDeviceData",
      [key]
    );
  },

  removeCustomPersonData: function (successCallback, errorCallback, key) {
    cordova.exec(
      successCallback,
      errorCallback,
      "ApptentiveBridge",
      "removeCustomPersonData",
      [key]
    );
  },

  getPersonEmail: function (successCallback, errorCallback) {
    cordova.exec(
      successCallback,
      errorCallback,
      "ApptentiveBridge",
      "getPersonEmail",
      []
    );
  },

  setPersonEmail: function (successCallback, errorCallback, email) {
    cordova.exec(
      successCallback,
      errorCallback,
      "ApptentiveBridge",
      "setPersonEmail",
      [email]
    );
  },

  getPersonName: function (successCallback, errorCallback) {
    cordova.exec(
      successCallback,
      errorCallback,
      "ApptentiveBridge",
      "getPersonName",
      []
    );
  },

  setPersonName: function (successCallback, errorCallback, name) {
    cordova.exec(
      successCallback,
      errorCallback,
      "ApptentiveBridge",
      "setPersonName",
      [name]
    );
  },

  setRatingProvider: function (
    successCallback,
    errorCallback,
    ratingProviderName
  ) {
    successCallback(); // Deprecated. Use the ANDROID_CUSTOM_APP_STORE_URL variable instead.
  },

  addUnreadMessagesListener: function (unreadMessagesCallback, errorCallback) {
    cordova.exec(
      unreadMessagesCallback,
      errorCallback,
      "ApptentiveBridge",
      "addUnreadMessagesListener",
      []
    );
  },

  addSurveyFinishedListener: function (surveyFinishedCallback, errorCallback) {
    cordova.exec(
      surveyFinishedCallback,
      errorCallback,
      "ApptentiveBridge",
      "setOnSurveyFinishedListener",
      []
    );
  },

  showMessageCenter: function (successCallback, errorCallback, customData) {
    if (customData) {
      cordova.exec(
        successCallback,
        errorCallback,
        "ApptentiveBridge",
        "showMessageCenter",
        [customData]
      );
    } else {
      cordova.exec(
        successCallback,
        errorCallback,
        "ApptentiveBridge",
        "showMessageCenter",
        []
      );
    }
  },

  canShowMessageCenter: function (successCallback, errorCallback) {
    cordova.exec(
      successCallback,
      errorCallback,
      "ApptentiveBridge",
      "canShowMessageCenter",
      []
    );
  },

  canShowInteraction: function (successCallback, errorCallback, eventName) {
    cordova.exec(
      successCallback,
      errorCallback,
      "ApptentiveBridge",
      "canShowInteraction",
      [eventName]
    );
  },

  setProperty: function (successCallback, errorCallback, key, value) {
    successCallback(); // Does nothing on Android
  },

  login: function (successCallback, errorCallback, token) {
    successCallback(); // Does nothing on Android. We are working on re-implementing this feature.
  },

  logout: function (successCallback, errorCallback) {
    successCallback(); // Does nothing on Android. We are working on re-implementing this feature.
  },

  sendAttachmentText: function (successCallback, errorCallback, text) {
    cordova.exec(
      successCallback,
      errorCallback,
      "ApptentiveBridge",
      "sendAttachmentText",
      [text]
    );
  },

  setPushNotificationIntegration: function (
    successCallback,
    errorCallback,
    token
  ) {
    cordova.exec(
      successCallback,
      errorCallback,
      "ApptentiveBridge",
      "setPushNotificationIntegration",
      [token]
    );
  },
};

module.exports = Apptentive;
