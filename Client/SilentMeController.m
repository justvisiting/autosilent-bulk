#import <UIKit/UIKit.h>
#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>

static int const P_SPACE = 50;
static int const CONTENTVIEW_SPACE = 50;

//static CFStringRef const settingsPath = CFSTR("/private/var/mobile/Library/SilentMe/settings.plist");
static CFStringRef const settingsPath = CFSTR("/Applications/SilentMe.app/settings.plist");
static CFStringRef const daemonPath = CFSTR("/Applications/SilentMe.app/daemonsettings.plist");
static CFStringRef const appPath = CFSTR("/Applications/SilentMe.app");
static CFStringRef const OnIcon = CFSTR("/Applications/SilentMe.app/SilentOn.png");
static CFStringRef const OffIcon = CFSTR("/Applications/SilentMe.app/SilentOff.png");
static CFStringRef const SettingsDisabledIcon = CFSTR("/Applications/SilentMe.app/SilentDisabled.png");

static CFStringRef const VibrateLabel=CFSTR("Vibrate Alert");

static CFStringRef const NotificaitonRingerOn = CFSTR("com.iphonepackers.ringerOn");
static CFStringRef const NotificaitonRingerOff = CFSTR("com.iphonepackers.ringerOff");
static CFStringRef const NotificaitonRunSilentMed = CFSTR("com.iphonepackers.runsilentMed");
static CFStringRef const NotificaitonVibrateOn = CFSTR("com.iphonepackers.vibrateOn");
static CFStringRef const NotificaitonVibrateOff = CFSTR("com.iphonepackers.vibrateOff");
static CFStringRef const NotificationSilentStatusChanged = CFSTR("com.iphonepackers.statusChanged");

//static CFStringRef const logPath = CFSTR("/Applications/SilentMe.app");
static CFStringRef const logPath = CFSTR("/private/var/mobile/Library/SilentMe");

static CFStringRef const AppEnabled = CFSTR("AppEnabled");
static CFStringRef const PhoneEnabled = CFSTR("CallEnabled");
static CFStringRef const VibrateEnabled = CFSTR("VibrateEnabled");
static CFStringRef const VoiceMailEnabled = CFSTR("VoiceMailenabled");
static CFStringRef const NewMailEnabled = CFSTR("NewMailEnabled");
static CFStringRef const CalAlertEnabled = CFSTR("CalAlertEnabled");
static CFStringRef const SmsAlertEnabled = CFSTR("SmsAlertEnabled");
static CFStringRef const NightEnabled = CFSTR("WeekdayNightEnabled");
static CFStringRef const WeekendNightEnabled = CFSTR("WeekendNightEnabled");
static CFStringRef const CalSyncEnabled = CFSTR("CalSyncEnabled");
static CFStringRef const OrigRingTone = CFSTR("OrigRingTone");
static CFStringRef const LockUnlockEnabled = CFSTR("LockUnLockSoundEnabled");
static CFStringRef const KeyboardSoundEnabled = CFSTR("KeyboardSoundEnabled");

static CFStringRef const LoggingEnabled = CFSTR("LoggingEnabled");
static CFStringRef const SilentModeOn = CFSTR("silentModeOn");

static CFStringRef const weekendStart = CFSTR("WeekendQuiteStartTime");
static CFStringRef const weekendEnd = CFSTR("WeekendQuiteEndTime");
static CFStringRef const weekdayStart = CFSTR("WeekdayQuiteStartTime");
static CFStringRef const weekdayEnd = CFSTR("WeekdayQuiteEndTime");
static CFStringRef const ActivationTag = CFSTR("key");
static CFStringRef const IsKeyNotValid = CFSTR("IsKeyNotValid");
static CFStringRef const URLString = CFSTR("http://iphonepackers.info/app/VerifyApp?v=4&code=");
//static CFStringRef const BuyURLString = CFSTR("http://www.iphonepackers.info/app/BuyAutoSilent?v=3&deviceid=");
static CFStringRef const BuyURLString = CFSTR("http://www.iphonepackers.info/app/Buy?v=4&appid=autosilent&code=");

static CFStringRef const LogUrl = CFSTR("http://iphonepackers.info/app/LogDiagnostics?v=4&appId=autosilent&code=");

static CFStringRef const NotActivatedStr = CFSTR("The app is not yet activated, please press OK to activate the app");

static CFStringRef const Pending = CFSTR("pending");
static CFStringRef const Failed = CFSTR("failed");
static CFStringRef const Reversed = CFSTR("reversed");
static CFStringRef const NotActivated = CFSTR("notactivated");

static CFStringRef const Completed = CFSTR("completed");
static CFStringRef const Error = CFSTR("error");
static CFStringRef const OurError = CFSTR("ourerror");


static CFStringRef const SuccessMsg = CFSTR("The app has been successfully activated. Enjoy your Silent hours!");
static CFStringRef const PendingMsg = CFSTR("Sorry your payment is still being processed. You will be asked to activate again. Enjoy all the benefits of AutoSilent till then.");
static CFStringRef const NotPurchasedMsg = CFSTR("To enjoy Silent Hours, please purchase the product from cydia store. The app will run for a trial period of 3 days.");
static CFStringRef const GenericActivationError = CFSTR(" Sorry we cannot activate the product now, you will be asked to reactivate later. If problem continues, contact autosilent@iphonepackers.info");
static CFStringRef const PaymentServiceError = CFSTR(" There was a problem connecting to the payment service.You will be asked to activate later.");
static CFStringRef const PaymentFailed = CFSTR(" Your payment was not completed successfully. Please purchase the program again or try later.");

@interface FlipView : UIImageView
@end

@class HelloController;
@class MYSwitch;
@class UIGlassButton;

@interface TimeButton : NSObject
{
	@public
	UIButton *button;
	NSDate *date;
	HelloController *controller;
	NSString *titlePrefix;
	UIDatePicker *picker;
}

-(void) OnClicked:(UIButton*) button;
- (void) changedDate: (UIDatePicker *) picker;
-(void) initializeWithController:(HelloController*) cntrller Title:(NSString*)title Centre:(CGPoint)center;
-(void) UpdateButton;

@end



@interface Model  : NSObject
{
	@public
	MYSwitch        *appEnabled;
	MYSwitch		*weekdayNightsEnabled;
	MYSwitch        *weekendNightsEnabled;
	MYSwitch		*calenderSyncEnabled;
    
	TimeButton  *weekdayNightStart;
	TimeButton  *weekdayNightEnd;
	TimeButton  *weekendNightStart;
	TimeButton  *weekendNightEnd;
	
	//PropertiesView Elements
	MYSwitch           *callEnabled;
	MYSwitch           *vibrateEnabled;
	MYSwitch			*voiceMailEnabled;
	MYSwitch           *newMailEnabled;
	MYSwitch           *calenderAlertEnabled;
	MYSwitch           *smsAlertEnabled;
	MYSwitch           *lockUnlockEnabled;
	MYSwitch			*keyboardSoundEnabled;
	
	//Debug Elements
	MYSwitch  * loggingSwitch;
	
	//Status Button
	UIButton * statusButton;
	
	int   weekendNightStartTime;
	int   weekendNightEndTime;
	
	int   weekdayNightStartTime;
	int   weekdayNightEndTime;
	

	NSString * deviceActivated;
	
	
	CFMutableDictionaryRef dict;
	NSDictionary * daemonDict;
	BOOL silentModeOn;
		//CFURLRef fileURL;
	
}
- (void) refreshStatusButton;
@end

@interface MYSwitch :NSObject
{
	@public
	UISwitch *uiSwitch;
	UILabel *label;
	NSString *text;
	HelloController *parentController;
	BOOL isOn;
}
@end

void PostNotification(CFStringRef name)
{
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter() //center
										 , name
										 , NULL
										 , NULL
										 , TRUE);
	
}

static void callback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) 
{

    Model * model = (Model *) object;	
	if(name != NULL)
	{
		if(CFStringCompare(NotificationSilentStatusChanged, name, kCFCompareCaseInsensitive) == kCFCompareEqualTo)
		{
			[model refreshStatusButton];
		}
	}
	
    return;
}



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

int GetTimeElapsedForTheday(NSDate* date)
{
	NSCalendar *gregorian = [[NSCalendar alloc]
							 initWithCalendarIdentifier:NSGregorianCalendar];
	
	NSUInteger unitFlags = NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
	
	NSDateComponents *components = [gregorian components:unitFlags 
												fromDate:date];
	
	int rv =	([components hour] * 60 + [components minute]) * 60 + [components second];
	
	
	
	//	NSString* logStr = [[NSString alloc] initWithFormat:@"date= %@, no. of seonds elapsed on the day= %d"
	//						, [date description], rv];
	
	
	//	Log((CFStringRef)logStr);
	
	[gregorian release];
	//	[logStr release];
	
	return rv;
	
}

