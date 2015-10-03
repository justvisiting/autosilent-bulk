#import "Model.h"
#import "Constants.h"

static Model * modelInstance = nil;
static void callback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) ;


void WriteMyPropertyListToFile( CFPropertyListRef propertyList,
							   CFURLRef fileURL ) {
	CFDataRef xmlData;
	Boolean status;
	SInt32 errorCode;
	
	// Convert the property list into XML data.
	xmlData = CFPropertyListCreateXMLData( kCFAllocatorDefault, propertyList );
	
	// Write the XML data to the file.
	status = CFURLWriteDataAndPropertiesToResource (
													fileURL,                  // URL to use
													xmlData,                  // data to write
													nil,
													&errorCode);
	
	CFRelease(xmlData);
}



@implementation Model

+(Model*) GetModel
{
	if ( modelInstance == nil)
	{
		modelInstance = [ Model alloc];
		[modelInstance initialize];
	}
	return modelInstance;
}


-(BOOL) GetBoolValue:(NSString*) key
{
	return [super GetBoolValue:key];
}

-(void) RefreshDaemonDictionary
{
	[daemonDict release];
	daemonDict = [[NSDictionary alloc] initWithContentsOfFile:daemonPath];
}

-(BOOL) GetBoolValueFromDaemon:(NSString*) key
{	
	CFBooleanRef val =  CFDictionaryGetValue((CFDictionaryRef)daemonDict, key);
	
	if(val == NULL)
	{
		return FALSE;
	}
	
	
	BOOL rv = CFBooleanGetValue(val);
	
	CFRelease(val);
	
	return rv;
}

-(id) GetValueFromDaemon:(NSString*) key
{	
    return [daemonDict valueForKey:key];
}

-(void) SetBoolValue:(NSString*)key value:(BOOL)val
{
	
	[super SetBoolValue:key value:val];
	
	[self WriteValues];
	
	if ([key compare:AutomaticEnabledKey options:NSCaseInsensitiveSearch] == NSOrderedSame )
	{
		[BaseDictionary PostInterProcessNotification:NotificaitonRunSilentMed];
		[[NSNotificationCenter defaultCenter] postNotificationName:AutomaticValueChangedNotification object:self];

	}
	
	if ([key compare:ManualMode options:NSCaseInsensitiveSearch] == NSOrderedSame )
	{
		if ([self GetBoolValue:ManualMode])
		{
			[[NSNotificationCenter defaultCenter] postNotificationName:NotificaitonManualModeSwitchedByUIOn object:nil];
		}
		else
		{
			[BaseDictionary PostInterProcessNotification:NotificaitonManualModeSwitchedByUIOff];
		}
	}
	
	if ([key compare:CalSyncEnabled options:NSCaseInsensitiveSearch] == NSOrderedSame)
	{
		[BaseDictionary PostInterProcessNotification:NotificaitonScheduleChanged];
	}
}

-(void) SetBoolValueWithoutNotification:(NSString*)key value:(BOOL)val
{
	[super SetBoolValue:key value:val];
	
	[self WriteValues];
}

-(void) SetValue:(NSString*)key value:(id)val
{
	[super SetValue:key value:val];
	[self WriteValues];
}

-(int) GetIntegerValue:(NSString*)key
{
	return [super GetIntegerValue:key];
}

-(void) SetIntegerValue:(NSString*)key value:(int)val
{
	[super SetIntegerValue:key value:val];
	[self WriteValues];
}

-(void) SetDateValue:(NSString*)key value:(NSDate *)val
{
	//int seconds = GetTimeElapsedForTheday(val);
	
	//[self SetIntegerValue:key value:seconds];
	
}

