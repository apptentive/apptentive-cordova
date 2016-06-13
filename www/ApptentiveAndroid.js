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
    }
};

module.exports = Apptentive;
