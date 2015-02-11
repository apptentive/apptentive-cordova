#import <Cordova/CDV.h>
#import "ATConnect.h"

@interface ApptentiveBridge : CDVPlugin {
    BOOL apptentiveInitted;
    BOOL registeredForMessageNotifications;
    BOOL registeredForRateNotifications;
    BOOL registeredForSurveyNotifications;
    NSString* messageNotificationCallback;
    NSString* rateNotificationCallback;
    NSString* surveyNotificationCallback;
}

- (void)execute:(CDVInvokedUrlCommand*)command;

@end