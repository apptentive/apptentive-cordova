@import ApptentiveKit;

#import "ApptentiveBridge.h"


@implementation ApptentiveBridge {
	BOOL apptentiveInitialized;
	BOOL registeredForMessageNotifications;
	NSString *messageNotificationCallback;
}

- (void)execute:(CDVInvokedUrlCommand *)command {
	NSString *callbackId = [command callbackId];
	if ([command arguments].count == 0) {
		[self sendFailureMessage:@"Insufficient arguments: No method name specified." callbackId:callbackId];
		return;
	}
	NSString *functionCall = [command argumentAtIndex:0];
	NSLog(@"Function call: %@", functionCall);

	//initialization
	if ([functionCall isEqualToString:@"deviceReady"]) {
		[self registerWithArguments:command.arguments callbackId:callbackId];
	} else if ([functionCall isEqualToString:@"addCustomDeviceData"]) {
		[self addCustomDeviceData:[command arguments] callBackString:callbackId];
	} else if ([functionCall isEqualToString:@"addCustomPersonData"]) {
		[self addCustomPersonData:[command arguments] callBackString:callbackId];
	} else if ([functionCall isEqualToString:@"engage"]) {
		[self engage:[command arguments] callBackString:callbackId];
	} else if ([functionCall isEqualToString:@"openAppStore"]) {
		[self openAppStore];
	} else if ([functionCall isEqualToString:@"showMessageCenter"]) {
		[self showMessageCenter:[command arguments] callBackString:callbackId];
	} else if ([functionCall isEqualToString:@"registerForMessageNotifications"]) {
		[self registerForMessageNotifications:[command arguments] callBackString:callbackId];
	} else if ([functionCall isEqualToString:@"removeCustomDeviceData"]) {
		[self removeCustomDeviceData:[command arguments] callBackString:callbackId];
	} else if ([functionCall isEqualToString:@"removeCustomPersonData"]) {
		[self removeCustomPersonData:[command arguments] callBackString:callbackId];
	} else if ([functionCall isEqualToString:@"sendAttachmentFileWithMimeType"]) {
		[self sendAttachmentFileWithMimeType:[command arguments] callBackString:callbackId];
	} else if ([functionCall isEqualToString:@"sendAttachmentImage"]) {
		[self sendAttachmentImage:[command arguments] callBackString:callbackId];
	} else if ([functionCall isEqualToString:@"sendAttachmentText"]) {
		[self sendAttachmentText:[command arguments] callBackString:callbackId];
	} else if ([functionCall isEqualToString:@"setProperty"]) {
		[self setProperty:[command arguments] callBackString:callbackId];
	} else if ([functionCall isEqualToString:@"getProperty"]) {
		[self getProperty:[command arguments] callBackString:callbackId];
	} else if ([functionCall isEqualToString:@"unreadMessageCount"]) {
		[self unreadMessageCount:callbackId];
	} else if ([functionCall isEqualToString:@"unregisterForNotifications"]) {
		[self unregisterForNotifications];
	} else if ([functionCall isEqualToString:@"canShowInteraction"]) {
		[self canShowInteraction:[command arguments] callBackString:callbackId];
	} else if ([functionCall isEqualToString:@"canShowMessageCenter"]) {
		[self canShowMessageCenter:callbackId];
	} else {
		//command not recognized
		[self sendFailureMessage:@"Command not recognized" callbackId:callbackId];
	}
}

- (void)sendSuccessMessage:(NSString *)msg callbackId:(NSString *)callbackId {
	CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:msg];
	[self.commandDelegate sendPluginResult:result callbackId:callbackId];
}

- (void)sendFailureMessage:(NSString *)error callbackId:(NSString *)callbackId {
	CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error];
	[self.commandDelegate sendPluginResult:result callbackId:callbackId];
}

- (BOOL)parseBoolValue:(NSString *)value {
	if ([value isEqualToString:@"true"] || [value isEqualToString:@"True"] || [value isEqualToString:@"yes"]) {
		return YES;
	} else
		return [value boolValue];
}

