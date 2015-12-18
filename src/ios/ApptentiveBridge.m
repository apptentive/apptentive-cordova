#import "ApptentiveBridge.h"
#import "ATConnect.h"

@implementation ApptentiveBridge  {
    BOOL apptentiveInitted;
    BOOL registeredForMessageNotifications;
    NSString* messageNotificationCallback;
}

- (void)execute:(CDVInvokedUrlCommand*)command {
    NSString* callbackId = [command callbackId];
    if ([command arguments].count == 0) {
        [self sendFailureMessage:@"Insufficient arguments: No method name specified." callbackId:callbackId];
        return;
    }
    NSString* functionCall = [command argumentAtIndex:0];
    NSLog([NSString stringWithFormat:@"Function call: %@",functionCall]);

    //initialization
    if ([functionCall isEqualToString:@"deviceReady"]) {
        [self initAPIKey:callbackId];
        return;
    }
    if (!apptentiveInitted) {
        [self sendFailureMessage:@"Apptentive API key is not set" callbackId:callbackId];
        return;
    }

    //all other functions
    if ([functionCall isEqualToString:@"addCustomDeviceData"]) {
        [self addCustomDeviceData:[command arguments] callBackString:callbackId];
    }
    else if ([functionCall isEqualToString:@"addCustomPersonData"]) {
        [self addCustomPersonData:[command arguments] callBackString:callbackId];
    }
    else if ([functionCall isEqualToString:@"engage"]) {
        [self engage:[command arguments] callBackString:callbackId];
    }
    else if ([functionCall isEqualToString:@"openAppStore"]) {
        [self openAppStore];
    }
    else if ([functionCall isEqualToString:@"pause"]) {
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:result callbackId:callbackId];
    }
    else if ([functionCall isEqualToString:@"showMessageCenter"]) {
        [self showMessageCenter:[command arguments] callBackString:callbackId];
    }
    else if ([functionCall isEqualToString:@"registerForMessageNotifications"]) {
        [self registerForMessageNotifications:[command arguments] callBackString:callbackId];
    }
    else if ([functionCall isEqualToString:@"removeCustomDeviceData"]) {
        [self removeCustomDeviceData:[command arguments] callBackString:callbackId];
    }
    else if ([functionCall isEqualToString:@"removeCustomPersonData"]) {
        [self removeCustomPersonData:[command arguments] callBackString:callbackId];
    }
    else if ([functionCall isEqualToString:@"resume"]) {
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:result callbackId:callbackId];
    }
    else if ([functionCall isEqualToString:@"sendAttachmentFileWithMimeType"]) {
        [self sendAttachmentFileWithMimeType:[command arguments] callBackString:callbackId];
    }
    else if ([functionCall isEqualToString:@"sendAttachmentImage"]) {
        [self sendAttachmentImage:[command arguments] callBackString:callbackId];
    }
    else if ([functionCall isEqualToString:@"sendAttachmentText"]) {
        [self sendAttachmentText:[command arguments] callBackString:callbackId];
    }
    else if ([functionCall isEqualToString:@"setProperty"]) {
        [self setProperty:[command arguments] callBackString:callbackId];
    }
    else if ([functionCall isEqualToString:@"getProperty"]) {
        [self getProperty:[command arguments] callBackString:callbackId];
    }
    else if ([functionCall isEqualToString:@"unreadMessageCount"]) {
        [self unreadMessageCount:callbackId];
    }
    else if ([functionCall isEqualToString:@"unregisterForNotifications"]) {
        [self unregisterForNotifications];
    }
    else if ([functionCall isEqualToString:@"canShowInteraction"]) {
        [self canShowInteraction:[command arguments] callBackString:callbackId];
    }
    else if ([functionCall isEqualToString:@"canShowMessageCenter"]) {
        [self canShowMessageCenter:callbackId];
    }
    else {
        //command not recognized
        [self sendFailureMessage:@"Command not recognized" callbackId:callbackId];
    }

}

