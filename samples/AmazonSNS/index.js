/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

var pushNotification;
var deviceToken;

var app = {

    // Application Constructor
    initialize: function () {
        this.bindEvents();
    },
    // Bind Event Listeners
    //
    // Bind any events that are required on startup. Common events are:
    // 'load', 'deviceready', 'offline', and 'online'.
    bindEvents: function () {
        document.addEventListener('deviceready', this.onDeviceReady, false);
    },
    // deviceready Event Handler
    //
    // The scope of 'this' is the event. In order to call the 'receivedEvent'
    // function, we must explicitly call 'app.receivedEvent(...);'
    onDeviceReady: function () {
        app.receivedEvent('deviceready');

        // handle APNS notifications for iOS
        window.onNotificationAPN = function (e) {
            if (e) {
                //forward the notification to Apptentive - if it is an Apptentive message, it will be processed, otherwise ignored
                Apptentive.forwardPushNotificationToApptentive(apptentiveSuccess, apptentiveFailure, e);
            }

            if (e.sound) {
                // playing a sound also requires the org.apache.cordova.media plugin
                var snd = new Media(e.sound);
                snd.play();
            }

            if (e.badge) {
                pushNotification.setApplicationIconBadgeNumber(successHandler, e.badge);
            }
        };

        try {
            pushNotification = window.plugins.pushNotification;
            pushNotification.register(tokenHandler, errorHandler, {
                "badge": "true",
                "sound": "true",
                "alert": "true",
                "ecb": "window.onNotificationAPN"
            });    // required!
        }
        catch (err) {
            alert("catch");
            txt = "There was an error on this page.\n\n";
            txt += "Error description: " + err.message + "\n\n";
            alert(txt);
        }

        // ---- Init apptentive here ----
        Apptentive.init(apptentiveSuccess, apptentiveFailure);

        // ---- Show message center ----
        Apptentive.presentMessageCenterFromViewController();

        // ---- Call engage to log events and trigger surverys, ratings and more ----
        // Apptentive.engage(null, null, 'myevent');

        // ---- Register observers for events such as user submitting survery ----
        // Apptentive.registerForMessageNotifications(success, failure);
        // Apptentive.registerForRateNotifications(success, failure);
        // Apptentive.registerForSurveyNotifications(success, failure);        

        // ---- Attach images to messages - note that the image is passed in from JS as Base64 encoded data ---
        // convertImgToBase64URL('http://www.fulton58.org/pages/uploaded_images/Nike-Vapor-Elite-Airlock-Size-9-Football-FT0210_201_A.jpg', function(base64Img){
        //     Apptentive.sendAttachmentImage(success,failure,base64Img);
        // });
        // Apptentive.sendAttachmentImage(success,failure,"logo.png");

        // ---- Set custom data such as person data or device data ----
        // Apptentive.addCustomPersonData(success, failure, "My name is Fred", "name");

        // ---- Show message center with custom data ----
        // var customData = {};
        // customData.name = "Henry";
        // navigator.Apptentive.presentMessageCenterFromViewControllerWithCustomData(success, failure, customData);

        // ---- Get unread message count - value will be returned in the success callback ----
        // Apptentive.unreadMessageCount(success, failure);
    },

    // Update DOM on a Received Event
    receivedEvent: function (id) {
        var parentElement = document.getElementById(id);
        var listeningElement = parentElement.querySelector('.listening');
        var receivedElement = parentElement.querySelector('.received');

        listeningElement.setAttribute('style', 'display:none;');
        receivedElement.setAttribute('style', 'display:block;');

        console.log('Received Event: ' + id);
    }
};

function tokenHandler(result) {
    deviceToken = result;
    //now that we have the token we can register with AmazonSNS
    Apptentive.addAmazonSnsPushIntegration(apptentiveSuccess, apptentiveFailure, deviceToken);

    // Your iOS push server needs to know the token before it can push to this device
    // here is where you might want to send it the token for later use.
}

function successHandler(result) {
}

function errorHandler(error) {
}

function apptentiveSuccess(message) {
    alert(message);
}

function apptentiveFailure() {
    alert("Error calling Apptentive Plugin");
}

app.initialize();