var exec = function() {

    var success = arguments[0],
        fail = arguments[1],
        service = arguement[2],
        command = arguments[3],
        args = arguments.slice(4);

        console.log("platformId >"+platformId+"<");

        switch( cordova.platformId ) {
            case "android":
                cordova.exec(successCallback, errorCallback, service, command, args);
                break;
            case "ios":
                break;
            default:
                console.warn("Warning: Apptentive cannot run on platform", cordova.platformId);
                break;
        }
}

var Apptentive = {
	
	init: function(successCallback, errorCallback, apiKey) {
		console.log("Apptentive.js init called");

        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "init", [apiKey]);
    },

	event: function(successCallback, errorCallback, event) {
		console.log("Apptentive.js event called");

        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "event", [event]);
    },
  
    addAmazonSnsPushIntegration: function(successCallback, errorCallback, registrationId) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "addAmazonSnsPushIntegration", [registrationId]);
    },

    addCustomDeviceData: function(successCallback, errorCallback, key, value) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "addCustomDeviceData", [key, value]);
    },

    addCustomPersonData: function(successCallback, errorCallback, key, value) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "addCustomPersonData", [key, value]);
    },

    addIntegration: function(successCallback, errorCallback, integration, config) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "addIntegration", [integration, config]);
    },

    addParsePushIntegration: function(successCallback, errorCallback, deviceToken) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "addParsePushItegration", [deviceToken]);
    },

    addUrbanAirshipPushIntegration: function(successCallback, errorCallback, appId) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "addUrbanAirshipPushIntegration", [appId]);
    },

    engage: function(successCallback, errorCallback, eventId, customData) {
        console.log("Apptentive.engage");

        if( customData && typeof customData === 'object' ) {
            cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "engage", [eventId, customData]);
        } else {
            console.info("arguments:", arguments);
            cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "engage", [eventId]);
        }
    },

    getUnreadMessageCount: function(successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "getUnreadMessageCount");
    },

    handleOpenedPushNotification: function(successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "handleOpenedPushNotification");
    },

    isApptentivePushNotification: function(successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "isApptentivePushNotification");
    },

    onStart: function(successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "onStart");
    },

    onStop: function(successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "onStop");
    },

    putRatingProviderArg: function(successCallback, errorCallback, key, value) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "putRatingProviderArg", [key, value]);
    },

    removeCustomDeviceData: function(successCallback, errorCallback, key) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "removeCustomDeviceData", [key]);
    },

    removeCustomPersonData: function(successCallback, errorCallback, key) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "removeCustomPersonData", [key]);
    },

    sendAttachmentFile: function(successCallback, errorCallback, uri, mimeType) {
        if(mimeType) {
            cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "sendAttachmentFile", [uri, mimeType]);
        } else {
            cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "sendAttachmentFile", [uri]);
        }
    },

    sendAttachmentText: function(successCallback, errorCallback, text) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "sendAttachmentText", [text]);
    },

    setCustomDeviceData: function(successCallback, errorCallback, customDeviceData) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "setCustomDeviceData", [customDeviceData]);
    },

    setCustomPersonData: function(successCallback, errorCallback, customPersonData) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "setCustomPersonData", [customPersonData]);
    },

    setInitialUserEmail: function(successCallback, errorCallback, email) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "setInitialUserEmail", [email]);
    },

    setInitialUserName: function(successCallback, errorCallback, name) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "setInitialUserName", [name]);
    },

    setOnSurveyFinishedListener: function(successCallback, errorCallback, listener) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "setOnSurveyFinishedListener", [listener]);
    },

    setParsePushCallback: function(successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "setParsePushCallback");
    },

    setPendingPushNotification: function(successCallback, errorCallback, intent) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "setPendingPushNotification", [intent]);
    },

    setProperty: function(success_callback, error_callback, property_id, value) {
        cordova.exec(success_callback, error_callback, "ApptentiveBridge", "setProperty", [property_id, value]);
    },

    setRatingProvider: function(successCallback, errorCallback, ratingProvider) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "setRatingProvider", [ratingProvider]);
    },

    setUnreadMessagesListener: function(successCallback, errorCallback, listener) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "setUnreadMessagesListener", [listener]);
    },

    showMessageCenter: function(successCallback, errorCallback, customData) {
        console.log("Apptentive.showMessageCenter");

        if( customData ) {
            cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "showMessageCenter", [customData]);
        } else {
            cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "showMessageCenter", []);
        }
    },

    willShowInteraction: function(successCallback, errorCallback, event) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "setRatingProvider", [event]);
    }
}

module.exports = Apptentive;