NSDate* GetDateFromInteger(int secondsElapsed)
{
	
	NSDate * date = [NSDate date];
	int nowSeconds = GetTimeElapsedForTheday(date);
	secondsElapsed = secondsElapsed - nowSeconds;
	NSDate *returnDate = [[NSDate alloc] initWithTimeInterval:secondsElapsed sinceDate:date];
	
	//[CFRelease date];
	
	return returnDate;
	
}

@implementation Model

-(void) InitObserver
{
	CFNotificationCenterRef notificationCenter = CFNotificationCenterGetDarwinNotifyCenter();
	
	CFNotificationCenterAddObserver(
									notificationCenter, //center
									NULL, // observer
									callback, // callback
									NotificationSilentStatusChanged, // name
									self, // object
									CFNotificationSuspensionBehaviorHold
									); 
}

-(BOOL) GetBoolValue:(const void*) key
{
	CFBooleanRef val =  CFDictionaryGetValue(dict, key);
	
	if(val == NULL)
	{
		return FALSE;
	}
	
	
	BOOL rv = CFBooleanGetValue(val);
	
	CFRelease(val);
	
	return rv;
}

-(BOOL) GetBoolValueFromDaemon:(const void*) key
{
	CFBooleanRef val =  CFDictionaryGetValue(daemonDict, key);
	
	if(val == NULL)
	{
		return FALSE;
	}
	
	
	BOOL rv = CFBooleanGetValue(val);
	
	CFRelease(val);
	
	return rv;
}


-(void) SetBoolValue:(const void*)key value:(BOOL)val
{
	
	if(val)
	{
		CFDictionarySetValue(dict, key, kCFBooleanTrue);
	}
	else
	{
		CFDictionarySetValue(dict, key, kCFBooleanFalse);
	}
	
}

-(int) GetIntegerValue:(const void*)key
{
	CFNumberRef val = CFDictionaryGetValue(dict, key);
	
	int rv = 0;
	
	if(val != NULL)
	{
	    CFNumberGetValue(val, kCFNumberIntType, &rv);
	

		//CFRelease(val);
	}
	return rv;
}

-(void) SetIntegerValue:(const void*)key value:(int)val
{
	CFNumberRef num = CFNumberCreate(kCFAllocatorDefault, kCFNumberIntType, &val);
	
	if(num != NULL)
	{
		CFDictionarySetValue(dict, key, num);
		CFRelease(num);
	}
	
}

-(void) SetDateValue:(const void*)key value:(NSDate *)val
{
	int seconds = GetTimeElapsedForTheday(val);
	
	[self SetIntegerValue:key value:seconds];
	
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
	
	CFRelease( resourceData );
	CFRelease(fileURL);
	return propertyList;
	
}

-(void) initialize 
{
	
	[self InitObserver];
	appEnabled = [MYSwitch alloc];
	weekdayNightsEnabled = [MYSwitch alloc];
	weekendNightsEnabled = [MYSwitch alloc];
	calenderSyncEnabled = [MYSwitch alloc];
    
	//PropertiesView Elements
	callEnabled = [MYSwitch alloc];
	vibrateEnabled = [MYSwitch alloc];
	voiceMailEnabled = [MYSwitch alloc];
	newMailEnabled = [MYSwitch alloc];
	calenderAlertEnabled = [MYSwitch alloc];
	smsAlertEnabled = [MYSwitch alloc];
	lockUnlockEnabled = [MYSwitch alloc];
	keyboardSoundEnabled = [MYSwitch alloc];
	
	weekdayNightStart = [TimeButton alloc];
	weekdayNightEnd = [TimeButton alloc];
	weekendNightStart = [TimeButton alloc];
	weekendNightEnd = [TimeButton alloc];
	
	//Debug Elements
	loggingSwitch = [MYSwitch alloc];
	loggingSwitch->isOn = FALSE;
	
	appEnabled->isOn = FALSE;
	weekdayNightsEnabled->isOn = FALSE;
	weekendNightsEnabled->isOn = FALSE;
	calenderSyncEnabled->isOn = FALSE;
    
	//PropertiesView Elements
	callEnabled->isOn = FALSE;
	vibrateEnabled->isOn = FALSE;
	voiceMailEnabled->isOn = FALSE;
	newMailEnabled->isOn  = FALSE;
	calenderAlertEnabled->isOn = FALSE;
	smsAlertEnabled->isOn = FALSE;
	lockUnlockEnabled->isOn = FALSE;
	keyboardSoundEnabled->isOn = FALSE;
	
	weekdayNightStart->date = [NSDate date];
	weekdayNightEnd->date = [NSDate date];
	weekendNightStart->date = [NSDate date];
	weekendNightEnd->date = [NSDate date];
	
	
	dict = [self CreateListFromFile:settingsPath];
	daemonDict = [[NSDictionary alloc] initWithContentsOfFile:daemonPath];
	
	if (dict == nil)
		return;
	
	appEnabled->isOn = [self GetBoolValue:AppEnabled];
	
	weekdayNightsEnabled->isOn = [self GetBoolValue:NightEnabled];
	weekendNightsEnabled->isOn = [self GetBoolValue:WeekendNightEnabled];
	calenderSyncEnabled->isOn = [self GetBoolValue:CalSyncEnabled];
    
	//PropertiesView Elements
	callEnabled->isOn = [self GetBoolValue:PhoneEnabled];
	vibrateEnabled->isOn = [self GetBoolValue:VibrateEnabled];
	voiceMailEnabled->isOn = [self GetBoolValue:VoiceMailEnabled];
	newMailEnabled->isOn  = [self GetBoolValue:NewMailEnabled];
	calenderAlertEnabled->isOn = [self GetBoolValue:CalAlertEnabled];
	smsAlertEnabled->isOn = [self GetBoolValue:SmsAlertEnabled];
	lockUnlockEnabled->isOn = [self GetBoolValue:LockUnlockEnabled];
	keyboardSoundEnabled->isOn = [self GetBoolValue:KeyboardSoundEnabled];
	
	loggingSwitch->isOn = [self GetBoolValue:LoggingEnabled];

	weekdayNightStart->date = GetDateFromInteger( [self GetIntegerValue:weekdayStart]);
	weekdayNightEnd->date = GetDateFromInteger( [self GetIntegerValue:weekdayEnd]);
	weekendNightStart->date = GetDateFromInteger( [self GetIntegerValue:weekendStart]);
	weekendNightEnd->date = GetDateFromInteger( [self GetIntegerValue:weekendEnd]);
	
	id val =  [daemonDict objectForKey:IsKeyNotValid];
	
	if (val != NULL)
	{
		if( ![val boolValue])
			deviceActivated = (NSString *)CFDictionaryGetValue(dict, ActivationTag);
		else
			deviceActivated = NULL;
	}
	else
	{
		deviceActivated = (NSString *)CFDictionaryGetValue(dict, ActivationTag);
	}
	
	silentModeOn = [self GetBoolValueFromDaemon:SilentModeOn];
	
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
	
	[self SetBoolValue:AppEnabled value:appEnabled->isOn];
	
	[self SetBoolValue:NightEnabled value:weekdayNightsEnabled->isOn ];
	[self SetBoolValue:WeekendNightEnabled value:weekendNightsEnabled->isOn];
	[self SetBoolValue:CalSyncEnabled value:calenderSyncEnabled->isOn];
    
	//PropertiesView Elements
	[self SetBoolValue:PhoneEnabled value:callEnabled->isOn];
	[self SetBoolValue:VibrateEnabled value:vibrateEnabled->isOn];
	[self SetBoolValue:VoiceMailEnabled value:voiceMailEnabled->isOn];
	[self SetBoolValue:NewMailEnabled value:newMailEnabled->isOn];
	[self SetBoolValue:CalAlertEnabled value:calenderAlertEnabled->isOn];
	[self SetBoolValue:SmsAlertEnabled value:smsAlertEnabled->isOn];
	[self SetBoolValue:LockUnlockEnabled value:lockUnlockEnabled->isOn];
	[self SetBoolValue:KeyboardSoundEnabled value:keyboardSoundEnabled->isOn];

	[self SetBoolValue:LoggingEnabled value:loggingSwitch->isOn];
	
	[self SetDateValue:weekdayStart value:weekdayNightStart->date];
	[self SetDateValue:weekdayEnd value:weekdayNightEnd->date];
	[self SetDateValue:weekendStart value:weekendNightStart->date];
	[self SetDateValue:weekendEnd value:weekendNightEnd->date];
	
	if (deviceActivated == NULL || [deviceActivated length] == 0)
		CFDictionaryRemoveValue(dict,ActivationTag);
	else
     	CFDictionarySetValue(dict, ActivationTag, deviceActivated);
	
	
	//CFDictionarySetValue(dict, CFSTR("QuiteStartTime"), kCFNumberNegativeInfinity);
	//CFDictionarySetValue(dict, CFSTR("QuiteEndTime"), kCFNumberNegativeInfinity);
	
	
}

