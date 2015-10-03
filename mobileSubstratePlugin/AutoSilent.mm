//when silent active, ringer toggle off, silent switch vibrate on and restart springboard,keylock.unlock is off
/*
 <string>Initialized successfully12009-12-07 00:34:11 -0800</string>
 <string>notification intercepted2009-12-07 00:34:15 -0800</string>
 <string>notification intercepted2009-12-07 00:34:15 -0800</string>
 <string>silent mode on2009-12-07 00:34:15 -0800</string>
 <string>ring or vibrate2009-12-07 00:35:06 -0800</string>
 <string>ringer toggle off2009-12-07 00:35:06 -0800</string>
 <string>bypass silent switch on 2009-12-07 00:35:06 -0800</string>
 <string>should ring on in bypass silent switch2009-12-07 00:35:06 -0800$
 <string>In start ring2009-12-07 00:35:06 -0800</string>
 <string>ringtone &lt;default&gt;2009-12-07 00:35:06 -0800</string>
 </array>
 //marimba is default
 */

#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIWindow.h>
#import <UIKit/UIView-Hierarchy.h>
#import <UIKit/UIHardware.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIApplication.h>
#import <UIKit/UITextView.h>
#import <UIKit/UIView.h>
#include <unistd.h>
#include <dlfcn.h>

#import "AutoSilent.h"
#import <UIKit/UIKit.h>
#import <UIKit/UIHardware.h>
#import <Celestial/AVSystemController.h>
#import <AudioToolbox/AudioToolbox.h>
#import <Celestial/AVController.h>
#import <Celestial/AVItem.h>
#import <Celestial/AVQueue.h>
#import <AVFoundation/AVAudioPlayer.h>
#import "PerformVibration.h"
#import "Log.h"
#import "../newdaemonScript/constants.h"
#import "../newdaemonScript/configManager.h"
//#import "../newdaemonScript/logger.h"

#define springBoardPlistPath @"/private/var/mobile/Library/Preferences/com.apple.springboard.plist"
#define ringTonesPlistPath @"/private/var/mobile/Media/iTunes_Control/iTunes/Ringtones.plist"
#define DefaultRingTonePath @"/Library/Ringtones/Harp.m4r"
#define AutoSilentStatusIcon @"AutoSilent_ON"

volatile BOOL shouldRing = FALSE;
volatile BOOL shouldVibrate = FALSE;
volatile BOOL isSilentStatusIconOn = FALSE;

//vibration related var
static void* connection = nil;
static int x = 0;
static int intensity = 20;

volatile BOOL ringerToggleStatus = TRUE;

NSOperationQueue * _queue = nil;
PerformVibration * operation = nil;
NSString* ringTonePath = NULL;
AVController* av;
AVItem       *item1;
AVQueue      *avq;
float _volume = 0.3;
BOOL ByPassSilentSwitch = TRUE;
//BOOL SystemVibrateSetting = TRUE;
static int CurrentProfile = 0;
AVAudioPlayer* audioPlayer;
BOOL showIcon = NO;

NSString* GetStatus(OSStatus status)
{
	switch (status) {
		case kAudioSessionNoError:
			return @"no error";
			
		case kAudioSessionNotInitialized:
			return @"kAudioSessionNotInitialized";
			
		case kAudioSessionAlreadyInitialized:
			return @"kAudioSessionAlreadyInitialized";
			
		case kAudioSessionInitializationError:
			return @"kAudioSessionInitializationError";
			
		case kAudioSessionUnsupportedPropertyError:
			return @"kAudioSessionUnsupportedPropertyError";
			
		case kAudioSessionBadPropertySizeError:
			return @"kAudioSessionBadPropertySizeError";
			
		case kAudioSessionNotActiveError:
			return @"kAudioSessionNotActiveError";
			//case kAudioServicesNoHardwareError:
			//	return @"kAudioServicesNoHardwareError";
			//	break;
			//	case kAudioSessionNoCategorySet:
			//		return @"kAudioSessionNoCategorySet";
			//		break;
			//	case kAudioSessionIncompatibleCategory:
			//		return @"kAudioSessionIncompatibleCategory";
			//		break;
			
		default:
			return [NSString stringWithFormat:@"%d", status];
	}
}

int vibrateCallback(void *connection, CFStringRef string, CFDictionaryRef dictionary, void *data) {
	
	return 0;
}

