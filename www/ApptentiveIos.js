var Apptentive = {
    initialized: false,

    addCustomDeviceData: function (successCallback, errorCallback, key, value) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["addCustomDeviceData", key, value]);
    },

    addCustomPersonData: function (successCallback, errorCallback, key, value) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["addCustomPersonData", key, value]);
    },

    deviceReady: function (successCallback, errorCallback) {
        console.log("Apptentive.deviceReady()");
        Apptentive.initialized = true;
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["deviceReady"]);
    },

    engage: function (successCallback, errorCallback, eventName, customData) {
        if (customData) {
            cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["engage", eventName, customData]);
        } else {
            cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["engage", eventName]);
        }
    },

    getUnreadMessageCount: function (successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["unreadMessageCount"]);
    },

    putRatingProviderArg: function (successCallback, errorCallback, key, value) {
        successCallback(); // Does nothing on iOS.
    },

    removeCustomDeviceData: function (successCallback, errorCallback, key) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["removeCustomDeviceData", key]);
    },

    removeCustomPersonData: function (successCallback, errorCallback, key) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["removeCustomPersonData", key]);
    },

    setPersonEmail: function (successCallback, errorCallback, email) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["setProperty", "personEmailAddress", email]);
    },

    getPersonEmail: function (successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["getProperty", "personEmailAddress"]);
    },

    setPersonName: function (successCallback, errorCallback, name) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["setProperty", "personName", name]);
    },

    getPersonName: function (successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["getProperty", "personName"]);
    },

    setRatingProvider: function (successCallback, errorCallback, ratingProviderName) {
        successCallback(); // Does nothing on iOS.
    },

    addUnreadMessagesListener: function (unreadMessagesCallback, errorCallback) {
        cordova.exec(unreadMessagesCallback, errorCallback, "ApptentiveBridge", "execute", ["registerForMessageNotifications"]);
    },

    showMessageCenter: function (successCallback, errorCallback, customData) {
        if (customData) {
            cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["showMessageCenter", customData]);
        } else {
            cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["showMessageCenter"]);
        }
    },

    canShowInteraction: function (successCallback, errorCallback, eventName) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["canShowInteraction", eventName]);
    },

    canShowMessageCenter: function (successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["canShowMessageCenter"]);
    },

    setProperty: function (successCallback, errorCallback, key, value) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["setProperty", key, value]);
    },

    getProperty: function (successCallback, errorCallback, key, value) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["getProperty", key]);
    }
};

module.exports = Apptentive;
