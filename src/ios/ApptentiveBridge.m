#import "ApptentiveBridge.h"

@implementation ApptentiveBridge

- (void)execute:(CDVInvokedUrlCommand*)command {
    NSString* callbackId = [command callbackId];
    NSArray *arguments = [command arguments];
    NSString* functionCall = [arguments objectAtIndex:0];
    if ([functionCall isEqualToString:@"init"]) {
        [self initWithAPIKey:arguments callBackString:callbackId];
    }
//    else if ([functionCall isEqualToString:@"getunreadmessagecount"]) {
//        [self getUnreadMessageCount:arguments callBackString:callbackId];
//    }
}

- (void)initWithAPIKey:(NSArray*)arguments callBackString:(NSString*)callbackId {
    NSString* apiKey = [arguments objectAtIndex:1];
    [ATConnect sharedConnection].apiKey = apiKey;

    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsString:apiKey];

    [self.commandDelegate sendPluginResult:result callbackId:callbackId];
}

//- (void)logEvent:(NSArray*)arguments callBackString:(NSString*)callbackId {
//    NSString* eventName = [arguments objectAtIndex:1];
//    [[ATConnect sharedConnection] engage:eventName fromViewController:viewController];
//    
//    CDVPluginResult* result = [CDVPluginResult
//                               resultWithStatus:CDVCommandStatus_OK
//                               messageAsString:msg];
//    
//    [self success:result callbackId:callbackId];
//}
//
//- (void) getUnreadMessageCount:(NSArray*)arguments callBackString:(NSString*)callbackId {
//    NSUInteger unreadMessageCount = [[ATConnect sharedConnection] unreadMessageCount];
//    NSString *messageCountAsString = [NSString stringWithFormat:@"%lu", (unsigned long)unreadMessageCount];
//    CDVPluginResult* result = [CDVPluginResult
//                               resultWithStatus:CDVCommandStatus_OK
//                               messageAsString:messageCountAsString];
//    
//    [self success:result callbackId:callbackId];
//}


@end
