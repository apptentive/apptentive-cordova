var Apptentive = {
    initialized: false,

    addCustomDeviceData: function (successCallback, errorCallback, key, value) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "addCustomDeviceData", [key, value]);
    },

    addCustomPersonData: function (successCallback, errorCallback, key, value) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "addCustomPersonData", [key, value]);
    },

    deviceReady: function (successCallback, errorCallback) {
        console.log("Apptentive.deviceReady()");
        Apptentive.initialized = true;
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

    pause: function (successCallback, errorCallback) {
        console.log("Apptentive.pause()");
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "pause", []);
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

    resume: function (successCallback, errorCallback) {
        console.log("Apptentive.resume()");
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "resume", []);
    },

    setInitialUserEmail: function (successCallback, errorCallback, email) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "setInitialUserEmail", [email]);
    },

    setInitialUserName: function (successCallback, errorCallback, name) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "setInitialUserName", [name]);
    },

    setRatingProvider: function (successCallback, errorCallback, ratingProviderName) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "setRatingProvider", [ratingProviderName]);
    },

    setUnreadMessagesListener: function (unreadMessagesCallback, errorCallback) {
        cordova.exec(unreadMessagesCallback, errorCallback, "ApptentiveBridge", "setUnreadMessagesListener", []);
    },

    showMessageCenter: function (successCallback, errorCallback, customData) {
        if (customData) {
            cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "showMessageCenter", [customData]);
        } else {
            cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "showMessageCenter", []);
        }
    },

    willShowInteraction: function (successCallback, errorCallback, eventName) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "willShowInteraction", [eventName]);
    },

    setProperty: function (successCallback, errorCallback, key, value) {
        successCallback(); // Does nothing on Android
    }
};

module.exports = Apptentive;
