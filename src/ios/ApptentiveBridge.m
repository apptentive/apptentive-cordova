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
    
    //initialization
    if ([functionCall isEqualToString:@"init"]) {
        [self initAPIKey:callbackId];
        return;
    }
    if (!apptentiveInitted) {
        [self sendFailureMessage:@"Apptentive API key is not set" callbackId:callbackId];
        return;
    }
    
    //all other functions
    if ([functionCall isEqualToString:@"addAmazonSnsPushIntegration"]) {
        [self addAmazonSNSIntegrationWithDeviceToken:[command arguments] callBackString:callbackId];
    }
    else if ([functionCall isEqualToString:@"addCustomDeviceData"]) {
        [self addCustomDeviceData:[command arguments] callBackString:callbackId];
    }
    else if ([functionCall isEqualToString:@"addCustomPersonData"]) {
        [self addCustomPersonData:[command arguments] callBackString:callbackId];
    }
    else if ([functionCall isEqualToString:@"addIntegration"]) {
        [self addIntegration:[command arguments] callBackString:callbackId];
    }
    else if ([functionCall isEqualToString:@"addIntegrationWithDeviceToken"]) {
        [self addIntegration:[command arguments] callBackString:callbackId];
    }
    else if ([functionCall isEqualToString:@"addParsePushIntegration"]) {
        [self addParseIntegrationWithDeviceToken:[command arguments] callBackString:callbackId];
    }
    else if ([functionCall isEqualToString:@"addUrbanAirshipPushIntegration"]) {
        [self addUrbanAirshipIntegrationWithDeviceToken:[command arguments] callBackString:callbackId];
    }
    else if ([functionCall isEqualToString:@"engage"]) {
        [self engage:[command arguments] callBackString:callbackId];
    }
    else if ([functionCall isEqualToString:@"forwardPushNotificationToApptentive"]) {
        [self forwardPushNotificationToApptentive:[command arguments] callBackString:callbackId];
    }
    else if ([functionCall isEqualToString:@"openAppStore"]) {
        [self openAppStore];
    }
    else if ([functionCall isEqualToString:@"presentMessageCenterFromViewController"]) {
        [self presentMessageCenterFromViewController];
    }
    else if ([functionCall isEqualToString:@"presentMessageCenterFromViewControllerWithCustomData"]) {
        [self presentMessageCenterFromViewControllerWithCustomData:[command arguments] callBackString:callbackId];
    }
    else if ([functionCall isEqualToString:@"registerForMessageNotifications"]) {
        [self registerForMessageNotifications:[command arguments] callBackString:callbackId];
    }
    else if ([functionCall isEqualToString:@"registerForRateNotifications"]) {
        [self registerForRateNotifications:[command arguments] callBackString:callbackId];
    }
    else if ([functionCall isEqualToString:@"registerForSurveyNotifications"]) {
        [self registerForSurveyNotifications:[command arguments] callBackString:callbackId];
    }
    else if ([functionCall isEqualToString:@"removeCustomDeviceDataWithKey"]) {
        [self removeCustomDeviceData:[command arguments] callBackString:callbackId];
    }
    else if ([functionCall isEqualToString:@"removeCustomPersonDataWithKey"]) {
        [self removeCustomPersonData:[command arguments] callBackString:callbackId];
    }
    else if ([functionCall isEqualToString:@"removeIntegration"]) {
        [self removeIntegration:[command arguments] callBackString:callbackId];
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
    else if ([functionCall isEqualToString:@"unreadMessageCount"]) {
        [self unreadMessageCount:callbackId];
    }
    else if ([functionCall isEqualToString:@"unregisterForNotifications"]) {
        [self unregisterForNotifications];
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
    //access info.plist for API key
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    NSString *apiKey = [infoPlist objectForKey:@"Apptentive_API_KEY"];

    NSLog(@"Initializing Apptentive API Key: %@", apiKey);

    if (!apiKey) {
        [self sendFailureMessage:@"Insufficient arguments - no apiKey" callbackId:callbackId];
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

- (void) registerForRateNotifications:(NSArray*)arguments callBackString:(NSString*)callbackId {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userAgreedToRateNotification:) name:ATAppRatingFlowUserAgreedToRateAppNotification object:nil];
    registeredForRateNotifications = YES;
    rateNotificationCallback = callbackId;
}

- (void) registerForSurveyNotifications:(NSArray*)arguments callBackString:(NSString*)callbackId {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(surveySentNotification:) name:ATSurveySentNotification object:nil];
    registeredForSurveyNotifications = YES;
    surveyNotificationCallback = callbackId;
}