- (NSDictionary *)parseDictionaryFromString:(id)value {
	NSDictionary *data;
	if ([value isKindOfClass:[NSDictionary class]]) {
		data = value;
	} else {
		//custom data needs to be parsed to NSDictionary - assuming json was passed
		NSData *data = [value dataUsingEncoding:NSUTF8StringEncoding];
		NSError *localError = nil;
		data = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
	}
	if (data != nil) {
		return data;
	} else
		return nil;
}

#pragma mark Initialization and Events
- (void)registerWithArguments:(NSArray *)arguments callbackId:(NSString *)callbackId {
	// Access Info.plist for ApptentiveAPIKey
	NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
	NSString *apptentiveKey = [infoPlist objectForKey:@"ApptentiveKey"];
	NSString *apptentiveSignature = [infoPlist objectForKey:@"ApptentiveSignature"];
	NSString *pluginVersion = [infoPlist objectForKey:@"ApptentivePluginVersion"];

	//NSString *pluginVersion = [CDVPlugin]

	// Log key and signature with verbose logs
	if ([arguments[1] isEqualToString:@"verbose"]) {
		NSLog(@"Initializing Apptentive Apptentive App Key: %@, Apptentive App Signature: %@", apptentiveKey, apptentiveSignature);
	}

	if (apptentiveKey.length == 0 || apptentiveSignature.length == 0) {
		[self sendFailureMessage:@"App credentials missing from Info.plist." callbackId:callbackId];
		return;
	}

	ApptentiveConfiguration *configuration = [ApptentiveConfiguration configurationWithApptentiveKey:apptentiveKey apptentiveSignature:apptentiveSignature];
	configuration.distributionName = @"Cordova";
	configuration.distributionVersion = pluginVersion;
	configuration.logLevel = [self parseLogLevel:arguments[1]];

	// Initialize Apptentive on main queue
	Apptentive *apptentive = Apptentive.shared;

	[self.commandDelegate runInBackground:^{
		[apptentive registerWithConfiguration:configuration completion:^(BOOL success) {
			if (success) {
				[self sendSuccessMessage:@"Apptentive registration succeeded." callbackId:callbackId];
			} else {
				[self sendFailureMessage:@"Apptentive registration failed." callbackId:callbackId];
			}
		}];
	}];
}

- (ApptentiveLogLevel)parseLogLevel:(NSString *) logLevel {
	if ([logLevel isEqualToString:@"verbose"]) { return ApptentiveLogLevelVerbose; }
	if ([logLevel isEqualToString:@"debug"]) { return ApptentiveLogLevelDebug; }
	if ([logLevel isEqualToString:@"info"]) { return ApptentiveLogLevelInfo; }
	if ([logLevel isEqualToString:@"warn"]) { return ApptentiveLogLevelWarn; }
	if ([logLevel isEqualToString:@"error"]) { return ApptentiveLogLevelError; }
	if ([logLevel isEqualToString:@"critical"]) { return ApptentiveLogLevelCrit; }
	return ApptentiveLogLevelUndefined;
}

- (void)registerForMessageNotifications:(NSArray *)arguments callBackString:(NSString *)callbackId {
	[Apptentive.shared addObserver:self forKeyPath:@"unreadMessageCount" options:NSKeyValueObservingOptionNew context:nil];
	registeredForMessageNotifications = YES;
	messageNotificationCallback = callbackId;
}

- (void)unregisterForNotifications {
	if (registeredForMessageNotifications) {
		[Apptentive.shared removeObserver:self forKeyPath:@"unreadMessageCount"];
	}
}

#pragma mark Observations

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
	NSNumber *unreadMessageCount = @(Apptentive.shared.unreadMessageCount);
	CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:[unreadMessageCount intValue]];
	[result setKeepCallback:[NSNumber numberWithBool:YES]];
	[self.commandDelegate sendPluginResult:result callbackId:messageNotificationCallback];
}

#pragma mark Properties and Interface Customization