static void __$AutoSilent_ringOrVibrate(SBCallAlertDisplay<AutoSilent> *_SBCallAlertDisplay)
{
	
	Log(@"ring or vibrate");
	BOOL callNativeAPI = YES;
	
	if(ringerToggleStatus)//notSilent
	{
		Log(@"ringer toggle on");
		/*keeping for help
		 if(shouldRing)
		 {
		 Log(@"should ring");
		 }
		 else*/ 
		if(shouldVibrate && !shouldRing) //this assumes that if ringer is ON that means profile is never default
			//this assumes this condition will only be true when default profile is not active
		{
			Log(@"should vibrate");
			StartVibrate();
			callNativeAPI = NO;
		}
	}
	else
	{
		Log(@"ringer toggle off");
		if(ByPassSilentSwitch)
		{
			Log(@"bypass silent switch on ");
			if(shouldRing)
			{
				Log(@"should ring on in bypass silent switch");
				StartRing();
				callNativeAPI = NO;
			}
			
			if(shouldVibrate)
			{
				Log(@"should vibrate on in bypass silent switch");
				StartVibrate();
				callNativeAPI = NO; //not necessarily required..but..
			}
		}
	}
	
	if(callNativeAPI)
	{
		[_SBCallAlertDisplay __OriginalMethodPrefix_ringOrVibrate];
	}
}

static void __$AutoSilent_stopRingingOrVibrating(SBCallAlertDisplay<AutoSilent> *_SBCallAlertDisplay)
{
	Log(@"stopRingingOrVibrating");
	StopVibrate();
	StopRing();
	
	
	[_SBCallAlertDisplay __OriginalMethodPrefix_stopRingingOrVibrating];
	
	
}

extern "C" void AutoSilentInitialize() {
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	
	//	[logger initLogger:@"M"];
	
	
	InitCurrentStatus();
	InitObserver();
	InitVibrateMode();
	InitSBCallAlertDisplay();
	
	
	Log(@"Initialized successfully1");
	[pool release];
}


void InitVibrateMode()
{
	/*
	 if(_queue == nil)
	 {
	 _queue = [[NSOperationQueue alloc] init];
	 }*/
}


void InitCurrentStatus()
{
	showIcon = [configManager IsStatusIconEnabled];
	CurrentProfile = [configManager CurrentProfile];
	shouldRing = GetRingerSetting();
	shouldVibrate = GetVibrateSetting();
	ringerToggleStatus = GetSilentSwithSetting();
	ByPassSilentSwitch = [configManager GetBypassSwitchStatus];
	
	if(ringerToggleStatus)
	{
		Log(@"ringer on");
	}
	else
	{
		Log(@"ringer off");
	}
}

static void UpdateStatusIcon(BOOL show)
{
	if(CurrentProfile == DefaultProfileId || !show)
	{
		
		if(isSilentStatusIconOn)
		{
			isSilentStatusIconOn = NO;
			[[UIApplication sharedApplication] removeStatusBarImageNamed: AutoSilentStatusIcon];
		}
	}
	else
	{
		if(!isSilentStatusIconOn && show)
		{
			[[UIApplication sharedApplication] addStatusBarImageNamed: AutoSilentStatusIcon];
			isSilentStatusIconOn = YES;
		}
		
	}
	
}

static void callback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	Log(@"notification intercepted");
	if(name != NULL)
	{
		if(CFStringCompare((CFStringRef)NotificaitonringerToggleStatusOff, name, kCFCompareCaseInsensitive) == kCFCompareEqualTo)
		{
			ringerToggleStatus = FALSE;
		}
		else if (CFStringCompare((CFStringRef)NotificaitonringerToggleStatusOn, name, kCFCompareCaseInsensitive) == kCFCompareEqualTo)
		{
			ringerToggleStatus = TRUE;
		}
		else if(CFStringCompare((CFStringRef)NotificationSilentStatusChanged, name, kCFCompareCaseInsensitive) == kCFCompareEqualTo)
		{
			[configManager RefreshAll];
			CurrentProfile = [configManager CurrentProfile];
			UpdateStatusIcon(showIcon);
			shouldRing = GetRingerSetting();
			shouldVibrate = GetVibrateSetting();
			Log(@"silent mode on");
		}
		else if(CFStringCompare((CFStringRef)NotificationFixSilentSwitchDone, name, kCFCompareCaseInsensitive) == kCFCompareEqualTo)
		{
			[configManager RefreshAll];
			ByPassSilentSwitch = [configManager GetBypassSwitchStatus];
		}
		else if(CFStringCompare((CFStringRef)NotificationDisableStatusIcon, name, kCFCompareCaseInsensitive) == kCFCompareEqualTo)
		{
			[configManager Refresh];
			showIcon = NO;
			UpdateStatusIcon(showIcon);
		}
		else if(CFStringCompare((CFStringRef)NotificationEnableStatusIcon, name, kCFCompareCaseInsensitive) == kCFCompareEqualTo)
		{
			[configManager Refresh];
			showIcon = YES;
			UpdateStatusIcon(showIcon);
		}
			
	}
	
    return;
}

