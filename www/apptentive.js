cordova.define("com.cordova.apptentive.Apptentive", function(require, exports, module) { // The following line is just an example to illistrate that you could define variables
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
        if( customData && typeof customData === 'object' ) {
            cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["engage", eventId, customData]);
        } else {
            alert(eventId);
            cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["engage", eventId]);
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
        alert("show message center");
        if( customData ) {
            cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["showMessageCenter", customData]);
        } else {
            cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["showMessageCenter"]);
        }
    },

    willShowInteraction: function(successCallback, errorCallback, event) {
        cordova.exec(successCallback, errorCallback, "ApptentiveBridge", "execute", ["setRatingProvider", event]);
    }
}

//window.Apptentive = Apptentive;
module.exports = Apptentive;

});