- (CFPropertyListRef) CreateListFromFile:(CFStringRef) filePath
{
	
	CFPropertyListRef propertyList;
	CFStringRef       errorString;
	CFDataRef         resourceData;
	Boolean           status;
	SInt32            errorCode;
	CFURLRef fileURL;
	fileURL = CFURLCreateWithFileSystemPath( kCFAllocatorDefault,
											filePath,       // file path name
											kCFURLPOSIXPathStyle,    // interpret as POSIX path
											false );    
	
	// Read the XML file.
	status = CFURLCreateDataAndPropertiesFromResource(
													  kCFAllocatorDefault,
													  fileURL,
													  &resourceData,            // place to put file data
													  NULL,
													  NULL,
													  &errorCode);
	
	// Reconstitute the dictionary using the XML data.
	propertyList = CFPropertyListCreateFromXMLData( kCFAllocatorDefault,
												   resourceData,
												   kCFPropertyListImmutable,
												   &errorString);
	
		//CFRelease( resourceData );
	CFRelease(fileURL);
	return propertyList;
	
}

-(void) initialize 
{
	
	//[self InitObserver];
	//appEnabled = [MYSwitch alloc];
	//weekdayNightsEnabled = [MYSwitch alloc];
	//weekendNightsEnabled = [MYSwitch alloc];
	//calenderSyncEnabled = [MYSwitch alloc];
    
	//PropertiesView Elements
	//callEnabled = [MYSwitch alloc];
	//vibrateEnabled = [MYSwitch alloc];
	//voiceMailEnabled = [MYSwitch alloc];
	//newMailEnabled = [MYSwitch alloc];
	//calenderAlertEnabled = [MYSwitch alloc];
	//smsAlertEnabled = [MYSwitch alloc];
	//lockUnlockEnabled = [MYSwitch alloc];
	//keyboardSoundEnabled = [MYSwitch alloc];
	
	//weekdayNightStart = [TimeButton alloc];
	//weekdayNightEnd = [TimeButton alloc];
	//weekendNightStart = [TimeButton alloc];
	//weekendNightEnd = [TimeButton alloc];
	
	//Debug Elements
	//loggingSwitch = [MYSwitch alloc];
	//loggingSwitch->isOn = FALSE;
	
	//appEnabled->isOn = FALSE;
	//weekdayNightsEnabled->isOn = FALSE;
	//weekendNightsEnabled->isOn = FALSE;
	//calenderSyncEnabled->isOn = FALSE;
    
	//PropertiesView Elements
	//callEnabled->isOn = FALSE;
	//vibrateEnabled->isOn = FALSE;
	//voiceMailEnabled->isOn = FALSE;
	//newMailEnabled->isOn  = FALSE;
	//calenderAlertEnabled->isOn = FALSE;
	//smsAlertEnabled->isOn = FALSE;
	//lockUnlockEnabled->isOn = FALSE;
	//keyboardSoundEnabled->isOn = FALSE;
	
	//weekdayNightStart->date = [NSDate date];
	//weekdayNightEnd->date = [NSDate date];
	//weekendNightStart->date = [NSDate date];
	//weekendNightEnd->date = [NSDate date];
	
	[self InitInterProcessObserver];
	
	dict = (NSMutableDictionary*) [self CreateListFromFile:(CFStringRef)settingsPath];
	daemonDict = [[NSDictionary alloc] initWithContentsOfFile:daemonPath];
	
	if (dict == nil)
		return;
	
	//appEnabled->isOn = [self GetBoolValue:AppEnabled];
	
	//weekdayNightsEnabled->isOn = [self GetBoolValue:NightEnabled];
	//weekendNightsEnabled->isOn = [self GetBoolValue:WeekendNightEnabled];
	//calenderSyncEnabled->isOn = [self GetBoolValue:CalSyncEnabled];
    
	//PropertiesView Elements
	//callEnabled->isOn = [self GetBoolValue:PhoneEnabled];
	//vibrateEnabled->isOn = [self GetBoolValue:VibrateEnabled];
	//voiceMailEnabled->isOn = [self GetBoolValue:VoiceMailEnabled];
	//newMailEnabled->isOn  = [self GetBoolValue:NewMailEnabled];
	//calenderAlertEnabled->isOn = [self GetBoolValue:CalAlertEnabled];
	//smsAlertEnabled->isOn = [self GetBoolValue:SmsAlertEnabled];
	//lockUnlockEnabled->isOn = [self GetBoolValue:LockUnlockEnabled];
	//keyboardSoundEnabled->isOn = [self GetBoolValue:KeyboardSoundEnabled];
	
	//loggingSwitch->isOn = [self GetBoolValue:LoggingEnabled];
	
	//weekdayNightStart->date = GetDateFromInteger( [self GetIntegerValue:weekdayStart]);
	//weekdayNightEnd->date = GetDateFromInteger( [self GetIntegerValue:weekdayEnd]);
	//weekendNightStart->date = GetDateFromInteger( [self GetIntegerValue:weekendStart]);
	//weekendNightEnd->date = GetDateFromInteger( [self GetIntegerValue:weekendEnd]);
	
	id val =  [daemonDict objectForKey:IsKeyNotValid];
	
	if (val != NULL)
	{
		if( ![val boolValue])
			deviceActivated = [self GetStringValue:ActivationTag];
		else
			deviceActivated = NULL;
	}
	else
	{
		deviceActivated = [self GetStringValue:ActivationTag];
	}
	
	silentModeOn = [self GetBoolValueFromDaemon:SilentModeOn];
	
	[self SynchronizeManualSettings];
}



