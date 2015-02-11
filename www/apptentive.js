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
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["addAmazonSnsPushIntegration", registrationId]);
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

    addParsePushIntegration: function(successCallback, errorCallback, deviceToken) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["addParsePushItegration", deviceToken]);
    },

    addUrbanAirshipPushIntegration: function(successCallback, errorCallback, appId) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["addUrbanAirshipPushIntegration", appId]);
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
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["getUnreadMessageCount"]);
    },

    handleOpenedPushNotification: function(successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["handleOpenedPushNotification"]);
    },

    isApptentivePushNotification: function(successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["isApptentivePushNotification"]);
    },

    onStart: function(successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["onStart"]);
    },

    onStop: function(successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["onStop"]);
    },

    putRatingProviderArg: function(successCallback, errorCallback, key, value) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["putRatingProviderArg", key, value]);
    },

    removeCustomDeviceData: function(successCallback, errorCallback, key) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["removeCustomDeviceData", key]);
    },

    removeCustomPersonData: function(successCallback, errorCallback, key) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["removeCustomPersonData", key]);
    },

    sendAttachmentFile: function(successCallback, errorCallback, uri, mimeType) {
        if(mimeType) {
            cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["sendAttachmentFile", uri, mimeType]);
        } else {
            cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["sendAttachmentFile", uri]);
        }
    },

    sendAttachmentText: function(successCallback, errorCallback, text) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["sendAttachmentText", text]);
    },

    setCustomDeviceData: function(successCallback, errorCallback, customDeviceData) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["setCustomDeviceData", customDeviceData]);
    },

    setCustomPersonData: function(successCallback, errorCallback, customPersonData) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["setCustomPersonData", customPersonData]);
    },

    setInitialUserEmail: function(successCallback, errorCallback, email) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["setInitialUserEmail", email]);
    },

    setInitialUserName: function(successCallback, errorCallback, name) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["setInitialUserName", name]);
    },

    setOnSurveyFinishedListener: function(successCallback, errorCallback, listener) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["setOnSurveyFinishedListener", listener]);
    },

    setParsePushCallback: function(successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["setParsePushCallback"]);
    },

    setPendingPushNotification: function(successCallback, errorCallback, intent) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["setPendingPushNotification", intent]);
    },

    setProperty: function(success_callback, error_callback, property_id, value) {
        cordova.exec(success_callback, error_callback, "ApptentiveBridge", "execute", ["setProperty", property_id, value]);
    },

    setRatingProvider: function(successCallback, errorCallback, ratingProvider) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["setRatingProvider", ratingProvider]);
    },

    setUnreadMessagesListener: function(successCallback, errorCallback, listener) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["setUnreadMessagesListener", listener]);
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
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["setRatingProvider", event]);
    }
}

module.exports = Apptentive;