- (void) refreshStatusButton
{
	[daemonDict release];
	
	daemonDict = [[NSDictionary alloc] initWithContentsOfFile:daemonPath];
	silentModeOn = [self GetBoolValueFromDaemon:SilentModeOn];
    // Swap the art when the state changes
	if (!( weekdayNightsEnabled->isOn || weekendNightsEnabled->isOn || 
		  calenderSyncEnabled->isOn))
	{
		[statusButton setBackgroundImage:[UIImage imageWithContentsOfFile:SettingsDisabledIcon] forState:UIControlStateNormal];
		[statusButton setBackgroundImage:[UIImage imageWithContentsOfFile:SettingsDisabledIcon] forState:UIControlStateHighlighted];

	}		
	else if (silentModeOn)
	{
		[statusButton setBackgroundImage:[UIImage imageWithContentsOfFile:OnIcon] forState:UIControlStateNormal];
		[statusButton setBackgroundImage:[UIImage imageWithContentsOfFile:OnIcon] forState:UIControlStateHighlighted];
		
	}
	else
	{
		[statusButton setBackgroundImage:[UIImage imageWithContentsOfFile:OffIcon] forState:UIControlStateNormal];
		[statusButton setBackgroundImage:[UIImage imageWithContentsOfFile:OffIcon] forState:UIControlStateHighlighted];
		
	}
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
											settingsPath,
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

@end

@interface DebugController : UIViewController
{
	@public
	UIImageView *debugView ;
	Model *model;
	UIGlassButton *button;
}

- (id) initWithModel: (Model*) m;
- (NSString*) generatePostDataForfile:(NSString*) fileName;
- (NSInteger)uploadFile:(NSString *) fileName WithPath:(NSString*)path;
- (void)uploadBtnHandler:(UIButton*) btn;
- (void) presentDebugInfo: (NSString *) msg;
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
- (void) UploadLogs;
- (NSInteger)uploadSystemInfo;
@end

@implementation DebugController

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0)
	{
		[self UploadLogs];
	}
	[alertView release];
}

- (void) presentDebugInfo: (NSString *) msg
{
    UIAlertView *baseAlert = [[UIAlertView alloc]
                              initWithTitle:@"Log Upload Status"
                              message:msg
                              delegate:nil cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
	// [baseAlert setNumberOfRows:3];
    [baseAlert show];
}

- (id) initWithModel: (Model*) m
{
	model = m;
	debugView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [debugView setBackgroundColor:[UIColor blackColor]];
	[debugView setUserInteractionEnabled:YES];
	return [self init];
}

- (id) init
{
	if (self = [super init]) self.title = @"Debug";
	return self;
}

-(void) loadView
{
	[super loadView];
	
	Class $UIGlassButton = objc_getClass("UIGlassButton");
	UIGlassButton * uploadLogBtn = [[$UIGlassButton alloc] initWithFrame:CGRectMake(90, 100 , 140, 30)];
	[uploadLogBtn setTitle:@"Send Logs" forState:0];
	[uploadLogBtn setTintColor:[UIColor colorWithWhite:0.10f alpha:1]];
	[uploadLogBtn addTarget:self action:@selector(uploadBtnHandler:) forControlEvents:UIControlEventTouchUpInside];
	[uploadLogBtn setFont:[UIFont boldSystemFontOfSize:14]];
	[debugView addSubview:uploadLogBtn];
	
	//UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc]
	//					 initWithTitle:@"Refresh"
	//					 style:UIBarButtonItemStylePlain
	//					 target:self
	//					 action:@selector(toggleButton)];
	
	//self.navigationItem.rightBarButtonItem = refreshButton;

    //[button addTarget:self action:nil forControlEvents: UIControlEventTouchUpInside];
	
	
	self.view = debugView;
}

-(void) UploadLogs
{
	NSArray * fileList = [[NSFileManager defaultManager] directoryContentsAtPath:logPath];
	NSInteger finalstatus = 200;
	NSInteger currStatus = 200;
	int cnt =[fileList count];
	
	int i =0;
	
	UIActivityIndicatorView * activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 20.0f, 20.0f)];
    [activityIndicator setCenter:CGPointMake(160.0f, 208.0f)];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [debugView addSubview:activityIndicator];
	[activityIndicator startAnimating];
	
	for ( i= 0; i< cnt; i++) {
		NSString * currentFile = [fileList objectAtIndex:i];
		
		if ([currentFile hasSuffix:@".plist"])
		{
			currStatus = [self uploadFile:currentFile WithPath:logPath];
			if (currStatus != 200 )
				finalstatus = currStatus;
		}
		
	}
	currStatus = [self uploadFile:@"settings.plist" WithPath:appPath];
	if (currStatus != 200 )
		finalstatus = currStatus;	
	
	currStatus = [self uploadFile:@"daemonsettings.plist" WithPath:appPath];
	if (currStatus != 200 )
		finalstatus = currStatus;
	
	currStatus = [self uploadSystemInfo];
	if (currStatus != 200 )
		finalstatus = currStatus;
	
	if (finalstatus == 200)
	{
		[self  presentDebugInfo:@"Logs sent successfully."];
	}
	else
	{
		NSString * str = [NSString stringWithFormat:@"Server Error: %d .There was an issue connecting to the remote server. Please try again later.",finalstatus];
		[self  presentDebugInfo:str];
	}
	
    [activityIndicator stopAnimating];
	
}

- (void)uploadBtnHandler:(UIButton*) btn
{
	UIAlertView *baseAlert = [[UIAlertView alloc]
                              initWithTitle:@"Privacy Notice"
							  message:@"Logs contain your calender(s) & device information. If you do not wish to send it to server, press Cancel button. If you choose to upload logs, please wait for it to finish."
                              delegate:self cancelButtonTitle:nil
                              otherButtonTitles:@"Upload",@"Cancel",nil];
	// [baseAlert setNumberOfRows:3];
    [baseAlert show];
}

- (NSString*) generatePostDataForfile:(NSString*) fileName
{
//	NSString *debugString =[ [[NSString alloc] initWithContentsOfFile:fileName] 
//							stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString *debugString =[[NSString alloc] initWithContentsOfFile:fileName] ;

	return debugString;
}

