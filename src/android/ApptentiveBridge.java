package com.apptentive.cordova.bridge;

import android.util.Log;
import android.provider.Settings;
import android.widget.Toast;

import com.apptentive.android.sdk.Apptentive;
import com.apptentive.android.sdk.module.messagecenter.UnreadMessagesListener;
import com.apptentive.android.sdk.module.survey.OnSurveyFinishedListener;
import com.apptentive.cordova.bridge.JsonHelper;
import com.google.android.gms.gcm.GoogleCloudMessaging;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GooglePlayServicesUtil;

import java.io.IOException;
import java.util.Map;

import org.apache.cordova.CordovaWebView;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

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

    public boolean execute(final String action, JSONArray args, final CallbackContext callbackContext) throws JSONException  {
        String msg = "execute: "+action;
        Log.v(TAG, msg);


        if( action.equals("init") ) {
            Apptentive.onStart(cordova.getActivity());
            callbackContext.success("Apptentive initted");
            return true;

        } else if( action.equals("showMessageCenter") ) {
            if( args.length() > 0 ) {
                Map config = JsonHelper.toMap(args.getJSONObject(0));
                Apptentive.showMessageCenter(cordova.getActivity(), config);
            } else {
                Apptentive.showMessageCenter(cordova.getActivity());
            }
            callbackContext.success("Apptentive showMessageCeneter success");
            return true;

        } else if( action.equals("addAmazonSnsPushIntegration") ) {
            this.addAmazonSnsPushIntegration(args, callbackContext);
            return true;

        } else if( action.equals("addCustomDeviceData") ) {
            String key = args.getString(0);
            String value = args.getString(1);
            Apptentive.addCustomDeviceData(cordova.getActivity(), key, value);
            callbackContext.success( "added "+key+"=>"+value );
            return true;

        } else if( action.equals("addCustomPersonData") ) {
            String key = args.getString(0);
            String value = args.getString(1);
            Apptentive.addCustomPersonData(cordova.getActivity(), key, value);
            callbackContext.success( "added "+key+"=>"+value );
            return true;

        } else if( action.equals("addIntegration") ) {
            String integrationId = args.getString(0);
            Map config = JsonHelper.toMap(args.getJSONObject(1));
            Apptentive.addIntegration(cordova.getActivity(), integrationId, config);
            callbackContext.success( "addIntegration successful" );
            return true;
            
        } else if( action.equals("addParsePushIntegration") ) {
            String deviceToken = args.getString(0);     // TODO probably need to get this from somewhere else
            Apptentive.addParsePushIntegration(cordova.getActivity(), deviceToken);
            callbackContext.success( "addParsePushIntegration successful" );
            return true;
            
        } else if( action.equals("addUrbanAirshipPushIntegration") ) {
            String apid = args.getString(0);     // TODO probably need to get this from somewhere else
            Apptentive.addUrbanAirshipPushIntegration(cordova.getActivity(), apid);
            callbackContext.success( "addUrbanAirshipPushIntegration successful" );
            return true;

        } else if( action.equals("engage") ) {
            String eventId = args.getString(0);
            Apptentive.engage(cordova.getActivity(), eventId);
            callbackContext.success("success");
            return true;

        } else if( action.equals("getUnreadMessageCount") ) {
            callbackContext.success( Apptentive.getUnreadMessageCount(cordova.getActivity()) );
            return true;
            
        } else if( action.equals("handleOpenedPushNotification") ) {
            Apptentive.handleOpenedPushNotification(cordova.getActivity());
            callbackContext.success( "successful" );
            return true;
            
        } else if( action.equals("isApptentivePushNotification") ) {
            // TODO
            callbackContext.success( "TODO" );
            return true;
            
        } else if( action.equals("putRatingProviderArg") ) {
            String key = args.getString(0);
            String value = args.getString(1);
            Apptentive.putRatingProviderArg(key, value);
            callbackContext.success( "putRatingProvider added "+key+"=>"+value );
            return true;

        } else if( action.equals("removeCustomDeviceData") ) {
            String key = args.getString(0);
            Apptentive.removeCustomDeviceData(cordova.getActivity(), key);
            // callbackContext.success( "removeCustomDeviceData >"+key+"<" );
            return true;

        } else if( action.equals("removeCustomPersonData") ) {
            String key = args.getString(0);
            Apptentive.removeCustomPersonData(cordova.getActivity(), key);
            callbackContext.success( "removeCustomPersoneData >"+key+"<" );
            return true;

        } else if( action.equals("sendAttachmentFileUri") ) {
            String uri = args.getString(0);
            Apptentive.sendAttachmentFile( cordova.getActivity(), uri );
            return true;
            
        } else if( action.equals("sendAttachmentFile") ) {
            byte[] content = args.getString(0).getBytes();
            String mimeType = args.getString(1);
            Apptentive.sendAttachmentFile( cordova.getActivity(), content, mimeType );
            return true;
            
        } else if( action.equals("sendAttachmentText") ) {
            String text = args.getString(0);
            Apptentive.sendAttachmentText(cordova.getActivity(), text );
            callbackContext.success( "success" );
            return true;
            
        } else if( action.equals("setCustomDeviceData") ) {
            Map data = JsonHelper.toMap(args.getJSONObject(0));
            Apptentive.setCustomDeviceData(cordova.getActivity(), data);
            callbackContext.success( "success" );
            return true;
            
        } else if( action.equals("setCustomPersonData") ) {
            Map data = JsonHelper.toMap(args.getJSONObject(0));
            Apptentive.setCustomPersonData(cordova.getActivity(), data);
            callbackContext.success( "success" );
            return true;
            
        } else if( action.equals("setInitialUserEmail") ) {
            String email = args.getString(0);
            Apptentive.setInitialUserEmail(cordova.getActivity(), email );
            callbackContext.success( "success" );
            return true;
            
        } else if( action.equals("setInitialUserName") ) {
            String name = args.getString(0);
            Apptentive.setInitialUserName(cordova.getActivity(), name );
            callbackContext.success( "success" );
            return true;
            
        } else if( action.equals("willShowInteraction") ) {
            String eventId = args.getString(0);
            // Convert boolean to int because we can't pass booleans back through cordova
            int bool = Apptentive.willShowInteraction(cordova.getActivity(), eventId ) ? 1 : 0;

            callbackContext.success( bool );
            return true;
            
        } else if( action.equals("setParsePushCallback") ) {
            // FIXME is this possible?
            // Apptentive.setParsePushCallback(cordova.getActivity());
            callbackContext.success( "FIXME" );
            return true;
            
        } else if( action.equals("setUnreadMessagesListener") ) {
            UnreadMessagesListener listener = new UnreadMessagesListener() {
                public void onUnreadMessageCountChanged( int unreadMessages ) {
                    PluginResult result = new PluginResult(PluginResult.Status.OK, unreadMessages);
                    result.setKeepCallback(true);
                    callbackContext.sendPluginResult( result );
                }
            };
            Apptentive.setUnreadMessagesListener( listener );
            return true;
            
        } else if( action.equals("setOnSurveyFinishedListener") ) {
            OnSurveyFinishedListener listener = new OnSurveyFinishedListener() {
                public void onSurveyFinished( boolean finished ) {
                    int completed = finished ? 1 : 0;
                    PluginResult result = new PluginResult(PluginResult.Status.OK, completed);
                    result.setKeepCallback(true);
                    callbackContext.sendPluginResult( result );
                }
            };
            Apptentive.setOnSurveyFinishedListener( listener );
            return true;
        }

        callbackContext.error("Unhandled action in ApptentiveBridge: "+action);
        return false;
    }

    private void addAmazonSnsPushIntegration(final JSONArray args, final CallbackContext callbackContext) {
        Log.v(TAG, "addAmazonSnsPushIntegration");
        
        if( this.checkPlayServices() ) {

            cordova.getThreadPool().execute(
                new Runnable() {
                    public void run() {
                        String regId = null;

                        String senderId = "950804752062";   //TODO change to get this inserted in stings.xml or some other config file
                        
                        GoogleCloudMessaging gcm = GoogleCloudMessaging.getInstance(cordova.getActivity());

                        if( gcm == null ) {
                            Log.v(TAG, "gcm is null");
                        }

                        try {
                            regId = gcm.register(senderId);

                            Apptentive.addAmazonSnsPushIntegration(cordova.getActivity(), regId);
                        } catch (IOException ex) {
                            callbackContext.success(  "Error :" + ex.getMessage() );
                        }
                        callbackContext.success( regId );
                    }
                }
            );
        } else {
            callbackContext.error( "Google Play Service NOT available" );
        }
    }

    private boolean checkPlayServices() {
        Log.v(TAG, "checkPlayServices");

        int result = GooglePlayServicesUtil.isGooglePlayServicesAvailable(cordova.getActivity());
        if( result == ConnectionResult.SUCCESS ) {
            Log.v(TAG, "Goole Play service is available");
            return true;
        } else {
            Log.v(TAG, "Goole Play service is NOT available");
            return false;
        }
    }

}
