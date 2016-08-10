Apptentive Cordova Changelog
============================

This document lets you know what has changed in the Cordova plugin. For changes in each version of the native SDKs, please see:

- [Android Changelog](https://github.com/apptentive/apptentive-android/blob/master/CHANGELOG.md)
- [iOS Changelog](https://github.com/apptentive/apptentive-ios/blob/master/CHANGELOG.md)

v3.2.0 - August 10, 2016
========================

- Apptentive Android SDK: 3.2.1
- Apptentive iOS SDK: 3.2.1

v3.1.0 - June 13, 2016
=========================

- Apptentive Android SDK: 3.1.0
- Apptentive iOS SDK: 3.1.0
- removed Android integration requirement on changing Application class

v3.0.0 - May 02, 2016
=========================

- Apptentive Android SDK: 3.0.0
- Apptentive iOS SDK: 3.0.0
- new Android required integration
- removed `pause` and `resume` functions

v2.1.3 - March 22, 2016
=========================

- Apptentive Android SDK: 2.1.4
- Apptentive iOS SDK: 2.1.3

v2.1.2 - January 21, 2016
=========================

- Apptentive Android SDK: 2.1.3
- Apptentive iOS SDK: 2.1.1

v2.1.1 - January 12, 2016
=========================

- Apptentive Android SDK: 2.1.2

v2.1.0 - December 22, 2015
=========================

- Apptentive Android SDK: 2.1.1
- Apptentive iOS SDK: 2.1.0
- Sending custom data through `Apptentive.showMessageCenter()`, `Apptentive.addCustomDeviceData(successCallback, errorCallback, key, value)` and `Apptentive.addCustomPersonData(successCallback, errorCallback, key, value)` now support typed `value`. The supported value types are Number, Boolean and String
- Updated to the latest Apptentive iOS SDK v2.1.0

v2.0.1 - November 5, 2015
=========================

- Apptentive Android SDK: 2.0.1
- Apptentive iOS SDK: 2.0.5
- Fixed a bug where the callback provided to `Apptentive.addUnreadMessagesListener()` wasn't getting called on Android.
- Updated to the latest Apptentive iOS SDK v2.0.5

v2.0.0 - September 22, 2015
===========================

- Apptentive Android SDK: 2.0.1
- Apptentive iOS SDK: 2.0.2
- Upgrades the Apptentive Cordova plugin with v2.0 of our Android and iOS SDKs
- Includes a completely redesigned Message Center