-(void) WriteToDictionary
{
	
	if (dict == nil)
	{
		dict = CFDictionaryCreateMutable( kCFAllocatorDefault,
										 0,
										 &kCFTypeDictionaryKeyCallBacks,
										 &kCFTypeDictionaryValueCallBacks );
	}
	// Put the various items into the dictionary.
	// Because the values are retained as they are placed into the
	//  dictionary, we can release any allocated objects here.
	
	//[self SetBoolValue:AppEnabled value:appEnabled->isOn];
	
	//[self SetBoolValue:NightEnabled value:weekdayNightsEnabled->isOn ];
	//[self SetBoolValue:WeekendNightEnabled value:weekendNightsEnabled->isOn];
	//[self SetBoolValue:CalSyncEnabled value:calenderSyncEnabled->isOn];
    
	//PropertiesView Elements
	//[self SetBoolValue:PhoneEnabled value:callEnabled->isOn];
	//[self SetBoolValue:VibrateEnabled value:vibrateEnabled->isOn];
	//[self SetBoolValue:VoiceMailEnabled value:voiceMailEnabled->isOn];
	//[self SetBoolValue:NewMailEnabled value:newMailEnabled->isOn];
	//[self SetBoolValue:CalAlertEnabled value:calenderAlertEnabled->isOn];
	//[self SetBoolValue:SmsAlertEnabled value:smsAlertEnabled->isOn];
	//[self SetBoolValue:LockUnlockEnabled value:lockUnlockEnabled->isOn];
	//[self SetBoolValue:KeyboardSoundEnabled value:keyboardSoundEnabled->isOn];
	
	//[self SetBoolValue:LoggingEnabled value:loggingSwitch->isOn];
	
	//[self SetDateValue:weekdayStart value:weekdayNightStart->date];
	//[self SetDateValue:weekdayEnd value:weekdayNightEnd->date];
	//[self SetDateValue:weekendStart value:weekendNightStart->date];
	//[self SetDateValue:weekendEnd value:weekendNightEnd->date];
	
	if (deviceActivated == NULL || [deviceActivated length] == 0)
		CFDictionaryRemoveValue(dict,ActivationTag);
	else
     	CFDictionarySetValue(dict, ActivationTag, deviceActivated);
	
	
	//CFDictionarySetValue(dict, CFSTR("QuiteStartTime"), kCFNumberNegativeInfinity);
	//CFDictionarySetValue(dict, CFSTR("QuiteEndTime"), kCFNumberNegativeInfinity);
	
	
}