- (void)sendSuccessMessage:(NSString*)msg callbackId:(NSString *)callbackId {
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:msg];
    [self.commandDelegate sendPluginResult:result callbackId:callbackId];
}

- (void)sendFailureMessage:(NSString*)error callbackId:(NSString *)callbackId {
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error];
    [self.commandDelegate sendPluginResult:result callbackId:callbackId];
}

- (BOOL)parseBoolValue:(NSString*)value {
    if ([value isEqualToString:@"true"] || [value isEqualToString:@"True"] || [value isEqualToString:@"yes"]) {
        return YES;
    }
    else
        return [value boolValue];
}

- (NSDictionary*)parseDictionaryFromString:(id)value {
    NSDictionary *data;
    if ([value isKindOfClass:[NSDictionary class]]) {
        data = value;
    }
    else {
        //custom data needs to be parsed to NSDictionary - assuming json was passed
        NSData* data = [value dataUsingEncoding:NSUTF8StringEncoding];
        NSError *localError = nil;
        data = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
    }
    if (data != nil) {
        return data;
    }
    else
        return nil;
}

#pragma mark Initialization and Events
- (void)initAPIKey:(NSString*)callbackId {
    // Access Info.plist for ApptentiveAPIKey
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    NSString *apiKey = [infoPlist objectForKey:@"ApptentiveAPIKey"];

    NSLog(@"Initializing Apptentive API Key: %@", apiKey);

    if (!apiKey) {
        [self sendFailureMessage:@"Insufficient arguments - no API key." callbackId:callbackId];
        return;
    }
    if (![apiKey isEqualToString:@""]) {
        [ATConnect sharedConnection].apiKey = apiKey;
        apptentiveInitted = YES;
    }
}

- (void) registerForMessageNotifications:(NSArray*)arguments callBackString:(NSString*)callbackId {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unreadMessageCountChanged:) name:ATMessageCenterUnreadCountChangedNotification object:nil];
    registeredForMessageNotifications = YES;
    messageNotificationCallback = callbackId;
}

- (void) unregisterForNotifications {
    if (registeredForMessageNotifications) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:ATMessageCenterUnreadCountChangedNotification object:nil];
        registeredForMessageNotifications = NO;
        messageNotificationCallback = nil;
    }
}


#pragma mark Notifications

- (void)unreadMessageCountChanged:(NSNotification *)notification {
    // Unread message count is contained in the notification's userInfo dictionary.
    NSNumber *unreadMessageCount = [notification.userInfo objectForKey:@"count"];
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:[unreadMessageCount intValue]];
    [result setKeepCallback:[NSNumber numberWithBool:YES]];
    [self.commandDelegate sendPluginResult:result callbackId:messageNotificationCallback];
}

#pragma mark Properties and Interface Customization