- (void)setProperty:(NSArray *)arguments callBackString:(NSString *)callbackId {
	if (arguments.count < 3) {
		[self sendFailureMessage:@"Insufficient arguments for setting property" callbackId:callbackId];
		return;
	}
	NSString *property_id = [arguments objectAtIndex:1];
	NSString *value = [arguments objectAtIndex:2];
	if ([property_id isEqualToString:@"personName"]) {
		Apptentive.shared.personName = value;
	} else if ([property_id isEqualToString:@"personEmailAddress"]) {
		Apptentive.shared.personEmailAddress = value;
	} else {
		[self sendFailureMessage:@"Property name not recognized" callbackId:callbackId];
	}
}

- (void)getProperty:(NSArray *)arguments callBackString:(NSString *)callbackId {
	if (arguments.count < 2) {
		[self sendFailureMessage:@"Insufficient arguments for getting property" callbackId:callbackId];
		return;
	}
	NSString *property_id = [arguments objectAtIndex:1];
	NSString *value = nil;
	if ([property_id isEqualToString:@"personName"]) {
		value = Apptentive.shared.personName;
	} else if ([property_id isEqualToString:@"personEmailAddress"]) {
		value = Apptentive.shared.personEmailAddress;
	} else {
		[self sendFailureMessage:@"Property name not recognized" callbackId:callbackId];
		return;
	}

	[self sendSuccessMessage:value callbackId:callbackId];
}

#pragma mark Methods

- (void)addCustomDeviceData:(NSArray *)arguments callBackString:(NSString *)callbackId {
	NSString *key = [arguments objectAtIndex:1];
	id value = [arguments objectAtIndex:2];
	if ([value isKindOfClass:[NSString class]]) {
		NSString *stringData = value;
		[Apptentive.shared addCustomDeviceDataString:stringData withKey:key];
	} else if ([value isKindOfClass:[NSNumber class]]) {
		if (value == [NSNumber numberWithBool:YES] || value == [NSNumber numberWithBool:NO]) {
			NSNumber *boolData = value;
			[Apptentive.shared addCustomDeviceDataBool:boolData.boolValue withKey:key];
		} else {
			NSNumber *numberData = value;
			[Apptentive.shared addCustomDeviceDataNumber:numberData withKey:key];
		}
	} else {
		[self sendFailureMessage:@"Custom Device data type not recognized" callbackId:callbackId];
		return;
	}
	CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
	[self.commandDelegate sendPluginResult:result callbackId:callbackId];
}

- (void)addCustomPersonData:(NSArray *)arguments callBackString:(NSString *)callbackId {
	NSString *key = [arguments objectAtIndex:1];
	id value = [arguments objectAtIndex:2];
	if ([value isKindOfClass:[NSString class]]) {
		NSString *stringData = value;
		[Apptentive.shared addCustomPersonDataString:stringData withKey:key];
	} else if ([value isKindOfClass:[NSNumber class]]) {
		if (value == [NSNumber numberWithBool:YES] || value == [NSNumber numberWithBool:NO]) {
			NSNumber *boolData = value;
			[Apptentive.shared addCustomPersonDataBool:boolData.boolValue withKey:key];
		} else {
			NSNumber *numberData = value;
			[Apptentive.shared addCustomPersonDataNumber:numberData withKey:key];
		}
	} else {
		[self sendFailureMessage:@"Custom Person data type not recognized" callbackId:callbackId];
		return;
	}
	CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
	[self.commandDelegate sendPluginResult:result callbackId:callbackId];
}

- (void)engage:(NSArray *)arguments callBackString:(NSString *)callbackId {
	NSString *eventLabel = [arguments objectAtIndex:1];
	if ([eventLabel isEqual:[NSNull null]]) {
		[self sendFailureMessage:@"Insufficient arguments to call engage - label is null" callbackId:callbackId];
		return;
	}

	void (^completion)(BOOL) = ^void(BOOL shown) {
	  CDVPluginResult *result = [CDVPluginResult
		  resultWithStatus:CDVCommandStatus_OK
			 messageAsBool:shown];
	  [self.commandDelegate sendPluginResult:result callbackId:callbackId];
	};

	if (arguments.count == 2) {
		[Apptentive.shared engage:eventLabel fromViewController:self.viewController completion:completion];
		return;
	} else if (arguments.count == 3) {
		NSDictionary *customData = [self parseDictionaryFromString:[arguments objectAtIndex:2]];
		if (customData == nil) {
			[self sendFailureMessage:@"Improperly formed json or object for engage custom data" callbackId:callbackId];
			return;
		}
		[Apptentive.shared engage:eventLabel withCustomData:customData fromViewController:self.viewController completion:completion];
		return;
	}

	[self sendFailureMessage:@"Too many arguments" callbackId:callbackId];
}

