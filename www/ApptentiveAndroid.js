var Apptentive = {
    initialized: false,

    deviceReady: function (successCallback, errorCallback) {
        console.log("Apptentive.deviceReady()");
        Apptentive.initialized = true;
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "deviceReady", []);
    },

    pause: function (successCallback, errorCallback) {
        console.log("Apptentive.pause()");
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "pause", []);
    },

    resume: function (successCallback, errorCallback) {
        console.log("Apptentive.resume()");
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "resume", []);
    },

    addAmazonSnsPushIntegration: function (successCallback, errorCallback, registrationId) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "addAmazonSnsPushIntegration", [registrationId]);
    },

    addCustomDeviceData: function (successCallback, errorCallback, key, value) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "addCustomDeviceData", [key, value]);
    },

    addCustomPersonData: function (successCallback, errorCallback, key, value) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "addCustomPersonData", [key, value]);
    },

    addIntegration: function (successCallback, errorCallback, integration, config) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "addIntegration", [integration, config]);
    },

    addParsePushIntegration: function (successCallback, errorCallback, deviceToken) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "addParsePushIntegration", [deviceToken]);
    },

    engage: function (successCallback, errorCallback, eventId, customData) {
        if (customData && typeof customData === 'object') {
            cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "engage", [eventId, customData]);
        } else {
            cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "engage", [eventId]);
        }
    },

    getUnreadMessageCount: function (successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "getUnreadMessageCount", []);
    },

    removeCustomDeviceData: function (successCallback, errorCallback, key) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "removeCustomDeviceData", [key]);
    },

    removeCustomPersonData: function (successCallback, errorCallback, key) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "removeCustomPersonData", [key]);
    },

    showMessageCenter: function (successCallback, errorCallback, customData) {
        if (customData) {
            cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "showMessageCenter", [customData]);
        } else {
            cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "showMessageCenter", []);
        }
    },

    /* Unmatched */
    // Disabled until native integration is fixed
    // addUrbanAirshipPushIntegration: function(successCallback, errorCallback, appId) {
    //     cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "addUrbanAirshipPushIntegration", [appId]);
    // }

    handleOpenedPushNotification: function (successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "handleOpenedPushNotification", []);
    },

    isApptentivePushNotification: function (successCallback, errorCallback, notificationPayload) {
        console.log("Apptentive.isApptentivePushNotification", notificationPayload);
        if (notificationPayload) {
            if (notificationPayload.action && notificationPayload.action === "com.apptentive.PUSH") {
                // This came from Parse.
                return true;
            }
            if (notificationPayload.apptentive) {
                // This came from another push provider.
                return true;
            }
        }
        return false;
    },

    onStart: function (successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "onStart", []);
    },

    onStop: function (successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "onStop", []);
    },

    putRatingProviderArg: function (successCallback, errorCallback, key, value) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "putRatingProviderArg", [key, value]);
    },

    sendAttachmentFileUri: function (successCallback, errorCallback, uri) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "sendAttachmentFile", [uri]);
    },

    sendAttachmentFile: function (successCallback, errorCallback, content, mimeType) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "sendAttachmentFile", [content, mimeType]);
    },

    sendAttachmentText: function (successCallback, errorCallback, text) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "sendAttachmentText", [text]);
    },

    // This is not implemented in the brige for some reason.
    setProperty: function (successCallback, errorCallback, key, value) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "setProperty", [key, value]);
    },

    setInitialUserEmail: function (successCallback, errorCallback, email) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "setInitialUserEmail", [email]);
    },

    setInitialUserName: function (successCallback, errorCallback, name) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "setInitialUserName", [name]);
    },

    setOnSurveyFinishedListener: function (successCallback, errorCallback, listener) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "setOnSurveyFinishedListener", [listener]);
    },

    setPendingPushNotification: function (successCallback, errorCallback, intentPayload) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "setPendingPushNotification", [intentPayload]);
    },

    setRatingProvider: function (successCallback, errorCallback, ratingProvider) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "setRatingProvider", [ratingProvider]);
    },

    setUnreadMessagesListener: function (unreadMessagesCallback, errorCallback) {
        cordova.exec(unreadMessagesCallback, errorCallback, "ApptentiveBridge", "setUnreadMessagesListener", []);
    },

    willShowInteraction: function (successCallback, errorCallback, eventId) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "willShowInteraction", [eventId]);
    }
};

module.exports = Apptentive;