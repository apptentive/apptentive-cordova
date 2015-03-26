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

        // ---- Init apptentive here ----
        Apptentive.init(apptentiveSuccess, apptentiveFailure);

        // ---- Init Parse here ----
        var appId = "YOUR_PARSE_APP_ID";           // -- change to your app id
        var clientKey = "YOUR_PARSE_CLIENT_KEY";   // -- change to your client key  
        parsePlugin.initialize(appId, clientKey, "window.onNotificationAPN", function () {
            parsePlugin.getDeviceToken(function (deviceToken) {
                // ---- device token returned successfully, now register Parse with Apptentive
                alert(deviceToken);
                Apptentive.addParsePushIntegration(apptentiveSuccess, apptentiveFailure, deviceToken);
            }, function (e) {
                alert('error');
            });

        }, function (e) {
            alert('error');
        });

        // handle APNS notifications for iOS
        window.onNotificationAPN = function (e) {
            if (e) {
                //forward the notification to Apptentive - if it is an Apptentive message, it will be processed, otherwise ignored
                Apptentive.forwardPushNotificationToApptentive(apptentiveSuccess, apptentiveFailure, e);
            }
        }
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

function apptentiveSuccess(message) {
    alert(message);
}

function apptentiveFailure() {
    alert("Error calling Apptentive Plugin");
}

app.initialize();