- (NSInteger)uploadSystemInfo
{
	NSMutableString *logStr = [[NSMutableString alloc] initWithString:LogUrl];
	NSString * deviceId = [[UIDevice currentDevice] uniqueIdentifier];
	if (deviceId == NULL)
	{
		deviceId = @"";
	}
	NSString *newdeviceId = [deviceId stringByReplacingOccurrencesOfString: @"-" withString: @"X"];
	
	[logStr appendString:newdeviceId];
	[logStr appendString:@"&file=SystemInfo"];
	

	NSURL * url = [[NSURL alloc] initWithString:logStr];
	
	NSString * postData = 
	[NSString stringWithFormat:@"%@ = %@ \n%@ = %@ \n%@ = %@ \n%@ = %@",
	@"Model",[[UIDevice currentDevice] model],
	@"Name",[[UIDevice currentDevice] name],
	@"systemName",[[UIDevice currentDevice] systemName],
	 @"systemVersion",[[UIDevice currentDevice] systemVersion] ];
	
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
	// Setup the request:
    NSMutableURLRequest *uploadRequest = [[[NSMutableURLRequest alloc] 
										   initWithURL:url 
										   cachePolicy: NSURLRequestReloadIgnoringLocalCacheData 
										   timeoutInterval: 30 ] autorelease];
    [uploadRequest setHTTPMethod:@"POST"];
    [uploadRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    //[uploadRequest setValue:@"multipart/form-data; boundary=AaB03x" forHTTPHeaderField:@"Content-Type"];
    [uploadRequest setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSHTTPURLResponse *response = [[[NSHTTPURLResponse alloc]
									initWithURL:[uploadRequest URL]
									MIMEType:@"text/html" 
								    expectedContentLength:1000 
									textEncodingName:nil] autorelease]; 
    [NSURLConnection sendSynchronousRequest:uploadRequest returningResponse:&response error:NULL]; 
	
	if ([response statusCode] != 200)
	{
		//try once more
		[NSURLConnection sendSynchronousRequest:uploadRequest returningResponse:&response error:NULL]; 
	}
	
	return [response statusCode];
}

- (NSInteger)uploadFile:(NSString *) fileName WithPath:(NSString*)path
{
	
	NSString * fullPath = [NSString stringWithFormat:@"%@/%@",path,fileName];
	NSMutableString *logStr = [[NSMutableString alloc] initWithString:LogUrl];
	
	NSString * deviceId = [[UIDevice currentDevice] uniqueIdentifier];
	if (deviceId == NULL)
	{
		deviceId = @"";
	}
	NSString *newdeviceId = [deviceId stringByReplacingOccurrencesOfString: @"-" withString: @"X"];

	[logStr appendString:newdeviceId];
	[logStr appendString:@"&file="];
	[logStr appendString:[fileName substringToIndex:([fileName length] - 6)]];
	//[logStr appendString:[fileName substringToIndex:([fileName length] -6)]];	
	
	NSURL * url = [[NSURL alloc] initWithString:logStr];
	
	
    // Generate the postdata:
    NSString *postData = [self generatePostDataForfile: fullPath];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    // Setup the request:
    NSMutableURLRequest *uploadRequest = [[[NSMutableURLRequest alloc] 
										   initWithURL:url 
										   cachePolicy: NSURLRequestReloadIgnoringLocalCacheData 
										   timeoutInterval: 30 ] autorelease];
    [uploadRequest setHTTPMethod:@"POST"];
    [uploadRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    //[uploadRequest setValue:@"multipart/form-data; boundary=AaB03x" forHTTPHeaderField:@"Content-Type"];
    [uploadRequest setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];

	NSHTTPURLResponse *response = [[[NSHTTPURLResponse alloc]
									initWithURL:[uploadRequest URL]
									MIMEType:@"text/html" 
								    expectedContentLength:1000 
									textEncodingName:nil] autorelease]; 
    [NSURLConnection sendSynchronousRequest:uploadRequest returningResponse:&response error:NULL]; 
	
	//if ([response statusCode] != 200)
	//{
		//try once more
	//	[NSURLConnection sendSynchronousRequest:uploadRequest returningResponse:&response error:NULL]; 
	//}

	return [response statusCode];
    //[uploadRequest release]; 

    // Execute the reqest:
   // NSURLConnection *conn=[[NSURLConnection alloc] initWithRequest:uploadRequest delegate:self];
   // if (conn)
    //{
        // Connection succeeded (even if a 404 or other non-200 range was returned).
    //}
    //else
    //{
        // Connection failed (cannot reach server).
    //}
}

@end


@interface HelloController : UIViewController
{
		@public
    UIImageView            *contentView;
	UIImageView            *properiesView;
	UIImageView			*mainView;
	UIView              *timeView;
	DebugController *debugController;

	//ContentView Elements

	
	//CFPropertyListRef   propertyList;
	//CFURLRef            fileUrl;
	
	BOOL weekdayNightOn;
	
	//NavigationItems
	UIBarButtonItem * topSettingsButton;
	UIBarButtonItem * backButton;
	UIBarButtonItem  * doneButton;
	UIBarButtonItem *buyButton;
	UIBarButtonItem *refreshButton;
	UIBarButtonItem *debugButton;
	
	UIButton * startTimeButton;
	
	Model * model;
	
	UIActivityIndicatorView * activityIndicator;
	
	NSString * dataString;
	
	NSString *status;
	NSString *key;
	NSString *messageToDisplay;
	
	UIDatePicker *picker;
	//UIGlassButton *buyButton;
	UIAlertView *buyAlert;


	
}
- (void) WriteValues;
- (UIButton *) buildButton: (NSString *) aTitle;

@end

@implementation TimeButton
-(void) OnClicked:(UIButton*) button
{
	//[picker setDate:date];
	
	for (UIView *view in controller->timeView.subviews) {
		[view removeFromSuperview];
	}
	[controller->timeView addSubview:picker];
	[picker setDate:date];
	CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft forView:controller->mainView cache:YES];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
	
    // Animations
    [controller->mainView exchangeSubviewAtIndex:0 withSubviewAtIndex:2];
	//controller.navigationItem.rightBarButtonItem = nil;
	//controller.navigationItem.leftBarButtonItem = controller->doneButton;
    // Commit Animation Block
    [UIView commitAnimations];
	controller.navigationItem.rightBarButtonItem = controller->doneButton;
	controller.navigationItem.leftBarButtonItem = controller->buyButton;
	
}

// Respond to a user when the date has changed
- (void) changedDate: (UIDatePicker *) picker
{
	date =  [picker date];
	[self UpdateButton];
}

-(void) initializeWithController:(HelloController*) cntrller Title:(NSString*)title Centre:(CGPoint) center
{
	controller = cntrller;
	if (date == nil)
		date = [NSDate date];
	titlePrefix = title;
	
	NSString *s = title;
	NSString *caldate =
	[[date descriptionWithCalendarFormat:
	  @"                         %I:%M %p  >" timeZone:nil locale:nil] description];
	
	s = [s stringByAppendingString:caldate];
	
	button = [controller buildButton:s];
	[button setCenter:center];
	
    [button addTarget:self action:@selector(OnClicked:) forControlEvents:UIControlEventTouchUpInside];
	[cntrller->contentView addSubview:button];
	
	float height = 216.0f;
	picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0f, 110, 320.0f, height)];
    picker.datePickerMode = UIDatePickerModeTime;
	picker.minuteInterval = 5;
    [picker addTarget:self action:@selector(changedDate:) forControlEvents:UIControlEventValueChanged];
    //[pickerView addTarget:self action:@selector(flipViewTime:) forControlEvents:UIControlEventTouchUpInside];	
}

-(void) UpdateButton
{
	NSString *s = titlePrefix;
//	NSString *caldate = [[[picker date] dateWithCalendarFormat:@"                             %I:%M %p" timeZone:nil] description];
		NSString *caldate = 
		[[[picker date] descriptionWithCalendarFormat:
				@"                         %I:%M %p  >" 
					timeZone:nil 
				   locale:nil] 
				 description];
	
	s = [s stringByAppendingString:caldate];
    [button setTitle:s forState:UIControlStateNormal];
    [button setTitle:s forState:UIControlStateHighlighted];
}
@end
  


@implementation MYSwitch

- (void) InitSwitchWithLabel:(NSString*)labelText WithCenter:(CGPoint)center WithController:(HelloController*)controller ForView:(UIView*)view
{
	uiSwitch = [[UISwitch  alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 120.0f, 40.0f)];
	
	[uiSwitch setOn:isOn];
	
	[uiSwitch setCenter:CGPointMake(center.x + 140.0f, center.y)];
	
	text = labelText;
	
	label = [ [UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 180.0f, 40.0f) ];
	[label setText:text];
	// Center Align the label's text
	[label setTextAlignment:UITextAlignmentLeft];
	[label setFont:[UIFont systemFontOfSize:18.0f]];
	[label setTextColor:[UIColor whiteColor]];
	[label setBackgroundColor:[UIColor blackColor]];
	[label setCenter:center];
	parentController = controller;
	[uiSwitch addTarget:self action:@selector(OnSwitchChanged:) forControlEvents:UIControlEventValueChanged];
	
	[view addSubview:uiSwitch];
	[view addSubview:label];
	//NSInteger s = 2;
}

- (void) InitInfoandSwitchWithLabel:(NSString*)labelText WithCenter:(CGPoint)center WithController:(HelloController*)controller ForView:(UIView*)view
{
	uiSwitch = [[UISwitch  alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 120.0f, 40.0f)];
	
	[uiSwitch setOn:isOn];
	
	[uiSwitch setCenter:CGPointMake(center.x + 140.0f, center.y)];
	
	text = labelText;
	
	label = [ [UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 180.0f, 40.0f) ];
	[label setText:text];
	// Center Align the label's text
	[label setTextAlignment:UITextAlignmentLeft];
	[label setFont:[UIFont systemFontOfSize:18.0f]];
	[label setTextColor:[UIColor whiteColor]];
	[label setBackgroundColor:[UIColor blackColor]];
	[label setCenter:center];
	
	//UIButton *infoBtn = [UIButton buttonWithType:UIButtonTypeInfoLight];
	//[infoBtn setCenter:CGPointMake(center.x + 60.0f, center.y)];	
	//[infoBtn addTarget:self action:@selector(presentInfoBtn:) forControlEvents:UIControlEventTouchUpInside];

	
	parentController = controller;
	[uiSwitch addTarget:self action:@selector(OnSwitchChanged:) forControlEvents:UIControlEventValueChanged];
	
	[view addSubview:uiSwitch];
	[view addSubview:label];
	//[view addSubview:infoBtn];
	//NSInteger s = 2;
}

