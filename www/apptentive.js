// The following line is just an example to illistrate that you could define variables
// here and then use them inside the scope of the 'Apptentive' object later on if that
// feels appropriate for the situation

// var someLocalVars = [ 'varOne', 'varTwo'];

alert("Apptentive created");

var Apptentive = {
	
    init: function(api_key) {
        console.log('preparing to init apptentive');
        alert("init called java script");
        cordova.exec(
        	
            function(err) {
        		alert('Cordova Exec Success.' + api_key);
    		},
            function(err) {
        		alert('App Exec Failed.');
    		},
            "ApptentiveBridge",
            "execute",
            ["init",api_key]
        );
    },

    event: function(event) {
    	alert("event called java script");
        console.log("Apptentive.event", event)   // This will log to javascript console 

        // Define success callback
        var callback = function() {
            alert('Cordova Exec Success.' + event); // This will pop up a browser alert (FYI: this will also pause javascript execution; not usually an issue)
        };

        // Define error callback
        var errCallback = function(err) {
            alert('App Exec Failed:', err);
        };

        // pass in all parameters to the cordova.exec to pass through to native code

        cordova.exec(callback, errCallback, "ApptentiveBridge", "execute", ["event",event]);
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
        if( customData && customData typeof === 'object' ) {
            cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "engage", [eventId, customData]);
        } else {
            cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "engage", [eventId]);
        }
    },

    getUnreadMessageCount: function(successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "getUnreadMessageCount", []);
    },

    handleOpenedPushNotification: function(successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "handleOpenedPushNotification", []);
    },

    isApptentivePushNotification: function(successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "isApptentivePushNotification", []);
    },

    onStart: function(successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "onStart", []);
    },

    onStop: function(successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "onStop", []);
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
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "setParsePushCallback", []);
    },

    setPendingPushNotification: function(successCallback, errorCallback, intent) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "setPendingPushNotification", [intent]);
    },

    setProperty: function(success_callback, error_callback, property_id, value) {
        cordova.exec(success_callback, error_callback, "ApptentiveBridge", "setProperty", [property_id, value]);
    }

    setRatingProvider: function(successCallback, errorCallback, ratingProvider) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "setRatingProvider", [ratingProvider]);
    },

    setUnreadMessagesListener: function(successCallback, errorCallback, listener) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "setUnreadMessagesListener", [listener]);
    },

    showMessageCenter: function(successCallback, errorCallback, customData) {
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

//window.Apptentive = Apptentive;
module.exports = Apptentive;