- (void) unregisterForNotifications {
    if (registeredForMessageNotifications) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:ATMessageCenterUnreadCountChangedNotification object:nil];
        registeredForMessageNotifications = NO;
        messageNotificationCallback = nil;
    }
    if (registeredForRateNotifications) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:ATAppRatingFlowUserAgreedToRateAppNotification object:nil];
        registeredForSurveyNotifications = NO;
        surveyNotificationCallback = nil;
    }
    if (registeredForSurveyNotifications) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:ATSurveySentNotification object:nil];
        registeredForSurveyNotifications = NO;
        surveyNotificationCallback = nil;
    }
}


#pragma mark Notifications

- (void)unreadMessageCountChanged:(NSNotification *)notification {
    // Unread message count is contained in the notification's userInfo dictionary.
    NSNumber *unreadMessageCount = [notification.userInfo objectForKey:@"count"];
    [self sendSuccessMessage:[unreadMessageCount stringValue] callbackId:messageNotificationCallback];
}

- (void) userAgreedToRateNotification:(NSNotification *)notification {
    [self sendSuccessMessage:@"rate notification" callbackId:rateNotificationCallback];
}

- (void) surveySentNotification:(NSNotification *)notification {
    [self sendSuccessMessage:@"survey notification" callbackId:surveyNotificationCallback];
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
//    else if ([property_id isEqualToString:@"useMessageCenter"]) {
//        //warning - useMessageCenter is deprecated
//        [ATConnect sharedConnection].useMessageCenter = [self parseBoolValue:value];
//    }
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

#pragma mark Methods

- (void) addAmazonSNSIntegrationWithDeviceToken:(NSArray*)arguments callBackString:(NSString*)callbackId  {
    NSString* deviceToken = [arguments objectAtIndex:1];
    NSData* data = [deviceToken dataUsingEncoding:NSUTF8StringEncoding];
    [[ATConnect sharedConnection] addAmazonSNSIntegrationWithDeviceToken:data];
}

- (void) addCustomDeviceData:(NSArray*)arguments callBackString:(NSString*)callbackId {
    NSString* key = [arguments objectAtIndex:1];
    id value = [arguments objectAtIndex:2];
    if ([value isKindOfClass:[NSString class]]) {
        NSString* stringData = value;
        [[ATConnect sharedConnection] addCustomDeviceData:stringData withKey:key];
    }
//    else if ([value isKindOfClass:[NSNumber class]]) {
//        NSDate* dateData = value;
//        [[ATConnect sharedConnection] addCustomDeviceData:dateData withKey:key];
//    }
//    else if ([value isKindOfClass:[NSNumber class]]) {
//        NSNumber* numberData = value;
//        [[ATConnect sharedConnection] addCustomDeviceData:numberData withKey:key];
//    }
}

- (void) addCustomPersonData:(NSArray*)arguments callBackString:(NSString*)callbackId {
    NSString* key = [arguments objectAtIndex:1];
    id value = [arguments objectAtIndex:2];
    if ([value isKindOfClass:[NSString class]]) {
        NSString* stringData = value;
        [[ATConnect sharedConnection] addCustomPersonData:stringData withKey:key];
    }
//    else if ([value isKindOfClass:[NSNumber class]]) {
//        NSDate* dateData = value;
//        [[ATConnect sharedConnection] addCustomPersonData:dateData withKey:key];
//    }
//    else if ([value isKindOfClass:[NSNumber class]]) {
//        NSNumber* numberData = value;
//        [[ATConnect sharedConnection] addCustomPersonData:numberData withKey:key];
//    }
}

- (void) addIntegration:(NSArray*)arguments callBackString:(NSString*)callbackId {
    NSString* integration = [arguments objectAtIndex:1];
    NSDictionary *configuration = [self parseDictionaryFromString:[arguments objectAtIndex:2]];
    [[ATConnect sharedConnection] addIntegration:integration withConfiguration:configuration];
}

- (void) addIntegrationWithDeviceToken:(NSArray*)arguments callBackString:(NSString*)callbackId  {
    NSString* integration = [arguments objectAtIndex:1];
    NSString* deviceToken = [arguments objectAtIndex:2];
    NSData* token = [deviceToken dataUsingEncoding:NSUTF8StringEncoding];
    [[ATConnect sharedConnection] addIntegration:integration withDeviceToken:token];
}

- (void) addParseIntegrationWithDeviceToken:(NSArray*)arguments callBackString:(NSString*)callbackId  {
    NSString* deviceToken = [arguments objectAtIndex:1];
    NSData* data = [deviceToken dataUsingEncoding:NSUTF8StringEncoding];
    [[ATConnect sharedConnection] addParseIntegrationWithDeviceToken:data];
}

- (void) addUrbanAirshipIntegrationWithDeviceToken:(NSArray*)arguments callBackString:(NSString*)callbackId  {
    NSString* deviceToken = [arguments objectAtIndex:1];
    NSData* data = [deviceToken dataUsingEncoding:NSUTF8StringEncoding];
    [[ATConnect sharedConnection] addUrbanAirshipIntegrationWithDeviceToken:data];
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
        NSDictionary *customData = [self parseDictionaryFromString:[arguments objectAtIndex:2]];
        if (customData == nil) {
            [self sendFailureMessage:@"Improperly formed json or object for engage custom data" callbackId:callbackId];
            return;
        }
        [[ATConnect sharedConnection] engage:eventLabel withCustomData:customData fromViewController:self.viewController];
    }
}