- (void) presentInfoBtn: (UIButton*) button
{
    UIAlertView *baseAlert = [[UIAlertView alloc]
                              initWithTitle:@"Weekday/Weekend Info"
                              message:@"Weekday nights: Sun - Thurs\nWeekend nights: Fri & Sat"
                              delegate:nil cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
	[baseAlert setNumberOfRows:2];
    [baseAlert show];
}

- (void) OnSwitchChanged:(MYSwitch*)mySwitch
{
	isOn = !isOn;
	
	if ([text caseInsensitiveCompare:@"RingTone"] == NSOrderedSame)
	{
		if (isOn)
		{
			PostNotification(NotificaitonRingerOn);
		}
		else
		{
			PostNotification(NotificaitonRingerOff);
		}
	}
	if ([text caseInsensitiveCompare:VibrateLabel] == NSOrderedSame)
	{
		if (isOn)
		{
			PostNotification(NotificaitonVibrateOn);
		}
		else
		{
			PostNotification(NotificaitonVibrateOff);
		}
	}
	
	[parentController WriteValues];
}
@end


@implementation FlipView
- (void) touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
    // Start Animation Block
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft forView:[self superview] cache:YES];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
	
    // Animations
    [[self superview] exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
	
    // Commit Animation Block
    [UIView commitAnimations];
}
@end

@implementation HelloController
- (id)init
{
	if (self = [super init])
	{
		self.title = [[[NSBundle mainBundle] infoDictionary]
					  objectForKey:@"CFBundleName"];
		// place any further initialization here
	}
	return self;
}

- (UIButton *) buildButton: (NSString *) aTitle
{
    // Create a button sized to our art
    //UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 220.0f, 233.0f)];
	UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[button setFrame:CGRectMake(0.0f, 0.0f, 260.0f, 25.0f)];
	//[button setCenter:CGPointMake(160.0f, 208.0f)];
	//[button setBackgroundColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
	//[button setBackgroundColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
	[button setAlpha:0.5f];
	
    // The cap width indicates the location where the stretch occurs
    //[button setBackgroundImage:[[UIImage imageNamed:@"green.png"] stretchableImageWithLeftCapWidth:110.0 topCapHeight:0.0] forState:UIControlStateNormal];
   // [button setBackgroundImage:[[UIImage imageNamed:@"green2.png"] stretchableImageWithLeftCapWidth:110.0 topCapHeight:0.0] forState:UIControlStateHighlighted];
	
	
    // Set up the button aligment properties
    //button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	
    // Set the title, font and color. The color switches from
    // white to gray for highlights
    [button setTitle:aTitle forState:UIControlStateNormal];
    [button setTitle:aTitle forState:UIControlStateHighlighted];
	
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
	
    [button setFont:[UIFont systemFontOfSize:14.0f]];
	button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //isOn = NO;
    return button;
}

- (UISwitch *) BuildSwitch
{
	UISwitch * uiswitch = [[UISwitch  alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 120.0f, 40.0f)];
	
	[uiswitch setOn:FALSE];
	
	return uiswitch;
}



-(void) switchAction: (UISwitch *) mySwitch
{
	//weekendNightOn = !weekdayNightOn;
	
	[self WriteValues];
	
	CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft forView:[[mySwitch superview] superview] cache:YES];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
	
    // Animations
    [[[mySwitch superview] superview] exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
	
    // Commit Animation Block
    [UIView commitAnimations];

}

-(void) switchActionCallEnabled: (UISwitch *) mySwitch
{
	//callEnabled = !callEnabled;
	
	[self WriteValues];
}

-(void) switchActionVibrateEnabled: (UISwitch *) mySwitch
{
	//vibrateEnabled = !vibrateEnabled;
	
	[self WriteValues];
	
}

- (UIButton *) buildStatusButton: (NSString *) aTitle
{
    // Create a button sized to our art
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 30, 30)];

	if ( !( model->weekdayNightsEnabled->isOn || model->weekendNightsEnabled->isOn || 
		model->calenderSyncEnabled->isOn))
	{
		[btn setBackgroundImage:[UIImage imageWithContentsOfFile:SettingsDisabledIcon] forState:UIControlStateNormal];
		[btn setBackgroundImage:[UIImage imageWithContentsOfFile:SettingsDisabledIcon] forState:UIControlStateHighlighted];
	}
	else if (model->silentModeOn)
	{
		[btn setBackgroundImage:[UIImage imageWithContentsOfFile:OnIcon] forState:UIControlStateNormal];
		[btn setBackgroundImage:[UIImage imageWithContentsOfFile:OnIcon] forState:UIControlStateHighlighted];
		
	}
	else
	{
		[btn setBackgroundImage:[UIImage imageWithContentsOfFile:OffIcon] forState:UIControlStateNormal];
		[btn setBackgroundImage:[UIImage imageWithContentsOfFile:OffIcon] forState:UIControlStateHighlighted];
		
	}
    // The cap width indicates the location where the stretch occurs
	
    // Set up the button aligment properties
    btn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	
    // Set the title, font and color. The color switches from
    // white to gray for highlights
    [btn setTitle:aTitle forState:UIControlStateNormal];
    [btn setTitle:aTitle forState:UIControlStateHighlighted];
	
	[btn addTarget:self action:@selector(ShowStatus:) forControlEvents:UIControlEventTouchUpInside];

	
    return [btn autorelease];
	//		Class $UIGlassButton = objc_getClass("UIGlassButton");
	//	UIGlassButton * glassbutton = [[$UIGlassButton alloc] initWithFrame:CGRectMake(0,0 , 30, 30.0f)];
	//	[glassbutton setTitle:aTitle forState:0];
	//[debugButton setTintColor:[UIColor colorWithWhite:0.10f alpha:1]];
	//	if (model->silentModeOn)
	//	{
	//		[glassbutton setTintColor:[UIColor colorWithRed:0 green:1 blue:0 alpha:1]];
	//	}
	//	else
	//	{
	//		[glassbutton setTintColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:1]];
	//	}
	//	[glassbutton setFont:[UIFont systemFontOfSize:13]];
	
	//    return [glassbutton autorelease];
}

- (void) presentSheet: (UIButton*) button
{
    UIAlertView *baseAlert = [[UIAlertView alloc]
                              initWithTitle:@"Settings Info"
                              message:@"ON - sounds are enabled in silent hours.\n OFF - sounds are disabled in silent hours."
                              delegate:nil cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
    [baseAlert setNumberOfRows:2];
    [baseAlert show];
}

- (void) presentInfo: (NSString *) msg
{
    UIAlertView *baseAlert = [[UIAlertView alloc]
                              initWithTitle:@"Activation Alert"
                              message:msg
                              delegate:nil cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
	// [baseAlert setNumberOfRows:3];
    [baseAlert show];
}

- (void) presentActivationInfo: (NSString *) msg
{
    UIAlertView *baseAlert = [[UIAlertView alloc]
                              initWithTitle:@"Activation Alert"
                              message:msg
                              delegate:self cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
	// [baseAlert setNumberOfRows:3];
    [baseAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
		NSString * deviceId = [[UIDevice currentDevice] uniqueIdentifier];
	
	if (alertView == buyAlert)
	{
		switch (buttonIndex) {
			case 0:
				if (deviceId == NULL)
				{
					deviceId = @"";
				}
				NSString * finalBuyStr = [(NSString *)BuyURLString stringByAppendingString:deviceId];
				NSURL * url = [[NSURL alloc] initWithString:finalBuyStr];
				
				[[UIApplication sharedApplication] openURL:url];
				break;
			default:
				break;
		}

		
	}
	else {
		//NSString * deviceId = @"183b2b917ff7ee2ef089ce6272f965d0505c82f3";
		NSString * finalRequestString = [(NSString *)URLString stringByAppendingString:deviceId];
		NSURLRequest *request = [[NSURLRequest alloc] initWithURL: [NSURL URLWithString: finalRequestString  ]];
		NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self]; 
		[self initIndicator];
		[activityIndicator startAnimating];

	}
		[alertView release];
}

-(void) flipView: (UIButton*) button
{

	CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft forView:[[button superview] superview] cache:YES];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
	
    // Animations
    [[[button superview] superview] exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
	
    // Commit Animation Block
    [UIView commitAnimations];
}


-(void) flipViewTopRight
{
	
	CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft forView:mainView cache:YES];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
	
    // Animations
    [mainView exchangeSubviewAtIndex:1 withSubviewAtIndex:2];

    // Commit Animation Block
    [UIView commitAnimations];
	self.navigationItem.rightBarButtonItem = backButton;
	self.navigationItem.leftBarButtonItem = buyButton;
	if (self.navigationItem.leftBarButtonItem == nil)
		self.navigationItem.leftBarButtonItem = debugButton;
	self.title = @"In Silent Mode";
	//self.navigationItem.leftBarButtonItem = backButton;
}

-(void) flipViewTopLeft
{
	
	CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft forView:mainView cache:YES];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
	
    // Animations
    [mainView exchangeSubviewAtIndex:1 withSubviewAtIndex:2];
	
    // Commit Animation Block
    [UIView commitAnimations];
	self.navigationItem.rightBarButtonItem = topSettingsButton;
	self.navigationItem.leftBarButtonItem = buyButton;
	if (self.navigationItem.leftBarButtonItem == nil)
		self.navigationItem.leftBarButtonItem = refreshButton;
	self.title = @"AutoSilent";
}

-(void) flipViewTimeDone
{
	
	CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft forView:mainView cache:YES];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
	
    // Animations
    [mainView exchangeSubviewAtIndex:0 withSubviewAtIndex:2];

    // Commit Animation Block
    [UIView commitAnimations];
	self.navigationItem.rightBarButtonItem = topSettingsButton;
	self.navigationItem.leftBarButtonItem = buyButton;
	if (self.navigationItem.leftBarButtonItem == nil)
		self.navigationItem.leftBarButtonItem = refreshButton;
	[self WriteValues];
}



