package com.apptentive.cordova.bridge;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaWebView;
import org.json.JSONArray;
import org.json.JSONException;

import android.content.Context;

public class ApptentiveBridge extends CordovaPlugin {

// 	public void initialize(CordovaInterface cordova, CordovaWebView webView) {
// 		super.initialize(cordova, webView);
// 	}

	public boolean execute(String action, JSONArray args,
			CallbackContext callbackContext) throws JSONException {
		 if (action.equals("event")) {
                String event = args.getString(0);
                this.handleEvent(event, callbackContext);
                return true;
         }
         if (action.equals("init")) {
                String app_id = args.getString(0);
                this.handleEvent(app_id, callbackContext);
                return true;
         }
         return false;
	}
	
	private void handleEvent(String event, CallbackContext callbackContext) {
            if (event != null && event.length() > 0) {
                callbackContext.success(event + " handled");
            } else {
                callbackContext.error("Expected one non-empty string argument.");
            }
        }
        
        
     private void handleInit(String app_id, CallbackContext callbackContext) {
            if (app_id != null && app_id.length() > 0) {
                callbackContext.success(app_id + " handled by init");
            } else {
                callbackContext.error("Expected one non-empty string argument.");
            }
        }   

}