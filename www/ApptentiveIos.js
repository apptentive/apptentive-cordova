// The following line is just an example to illistrate that you could define variables
// here and then use them inside the scope of the 'Apptentive' object later on if that
// feels appropriate for the situation

// var someLocalVars = [ 'varOne', 'varTwo'];


var Apptentive = {
	
    init: function(successCallback, errorCallback, api_key, app_id) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["init"]);
    },

    addAmazonSnsPushIntegration: function(successCallback, errorCallback, deviceToken) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["addAmazonSnsPushIntegration", deviceToken]);
    },

    addCustomDeviceData: function(successCallback, errorCallback, key, value) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["addCustomDeviceData", key, value]);
    },

    addCustomPersonData: function(successCallback, errorCallback, key, value) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["addCustomPersonData", key, value]);
    },

    addIntegration: function(successCallback, errorCallback, integration, config) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["addIntegration", integration, config]);
    },

    addIntegrationWithDeviceToken: function(successCallback, errorCallback, integration, deviceToken) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["addIntegration", integration, deviceToken]);
    },

    addParsePushIntegration: function(successCallback, errorCallback, deviceToken) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["addParsePushIntegration", deviceToken]);
    },

    addUrbanAirshipPushIntegration: function(successCallback, errorCallback, deviceToken) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["addUrbanAirshipPushIntegration", deviceToken]);
    },

    engage: function(successCallback, errorCallback, eventId, customData) {
        if( customData) {
            cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["engage", eventId, customData]);
        } else {
            cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["engage", eventId]);
        }
    },

    forwardPushNotificationToApptentive: function(successCallback, errorCallback, userInfo) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["forwardPushNotificationToApptentive", userInfo]);
    },

    openAppStore: function(successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["openAppStore"]);
    },

    showMessageCenter: function(successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["presentMessageCenterFromViewController"]);
    },

    presentMessageCenterFromViewControllerWithCustomData: function(successCallback, errorCallback, customData) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["presentMessageCenterFromViewControllerWithCustomData", customData]);
    },

    registerForMessageNotifications: function(successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["registerForMessageNotifications"]);
    },

    registerForRateNotifications: function(successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["registerForRateNotifications"]);
    },

    registerForSurveyNotifications: function(successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["registerForSurveyNotifications"]);
    },
    
    removeCustomDeviceData: function(successCallback, errorCallback, key) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["removeCustomDeviceData", key]);
    },

    removeCustomPersonData: function(successCallback, errorCallback, key) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["removeCustomPersonData", key]);
    },

    removeIntegration: function(successCallback, errorCallback, integration) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["removeIntegration", integration]);
    },

    sendAttachmentFileWithMimeType: function(successCallback, errorCallback, uri, mimeType) {
        if(mimeType) {
            cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["sendAttachmentFile", uri, mimeType]);
        } else {
            cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["sendAttachmentFile", uri]);
        }
    },

    sendAttachmentImage: function(successCallback, errorCallback, image) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["sendAttachmentImage", image]);
    },

    sendAttachmentText: function(successCallback, errorCallback, text) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["sendAttachmentText", text]);
    },

    setProperty: function(success_callback, error_callback, property_id, value) {
        cordova.exec(success_callback, error_callback, "ApptentiveBridge", "execute", ["setProperty", property_id, value]);
    },

    unregisterForNotifications: function(successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["unregisterForNotifications"]);
    },


    unreadMessageCount: function(successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["unreadMessageCount"]);
    }
}

//window.Apptentive = Apptentive;
module.exports = Apptentive;