- (UILabel *) getLabel: (NSString *) text
{
	UILabel * label = [ [UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 40.0f) ];
	[label setText:text];
	// Center Align the label's text
	[label setTextAlignment:UITextAlignmentCenter];
	[label setFont:[UIFont systemFontOfSize:18.0f]];
	[label setTextColor:[UIColor whiteColor]];
	[label setBackgroundColor:[UIColor blackColor]];
	return label;
}

- (void) toggleWeekdayNightButton: (UIButton *) button
{
    // Swap the art when the state changes
    if (weekdayNightOn = !weekdayNightOn)
    {
        [button setTitle:@"Weekday Night On" forState:UIControlStateNormal];
        [button setTitle:@"Weekday Night On" forState:UIControlStateHighlighted];
        //[button setBackgroundImage:[[UIImage imageNamed:@"green.png"] stretchableImageWithLeftCapWidth:110.0 topCapHeight:0.0] forState:UIControlStateNormal];
        //[button setBackgroundImage:[[UIImage imageNamed:@"green2.png"] stretchableImageWithLeftCapWidth:110.0 topCapHeight:0.0] forState:UIControlStateHighlighted];
    }
    else
    {
        [button setTitle:@"Weekday Night Off" forState:UIControlStateNormal];
        [button setTitle:@"Weekday Night Off" forState:UIControlStateHighlighted];
        //[button setBackgroundImage:[[UIImage imageNamed:@"red.png"] stretchableImageWithLeftCapWidth:110.0 topCapHeight:0.0] forState:UIControlStateNormal];
        //[button setBackgroundImage:[[UIImage imageNamed:@"red2.png"] stretchableImageWithLeftCapWidth:110.0 topCapHeight:0.0] forState:UIControlStateHighlighted];
    }
	
	[self WriteValues];
}

-(void) initIndicator
{
	activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 20.0f, 20.0f)];
    [activityIndicator setCenter:CGPointMake(160.0f, 208.0f)];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [contentView addSubview:activityIndicator];
}

-(void)parseData
{
	//dataString = @"state=pending&signature=12356127318_";
	if ( dataString == nil )
	{
		status = OurError;
		return;
	}
	
	NSRange range = [dataString rangeOfString:@"state"];
	if (range.location == NSNotFound)
	{
		status = NotActivated;
//		range = [dataString  rangeOfString:@"="];
//		int index = range.location + 1;
//		range = [dataString rangeOfString:@"&"];
//		if (range.location == NSNotFound)
//		{
//			key = [dataString substringFromIndex:index];
//		}
//		else
//		{
//			int len = range.location - index ;
//			key = [dataString substringWithRange:range];
//		}
		return;
	}
	int index = range.location + 6;
	range = [dataString rangeOfString:@"&"];
	int len = range.location - index ;
	range.location = index;
	range.length = len;
	status = [dataString substringWithRange:range];
	
	range = [dataString rangeOfString:@"signature"];
	index = range.location + 10;
	range = [dataString rangeOfString:@"&" options:NSCaseInsensitiveSearch range:NSMakeRange(index, [dataString length] - index -1)];
	if (range.location == NSNotFound)
	{
		key = [dataString substringFromIndex:index];
	}
	else
	{
		int len = range.location - index ;
		range.length = len;
		range.location = index;
		key = [dataString substringWithRange:range];
	}
	return;
	//key = [dataString substringFromIndex:index];
}

-(void)parseDataV2
{
	//dataString = @"stt=&msg=&sig=";
	status = OurError;
	messageToDisplay = GenericActivationError;
	key = nil;
	
	
	if ( dataString == nil )
	{
		return;
	}
	
	NSArray *tokens = [dataString componentsSeparatedByString:@"&"];
	
	if (tokens == nil)
	{
		return;
	}
	
	NSEnumerator *enumerator = [tokens objectEnumerator];
	NSString *item ;
	
	while (item = [enumerator nextObject])
	{
		NSRange range = [item rangeOfString:@"="];
		
		if (range.location == NSNotFound || [item length] < 5)
		{
			continue;
		}
		
		NSString * first = [item substringToIndex:3];
		if ( [@"sig" compare:first options:NSCaseInsensitiveSearch] == NSOrderedSame )
		{
			key = [item substringFromIndex:4]; 
		}
		else if ( [@"msg" compare:first options:NSCaseInsensitiveSearch] == NSOrderedSame )
		{
			messageToDisplay = [item substringFromIndex:4]; 
			if ( [messageToDisplay length] == 0 || [messageToDisplay length] > 200 )
			{
				messageToDisplay = GenericActivationError;
			} 
		}
		else if ( [@"stt" compare:first options:NSCaseInsensitiveSearch] == NSOrderedSame )
		{
				status = [item substringFromIndex:4]; 
		}		
	}
	
	return;
}

-(void) ShowInfo
{
	if (status == NULL ||  CFStringCompare(status, OurError, kCFCompareCaseInsensitive) == kCFCompareEqualTo)
	{
		[self presentInfo:GenericActivationError];
		model->deviceActivated = NULL;
		[self WriteValues];		
		return;
	}
	
	if(	CFStringCompare(status, Error, kCFCompareCaseInsensitive) == kCFCompareEqualTo)
	{
		[self presentInfo:PaymentServiceError];
		model->deviceActivated = NULL; //key;
		[self WriteValues];
		return;
	}
	
    if(	CFStringCompare(status, NotActivated, kCFCompareCaseInsensitive) == kCFCompareEqualTo ||
		CFStringCompare(status, Reversed, kCFCompareCaseInsensitive) == kCFCompareEqualTo )
	{
		[self presentInfo:NotPurchasedMsg];
		model->deviceActivated = NULL; //key;
		[self WriteValues];
		return;
	}
	if(	CFStringCompare(status, Pending, kCFCompareCaseInsensitive) == kCFCompareEqualTo)
	{
		[self presentInfo:PendingMsg];
		model->deviceActivated = NULL;
		return;
	}
	if(	CFStringCompare(status, Completed, kCFCompareCaseInsensitive) == kCFCompareEqualTo)
	{
		[self presentInfo:SuccessMsg];
		model->deviceActivated = key;
		[self WriteValues];
		return;
	}
	
	[self presentInfo:GenericActivationError];
	model->deviceActivated = NULL;
	return;
}


-(void) ShowInfoV2
{
	if ( messageToDisplay == NULL || [messageToDisplay length] == 0)
	{
		[self presentInfo:GenericActivationError];
		model->deviceActivated = NULL;
		[self WriteValues];		
		return; 
	}
	
	[self presentInfo:messageToDisplay];
	
	if( key != NULL && [key length] == 0)
		model->deviceActivated = NULL;
	else
	{
		model->deviceActivated = key;
	}
	
	if(model->deviceActivated != NULL && [model->deviceActivated length] != 0)
	{
		
		self.navigationItem.leftBarButtonItem = refreshButton;
		[buyButton release];
		buyButton = nil;

	}
	
	[self WriteValues];
	
	return;
}

#pragma mark NSURLConnection Delegates
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	//[self parseData];

	//[self ShowInfo];
	//[self presentInfo:CFSTR("REsponseREceived")];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	NSString * currentData = nil;
	if (dataString == nil)
		dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	else
	{
		currentData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		dataString =  [[[dataString autorelease] stringByAppendingString:currentData] retain];
		[currentData release];
	}
	
	
	//[self presentInfo:dataString];
	//[self parseData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //[self presentInfo:CFSTR("FinshLaoding")];
	[self parseDataV2];
	[self ShowInfoV2];
	[activityIndicator stopAnimating];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {

	[self presentInfo:GenericActivationError];
	[activityIndicator stopAnimating];
}

-(void)SendEmail:(UIButton*) button
{
	NSString * emailStr = @"mailto://autosilent@iphonepackers.info?subject=Feedback&body=UID=";

	NSString * deviceId = [[UIDevice currentDevice] uniqueIdentifier];
	if (deviceId == NULL)
	{
		deviceId = @"";
	}
	NSString * finalEmail = [emailStr stringByAppendingString:deviceId];
	NSURL * url = [[NSURL alloc] initWithString:finalEmail];
	
	[[UIApplication sharedApplication] openURL:url];
}