- (void)openAppStore {
	NSLog(@"Open App Store is not implemented in the new iOS SDK");
}

- (void)showMessageCenter:(NSArray *)arguments callBackString:(NSString *)callbackId {
	if (arguments.count == 2) {
		NSDictionary *customData = [self parseDictionaryFromString:[arguments objectAtIndex:1]];
		[Apptentive.shared presentMessageCenterFromViewController:self.viewController withCustomData:customData];
	} else {
		[Apptentive.shared presentMessageCenterFromViewController:self.viewController completion:nil];
		// [Apptentive.shared presentMessageCenterFromViewController:self.viewController];
	}
}

- (void)removeCustomDeviceData:(NSArray *)arguments callBackString:(NSString *)callbackId {
	NSString *key = [arguments objectAtIndex:1];
	[Apptentive.shared removeCustomDeviceDataWithKey:key];
	CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
	[self.commandDelegate sendPluginResult:result callbackId:callbackId];
}

- (void)removeCustomPersonData:(NSArray *)arguments callBackString:(NSString *)callbackId {
	NSString *key = [arguments objectAtIndex:1];
	[Apptentive.shared removeCustomPersonDataWithKey:key];
	CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
	[self.commandDelegate sendPluginResult:result callbackId:callbackId];
}

- (void)sendAttachmentFileWithMimeType:(NSArray *)arguments callBackString:(NSString *)callbackId {
	NSData *data = [[arguments objectAtIndex:1] dataUsingEncoding:NSUTF8StringEncoding];
	NSString *mimeType = [arguments objectAtIndex:2];
	[Apptentive.shared sendAttachmentData:data mimeType:mimeType];
	// [Apptentive.shared sendAttachmentFile:data withMimeType:mimeType];
}

- (void)sendAttachmentImage:(NSArray *)arguments callBackString:(NSString *)callbackId {
	//expecting Base64 encoded string data here
	NSString *base64String = [arguments objectAtIndex:1];
	NSData *data = [[NSData alloc] initWithBase64EncodedString:base64String options:0];
	UIImage *attachmentImage = [UIImage imageWithData:data];
	if (attachmentImage == nil) {
		[self sendFailureMessage:@"Image could not be constructed from the passed data" callbackId:callbackId];
	}
	[Apptentive.shared sendAttachmentImage:attachmentImage];
}

- (void)sendAttachmentText:(NSArray *)arguments callBackString:(NSString *)callbackId {
	NSString *text = [arguments objectAtIndex:1];
	[Apptentive.shared sendAttachmentText:text];
}

- (void)unreadMessageCount:(NSString *)callbackId {
	NSUInteger unreadMessageCount = [Apptentive.shared unreadMessageCount];
	CDVPluginResult *result = [CDVPluginResult
		resultWithStatus:CDVCommandStatus_OK
			messageAsInt:(int)unreadMessageCount];
	[self.commandDelegate sendPluginResult:result callbackId:callbackId];
}

- (void)canShowInteraction:(NSArray *)arguments callBackString:(NSString *)callbackId {
	NSString *eventName = [arguments objectAtIndex:1];
	if ([eventName isEqual:[NSNull null]]) {
		[self sendFailureMessage:@"Insufficient arguments to call willShowInteraction - eventName is null" callbackId:callbackId];
		return;
	}
	[Apptentive.shared queryCanShowInteractionForEvent:eventName completion:^(BOOL canShow) {
		CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:canShow];
		[self.commandDelegate sendPluginResult:result callbackId:callbackId];
	}];
}

- (void)canShowMessageCenter:(NSString *)callbackId {
	// ApptentiveKit Message Center will always show either a "not available" note or succeed.
	CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:YES];
	[self.commandDelegate sendPluginResult:result callbackId:callbackId];
}

@end