void InitObserver()
{
	CFNotificationCenterRef notificationCenter = CFNotificationCenterGetDarwinNotifyCenter();
	
	//change in bypass silent switch setting
	CFNotificationCenterAddObserver(
									notificationCenter, //center
									NULL, // observer
									callback, // callback
									(CFStringRef)NotificaitonByPassSilentSwitchOn, // name
									NULL, // object
									CFNotificationSuspensionBehaviorHold
									); 
	
	CFNotificationCenterAddObserver(
									notificationCenter, //center
									NULL, // observer
									callback, // callback
									(CFStringRef)NotificaitonByPassSilentSwitchOff, // name
									NULL, // object
									CFNotificationSuspensionBehaviorHold
									); 
	
	// change in silent switch
	CFNotificationCenterAddObserver(
									notificationCenter, //center
									NULL, // observer
									callback, // callback
									(CFStringRef)NotificaitonringerToggleStatusOn, // name
									NULL, // object
									CFNotificationSuspensionBehaviorHold
									); 
	CFNotificationCenterAddObserver(
									notificationCenter, //center
									NULL, // observer
									callback, // callback
									(CFStringRef)NotificaitonringerToggleStatusOff, // name
									NULL, // object
									CFNotificationSuspensionBehaviorHold
									); 
	
	
	
	//vibrate setting
	CFNotificationCenterAddObserver(
									notificationCenter, //center
									NULL, // observer
									callback, // callback
									(CFStringRef)NotificaitonVibrateOn, // name
									NULL, // object
									CFNotificationSuspensionBehaviorHold
									); 
	
	CFNotificationCenterAddObserver(
									notificationCenter, //center
									NULL, // observer
									callback, // callback
									(CFStringRef)NotificaitonVibrateOff, // name
									NULL, // object
									CFNotificationSuspensionBehaviorHold
									); 
	
	
	// silent on 
	CFNotificationCenterAddObserver(
									notificationCenter, //center
									NULL, // observer
									callback, // callback
									(CFStringRef)NotificationSilentStatusChanged, // name
									NULL, // object
									CFNotificationSuspensionBehaviorHold
									); 
	
	
	
	// ring setting
	CFNotificationCenterAddObserver(
									notificationCenter, //center
									NULL, // observer
									callback, // callback
									(CFStringRef)NotificaitonRingerOn, // name
									NULL, // object
									CFNotificationSuspensionBehaviorHold
									); 
	
	
	
	CFNotificationCenterAddObserver(
									notificationCenter, //center
									NULL, // observer
									callback, // callback
									(CFStringRef)NotificaitonRingerOff, // name
									NULL, // object
									CFNotificationSuspensionBehaviorHold
									); 
	
	
	CFNotificationCenterAddObserver(
									notificationCenter, //center
									NULL, // observer
									callback, // callback
									(CFStringRef)NotificationFixSilentSwitchDone, // name
									NULL, // object
									CFNotificationSuspensionBehaviorHold
									);

	CFNotificationCenterAddObserver(
									notificationCenter, //center
									NULL, // observer
									callback, // callback
									(CFStringRef)NotificationEnableStatusIcon, // name
									NULL, // object
									CFNotificationSuspensionBehaviorHold
									);
	CFNotificationCenterAddObserver(
									notificationCenter, //center
									NULL, // observer
									callback, // callback
									(CFStringRef)NotificationDisableStatusIcon, // name
									NULL, // object
									CFNotificationSuspensionBehaviorHold
									);

	
}

