#import "ApptentiveBridge.h"

@implementation ApptentiveBridge

- (void)execute:(CDVInvokedUrlCommand*)command {
    NSString* callbackId = [command callbackId];
    if ([command arguments].count == 0) {
        [self sendFailureMessage:@"Insufficient arguments" callbackId:callbackId];
        return;
    }
    NSString* functionCall = [command argumentAtIndex:0];
    NSLog([NSString stringWithFormat:@"Function call: %@",functionCall]);
    if ([functionCall isEqualToString:@"init"]) {
        [self initWithAPIKey:[command arguments] callBackString:callbackId];
    }
    else if ([functionCall isEqualToString:@"event"]) {
        [self logEvent:[command arguments] callBackString:callbackId];
    }
    else if ([functionCall isEqualToString:@"engage"]) {
        [self engage:[command arguments] callBackString:callbackId];
    }
    else if ([functionCall isEqualToString:@"getUnreadMessageCount"]) {
        [self getUnreadMessageCount:callbackId];
    }
    else if ([functionCall isEqualToString:@"setProperty"]) {
        [self setProperty:[command arguments] callBackString:callbackId];
    }
    else if ([functionCall isEqualToString:@"showMessageCenter"]) {
        [self presentMessageCenterFromViewController];
    }
    else {
        //command not recognized
        [self sendFailureMessage:@"Command not recognized" callbackId:callbackId];
    }
    
}

- (void)sendSuccessMessage:(NSString*)msg callbackId:(NSString *)callbackId {
    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsString:msg];
    [self.commandDelegate sendPluginResult:result callbackId:callbackId];
}

- (void)sendFailureMessage:(NSString*)error callbackId:(NSString *)callbackId {
    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_ERROR
                               messageAsString:error];
    [self.commandDelegate sendPluginResult:result callbackId:callbackId];
}

- (BOOL)parseBoolValue:(NSString*)value {
    if ([value isEqualToString:@"true"] || [value isEqualToString:@"True"] || [value isEqualToString:@"yes"]) {
        return YES;
    }
    else
        return [value boolValue];
}

#pragma mark Initialization and Events
- (void)initWithAPIKey:(NSArray*)arguments callBackString:(NSString*)callbackId {
    if (arguments.count < 2) {
        [self sendFailureMessage:@"Insufficient arguments - no apiKey" callbackId:callbackId];
        return;
    }
    NSString* apiKey = [arguments objectAtIndex:1];
    [ATConnect sharedConnection].apiKey = apiKey;
}

- (void)logEvent:(NSArray*)arguments callBackString:(NSString*)callbackId {
    if (arguments.count < 2) {
        [self sendFailureMessage:@"Insufficient arguments - no event name" callbackId:callbackId];
        return;
    }
    NSString* eventName = [arguments objectAtIndex:1];
    [[ATConnect sharedConnection] engage:eventName fromViewController:self.viewController];
}

- (void)engage:(NSArray*)arguments callBackString:(NSString*)callbackId {
    NSString* eventLabel = [arguments objectAtIndex:1];
    if([eventLabel isEqual:[NSNull null]]) {
        [self sendFailureMessage:@"Insufficient arguments to call engage - label is null" callbackId:callbackId];
        return;
    }
    if (arguments.count == 2) {
        [[ATConnect sharedConnection] engage:eventLabel fromViewController:self.viewController];
    }
    else if (arguments.count == 3) {
        //custom data needs to be parsed to NSDictionary - assuming json was passed
        NSData* data = [[arguments objectAtIndex:2] dataUsingEncoding:NSUTF8StringEncoding];
        NSError *localError = nil;
        NSDictionary *customData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
        if (localError != nil) {
            [self sendFailureMessage:@"Improperly formed json for engage custom data" callbackId:callbackId];
            return;
        }
        [[ATConnect sharedConnection] engage:eventLabel withCustomData:customData fromViewController:self.viewController];
    }
    
}


#pragma mark Properties and Interface Customization

- (void) setProperty:(NSArray*)arguments callBackString:(NSString*)callbackId {
    if (arguments.count < 3) {
        [self sendFailureMessage:@"Insufficient arguments for setting property" callbackId:callbackId];
        return;
    }
    NSString *property_id = [arguments objectAtIndex:1];
    NSString *value = [arguments objectAtIndex:2];
    NSLog(@"Calling setProprty");
    if ([property_id isEqualToString:@"appID"]) {
        [ATConnect sharedConnection].appID = value;
    }
    else if ([property_id isEqualToString:@"showEmailField"]) {
        [ATConnect sharedConnection].showEmailField = [self parseBoolValue:value];
    }
    else if ([property_id isEqualToString:@"customPlaceholderText"]) {
        [ATConnect sharedConnection].customPlaceholderText = value;
    }
    else if ([property_id isEqualToString:@"useMessageCenter"]) {
        //warning - useMessageCenter is deprecated
        [ATConnect sharedConnection].useMessageCenter = [self parseBoolValue:value];
    }
    else if ([property_id isEqualToString:@"initiallyUseMessageCenter"]) {
        [ATConnect sharedConnection].initiallyUseMessageCenter = [self parseBoolValue:value];
    }
    else if ([property_id isEqualToString:@"initialUserName"]) {
        [ATConnect sharedConnection].initialUserName = value;
    }
    else if ([property_id isEqualToString:@"initialUserEmailAddress"]) {
        [ATConnect sharedConnection].initialUserEmailAddress = value;
    }
    else if ([property_id isEqualToString:@"tintColor"]) {
        NSArray *colorValues = [value componentsSeparatedByString:@","];
        if (colorValues == nil || colorValues.count < 4) {
            [self sendFailureMessage:@"TintColor not set with 4 comma separated float values" callbackId:callbackId];
        }
        UIColor* tintColor = [UIColor colorWithRed:[[colorValues objectAtIndex:0] floatValue] green:[[colorValues objectAtIndex:1] floatValue] blue:[[colorValues objectAtIndex:2] floatValue] alpha:[[colorValues objectAtIndex:3] floatValue]];
        [ATConnect sharedConnection].tintColor = tintColor;
    }
    else {
        [self sendFailureMessage:@"Property name not recognized" callbackId:callbackId];
    }
}

#pragma mark Presenting UI

- (void)presentMessageCenterFromViewController {
    [[ATConnect sharedConnection] presentMessageCenterFromViewController:self.viewController];
}

- (void)presentMessageCenterFromViewControllerWithCustomData {
//    [[ATConnect sharedConnection] presentMessageCenterFromViewController:self.viewController];
}

- (void) getUnreadMessageCount:(NSString*)callbackId {
    NSUInteger unreadMessageCount = [[ATConnect sharedConnection] unreadMessageCount];
    NSString *messageCountAsString = [NSString stringWithFormat:@"%lu", (unsigned long)unreadMessageCount];
    [self sendSuccessMessage:messageCountAsString callbackId:callbackId];
}



@end



