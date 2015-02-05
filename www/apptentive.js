// The following line is just an example to illistrate that you could define variables
// here and then use them inside the scope of the 'Apptentive' object later on if that
// feels appropriate for the situation

// var someLocalVars = [ 'varOne', 'varTwo'];

var Apptentive = {

    init: function(api_key) {
        console.log('preparing to init apptentive');
        cordova.exec(
            function(err) {
        		alert('Cordova Exec Success.' + api_key);
    		},
            function(err) {
        		alert('App Exec Failed.');
    		},
            "ApptentiveBridge",
            "execute",
            [api_key]
        );
    },

    event: function(event) {
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
        cordova.exec(callback, errCallback, "ApptentiveBridge", "execute", [event]);
    }
}


module.exports = Apptentive;