- (void) forwardPushNotificationToApptentive:(NSArray*)arguments callBackString:(NSString*)callbackId {
    NSDictionary *userInfo = [self parseDictionaryFromString:[arguments objectAtIndex:1]];
    [[ATConnect sharedConnection] didReceiveRemoteNotification:userInfo fromViewController:self.viewController];
}

- (void) openAppStore {
    [[ATConnect sharedConnection] openAppStore];
}

- (void) presentMessageCenterFromViewController {
    [[ATConnect sharedConnection] presentMessageCenterFromViewController:self.viewController];
}

- (void) presentMessageCenterFromViewControllerWithCustomData:(NSArray*)arguments callBackString:(NSString*)callbackId  {
    NSDictionary *customData = [self parseDictionaryFromString:[arguments objectAtIndex:1]];
    [[ATConnect sharedConnection] presentMessageCenterFromViewController:self.viewController withCustomData:customData];
}

- (void) removeCustomDeviceData:(NSArray*)arguments callBackString:(NSString*)callbackId {
    NSString* key = [arguments objectAtIndex:1];
    [[ATConnect sharedConnection] removeCustomDeviceDataWithKey:key];
}

- (void) removeCustomPersonData:(NSArray*)arguments callBackString:(NSString*)callbackId {
    NSString* key = [arguments objectAtIndex:1];
    [[ATConnect sharedConnection] removeCustomPersonDataWithKey:key];
}

- (void) removeIntegration:(NSArray*)arguments callBackString:(NSString*)callbackId {
    NSString* integration = [arguments objectAtIndex:1];
    [[ATConnect sharedConnection] removeIntegration:integration];
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
    NSString *messageCountAsString = [NSString stringWithFormat:@"%lu", (unsigned long)unreadMessageCount];
    [self sendSuccessMessage:messageCountAsString callbackId:callbackId];
}

@end



