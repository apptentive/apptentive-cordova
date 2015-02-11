package com.apptentive.cordova.bridge;

import org.apache.cordova.CordovaWebView;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaInterface;
import android.util.Log;
import android.provider.Settings;
import android.widget.Toast;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.apptentive.android.sdk.Apptentive;

public class ApptentiveBridge extends CordovaPlugin {

    public static final String TAG = "ApptentiveBridge";
    /**
    * Constructor.
    */
    public ApptentiveBridge() {}

    /**
    * Sets the context of the Command. This can then be used to do things like
    * get file paths associated with the Activity.
    *
    * @param cordova The context of the main Activity.
    * @param webView The CordovaWebView Cordova is running in.
    */
    // public void initialize(CordovaInterface cordova, CordovaWebView webView) {
    //     Log.v(TAG,"initialize");

    //     super.initialize(cordova, webView);

    // }

    public boolean execute(final String action, JSONArray args, CallbackContext callbackContext) throws JSONException  {
        String msg = "execute "+action;
        Log.v(TAG, msg);

        try {
            if (action.equals("init")) {
                Log.v(TAG,"ApptentiveBridge init called");
                this.init(callbackContext);
                return true;
            }
            if (action.equals("engage")) {
                String event = args.getString(0);
                Log.v(TAG,"ApptentiveBridge event: " + event);
                this.engage(event, callbackContext);
                return true;
            }
            if (action.equals("showMessageCenter")){
                //if(args.length() > 1)
                this.showMessageCenter(callbackContext);
                return true;
            }
        } catch (Exception e) {
            Log.v(TAG, "SOME ERROR");
        };

        callbackContext.error("Unhandled action in ApptentiveBridge.execute: " + action);

        return false;
    }

    private void init(CallbackContext callbackContext) {
        Log.v(TAG,"init");

    	Apptentive.onStart(cordova.getActivity());

        callbackContext.success("Apptentive initted");
    }

    private void engage(final String event, final CallbackContext callbackContext) {
        Log.v(TAG,"engage");
        Log.v(TAG, event);

        if (event != null && event.length() > 0) {
        	cordova.getThreadPool().execute(new Runnable() {
                    public void run() {
                        Apptentive.engage(cordova.getActivity(),event);
            			callbackContext.success("engage event " + event);
                    }
                });
        	
        } else {
            callbackContext.error("Invalid engage event. nil or zero length");
        }
    }

    private void showMessageCenter(CallbackContext callbackContext) {
        Log.v(TAG, "showMessageCenter");

        Apptentive.showMessageCenter(cordova.getActivity());
        callbackContext.success("Apptentive showMessageCeneter success");
    }
}
