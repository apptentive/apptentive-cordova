var Apptentive = {
    addCustomDeviceData: function (successCallback, errorCallback, key, value) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "addCustomDeviceData", [key, value]);
    },

    addCustomPersonData: function (successCallback, errorCallback, key, value) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "addCustomPersonData", [key, value]);
    },

    deviceReady: function (successCallback, errorCallback) {
        console.log("Apptentive.deviceReady()");
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "deviceReady", []);
    },

    registerWithLogs: function (successCallback, errorCallback, loglevel) {
        console.log("Apptentive.registerWithLogs()");
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "deviceReady", [loglevel]);
    },

    engage: function (successCallback, errorCallback, eventName, customData) {
        if (customData && typeof customData === 'object') {
            cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "engage", [eventName, customData]);
        } else {
            cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "engage", [eventName]);
        }
    },

    getUnreadMessageCount: function (successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "getUnreadMessageCount", []);
    },

    putRatingProviderArg: function (successCallback, errorCallback, key, value) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "putRatingProviderArg", [key, value]);
    },

    removeCustomDeviceData: function (successCallback, errorCallback, key) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "removeCustomDeviceData", [key]);
    },

    removeCustomPersonData: function (successCallback, errorCallback, key) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "removeCustomPersonData", [key]);
    },

    getPersonEmail: function (successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "getPersonEmail", []);
    },

    setPersonEmail: function (successCallback, errorCallback, email) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "setPersonEmail", [email]);
    },

    getPersonName: function (successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "getPersonName", []);
    },

    setPersonName: function (successCallback, errorCallback, name) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "setPersonName", [name]);
    },

    setRatingProvider: function (successCallback, errorCallback, ratingProviderName) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "setRatingProvider", [ratingProviderName]);
    },

    addUnreadMessagesListener: function (unreadMessagesCallback, errorCallback) {
        cordova.exec(unreadMessagesCallback, errorCallback, "ApptentiveBridge", "addUnreadMessagesListener", []);
    },

    addSurveyFinishedListener: function (surveyFinishedCallback, errorCallback) {
        cordova.exec(surveyFinishedCallback, errorCallback, "ApptentiveBridge", "setOnSurveyFinishedListener", []);
    },

    showMessageCenter: function (successCallback, errorCallback, customData) {
        if (customData) {
            cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "showMessageCenter", [customData]);
        } else {
            cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "showMessageCenter", []);
        }
    },

    canShowMessageCenter: function (successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "canShowMessageCenter", []);
    },

    canShowInteraction: function (successCallback, errorCallback, eventName) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "canShowInteraction", [eventName]);
    },

    setProperty: function (successCallback, errorCallback, key, value) {
        successCallback(); // Does nothing on Android
    },

    login: function (successCallback, errorCallback, token) {
        successCallback(); // Does nothing on Android
    },

    logout: function (successCallback, errorCallback) {
      successCallback(); // Does nothing on Android
    },

    sendAttachmentText: function (successCallback, errorCallback, text) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "sendAttachmentText", [text]);
    },
};

module.exports = Apptentive;