- (void) WriteValues {
	CFPropertyListRef propertyList;
	CFURLRef fileURL;
	
	// Construct a complex dictionary object;
	[self WriteToDictionary];
	propertyList = (CFPropertyListRef)dict;
	
	// Create a URL that specifies the file we will create to
	// hold the XML data.
	fileURL = CFURLCreateWithFileSystemPath( kCFAllocatorDefault,
											(CFStringRef)settingsPath,
											//CFSTR("/Applications/HelloWorld/settings.plist"),
											//CFSTR("/private/var/mobile/Library/SilentMe/settings.plist"),       // file path name
											kCFURLPOSIXPathStyle,    // interpret as POSIX path
											false );                 // is it a directory?
	
	// Write the property list to the file.
	WriteMyPropertyListToFile( propertyList, fileURL );
	//CFRelease(propertyList);
	
	// Recreate the property list from the file.
	//propertyList = CreateMyPropertyListFromFile( fileURL );
	
	// Release any objects to which we have references.
	//CFRelease(propertyList);
	CFRelease(fileURL);
	
	//return 0;
}

-(void) refreshStatusButton
{
}

-(void) InitInterProcessObserver
{
	CFNotificationCenterRef notificationCenter = CFNotificationCenterGetDarwinNotifyCenter();
	
	CFNotificationCenterAddObserver(
									notificationCenter, //center
									NULL, // observer
									callback, // callback
									(CFStringRef)NotificationSilentStatusChanged, // name
									self, // object
									CFNotificationSuspensionBehaviorHold
									); 
	
	CFNotificationCenterAddObserver(
									notificationCenter, //center
									NULL, // observer
									callback, // callback
									(CFStringRef)NotificationFixSilentSwitchDone, // name
									self, // object
									CFNotificationSuspensionBehaviorHold
									); 
	
	CFNotificationCenterAddObserver(
									notificationCenter, //center
									NULL, // observer
									callback, // callback
									(CFStringRef)NotificaitonActiveScheduleChanged, // name
									self, // object
									CFNotificationSuspensionBehaviorHold
									); 
}

-(void) PostMyNotification:(NSString*)key
{
	if ([key caseInsensitiveCompare:AutomaticEnabledKey] == NSOrderedSame)
	{
		[BaseDictionary PostInterProcessNotification:NotificaitonRunSilentMed];
	}
			
}

-(void) SynchronizeManualSettings
{
	bool daemonEnabled =  [self GetBoolValueFromDaemon:ManualMode];
	[self SetBoolValueWithoutNotification:ManualMode value:daemonEnabled];
	
	id daemonTime = [self GetValueFromDaemon:ManualEndTime];
	
	[self SetValue:ManualEndTime value:daemonTime];
}

@end

static void callback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) 
{
	if(name != NULL)
	{
		if(CFStringCompare((CFStringRef)NotificationSilentStatusChanged, name, kCFCompareCaseInsensitive) == kCFCompareEqualTo)
		{
			[[NSNotificationCenter defaultCenter] postNotificationName:StatusChangedNotification object:[Model GetModel]];
		}
		if(CFStringCompare((CFStringRef)NotificationFixSilentSwitchDone, name, kCFCompareCaseInsensitive) == kCFCompareEqualTo)
		{
			[[NSNotificationCenter defaultCenter] postNotificationName:NotificationFixSilentSwitchDone object:[Model GetModel]];
		}
		if(CFStringCompare((CFStringRef)NotificaitonActiveScheduleChanged, name, kCFCompareCaseInsensitive) == kCFCompareEqualTo)
		{
			[[NSNotificationCenter defaultCenter] postNotificationName:NotificaitonActiveScheduleChanged object:[Model GetModel]];
		}
	}
	
    return;
}