- (void) setProperty:(NSArray*)arguments callBackString:(NSString*)callbackId {
    if (arguments.count < 3) {
        [self sendFailureMessage:@"Insufficient arguments for setting property" callbackId:callbackId];
        return;
    }
    NSString *property_id = [arguments objectAtIndex:1];
    NSString *value = [arguments objectAtIndex:2];
    if ([property_id isEqualToString:@"appID"]) {
        [ATConnect sharedConnection].appID = value;
    }
    else if ([property_id isEqualToString:@"showEmailField"]) {
        [ATConnect sharedConnection].showEmailField = [self parseBoolValue:value];
    }
    else if ([property_id isEqualToString:@"customPlaceholderText"]) {
        [ATConnect sharedConnection].customPlaceholderText = value;
    }
    else if ([property_id isEqualToString:@"personName"]) {
        [ATConnect sharedConnection].personName = value;
    }
    else if ([property_id isEqualToString:@"personEmailAddress"]) {
        [ATConnect sharedConnection].personEmailAddress = value;
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

- (void) getProperty:(NSArray*)arguments callBackString:(NSString*)callbackId {
    if (arguments.count < 2) {
        [self sendFailureMessage:@"Insufficient arguments for getting property" callbackId:callbackId];
        return;
    }
    NSString *property_id = [arguments objectAtIndex:1];
    NSString *value = nil;
    if ([property_id isEqualToString:@"appID"]) {
        value = [ATConnect sharedConnection].appID;
    }
    else if ([property_id isEqualToString:@"showEmailField"]) {
        value = [ATConnect sharedConnection].showEmailField ? @"true" : @"false";
    }
    else if ([property_id isEqualToString:@"customPlaceholderText"]) {
        value = [ATConnect sharedConnection].customPlaceholderText;
    }
    else if ([property_id isEqualToString:@"personName"]) {
        value = [ATConnect sharedConnection].personName;
    }
    else if ([property_id isEqualToString:@"personEmailAddress"]) {
        value = [ATConnect sharedConnection].personEmailAddress;
    }
    else if ([property_id isEqualToString:@"tintColor"]) {
        CGFloat red, green, blue, alpha;

        [[ATConnect sharedConnection].tintColor getRed:&red green:&green blue:&blue alpha:&alpha];
        value = [NSString stringWithFormat:@"%f,%f,%f,%f", red, green, blue, alpha];
    }
    else {
        [self sendFailureMessage:@"Property name not recognized" callbackId:callbackId];
        return;
    }

    [self sendSuccessMessage:value callbackId:callbackId];
}

#pragma mark Methods

- (void) addCustomDeviceData:(NSArray*)arguments callBackString:(NSString*)callbackId {
    NSString* key = [arguments objectAtIndex:1];
    id value = [arguments objectAtIndex:2];
    if ([value isKindOfClass:[NSString class]]) {
        NSString* stringData = value;
        [[ATConnect sharedConnection] addCustomDeviceDataString:stringData withKey:key];
    }
    else if ([value isKindOfClass:[NSNumber class]] ) {
        if (value == [NSNumber numberWithBool:YES] || value == [NSNumber numberWithBool:NO])) {
            NSNumber* boolData = value;
            [[ATConnect sharedConnection] addCustomDeviceDataBool:boolData.boolValue withKey:key];
        } else {
            NSNumber* numberData = value;
            [[ATConnect sharedConnection] addCustomDeviceDataNumber:numberData withKey:key];
        }
    } else {
        [self sendFailureMessage:@"Custom Device data type not recognized" callbackId:callbackId];
        return;
    }
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:result callbackId:callbackId];
}

- (void) addCustomPersonData:(NSArray*)arguments callBackString:(NSString*)callbackId {
    NSString* key = [arguments objectAtIndex:1];
    id value = [arguments objectAtIndex:2];
    if ([value isKindOfClass:[NSString class]]) {
        NSString* stringData = value;
        [[ATConnect sharedConnection] addCustomPersonDataString:stringData withKey:key];
    }
    else if ([value isKindOfClass:[NSNumber class]] ) {
        if (value == [NSNumber numberWithBool:YES] || value == [NSNumber numberWithBool:NO])) {
            NSNumber* boolData = value;
            [[ATConnect sharedConnection] addCustomPersonDataBool:boolData.boolValue withKey:key];
        } else {
            NSNumber* numberData = value;
            [[ATConnect sharedConnection] addCustomPersonDataNumber:numberData withKey:key];
        }
    } else {
        [self sendFailureMessage:@"Custom Device data type not recognized" callbackId:callbackId];
        return;
    }
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:result callbackId:callbackId];
}

- (void)engage:(NSArray*)arguments callBackString:(NSString*)callbackId {
    NSString* eventLabel = [arguments objectAtIndex:1];
    if([eventLabel isEqual:[NSNull null]]) {
        [self sendFailureMessage:@"Insufficient arguments to call engage - label is null" callbackId:callbackId];
        return;
    }
    BOOL shown = false;
    if (arguments.count == 2) {
        shown = [[ATConnect sharedConnection] engage:eventLabel fromViewController:self.viewController];
    }
    else if (arguments.count == 3) {
        NSDictionary *customData = [self parseDictionaryFromString:[arguments objectAtIndex:2]];
        if (customData == nil) {
            [self sendFailureMessage:@"Improperly formed json or object for engage custom data" callbackId:callbackId];
            return;
        }
        shown = [[ATConnect sharedConnection] engage:eventLabel withCustomData:customData fromViewController:self.viewController];
    }
    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsBool:shown];
    [self.commandDelegate sendPluginResult:result callbackId:callbackId];
}

