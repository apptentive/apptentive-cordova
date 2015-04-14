var Apptentive = {
    initialized: false,

    deviceReady: function (successCallback, errorCallback) {
        console.log("Apptentive.deviceReady()");
        Apptentive.initialized = true;
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["deviceReady"]);
    },

    pause: function (successCallback, errorCallback) {
        console.log("Apptentive.pause()");
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["pause"]);
    },

    resume: function (successCallback, errorCallback) {
        console.log("Apptentive.resume()");
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["resume"]);
    },

    addAmazonSnsPushIntegration: function (successCallback, errorCallback, deviceToken) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["addAmazonSnsPushIntegration", deviceToken]);
    },

    addCustomDeviceData: function (successCallback, errorCallback, key, value) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["addCustomDeviceData", key, value]);
    },

    addCustomPersonData: function (successCallback, errorCallback, key, value) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["addCustomPersonData", key, value]);
    },

    addIntegration: function (successCallback, errorCallback, integration, config) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["addIntegration", integration, config]);
    },

    addParsePushIntegration: function (successCallback, errorCallback, deviceToken) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["addParsePushIntegration", deviceToken]);
    },

    engage: function (successCallback, errorCallback, eventId, customData) {
        if (customData) {
            cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["engage", eventId, customData]);
        } else {
            cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["engage", eventId]);
        }
    },

    getUnreadMessageCount: function (successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["unreadMessageCount"]);
    },

    removeCustomDeviceData: function (successCallback, errorCallback, key) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["removeCustomDeviceData", key]);
    },

    removeCustomPersonData: function (successCallback, errorCallback, key) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["removeCustomPersonData", key]);
    },

    showMessageCenter: function (successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["presentMessageCenterFromViewController"]);
    },


    /* Unmatched */

    addIntegrationWithDeviceToken: function (successCallback, errorCallback, integration, deviceToken) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["addIntegration", integration, deviceToken]);
    },

    addUrbanAirshipPushIntegration: function (successCallback, errorCallback, deviceToken) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["addUrbanAirshipPushIntegration", deviceToken]);
    },
    forwardPushNotificationToApptentive: function (successCallback, errorCallback, userInfo) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["forwardPushNotificationToApptentive", userInfo]);
    },

    openAppStore: function (successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["openAppStore"]);
    },

    registerForMessageNotifications: function (successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["registerForMessageNotifications"]);
    },

    registerForRateNotifications: function (successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["registerForRateNotifications"]);
    },

    registerForSurveyNotifications: function (successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["registerForSurveyNotifications"]);
    },

    removeIntegration: function (successCallback, errorCallback, integration) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["removeIntegration", integration]);
    },

    sendAttachmentFileWithMimeType: function (successCallback, errorCallback, uri, mimeType) {
        if (mimeType) {
            cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["sendAttachmentFile", uri, mimeType]);
        } else {
            cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["sendAttachmentFile", uri]);
        }
    },

    sendAttachmentImage: function (successCallback, errorCallback, image) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["sendAttachmentImage", image]);
    },

    sendAttachmentText: function (successCallback, errorCallback, text) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["sendAttachmentText", text]);
    },

    setInitialUserEmail: function (successCallback, errorCallback, email) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["setProperty", "initialUserEmailAddress", email]);
    },

    setInitialUserName: function (successCallback, errorCallback, name) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["setProperty", "initialUserName", name]);
    },

    setProperty: function (successCallback, errorCallback, key, value) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["setProperty", key, value]);
    },

    // Todo: Combine this into showMessageCenter() with varargs.
    /*
     presentMessageCenterFromViewControllerWithCustomData: function (successCallback, errorCallback, customData) {
     cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["presentMessageCenterFromViewControllerWithCustomData", customData]);
     },
     */

    unregisterForNotifications: function (successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["unregisterForNotifications"]);
    }
};

module.exports = Apptentive;