void InitSBCallAlertDisplay()
{
	Class _$SBAppIcon = objc_getClass("SBCallAlertDisplay");
	
	MSHookMessage(_$SBAppIcon, @selector(ringOrVibrate), (IMP) &__$AutoSilent_ringOrVibrate, "__OriginalMethodPrefix_");
	
	MSHookMessage(_$SBAppIcon, @selector(stopRingingOrVibrating), (IMP) &__$AutoSilent_stopRingingOrVibrating, "__OriginalMethodPrefix_");
}



inline CFPropertyListRef CreateListFromFile(CFStringRef filePath)
{
	CFURLRef fileURL;
	CFPropertyListRef propertyList;
	CFStringRef       errorString;
	CFDataRef         resourceData;
	Boolean           status;
	SInt32            errorCode;
	
	fileURL = CFURLCreateWithFileSystemPath( kCFAllocatorDefault,
											filePath,       // file path name
											kCFURLPOSIXPathStyle,    // interpret as POSIX path
											false );    
	
	// Read the XML file.
	status = CFURLCreateDataAndPropertiesFromResource(
													  kCFAllocatorDefault,
													  fileURL,
													  &resourceData,            // place to put file data
													  NULL	,
													  NULL,
													  &errorCode);
	
	// Reconstitute the dictionary using the XML data.
	propertyList = CFPropertyListCreateFromXMLData( kCFAllocatorDefault,
												   resourceData,
												   kCFPropertyListImmutable,
												   &errorString);
	
	CFRelease(fileURL);
	
	if (resourceData) {
        CFRelease( resourceData );
    } else {
        CFRelease( errorString );
    }
	
	return propertyList;
	
}


inline BOOL GetValue(CFStringRef fileUrl, CFStringRef key, BOOL defaultVal)
{
	CFDictionaryRef dict = (CFDictionaryRef)CreateListFromFile(fileUrl);
	
	CFBooleanRef val = NULL;
	if(dict != NULL)
	{
		val =  (CFBooleanRef)CFDictionaryGetValue(dict, key);
	}
	
	if(val == NULL)
	{
		return defaultVal;
	}
	
	
	BOOL rv = CFBooleanGetValue(val);
	
	CFRelease(dict);
	return rv;
	
}


inline BOOL GetSystemVibrateSetting()
{
	return GetValue((const CFStringRef)springBoardPlistPath, (const CFStringRef) VibrateKey, TRUE);	
}

inline BOOL GetVibrateSetting()
{
	if(CurrentProfile != DefaultProfileId)
	{
		NSDictionary* profileDict = [[configManager GetProfile:CurrentProfile] retain];
		BOOL rv = YES;
		
		if(profileDict != nil)
		{
			rv = [[profileDict objectForKey:VibrateEnabled] boolValue];
			[profileDict release];
		}
		
		return rv;
	}
	else
	{
		return GetSystemVibrateSetting();
	}
	
}


inline BOOL GetRingerSetting()
{
	BOOL rv = YES;
	
	if(CurrentProfile != DefaultProfileId)
	{
		NSDictionary* profileDict = [[configManager GetProfile:CurrentProfile] retain];
		
		if(profileDict != nil)
		{
			rv = [[profileDict objectForKey:PhoneEnabled] boolValue];
			[profileDict release];
		}
	}
	
	return rv;
}

inline BOOL GetSilentSwithSetting()
{
	[configManager RefreshAll];
	return [configManager GetSilentSwitchStatus];
}

//return value of bool type from dict
inline BOOL isCurrentlySilent()
{
	if(CurrentProfile == SilentProfileId)
	{
		return YES;
	}
	return NO;
}


inline void StartVibrate()
{
	Log(@"In start vibrate");
	
	if(operation != nil)
	{
		[operation Stop];
		operation = nil;
	}
	
	operation =
	[[PerformVibration alloc] init];
	
	if(_queue != nil)
	{
		[_queue autorelease];
		_queue = nil;
	}
	
	_queue = [[NSOperationQueue alloc] init];
	
	[_queue addOperation:operation];
	
	[operation release];
}

