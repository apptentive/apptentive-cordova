define(function (require) {

	
	var apptentive = {
		init: function(api_key) {
			
            cordova.exec(function(err) {
            		alert('Cordova Exec Success.' + api_key);
        		}, function(err) {
            		alert('App Exec Failed.');
        		}, "ApptentiveBridge", "execute", [api_key]);
        }
        
        event: function(event) {
            cordova.exec(function(err) {
            		alert('Cordova Exec Success.' + event);
        		}, function(err) {
            		alert('App Exec Failed.');
        		}, "ApptentiveBridge", "execute", [event]);
        }
		
	}
	
	return apptentive;
	

}