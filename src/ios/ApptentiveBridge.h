#import <Cordova/CDV.h>
#import "ATConnect.h"
//#import "ATConnect_Debugging.h"

@interface ApptentiveBridge : CDVPlugin {
    BOOL apptentiveInitted;
    BOOL registeredForMessageNotifications;
    BOOL registeredForRateNotifications;
    BOOL registeredForSurveyNotifications;
    NSString* messageNotificationCallback;
    NSString* rateNotificationCallback;
    NSString* surveyNotificationCallback;
    NSString* pushNotificationCallback;
    NSString* cachedDeviceToken;
}

- (void)execute:(CDVInvokedUrlCommand*)command;

@end