-(void)ShowStatus:(UIButton*) button
{
	NSString * message = nil;
	
	
	if (!( model->weekdayNightsEnabled->isOn || model->weekendNightsEnabled->isOn || 
		 model->calenderSyncEnabled->isOn))
	{
		message = [[NSString alloc] initWithString:@"App is disabled as none of the GO Silent settings are ON"];
	}
	else if (model->silentModeOn)
	{
		message = [[NSString alloc] initWithString:@"Phone is in silent mode"];
	} 
	else
	{
		message = [[NSString alloc] initWithString:@"App is active but the phone is not in silent mode"];
	}
	
	
	UIAlertView *baseAlert = [[UIAlertView alloc]
                              initWithTitle:@"Current Status"
                              message:message
                              delegate:nil cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
    //[baseAlert setNumberOfRows:2];
    [baseAlert show];
}

-(void)LoadDebugView
{
	[[self navigationController] pushViewController:debugController animated:YES];
}

-(void)refreshStatusButton
{
	[model refreshStatusButton];
}

-(void)BuyApp
{
	
	buyAlert = [[UIAlertView alloc]
                              initWithTitle:@""
                              message:@"\n\n\n\n\n\n"
                              delegate:self cancelButtonTitle:nil
                              otherButtonTitles:@"Buy",@"Cancel",nil];

	[buyAlert setNumberOfRows:2];
    [buyAlert show];
	CGRect frame = [buyAlert frame];
	
	frame.origin.y -= 20.0f;
	//frame.size.height +=60.0f;
	buyAlert.frame = frame;
	[buyAlert setBackgroundColor:[UIColor blackColor]];	
	UITextView * textView = [[UITextView alloc] initWithFrame:CGRectMake(20.0, 20.0, 245.0, 120.0)];
	[textView setEditable:NO];
	[textView setScrollEnabled:YES];
	[textView setIndicatorStyle:UIScrollViewIndicatorStyleBlack];
	//
	[textView setBackgroundColor:[UIColor whiteColor]];
	[textView setAlpha:1];
    //[textView setOpaque:YES];
	[textView setTextColor:[UIColor blackColor]];
	[textView setFont:[UIFont systemFontOfSize:14.0f]];
	
	//[ textView setMarginTop: 20 ];
	[ textView setText: @"The price to buy the license is 3 USD. The purchase can be made using major credit cards through our PayPal Store or CydiaStore. The license is bound to iPhone device from where it was purchased and cannot be transferred to any other iPhone or other device owned by you or someone else. If you lose or buy/upgrade to new iPhone you will have to buy a new license. There is no way to transfer the license from one device (e.g: iPhone) to another. \n \n By downloading or buying the app you accept the following license agreement: \n	Auto Silent software is sold 'as is'. All warranties either expressed or implied are disclaimed as to the software, its quality, performance, usability, fitness for any particular purpose(s).  You, the consumer, bear the entire risk relating to the software, caused by it directly or indirectly. In no event its developers, iPhone Packers or any members of its team wil be liable for direct, indirect, incidental or consequential damages resulting from the defect or using the software.	If the software is proved to have defect, you and not iPhone Packers or its team assume the cost of any necessary service or repair. \n To buy the app from our PayPal Store, click Buy button below. To buy the app from Cydia store, open Cydia and buy it via CydiaStore. Once payment is processed, the app will try to activate automatically when opened." ];
	
		[buyAlert addSubview:textView];
}

-(void) viewDidLoad
{
	if (model->deviceActivated == NULL || [model->deviceActivated length] == 0 ) 
	{
		[self presentActivationInfo:(NSString*)NotActivatedStr];
		//NSString urlString = @"http://iphonepackers.info/app/VerifyApp?deviceid=";
		//NSString *deviceId = [[UIDevice currentDevice] uniqueIdentifier];
		//NSString * finalRequestString = [(NSString *)URLString stringByAppendingString:deviceId];
		//NSURLRequest *request = [[NSURLRequest alloc] initWithURL: [NSURL URLWithString: finalRequestString  ]];
		//NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self]; 
		//[self initIndicator];
		//[activityIndicator startAnimating];
	}
	//[connection release]; 
	//[request release];
}

- (void)loadView
{

	//dataString = nil;

	model = [Model alloc];
	
	[model initialize];
	
	debugController = [[DebugController alloc] initWithModel:model];
	self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    // Load an application image and set it as the primary view
	mainView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [mainView setBackgroundColor:[UIColor blackColor]];
	[mainView setUserInteractionEnabled:YES];
	self.view = mainView;
	
	timeView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    //[contentView setImage:[UIImage imageNamed:@"default1.png"]];
	[timeView setBackgroundColor:[UIColor blackColor]];
    [timeView setUserInteractionEnabled:YES];
	
	
	
    contentView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    //[contentView setImage:[UIImage imageNamed:@"default1.png"]];
	[contentView setBackgroundColor:[UIColor blackColor]];
    [contentView setUserInteractionEnabled:YES];

	
	properiesView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    //[contentView setImage:[UIImage imageNamed:@"default1.png"]];
	[properiesView setBackgroundColor:[UIColor blackColor]];
    [properiesView setUserInteractionEnabled:YES];
	[mainView insertSubview:timeView atIndex:0];
    [mainView insertSubview:properiesView atIndex:1];
	[mainView insertSubview:contentView atIndex:2];
    [contentView release];
    [properiesView release];

	
	//Time View
	//float height = 216.0f;
    //UIDatePicker * pickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0f, 416.0f - height, 320.0f, height)];
    //pickerView.datePickerMode = UIDatePickerModeTime;
    //[pickerView addTarget:self action:@selector(changedDate:) forControlEvents:UIControlEventValueChanged];
    //[pickerView addTarget:self action:@selector(flipViewTime:) forControlEvents:UIControlEventTouchUpInside];
    //[timeView addSubview:pickerView];
	
	
	//CONTENT VIEW
	
	CGPoint center = CGPointMake(100.0f, 15.0f);	
	
	//[model->appEnabled InitSwitchWithLabel:@"Enabled" WithCenter:center WithController:self ForView:contentView];
	UILabel *label = [ [UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 180.0f, 40.0f) ];
	[label setText:@"Current Status"];
	// Center Align the label's text
	[label setTextAlignment:UITextAlignmentLeft];
	[label setFont:[UIFont systemFontOfSize:18.0f]];
	[label setTextColor:[UIColor whiteColor]];
	[label setBackgroundColor:[UIColor blackColor]];
	[label setCenter:center];
	[contentView addSubview:label];
	
	UIButton *infoBtn = [UIButton buttonWithType:UIButtonTypeInfoLight];
	[infoBtn setCenter:CGPointMake(150,center.y)];	
	[infoBtn addTarget:self action:@selector(ShowStatus:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:infoBtn];
	//p.y = p.y + P_SPACE;
	
	
	model->statusButton = [self buildStatusButton:@""];
    [model->statusButton setCenter:CGPointMake(230.0f,15)];
    [contentView addSubview: model->statusButton];
	
	
	center.y += CONTENTVIEW_SPACE + 5; 
	
	UILabel * timeSettings = [self getLabel:@"Go Silent"];
	[timeSettings setFont:[UIFont systemFontOfSize:20.0f]];
	[timeSettings setCenter:CGPointMake(160,center.y)];
	[contentView addSubview:timeSettings];
	
	center.y += CONTENTVIEW_SPACE -5;
	
	[model->calenderSyncEnabled InitSwitchWithLabel:@"During Meetings" WithCenter:center WithController:self ForView:contentView];

    // Add the button
	
	center.y += CONTENTVIEW_SPACE;
	[model->weekdayNightsEnabled InitInfoandSwitchWithLabel:@"Weekday Nights" WithCenter:center WithController:self ForView:contentView];
	
	
	float timeSpace = 30;
	CGPoint timeCenter = CGPointMake(160, center.y + timeSpace);
	[model->weekdayNightStart initializeWithController:self Title:@"  Start Time" Centre:timeCenter];
	//startTimeButton = [self buildButton:@"  Start Time                             08:00 PM"];
	//[startTimeButton setCenter:CGPointMake(160, center.y + 30)];
	//[startTimeButton addTarget:self action:@selector(flipViewTime:) forControlEvents:UIControlEventTouchUpInside];
	//[contentView addSubview:startTimeButton];
	timeCenter.y += timeSpace;
		[model->weekdayNightEnd initializeWithController:self Title:@"  End Time " Centre:timeCenter];
	
	center.y = timeCenter.y;
	
	center.y += CONTENTVIEW_SPACE;

	[model->weekendNightsEnabled InitSwitchWithLabel:@"Weekend Nights" WithCenter:center WithController:self ForView:contentView];

	timeCenter.y = center.y +  timeSpace;
		[model->weekendNightStart initializeWithController:self Title:@"  Start Time" Centre:timeCenter];
	timeCenter.y += timeSpace;	
		[model->weekendNightEnd initializeWithController:self Title:@"  End Time " Centre:timeCenter];

	// Add email info
	int emailX = 0;
	emailX = 310;
	
	UIButton *emailButton = [UIButton buttonWithType:UIButtonTypeCustom];
	 [emailButton setFrame:CGRectMake(10, timeCenter.y + 30 , emailX, 15.0f)];
	 [emailButton setTitle:@"Contact us - autosilent@iphonepackers.info" forState:UIControlStateNormal];
	 [emailButton setTitle:@"Contact us - autosilent@iphonepackers.info" forState:UIControlStateHighlighted];
	 [emailButton setFont:[UIFont systemFontOfSize:11.0f]];
	[emailButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[emailButton setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
	
	 [emailButton setBackgroundColor:[UIColor blackColor] ];
	// [emailButton setBackgroundColor:[UIColor blackColor] forState:UIControlStateHighlighted];
	 [emailButton addTarget:self action:@selector(SendEmail:) forControlEvents:UIControlEventTouchUpInside];
	//emailButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	[contentView addSubview:emailButton];
	
	
	//center.y +=CONTENTVIEW_SPACE;
	//center.x = 280;
	//UIButton* settingsButton = [self buildButton:@"Settings"];
    //[settingsButton setCenter:center];
    //[contentView addSubview: settingsButton];
	//[settingsButton addTarget:self action:@selector(flipView:) forControlEvents:UIControlEventTouchUpInside];
	
	// Properties View
	
	CGPoint p =  CGPointMake(100.0f, 20.0f);
	//UIButton* backbutton = [self buildButton:@"Back"];
    //[backbutton setCenter:CGPointMake(40,p.y)];
    //[properiesView addSubview: backbutton];
	//[backbutton addTarget:self action:@selector(flipView:) forControlEvents:UIControlEventTouchUpInside];
	
	//UILabel * soundSettings = [self getLabel:@"In Silent Mode"];
	//[soundSettings setFont:[UIFont systemFontOfSize:20.0f]];
	//[soundSettings setCenter:CGPointMake(160,p.y)];
	//[properiesView addSubview:soundSettings];
	
	//	UIButton *infoBtn = [UIButton buttonWithType:UIButtonTypeInfoLight];
	//[infoBtn setCenter:CGPointMake(240,p.y)];	
	//[infoBtn addTarget:self action:@selector(presentSheet:) forControlEvents:UIControlEventTouchUpInside];
	//[properiesView addSubview:infoBtn];
	//p.y = p.y + P_SPACE;

	
	[model->callEnabled InitSwitchWithLabel:@"RingTone" WithCenter:p WithController:self ForView:properiesView];
	
	p.y = p.y + P_SPACE;
	
	[model->vibrateEnabled InitSwitchWithLabel:VibrateLabel WithCenter:p WithController:self ForView:properiesView];


	p.y = p.y + P_SPACE;
	
	[model->voiceMailEnabled InitSwitchWithLabel:@"VoiceMail Alert" WithCenter:p WithController:self ForView:properiesView];

	
	p.y = p.y + P_SPACE;

	[model->newMailEnabled InitSwitchWithLabel:@"New Mail" WithCenter:p WithController:self ForView:properiesView];

	
	p.y = p.y + P_SPACE;
	
	[model->calenderAlertEnabled InitSwitchWithLabel:@"Calender Alerts" WithCenter:p WithController:self ForView:properiesView];

	
	p.y = p.y + P_SPACE;

	[model->smsAlertEnabled InitSwitchWithLabel:@"New Text Message" WithCenter:p WithController:self ForView:properiesView];

	p.y = p.y +P_SPACE;
	[model->lockUnlockEnabled InitSwitchWithLabel:@"Lock Sounds" WithCenter:p WithController:self ForView:properiesView];

	//p.y = p.y + P_SPACE/2;
	
	//Class $UIGlassButton = objc_getClass("UIGlassButton");
	//UIGlassButton * debugButton = [[$UIGlassButton alloc] initWithFrame:CGRectMake(220, p.y , 80, 30.0f)];
	//[debugButton setTitle:@"Debug" forState:0];
	//[debugButton setTintColor:[UIColor colorWithWhite:0.10f alpha:1]];
	//[debugButton setTintColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:1]];
	//[debugButton addTarget:self action:@selector(LoadDebugView:) forControlEvents:UIControlEventTouchUpInside];
	//[debugButton setFont:[UIFont systemFontOfSize:13]];
	//[properiesView addSubview:debugButton];
	
	p.y = p.y +P_SPACE;
	[model->keyboardSoundEnabled InitSwitchWithLabel:@"Keyboard Clicks" WithCenter:p WithController:self ForView:properiesView];

	
	topSettingsButton = [[UIBarButtonItem alloc]
									  initWithTitle:@"Settings"
									  style:UIBarButtonItemStyleDone
									  target:self
									  action:@selector(flipViewTopRight)];
	backButton = [[UIBarButtonItem alloc]
					   initWithTitle:@"Done"
					   style:UIBarButtonItemStyleDone
				  target:self
					   action:@selector(flipViewTopLeft)];
	
	doneButton = [[UIBarButtonItem alloc]
				  initWithTitle:@"Done"
				  style:UIBarButtonItemStyleDone
				  target:self
				  action:@selector(flipViewTimeDone)];

	debugButton = [[UIBarButtonItem alloc]
				  initWithTitle:@"Debug"
				  style:UIBarButtonItemStyleDone
				  target:self
				  action:@selector(LoadDebugView)];
	
	if (model->deviceActivated == NULL || [model->deviceActivated length] == 0)
	{
		
		//Class $UIGlassButton = objc_getClass("UIGlassButton");
		//buyButton = [[$UIGlassButton alloc] initWithFrame:CGRectMake(248, timeCenter.y + 20 , 62, 30.0f)];
		//[buyButton setTitle:@"Buy" forState:0];
		//[buyButton setTintColor:[UIColor colorWithWhite:0.10f alpha:1]];
		//[buyButton addTarget:self action:@selector(BuyApp:) forControlEvents:UIControlEventTouchUpInside];
		//[buyButton setFont:[UIFont boldSystemFontOfSize:12]];
		//[contentView addSubview:buyButton];
		buyButton = [[UIBarButtonItem alloc]
							 initWithTitle:@"Buy"
							 style:UIBarButtonItemStyleDone
							 target:self
							 action:@selector(BuyApp)];
		
	}

	refreshButton = [[UIBarButtonItem alloc]
					 initWithTitle:@"Refresh"
					 style:UIBarButtonItemStyleDone
					 target:self
					 action:@selector(refreshStatusButton)];

	self.navigationItem.rightBarButtonItem = topSettingsButton;
	self.navigationItem.leftBarButtonItem = buyButton;

	if(self.navigationItem.leftBarButtonItem == nil)
		self.navigationItem.leftBarButtonItem = refreshButton;
	
	//CGPoint debugCenter =  CGPointMake(100.0f, 130.0f);
	//[model->loggingSwitch InitSwitchWithLabel:@"Logging" WithCenter:debugCenter WithController:self ForView:debugController->debugView];

	//[self presentSheet];
	

}
//CFDictionaryRef CreateMyDictionary( void );
//CFPropertyListRef CreateMyPropertyListFromFile( CFURLRef fileURL );
//void WriteMyPropertyListToFile( CFPropertyListRef propertyList,
//							   CFURLRef fileURL );

-(void) WriteValues
{
	[model WriteValues];
	PostNotification(NotificaitonRunSilentMed);
}

-(void) dealloc
{
    [contentView release];
    [super dealloc];
}
@end
// Application Delegate handles application start-up and shut-down
@interface SampleAppDelegate : NSObject <UIApplicationDelegate> {
}
@end

@implementation SampleAppDelegate

// On launch, create a basic window
- (void)applicationDidFinishLaunching:(UIApplication *)application {
	UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[HelloController alloc] init]];
	[window addSubview:nav.view];
	[window makeKeyAndVisible];
	//[[UIApplication sharedApplication] addStatusBarImageNamed: @"Bluetooth" removeOnExit: NO ];

}

- (void)applicationWillTerminate:(UIApplication *)application  {
	// handle any final state matters here
}

- (void)dealloc {
	[super dealloc];
}

@end

int main(int argc, char *argv[])
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	int retVal = UIApplicationMain(argc, argv, nil, @"SampleAppDelegate");
	[pool release];
	return retVal;
}