inline void StartRing()
{
	Log(@"In start ring");
	
	SetRingTonePath();
	
	AudioSessionInitialize(NULL, NULL, NULL, NULL);
	NSString *audioDeviceName;
	AVSystemController *avs = [AVSystemController sharedAVSystemController];
	[avs getActiveCategoryVolume: &_volume andName: &audioDeviceName];	
	
	
	UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
	AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory);    
	
	UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
	AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,sizeof (audioRouteOverride),&audioRouteOverride);
	
	//encoding required if string has space or special char
	NSURL * theAudioURL = [NSURL URLWithString:[ringTonePath stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
	audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:theAudioURL error:nil];
	[audioPlayer prepareToPlay];
	audioPlayer.numberOfLoops = -1; // infinite
	audioPlayer.volume = _volume;
	[audioPlayer play];
	
	OSStatus status = AudioSessionSetActive(true);	
	
	NSString* logInfo = [NSString stringWithFormat:@"in play ring tone  volume: %f, setActiveStatus: %@, ringtone:%@"												 , _volume
						 , GetStatus(status)
						 , ringTonePath];
	Log(logInfo);
	
	Log(@"was in play ringtone");
	
	
}

inline void StopRing()
{
	if(audioPlayer != nil)
	{	
		Log(@"stop ring, releasing audio player & setting active audio sess to false");
		audioPlayer.volume = 0.0;
		[audioPlayer stop];
		AudioSessionSetActive(false);
		audioPlayer = nil;
	}
}

inline void StopVibrate()
{
	
	if(operation != nil)
	{
		Log(@"stop vibrated in operation");
		
		[operation Stop];
		operation = nil;
	}
	
	if(_queue != nil)
	{
		Log(@"stop vibrated in queue");
		[_queue autorelease];
		_queue = nil;
	}
	
}

void SetRingTonePath()
{
	if(ringTonePath != nil)
	{
		[ringTonePath release];
		ringTonePath = nil;
	}
	
	NSDictionary* plistDictionary = [[[NSDictionary alloc] initWithContentsOfFile:springBoardPlistPath] autorelease];
	
	NSString *value =  [plistDictionary objectForKey:@"ringtone"];
	
	if(value != NULL && [value length] > 7)
	{
		Log([NSString stringWithFormat:@"ringtone %@", value]);
		
		if([value compare:@"<default>" options:NSCaseInsensitiveSearch] == NSOrderedSame)
		{
			ringTonePath = @"/System/Library/CoreServices/SpringBoard.app/ring.m4r";
		}
		else
		{
			NSRange range = [value rangeOfString:@"system:"];
			NSString* urlPath = NULL;
			
			
			if(range.location == 0)
			{
				
				NSString* name = [value substringFromIndex:7];
				ringTonePath = [[NSString stringWithFormat:@"/Library/Ringtones/%@.m4r", name] retain];
				
				Log([NSString stringWithFormat:@"using system ringtone %@", urlPath]);
				
			}
			else
			{
				
				NSRange range = [value rangeOfString:@"itunes:"];
				
				if(range.location == 0)
				{
					Log([NSString stringWithFormat:@"using itunes ringtone"]);
					
					NSString* itunesGuid = [value substringFromIndex:7];
					
					if(itunesGuid != NULL)
					{
						
						NSDictionary* plistDictionary = [[[NSDictionary alloc] initWithContentsOfFile:ringTonesPlistPath] autorelease];
						NSDictionary* ringtonesDict =  [plistDictionary objectForKey:@"Ringtones"];
						id ringToneName = NULL;
						
						if(ringtonesDict != NULL)
						{
							for (id key in ringtonesDict) {
								
								NSDictionary* ringtoneInfo = [ringtonesDict objectForKey:key];
								if(ringtoneInfo != NULL)
								{
									
									NSString* guidvalue = [ringtoneInfo objectForKey:@"GUID"];
									
									
									if(guidvalue != NULL && [guidvalue caseInsensitiveCompare:itunesGuid] == NSOrderedSame)
									{
										Log([NSString stringWithFormat:@"guid of ringtone %@ %@", guidvalue, key]);
										
										ringToneName = key;
										break;
									}
								}
								
							}
							
							if(ringToneName != NULL)
							{
								
								ringTonePath =
								[[NSString stringWithFormat:@"/private/var/mobile/Media/iTunes_Control/Ringtones/%@", ringToneName] retain];
								
							}
							
						}
					}                                                                                        
				}
			}	
		}
	}
}