- (void) openAppStore {
    [[ATConnect sharedConnection] openAppStore];
}

- (void) showMessageCenter:(NSArray*)arguments callBackString:(NSString*)callbackId  {
    if (arguments.count == 2) {
        NSDictionary *customData = [self parseDictionaryFromString:[arguments objectAtIndex:1]];
        [[ATConnect sharedConnection] presentMessageCenterFromViewController:self.viewController withCustomData:customData];
    } else {
        [[ATConnect sharedConnection] presentMessageCenterFromViewController:self.viewController];
    }
}

- (void) removeCustomDeviceData:(NSArray*)arguments callBackString:(NSString*)callbackId {
    NSString* key = [arguments objectAtIndex:1];
    [[ATConnect sharedConnection] removeCustomDeviceDataWithKey:key];
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:result callbackId:callbackId];
}

- (void) removeCustomPersonData:(NSArray*)arguments callBackString:(NSString*)callbackId {
    NSString* key = [arguments objectAtIndex:1];
    [[ATConnect sharedConnection] removeCustomPersonDataWithKey:key];
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:result callbackId:callbackId];
}

- (void) sendAttachmentFileWithMimeType:(NSArray*)arguments callBackString:(NSString*)callbackId {
    NSData* data = [[arguments objectAtIndex:1] dataUsingEncoding:NSUTF8StringEncoding];
    NSString* mimeType = [arguments objectAtIndex:2];
    [[ATConnect sharedConnection] sendAttachmentFile:data withMimeType:mimeType];
}

- (void) sendAttachmentImage:(NSArray*)arguments callBackString:(NSString*)callbackId {
    //expecting Base64 encoded string data here
    NSString* base64String = [arguments objectAtIndex:1];
    NSData* data = [[NSData alloc] initWithBase64EncodedString:base64String options:0];
    UIImage* attachmentImage = [UIImage imageWithData:data];
    if (attachmentImage == nil) {
        [self sendFailureMessage:@"Image could not be constructed from the passed data" callbackId:callbackId];
    }
    [[ATConnect sharedConnection] sendAttachmentImage:attachmentImage];
}

- (void) sendAttachmentText:(NSArray*)arguments callBackString:(NSString*)callbackId {
    NSString* text = [arguments objectAtIndex:1];
    [[ATConnect sharedConnection] sendAttachmentText:text];
}

- (void) unreadMessageCount:(NSString*)callbackId {
    NSUInteger unreadMessageCount = [[ATConnect sharedConnection] unreadMessageCount];
    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsInt:unreadMessageCount];
    [self.commandDelegate sendPluginResult:result callbackId:callbackId];
}

- (void)canShowInteraction:(NSArray*)arguments callBackString:(NSString*)callbackId {
    NSString* eventName = [arguments objectAtIndex:1];
    if([eventName isEqual:[NSNull null]]) {
        [self sendFailureMessage:@"Insufficient arguments to call willShowInteraction - eventName is null" callbackId:callbackId];
        return;
    }
    BOOL canShow = [[ATConnect sharedConnection] canShowInteractionForEvent:eventName];
    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsBool:canShow];
    [self.commandDelegate sendPluginResult:result callbackId:callbackId];
}

- (void)canShowMessageCenter:(NSString *)callbackId {
    BOOL canShow = [[ATConnect sharedConnection] canShowMessageCenter];
    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsBool:canShow];
    [self.commandDelegate sendPluginResult:result callbackId:callbackId];
}

@end
