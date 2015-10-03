//285092 VMSz Util
//test
//test depot4
#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <CoreFoundation/CFDate.h>
#import <IOKit/pwr_mgt/IOPMLib.h> //power mgmt
#import <IOKit/IOMessage.h> //power mgmt

#import "anticrack.h"
#import "SilentMed.h"
#import "PowerMgmt.h"
#import "NightTime.h"
#import "CalendarReader.h"
#import "Crypto.h"
#import "CheckAppType.h"
#import "Notifications.h"
#import "BaseEvent.h"
#import "Shared.h"
#import <sys/ptrace.h>
#import "Logger.h"

#define ByPassSilentSwitchStatusKey @"ByPassSilentSwitchStatus"

//constants defined in silent me 
static CFStringRef const LoggingEnabled = CFSTR("LoggingEnabled");
static CFStringRef const AppEnabled = CFSTR("AppEnabled");
static CFStringRef const CalSyncEnabled = CFSTR("CalSyncEnabled");
static CFStringRef const PhoneEnabled = CFSTR("CallEnabled");
static CFStringRef const VibrateEnabled = CFSTR("VibrateEnabled");
static CFStringRef const VoiceMailEnabled = CFSTR("VoiceMailenabled");
static CFStringRef const NewMailEnabled = CFSTR("NewMailEnabled");
static CFStringRef const CalAlertEnabled = CFSTR("CalAlertEnabled");
static CFStringRef const SmsAlertEnabled = CFSTR("SmsAlertEnabled");
static CFStringRef const OrigRingTone = CFSTR("OrigRingTone");
static CFStringRef const settingsPath = CFSTR("/Applications/SilentMe.app/settings.plist");
static CFStringRef const KeyboardSoundEnabled = CFSTR("KeyboardSoundEnabled");
static CFStringRef const LockUnlockSoundEnabled = CFSTR("LockUnLockSoundEnabled");

//strings in orig settings files
static CFStringRef const VoiceMailKey = CFSTR("VoicemailToneEnabled"); //mobilephone.plist
static CFStringRef const RingtoneKey = CFSTR("ringtone");
static CFStringRef const VibrateKey = CFSTR("ring-vibrate");
static CFStringRef const CalAlarmSoundKey = CFSTR("calendar-alarm");
static CFStringRef const NewMailKey = CFSTR("PlayNewMailSound"); //mobilemail.plist
static CFStringRef const SentMailKey = CFSTR("PlaySentMailSound"); //mobilemail.plist
static CFStringRef const SmsSoundKey = CFSTR("sms-sound");
static CFStringRef const KeyboardSoundKey = CFSTR("keyboard");
static CFStringRef const LockUnlockSoundKey = CFSTR("lock-unlock");

//string deamon settings file
static CFStringRef const SilentRingToneKey = CFSTR("silentRingtone");
static CFStringRef const SilentCalAlarmKey = CFSTR("silentCalAlarm");
static CFStringRef const SilentSmsSoundKey = CFSTR("silentSmsSound");
static CFStringRef const SilentVoiceMailSoundKey = CFSTR("silentVoiceMailSound");
static CFStringRef const SilentNewMailKey = CFSTR("silentNewMailSound");
static CFStringRef const SilentModeOnKey = CFSTR("silentModeOn");

static CFStringRef const NotificaitonOn = CFSTR("com.iphonepackers.silentMeOn");
static CFStringRef const NotificaitonOff = CFSTR("com.iphonepackers.silentMeOff");
static CFStringRef const NotificationSilentStatusChanged = CFSTR("com.iphonepackers.statusChanged");


#define SpringBoardPlistPathString @"/private/var/mobile/Library/Preferences/com.apple.springboard.plist"
#define SpringBoardPlistId @"com.apple.springboard"

#define OrigSettingsPlistPathString @"/private/var/mobile/Library/SilentMe/origsettings.plist"
#define ExpectedSettingsPlistPathString @"/private/var/mobile/Library/SilentMe/expectedsettings.plist"

#define MobilePhonePlistPathString @"/private/var/mobile/Library/Preferences/com.apple.mobilephone.plist"
#define MobilePhonePlistId @"com.apple.mobilephone"

#define MobileEmailPlistPathString @"/private/var/mobile/Library/Preferences/com.apple.mobilemail.plist"
#define MobileEmailPlistId @"com.apple.mobilemail"


#define SoundPlistPathString @"/private/var/mobile/Library/Preferences/com.apple.preferences.sounds.plist"
#define SoundPlistId @"com.apple.preferences.sounds"


static CFStringRef const SpringBoardPlistPath = CFSTR("/private/var/mobile/Library/Preferences/com.apple.springboard.plist");
static CFStringRef const MobilePhonePlistPath = CFSTR("/private/var/mobile/Library/Preferences/com.apple.mobilephone.plist");
static CFStringRef const MobilEmailPlistPath = CFSTR("/private/var/mobile/Library/Preferences/com.apple.mobilemail.plist");
static CFStringRef const OrigSettingsPlistPath = CFSTR("/private/var/mobile/Library/SilentMe/origsettings.plist");
static CFStringRef const ExpectedSettingsPlistPath = CFSTR("/private/var/mobile/Library/SilentMe/expectedsettings.plist");
static CFStringRef const SoundPlistPath = CFSTR("/private/var/mobile/Library/Preferences/com.apple.preferences.sounds.plist");


//static CFStringRef const SettingsPlistPath = CFSTR("/private/var/mobile/Library/SilentMe/settings.plist");
static CFStringRef LogFilePath = CFSTR("/private/var/mobile/Library/SilentMe/LogFile.plist");
static CFStringRef SilentLogFilePath = CFSTR("/private/var/mobile/Library/SilentMe/SilentLogFile.plist");
NSString* logFilePathNSStr;
NSString* silentLogFilePathNSStr;
//static CFStringRef const settingsPath = CFSTR("/private/var/mobile/Library/SilentMe/settings.plist");
CFMutableDictionaryRef logDict;
static int LogMsgCounter;
CFMutableDictionaryRef LogDictionary;
CFMutableDictionaryRef SilentLogDictionary;
static NSInteger SilentMsgCounter;
static PowerMgmt* powerMgmtObj;
int count = 0;
//io_connect_t root_port;
NSDate *nextRunTime = NULL;
int32_t  theValue = 0;
NSLock *theLock; 
NSInteger timeWhenToShutDown = ((23*60*60) - 3*60);
NSInteger timeElapsedBeforeShutDownIsAllowed = 4200;

NSDate* appStartTime;
BOOL isLogginEnabled = TRUE;
NSLock *completeLock;

int main (int argc, char * const argv[]) {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

	//ptrace(PT_DENY_ATTACH, 0, 0, 0);
	if(argc > 1)
	{
		NSString* disableApp = [NSString stringWithCString:argv[1] encoding:1];
		
		if(disableApp != NULL && [disableApp caseInsensitiveCompare:@"1"] == NSOrderedSame)
		{
			Run(CFSTR("console"),  TRUE);
			
		}
		else			
		{
			Run(CFSTR("console"),  FALSE);
		}
		
	}
	else
	{
		
		WriteSilentSwitchStatus();
		
		
		completeLock = [[NSLock alloc] init];
		
		CreateLogDir();
		RegisterNotification();
		
		SetCustomList();
		appStartTime = [NSDate date];
		powerMgmtObj = [PowerMgmt Instance];
		[powerMgmtObj RegisterSource];
		[Logger Log:@"exiting app"];
	}
	

	//region power mgmt
	//end region
	return 0;
}

inline void SetCustomList()
{
	CFDictionaryRef settingDict = CreateListFromFile(settingsPath);
	InitializeCustomList(settingDict);
	CFRelease(settingDict);
	
}

//inline void AddPowerMgmt
inline void Repeat(CFStringRef source)
{
		NSDate* date = [NSDate date];
		
		BOOL calledByUI = (CFStringCompare(NotificaitonRunDaemon, source, kCFCompareCaseInsensitive) == kCFCompareEqualTo);
		

		if(nextRunTime == NULL || [date compare:nextRunTime] == NSOrderedDescending || calledByUI)
		{
			if(nextRunTime != NULL)
			{
				[nextRunTime release];
				nextRunTime = NULL;
			}
			
			
			if(calledByUI)
			{
				SetCustomList();
				Run(source, TRUE);
			}
			
			Run(source, FALSE);
			
			nextRunTime = [[NSDate alloc] initWithTimeIntervalSinceNow:30];
			
		}
		
		
		
		NSInteger secondsPassed = GetTimeElapsedForTheday(date) - timeWhenToShutDown;
		
		NSInteger timePassedSinceStart = [appStartTime timeIntervalSinceNow] + timeElapsedBeforeShutDownIsAllowed;
		
		if(secondsPassed >= 0 && timePassedSinceStart < 0)
		{
			ArrangWakeUpCall();
			[powerMgmtObj RemoveSource];
			exit (0);
		}
		
	
	
	
}


inline void Run(CFStringRef source, BOOL overrideAndDisableApp)
{
	[completeLock lock];
	// user settings
	CFDictionaryRef settingDict = CreateListFromFile(settingsPath);
	isLogginEnabled = GetBoolValue(settingDict, LoggingEnabled);
	
	count = (++count % 20);
	
	LogMsgCounter = 0;
	LogDictionary = CFDictionaryCreateMutable(kCFAllocatorDefault, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
	logFilePathNSStr  = [NSString stringWithFormat:@"/private/var/mobile/Library/SilentMe/%dLogFile.plist", count];
	LogFilePath = (CFStringRef)logFilePathNSStr;
	
	
	SilentMsgCounter = 0;
	SilentLogDictionary = CFDictionaryCreateMutable(kCFAllocatorDefault, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
	silentLogFilePathNSStr = [NSString stringWithFormat:@"/private/var/mobile/Library/SilentMe/%dSilentLogFile.plist", count];	
	SilentLogFilePath = (CFStringRef)silentLogFilePathNSStr; 
	
	Log(source);
	
	Log(CFSTR("starting next run"));
	//WriteListToFile(LogFilePath, LogDictionary);
	//chmod([logFilePathNSStr UTF8String], 755, 755);
	
	@try
	{
		UpdateSettings(settingDict, overrideAndDisableApp);	
	}
	@catch (NSException *e) {
		//[e name]; [e reason]; 
		@throw e;
	}
	
	CFRelease(SilentLogDictionary);
	CFRelease(SilentLogFilePath);
	CFRelease(settingDict);
	
	//Log(CFSTR("finishing run"));
	//WriteListToFile(LogFilePath, LogDictionary);
	
	CFRelease(LogDictionary);
	CFRelease(LogFilePath);
	
	[completeLock unlock];
}


inline CFTypeRef GetValue(CFDictionaryRef dict, const void* key)
{
	CFTypeRef val = CFDictionaryGetValue(dict, key);
	
	return val;
}

//return value of bool type from dict
inline BOOL GetBoolValue(CFDictionaryRef dict, const void* key)
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

inline void SetBoolValue(CFMutableDictionaryRef dict, const void* key, BOOL val)
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

// will it work??
inline CFStringRef GetStringValue(CFDictionaryRef dict, const void* key)
{
	CFStringRef val = CFDictionaryGetValue(dict, key);
	
	return val;
}

inline int GetIntegerValue(CFDictionaryRef dict, const void* key)
{
	CFNumberRef val = CFDictionaryGetValue(dict, key);
	
	int rv = -1;
	
	CFNumberGetValue(val, kCFNumberShortType, &rv);
	
	if(val != NULL)
	{
		CFRelease(val);
	}
	return rv;
}

inline BOOL UpdateSettings(CFDictionaryRef settingDict, BOOL overrideAndDisableApp)
{
	
	
	Log(CFSTR("update settings started"));
	
	if(settingDict != NULL)
	{
		
		Log(CFSTR("settings dict is not null"));
		
		BOOL isAppEnabled = GetBoolValue(settingDict,AppEnabled);
		
		if(overrideAndDisableApp)
		{
			isAppEnabled = FALSE;
		}
		
		//orig settings
		//	NSDictionary *origsettingDict = [NSDictionary dictionaryWithContentsOfFile:@"/private/var/mobile/Library/SilentMe/origsettings.plist"];
		//	BOOL vibrateOrig = [[origsettingDict objectForKey:@"VibrateEnabled"] boolValue];
		//	BOOL voiceMailOrig = [[origsettingDict objectForKey:@"VoiceMailEnabled"] boolValue];
		//	BOOL emailOrig = [[origsettingDict objectForKey:@"NewMailEnabled"] boolValue];
		//	BOOL calAlertsOrig = [[origsettingDict objectForKey:@"CalAlertsEnabled"] boolValue];
		//	NSString *ringToneOrig = [[origsettingDict objectForKey:@"OrigRingTone"] stringValue];
		
		//current settings
		//NSDictionary *currentExpectedsettingDict = [NSDictionary dictionaryWithContentsOfFile:@"/private/var/mobile/Library/SilentMe/expectedsettings.plist"];
		CFDictionaryRef deamonsettingDict = CreateListFromFile(DeamonSettingsPlistPath);
		NSString* key = @"9e7d898020356201432df8321cb4ac96";
		
		if(deamonsettingDict != NULL)
		{
			Log(CFSTR("deamon settings is not null"));
			
			BOOL silentModeOn = GetBoolValue(deamonsettingDict, SilentModeOnKey);
			
			//	BOOL isChangeRequired = FALSE;
			CFMutableDictionaryRef mutableDeamonSettingsDict =  CFDictionaryCreateMutableCopy(kCFAllocatorDefault, 0, deamonsettingDict);
			
			if (isAppEnabled == FALSE || CheckVal(settingDict, key, mutableDeamonSettingsDict) != 0)
			{
				
				Log(CFSTR("user settings app disabled"));
				if(silentModeOn == TRUE)
				{//revert to orig settings
					//RevertToOrigSettings(vibrateOrig, voiceMailOrig, emailOrig, calAlertsOrig, ringToneOrig, currentExpectedsettingDict, currentSettingsDict);
					
					Log(CFSTR("app disabled and starting to revert to orig settings"));
					
					RevertToOrigSettings();
					PostNotification(NotificaitonOff);
					PostNotification(NotificationSilentStatusChanged);
					
					Log(CFSTR("app disabled and finished to revert to orig settings"));
					
					if(mutableDeamonSettingsDict != NULL)
					{
						
						CFDictionarySetValue(mutableDeamonSettingsDict, SilentModeOnKey, kCFBooleanFalse);
						
						//  WriteListToFile(DeamonSettingsPlistPath, mutableDeamonSettingsDict);
					}
					
					Log(CFSTR("saved updated settings to deamon settings file"));
					
				}
				
				
			}
			else
			{
				Log(CFSTR("user setting app enabled"));
				//if(mutableDeamonSettingsDict != NULL && silentModeOn == FALSE)
				{
					bool doSilent =	IsNightQuiteTime(settingDict) ;
					Log((CFStringRef)[NSString stringWithFormat:@"Night quite time out out %d", doSilent]);
					NSDate* nowDate = [NSDate date];
					if(!doSilent)
					{
						int suspect = CheckVal(settingDict, key, mutableDeamonSettingsDict);
						
						if(suspect == 0 && GetBoolValue(settingDict, CalSyncEnabled))
						{
							BaseEvent* event = [[Shared CalendarInstance] GetEventWhichMightResultIntoChangeInProfile];
							bool readCalOut = FALSE;
							
							if(event != nil && [[event getStartDate] compare:nowDate] == NSOrderedAscending
							   && [[event getEndDate] compare:nowDate] == NSOrderedDescending)
							{
								readCalOut = TRUE;
							}
							
							Log((CFStringRef)[NSString stringWithFormat:@"ReadCalendar out %d", readCalOut]);
							
							doSilent = readCalOut;
						}
					}
					else
					{
						LogSilent(CFSTR("silent done because of quite night hours"));
					}
					
					if(doSilent != silentModeOn)
					{
						Log((CFStringRef)[NSString  
										  stringWithFormat:@"Current setting is different than it should be. actual=%d. It should be=%d"
										  , silentModeOn,doSilent]);
						if(!doSilent)
						{
							Log(CFSTR("reverting to orig settings"));
							
							RevertToOrigSettings();
							PostNotification(NotificaitonOff);
							PostNotification(NotificationSilentStatusChanged);
							
							Log(CFSTR("reverted to orig settings"));
							
							if(mutableDeamonSettingsDict != NULL)
							{
								
								CFDictionarySetValue(mutableDeamonSettingsDict, SilentModeOnKey, kCFBooleanFalse);
								
								
								//WriteListToFile(DeamonSettingsPlistPath, mutableDeamonSettingsDict);								
							}
							
							Log(CFSTR("saved new silentValue to deamon settings"));
							
							
						}
						else
						{
							
							LogSilent(CFSTR("setting to silent mode"));
							
							SettoSilentMode(settingDict, deamonsettingDict);
							PostNotification(NotificaitonOn);
							PostNotification(NotificationSilentStatusChanged);
							
							LogSilent(CFSTR("silent mode done"));
							
							CFDictionarySetValue(mutableDeamonSettingsDict, SilentModeOnKey, kCFBooleanTrue);
							
							//WriteListToFile(DeamonSettingsPlistPath, mutableDeamonSettingsDict);
							
							LogSilent(CFSTR("saved new silentValue to deamon settings"));
							
						}
					}
					
					
				}
				
			}
			
			
			WriteListToFile(DeamonSettingsPlistPath, mutableDeamonSettingsDict);
			CFRelease(mutableDeamonSettingsDict);
			
			CFRelease(deamonsettingDict);
			
		}
		
		//	CFRelease(settingDict);
	}
	
	
	Log(CFSTR("done method UpdateSettings()"));
	
	return TRUE;
}


inline BOOL SettoSilentMode(CFDictionaryRef settingDict, CFDictionaryRef deamonSettings)
{
	
	id expectedList = [NSMutableDictionary dictionaryWithCapacity:20];
	id origList = [NSMutableDictionary dictionaryWithCapacity:20];
	
	SetSpringBoardToSilentMode1(expectedList, origList, settingDict, deamonSettings);
	SetPhonePlistToSilentSettings1(expectedList, origList,settingDict, deamonSettings);
	SetEmailPlistToSilentSettings1(expectedList, origList, settingDict, deamonSettings);
	SetSoundsPlistToSilentSettings(expectedList, origList, settingDict, deamonSettings);
	
	[origList writeToFile:OrigSettingsPlistPathString atomically:YES];
	[expectedList writeToFile:ExpectedSettingsPlistPathString atomically:YES];		
	
	return FALSE;
}


inline BOOL SetSoundsPlistToSilentSettings(id expectedList, id origList, CFDictionaryRef settingDict, CFDictionaryRef deamonSettings)
{
	Log(CFSTR("Updating sound settings"));
	BOOL returnValue = FALSE;
	
	id plist = [NSMutableDictionary dictionaryWithContentsOfFile:SoundPlistPathString];
	
	if(plist != NULL)
	{
		
		BOOL keyboardSetting = GetBoolValue(settingDict, KeyboardSoundEnabled);
		
		id currentKeyboardSetting = [plist valueForKey:(NSString*)KeyboardSoundKey];
		
		//update keyboard sound setting bool
		if(currentKeyboardSetting != NULL && keyboardSetting != [currentKeyboardSetting boolValue])
		{
			
			[origList setObject:currentKeyboardSetting forKey:(NSString*)KeyboardSoundKey];
			
			
			id value = [NSNumber numberWithBool:keyboardSetting];
			
			[expectedList setObject:value forKey:(NSString*)KeyboardSoundKey];
			
			WriteToFileAndNotify(plist, (NSString*)KeyboardSoundKey, value, SoundPlistPathString, SoundPlistId);
			
			GSSendAppPreferencesChanged((CFStringRef)SoundPlistId, KeyboardSoundKey);
			returnValue = TRUE;
			
		}
		
	}
	
	return returnValue;
	
}


inline BOOL SetPhonePlistToSilentSettings1(id expectedList, id origList, CFDictionaryRef settingDict, CFDictionaryRef deamonSettings)
{
	Log(CFSTR("Updating phone settings"));
	BOOL returnValue = FALSE;
	
	//if(dict != NULL)
	{
		//	CFMutableDictionaryRef currentPhoneSettingsDict = CFDictionaryCreateMutableCopy(kCFAllocatorDefault, 0, dict);
		
		id plist = [NSMutableDictionary dictionaryWithContentsOfFile:MobilePhonePlistPathString];
		
		if(plist != NULL)
		{
			
			BOOL voicemailSetting = GetBoolValue(settingDict, VoiceMailEnabled);
			
			id currentVoicemailSetting = [plist valueForKey:(NSString*)VoiceMailKey];
			
			//update new email setting bool
			if(voicemailSetting != [currentVoicemailSetting boolValue])
			{
				
				[origList setObject:currentVoicemailSetting forKey:(NSString*)VoiceMailKey];
				
				
				id value = [NSNumber numberWithBool:voicemailSetting];
				
				[expectedList setObject:value forKey:(NSString*)VoiceMailKey];
				//BOOL WriteToFileAndNotify(id list, id key, id value, NSString* filePath, NSString* fileId);
				WriteToFileAndNotify(plist, (NSString*)VoiceMailKey, value, MobilePhonePlistPathString, MobilePhonePlistId);
				
				returnValue = TRUE;
				
			}
			
		}
		
	}
	
	
	return returnValue;
	
}


//new email
inline BOOL SetEmailPlistToSilentSettings1(id expectedList, id origList, CFDictionaryRef settingDict, CFDictionaryRef deamonSettings)
{
	Log(CFSTR("in setting email  to silent mode"));
	
	BOOL returnValue = FALSE;
	
	//CFDictionaryRef dict = CreateListFromFile(MobilEmailPlistPath);
	
	//if(dict != NULL)
	{
		
		id plist = [NSMutableDictionary dictionaryWithContentsOfFile:MobileEmailPlistPathString];
		
		
		if(plist != NULL)
		{
			
			id currentValue = [plist valueForKey:(NSString*)NewMailKey];
			BOOL newmailSeting = GetBoolValue(settingDict, NewMailEnabled);
			//update new email setting bool
			if(newmailSeting != [currentValue boolValue])
			{
				
				[origList setObject:currentValue forKey:(NSString*)NewMailKey];
				
				id value = [NSNumber numberWithBool:newmailSeting];
				
				[expectedList setObject:value forKey:(NSString*)NewMailKey];
				
				//BOOL WriteToFileAndNotify(id list, id key, id value, NSString* filePath, NSString* fileId);
				WriteToFileAndNotify(plist, (NSString*)NewMailKey, value, MobileEmailPlistPathString, MobileEmailPlistId);
				
				returnValue = TRUE;
				
			}
			
		}
		
		//	CFRelease(dict);
	}
	
	return returnValue;	
}



inline BOOL SetSpringBoardToSilentMode1(id expectedList, id origList, CFDictionaryRef settingDict, CFDictionaryRef deamonSettings)
{
	BOOL isSpingBoardPlistChanged = FALSE;
	
	if(expectedList != NULL && origList != NULL & deamonSettings != NULL && settingDict != NULL)
	{
		id plist = [NSMutableDictionary dictionaryWithContentsOfFile:SpringBoardPlistPathString];
		id value = NULL;
		
		if(plist != NULL)
		{
			//set spring board
			//spring board ringtone, vibrate, calalarm, smssound
			
			//set ring tone
			
			Log(CFSTR("checking ring tone"));
			
			
			if(!GetBoolValue(settingDict, PhoneEnabled))
			{
				Log(CFSTR("ringtone applicable, changing it"));
				
				id currentValue = [plist valueForKey:(NSString*)RingtoneKey];
				
				//populate plist in case it is empty
				if(currentValue == NULL)
				{
					WriteToSpringBoardAndNotify1(plist, (NSString*) RingtoneKey, @"system:Harp");
					currentValue = @"system:Harp";
				}
				
				
				[origList setObject:currentValue forKey:(NSString*)RingtoneKey];
				
				
				//set ring tone in spring board
				value = (NSString*)GetStringValue(deamonSettings, SilentRingToneKey);
				
				[expectedList setObject:value forKey:(NSString*)RingtoneKey];
				
				WriteToSpringBoardAndNotify1(plist, (NSString*) RingtoneKey, value);
				
			}
			
			
			//--------end region setting ringtone
			
			
			//---region set vibrate mode
			
			Log(CFSTR("checking vibrate mode"));
			//set vibrate mode
			//backup orig value
			BOOL vibrateSetting  = GetBoolValue(settingDict, VibrateEnabled);
			id currentVibrateSetting = [plist valueForKey:(NSString*)VibrateKey];
			
			if(currentVibrateSetting == NULL)
			{
				currentVibrateSetting = [NSNumber numberWithBool:TRUE];
			}
			
			if(vibrateSetting != [currentVibrateSetting boolValue])
			{
				Log(CFSTR("vibrate setting is applicable"));
				
				//id currentValue = [NSNumber numberWithBool:&crValue];
				
				[origList setObject:currentVibrateSetting forKey:(NSString*)VibrateKey];
				
				//set vibrate setting
				value = [NSNumber numberWithBool:vibrateSetting];
				
				[expectedList setObject:value forKey:(NSString*)VibrateKey];
				
				WriteToSpringBoardAndNotify1(plist, (NSString*)VibrateKey, value);
			}
			
			//---end vibrate setting mode
			
			
			//---region set lock-unlock sound
			
			Log(CFSTR("checking lock-unlock mode"));
			//set vibrate mode
			//backup orig value
			BOOL lockUnlockSetting  = GetBoolValue(settingDict, LockUnlockSoundEnabled);
			id currentLockUnlockSetting = [plist valueForKey:(NSString*)LockUnlockSoundKey];
			
			if(currentLockUnlockSetting == NULL)
			{
				currentLockUnlockSetting = [NSNumber numberWithBool:TRUE];
			}
			
			if(lockUnlockSetting != [currentLockUnlockSetting boolValue])
			{
				Log(CFSTR("lock unlock setting is applicable"));
				
				
				[origList setObject:currentLockUnlockSetting forKey:(NSString*)LockUnlockSoundKey];
				
				//set lock-unlock setting
				value = [NSNumber numberWithBool:lockUnlockSetting];
				
				[expectedList setObject:value forKey:(NSString*)LockUnlockSoundKey];
				
				WriteToSpringBoardAndNotify1(plist, (NSString*)LockUnlockSoundKey, value);
			}
			
			//---end lock-unlock setting
			
			
			
			//set cal alarm
			if(!GetBoolValue(settingDict, CalAlertEnabled))
			{
				Log(CFSTR("cal alert setting is applicable"));
				
				id currentValue = [plist valueForKey:(NSString*)CalAlarmSoundKey];
				
				if(currentValue == NULL)
				{
					currentValue = @"/Applications/MobileCal.app/alarm.aiff";
				}
				
				[origList setObject:currentValue forKey:(NSString*)CalAlarmSoundKey];
				//set empty cal alert
				value = [NSString string];
				
				
				[expectedList setObject:value forKey:(NSString*)CalAlarmSoundKey];
				
				WriteToSpringBoardAndNotify1(plist, (NSString*)CalAlarmSoundKey, value);
			}
			
			
			//--end region cal alarm
			
			//region sms sound int
			
			Log(CFSTR("checking sms sound"));
			
			if(!GetBoolValue(settingDict, SmsAlertEnabled))
			{
				Log(CFSTR("sms sound setting is applicable"));
				
				value = [NSNumber numberWithInteger:0];
				
				id currentValue = [plist valueForKey:(NSString*)SmsSoundKey];
				
				if(currentValue == NULL)
				{
					currentValue  = [NSNumber numberWithInteger:1];
				}
				
				[origList setObject:currentValue forKey:(NSString*)SmsSoundKey];
				
				
				[expectedList setObject:value forKey:(NSString*)SmsSoundKey];
				
				
				WriteToSpringBoardAndNotify1(plist, (NSString*)SmsSoundKey, value);
			}
			
		}	
		//----end region sms sound
		
		
		[origList writeToFile:OrigSettingsPlistPathString atomically:YES];
		[expectedList writeToFile:ExpectedSettingsPlistPathString atomically:YES];		
		
		//	CFRelease(currentSpringSettingsDict);
	}
	
	return isSpingBoardPlistChanged;
	
}



inline BOOL RevertToOrigSettings()
{
	CFDictionaryRef origSettingsDict = CreateListFromFile(OrigSettingsPlistPath);
	
	CFDictionaryRef currentExpectedsettingDict = CreateListFromFile(ExpectedSettingsPlistPath);
	
	if(origSettingsDict != NULL && currentExpectedsettingDict != NULL)
	{
		RevertSpringBoardToOrigSettings(origSettingsDict, currentExpectedsettingDict);
		
		RevertEmailPlistToOrigSettings(origSettingsDict, currentExpectedsettingDict);
		RevertMobilePhonePlistToOrigSettings(origSettingsDict, currentExpectedsettingDict);
		RevertSoundsPlistToOrigSettings(origSettingsDict, currentExpectedsettingDict);
		
		if(currentExpectedsettingDict)
		{
			CFRelease(currentExpectedsettingDict);
		}
		
		if(origSettingsDict)
		{ //I don't understand why this throw bad access ??
			//CFRelease(origSettingsDict);
		}
	}
	
	return TRUE;
}

inline void RevertKeyValueToOrig(id origList, id listtoBeUpdated, id key)
{
	id value = [origList valueForKey:key];
	
	if(value != NULL)
	{
		WriteToSpringBoardAndNotify1(listtoBeUpdated, key, value);
	}
	
}



inline void RevertKeyValueToOrig1(id origList, id listtoBeUpdated, id key, NSString* filePath, NSString* fileId)
{
	id value = [origList valueForKey:key];
	
	if(value != NULL)
	{
		WriteToFileAndNotify(listtoBeUpdated, key, value, filePath, fileId);
	}
	
}


//spring board ringtone, vibrate, calalarm, smssound
inline BOOL RevertSpringBoardToOrigSettings(CFDictionaryRef origSettingsDict, CFDictionaryRef currentExpectedsettingDict)
{
	Log(CFSTR("reverting springboard to orig settings"));
	
	BOOL returnValue = FALSE;
	//	CFBooleanRef vibrateOrig = CFDictionaryGetValue(origSettingsDict, VibrateKey);
	CFStringRef ringToneOrig = GetStringValue(origSettingsDict, RingtoneKey);
	CFStringRef calAlarmOrig = GetStringValue(origSettingsDict, CalAlarmSoundKey);
	//	CFStringRef smsSoundIndexOrig = CFDictionaryGetValue(origSettingsDict, SmsSoundKey);
	
	
	CFDictionaryRef dict = CreateListFromFile(SpringBoardPlistPath);
	
	if(dict != NULL)
	{
		CFMutableDictionaryRef currentSpringSettingsDict = CFDictionaryCreateMutableCopy(kCFAllocatorDefault, 0, dict);
		
		id plist =  [[NSMutableDictionary alloc] initWithContentsOfFile:SpringBoardPlistPathString];
		id origList = [[NSDictionary alloc] initWithContentsOfFile:OrigSettingsPlistPathString];
		//id plist = [NSMutableDictionary dictionaryWithContentsOfFile:SpringBoardPlistPathString];
		//id origList = [NSDictionary dictionaryWithContentsOfFile:OrigSettingsPlistPathString];
		
		//	id value;
		
		//region springboard
		
		
		//if(!DidUserOverrideRingTone(GetStringValue(currentExpectedsettingDict, RingtoneKey), GetStringValue(currentSpringSettingsDict, RingtoneKey)))
		if(!DidUserOverride(GetValue(currentExpectedsettingDict, RingtoneKey), GetValue(currentSpringSettingsDict, RingtoneKey)))
		{
			//update ring tone
			//CFDictionarySetValue(currentSpringSettingsDict, RingtoneKey, ringToneOrig);
			returnValue = TRUE;
			//WriteToSpringBoardAndNotify(currentSpringSettingsDict, RingtoneKey);
			
			//[currentSettingsDict setValue:[&vibrateOrig] forKey:VibrateEnabled];
			
			RevertKeyValueToOrig(origList, plist, (NSString*)RingtoneKey);
		}
		
		
		//update vibrate bool
		
		if(!DidUserOverride(GetValue(currentExpectedsettingDict, VibrateKey), GetValue(currentSpringSettingsDict, VibrateKey)))
		{
			RevertKeyValueToOrig(origList, plist, (NSString*)VibrateKey);
		}	
		
		
		
		//update lock unlock bool
		
		if(!DidUserOverride(GetValue(currentExpectedsettingDict, LockUnlockSoundKey), GetValue(currentSpringSettingsDict, LockUnlockSoundKey)))
		{
			RevertKeyValueToOrig(origList, plist, (NSString*)LockUnlockSoundKey);
		}	
		
		
		//update calalarm string some issues...
		if(!DidUserOverride(GetValue(currentExpectedsettingDict, CalAlarmSoundKey), GetValue(currentSpringSettingsDict, CalAlarmSoundKey)))
		{
			RevertKeyValueToOrig(origList, plist, (NSString*)CalAlarmSoundKey);
		}	
		
		//update sms sound int
		if(!DidUserOverride(GetValue(currentExpectedsettingDict, SmsSoundKey), GetValue(currentSpringSettingsDict, SmsSoundKey)))
		{
			//RevertKeyValueToOrig(origList, plist, (NSString*)SmsSoundKey);
			id value = (NSNumber*)[origList valueForKey:(NSString*)SmsSoundKey];
			
			
			if(value != NULL)
			{
				Log((CFStringRef)[NSString stringWithFormat:@" sms sound value while reverting %d", *value]);
				
				WriteToSpringBoardAndNotify1(plist, (NSString*)SmsSoundKey, value);
			}
		}	
		
		
		
		[plist release];
		[origList release];
		CFRelease(currentSpringSettingsDict);
		CFRelease(dict);
	}
	
	
	if(ringToneOrig != NULL)
	{
		CFRelease(ringToneOrig);
	}
	
	if(calAlarmOrig != NULL)
	{
		CFRelease(calAlarmOrig);
	}
	//commit to it
	
	return returnValue;
	//end
}

inline BOOL WriteToSpringBoardAndNotify1(NSMutableDictionary* springBoardDict, id key, id value)
{
	return WriteToFileAndNotify(springBoardDict, key, value, SpringBoardPlistPathString, SpringBoardPlistId);
}


inline BOOL WriteToFileAndNotify(id list, id key, id value, NSString* filePath, NSString* fileId)
{
	
	NSString* logString  = [[NSString alloc] initWithFormat:@"writing into %s, for key %s, value %@"
							, [filePath UTF8String], [key UTF8String], value]; 
	Log((CFStringRef)logString);
	[logString release];
	//NSString *path = [[NSString alloc] initWithFormat:@"/private/var/mobile/Library/SilentMe/sbCustom %@ %@"
	//				  , [key UTF8String], [springBoardDict valueForKey: key] ];
	
	//	Log((CFStringRef)path);
	
	[list setObject:value forKey:key];
	
	[list writeToFile:filePath atomically:YES];
	
	Log(CFSTR("updating phone setting file"));
	
	chown([filePath UTF8String], 501, 501);
	
	GSSendAppPreferencesChanged((CFStringRef)fileId, key);
	
	
	Log(CFSTR("done updating phone settings"));
	
	
	return FALSE;
}

inline BOOL WriteToSpringBoardAndNotify(CFDictionaryRef springBoardDict, CFStringRef key)
{
	
	NSString *path = [[NSString alloc] initWithFormat:@"/private/var/mobile/Library/SilentMe/sbCustom %@ %@"
					  , key, CFDictionaryGetValue(springBoardDict, key)];
	
	//Log((CFStringRef)path);
	[path release];
	
	//system([path UTF8String]);
	
	
	//	Log((CFStringRef)[	NSString stringWithFormat:@"setting springboard key:%@, value:%@", key, CFDictionaryGetValue(springBoardDict, key)]);	
	WriteListToFile(SpringBoardPlistPath, springBoardDict);	
	
	//chown([SpringBoardPlistPathString UTF8String], 501, 501);
	
	//GSSendAppPreferencesChanged(CFSTR("com.apple.springboard"), key);
	
	return TRUE;
}	

//new email
inline BOOL RevertEmailPlistToOrigSettings(CFDictionaryRef origSettingsDict, CFDictionaryRef currentExpectedsettingDict)
{
	Log(CFSTR("in revert email plist to orig"));
	
	BOOL returnValue = FALSE;
	
	CFDictionaryRef dict = CreateListFromFile(MobilEmailPlistPath);
	if(dict != NULL)
	{
		
		id plist = [NSMutableDictionary dictionaryWithContentsOfFile:MobileEmailPlistPathString];
		
		id origList = [NSDictionary dictionaryWithContentsOfFile:OrigSettingsPlistPathString];
		
		
		if(plist != NULL)
		{
			
			//update new email setting bool
			if(!DidUserOverride(GetValue(currentExpectedsettingDict, NewMailKey), GetValue(dict, NewMailKey)))
			{
				//read orig sent mail setting
				id currentSentMailValue = [plist valueForKey:(NSString*)SentMailKey];
				
				RevertKeyValueToOrig1(origList, plist, (NSString*)NewMailKey, MobileEmailPlistPathString, MobileEmailPlistId);
				
				WriteToFileAndNotify(plist, (NSString*)SentMailKey, currentSentMailValue, MobileEmailPlistPathString, MobileEmailPlistId);
				
				returnValue = TRUE;		
				
			}
		}
	}
	
	CFRelease(dict);
	
	return returnValue;
	
}





//sounds plist
inline BOOL RevertSoundsPlistToOrigSettings(CFDictionaryRef origSettingsDict, CFDictionaryRef currentExpectedsettingDict)
{
	Log(CFSTR("in revert sounds plist to orig"));
	
	BOOL returnValue = FALSE;
	
	CFDictionaryRef dict = CreateListFromFile(SoundPlistPath);
	if(dict != NULL)
	{
		
		id plist = [NSMutableDictionary dictionaryWithContentsOfFile:SoundPlistPathString];
		
		id origList = [NSDictionary dictionaryWithContentsOfFile:OrigSettingsPlistPathString];
		
		
		if(plist != NULL)
		{
			
			//update new email setting bool
			if(!DidUserOverride(GetValue(currentExpectedsettingDict, KeyboardSoundKey), GetValue(dict, KeyboardSoundKey)))
			{
				
				RevertKeyValueToOrig1(origList, plist, (NSString*)KeyboardSoundKey, SoundPlistPathString, SoundPlistId);
				GSSendAppPreferencesChanged((CFStringRef)SoundPlistId, KeyboardSoundKey);
				
				returnValue = TRUE;		
				
			}
		}
	}
	
	CFRelease(dict);
	
	return returnValue;
	
}




//for voice email bool
inline BOOL RevertMobilePhonePlistToOrigSettings(CFDictionaryRef origSettingsDict, CFDictionaryRef currentExpectedsettingDict)
{
	Log(CFSTR("reverting phone settings to orig"));
	
	BOOL returnValue = FALSE;
	
	CFDictionaryRef dict = CreateListFromFile(MobilePhonePlistPath);
	
	if(dict != NULL)
	{
		//CFMutableDictionaryRef currentMobilePhoneSettingsDict = CFDictionaryCreateMutableCopy(kCFAllocatorDefault, 0, dict);
		
		id plist = [NSMutableDictionary dictionaryWithContentsOfFile:MobilePhonePlistPathString];
		
		id origList = [NSDictionary dictionaryWithContentsOfFile:OrigSettingsPlistPathString];
		
		
		if(plist != NULL)
		{
			
			//update new email setting bool
			if(!DidUserOverride(GetValue(currentExpectedsettingDict, VoiceMailKey), GetValue(dict, VoiceMailKey)))
			{
				
				RevertKeyValueToOrig1(origList, plist, (NSString*)VoiceMailKey, MobilePhonePlistPathString,MobilePhonePlistId);
				returnValue = TRUE;		
				
			}
			
			//CFRelease(currentMobilePhoneSettingsDict);
		}
		CFRelease(dict);
	}
	
	
	
	return returnValue;
}

inline BOOL DidUserOverride(CFTypeRef expected, CFTypeRef actual)
{
	if(expected == NULL || actual == NULL)
	{
		return FALSE;
	}
	
	return !CFEqual(expected, actual);
}

//BOOL DidUserOverride(BOOL expected, BOOL current)
//{
//	return (expected == current);
//}

//expected or actual can be null
inline BOOL DidUserOverrideRingTone(CFStringRef expected, CFStringRef actual)
{
	if(expected == NULL || actual == NULL)
	{
		return FALSE;
	}
	
	return (CFStringCompare(expected, actual, kCFCompareCaseInsensitive) == kCFCompareEqualTo);
}

inline BOOL UpdateRingTone(CFStringRef ringtone)
{
	CFStringRef url = CFSTR("/private/var/mobile/Library/Preferences/com.apple.springboard.plist");
	CFDictionaryRef dict = CreateListFromFile(url);
	
	BOOL result = false;
	
	if(dict != NULL)
	{
		CFMutableDictionaryRef mutableDict = CFDictionaryCreateMutableCopy(kCFAllocatorDefault, 0, dict);
		
		CFDictionarySetValue(mutableDict, CFSTR("ringtone"), ringtone);
		
		result = WriteListToFile(url, mutableDict);
		//TBD retry if fail
		CFRelease(mutableDict);
	}
	
	CFRelease(dict);
	
	
	return result;
}


inline BOOL WriteListToFile(CFStringRef url, CFPropertyListRef dataToWrite)
{
	if(url != NULL)
	{
		SInt32 errorCode;
		
		CFURLRef fileUrl = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, url, kCFURLPOSIXPathStyle, false);
		
		CFDataRef xmlData;
		Boolean status;
		
		// Convert the property list into XML data.
		xmlData = CFPropertyListCreateXMLData( kCFAllocatorDefault, dataToWrite);
		
		// Write the XML data to the file.
		status = CFURLWriteDataAndPropertiesToResource (
														fileUrl,                  // URL to use
														xmlData,                  // data to write
														NULL,
														&errorCode);
		
		CFRelease(xmlData);
		
		//TBD retry if fail
		
		CFRelease(fileUrl);
		
		return status;
	}
	
	return FALSE;
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


inline void Log(CFStringRef message)
{

// 	NSLog(message); 
//	[Logger Log:message];
 if(isLogginEnabled && message != NULL)
 {

	 /*
 CFNumberRef num = CFNumberCreate(kCFAllocatorDefault, kCFNumberIntType, &LogMsgCounter);
 CFLocaleRef locale = CFLocaleCreate(kCFAllocatorDefault,CFSTR("en_GB"));
 
 CFNumberFormatterRef formatter = CFNumberFormatterCreate(NULL, locale, kCFNumberFormatterDecimalStyle);
 
 CFStringRef numStr = CFNumberFormatterCreateStringWithNumber(kCFAllocatorDefault, formatter, num);
 CFDictionarySetValue(LogDictionary, numStr, message);
 
 LogMsgCounter++;
 
 
 WriteListToFile(LogFilePath, LogDictionary);
 CFRelease(num);
 CFRelease(locale);
 CFRelease(formatter);
 CFRelease(numStr);
	  */
 }

}


inline void LogSilent(CFStringRef message)
{
	
	if(isLogginEnabled && message != NULL)
	{
/*		CFNumberRef num = CFNumberCreate(kCFAllocatorDefault, kCFNumberIntType, &SilentMsgCounter);
		
		CFLocaleRef locale = CFLocaleCreate(kCFAllocatorDefault,CFSTR("en_GB"));
		
		CFNumberFormatterRef formatter = CFNumberFormatterCreate(NULL, locale, kCFNumberFormatterDecimalStyle);
		
		CFStringRef numStr = CFNumberFormatterCreateStringWithNumber(kCFAllocatorDefault, formatter, num);
		CFDictionarySetValue(SilentLogDictionary, numStr, message);
		
		SilentMsgCounter++;
		
		WriteListToFile(SilentLogFilePath, SilentLogDictionary);
		CFRelease(num);
		CFRelease(locale);
		CFRelease(formatter);
	    CFRelease(numStr);
		
		chmod([silentLogFilePathNSStr UTF8String], 755, 755);
*/		
	}
	
}

inline BOOL FileExists(NSString* path, BOOL isDir)
{
	NSFileManager *fm = [NSFileManager defaultManager];
	return [fm fileExistsAtPath:path isDirectory:&isDir];		
}

inline BOOL CreateLogDir()
{
	
	NSString* path = @"/private/var/mobile/Library/SilentMe";
	BOOL isDir = TRUE;
	NSError* errord;
	
	if(!FileExists(path, isDir))
	{
		NSFileManager *fm = [NSFileManager defaultManager];
		
		BOOL rv = [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&errord];
	}
	
	return TRUE;
}

inline void Test()
{
	
	
	NSDate* startDate = [[NSDate alloc] initWithString:@"2008-03-24 10:45:32 -0700"];
	
	NSDate* endDate = [[NSDate alloc] initWithString:@"2009-04-24 10:45:32 -0700"];
	
	NSCalendar *gregorian = [[NSCalendar alloc]
							 initWithCalendarIdentifier:NSGregorianCalendar];
	
	NSUInteger unitFlags = NSDayCalendarUnit; //NSMonthCalendarUnit | NSDayCalendarUnit | NSYearCalendarUnit;
	
	NSDateComponents *components = [gregorian components:unitFlags
												fromDate:startDate
												  toDate:endDate options:0];
	NSInteger months = [components month];
	NSInteger days = [components day];
	
	Log((CFStringRef)([NSString stringWithFormat:@"difference months:%d, days:%d", months, days]));	
	
	
	//	SchedulerInfoRec
}

//arm-apple-darwin-nm -gmu SpringBoard
// disassemblers otool / ht/machonist

inline void FixSilentSwitch()
{
	Log(CFSTR("in fixing broken switch"));
	
	//lock to stop overriding daemonsettings.plist
	[completeLock lock];
	
	id currentByPassSwitchSetting = GetValueFromPlist((NSString*)DeamonSettingsPlistPath, ByPassSilentSwitchStatusKey);
	
	if(currentByPassSwitchSetting == NULL || ![currentByPassSwitchSetting boolValue])
	{
		//make back up of .plist file at two places
		//cp command may not be there so do it reading/writin
		NSDictionary* soundBehaviorPlist = [NSDictionary dictionaryWithContentsOfFile:OrigSystemSoundBehaviourPlistPath];
		
		if(soundBehaviorPlist != NULL && [soundBehaviorPlist count] > 0)
		{
			//verify it is really orig file or else just continue...
			NSDictionary* defaultKeyDict = [soundBehaviorPlist objectForKey:@"Default"];
			
			if(defaultKeyDict != NULL)
			{
				NSArray* defaultKeyValues = [defaultKeyDict objectForKey:@"RingVibrateIgnore,SilentVibrateIgnore,RingerSwitchOff"];
				
				//make sure it is really really real one
				if(defaultKeyValues != NULL && [defaultKeyValues count] == 0)
				{
					[soundBehaviorPlist writeToFile:CopiedOrigSoundBehaviorPlistPath atomically:YES];
					Log(CFSTR("made backup of orig"));
					
					//verify file was successfully copied
					BOOL isDir = FALSE;
					if(FileExists(CopiedOrigSoundBehaviorPlistPath, isDir))
					{
						//overwrite orig systemsoundbehavior with bypass system sound behavior file
						NSDictionary* byPassSoundBehaviorPlist = [NSDictionary dictionaryWithContentsOfFile:@"/Applications/SilentMe.app/SystemSoundBehaviour.plist"];
						
						if(byPassSoundBehaviorPlist != NULL && [byPassSoundBehaviorPlist count] > 0)
						{
							[byPassSoundBehaviorPlist writeToFile:OrigSystemSoundBehaviourPlistPath atomically:YES];
							Log(CFSTR("overwrote orig with fixed silent switch systemsoundbehavior.plist file"));
							KillMediaServer();
							
							id status = [NSNumber numberWithBool:YES];
							AddOrUpdateKeyInPlist((NSString*)DeamonSettingsPlistPath, ByPassSilentSwitchStatusKey, status);
								
							PostNotification(NotificaitonByPassSilentSwitchOnFixed);
								
						}
						
					}
					
					
				}
			}
			
		}	
	}
	
	[completeLock unlock];
			Log(CFSTR("done fixing broken silent switch"));
}

inline void UnfixSilentSwitch()
{
	[completeLock lock];
	
	id currentByPassSwitchSetting = GetValueFromPlist((NSString*)DeamonSettingsPlistPath, ByPassSilentSwitchStatusKey);
	
	if(currentByPassSwitchSetting != NULL && [currentByPassSwitchSetting boolValue])
	{		
		//make back up of .plist file at two places
		//cp command may not be there so do it reading/writin
		NSDictionary* soundBehaviorPlist = [NSDictionary dictionaryWithContentsOfFile:CopiedOrigSoundBehaviorPlistPath];
		
		if(soundBehaviorPlist != NULL && [soundBehaviorPlist count] > 0)
		{
			[soundBehaviorPlist writeToFile:OrigSystemSoundBehaviourPlistPath atomically:YES];
			Log(CFSTR("done reverting system sound behavior to orig"));
			KillMediaServer();
			id value = [NSNumber numberWithBool:NO];
			AddOrUpdateKeyInPlist((NSString*)DeamonSettingsPlistPath, ByPassSilentSwitchStatusKey, value);
			PostNotification(NotificaitonByPassSilentSwitchOffFixed);
		}	
	}
	[completeLock unlock];
	Log(CFSTR("done reverting system sound behavior to orig"));
}

inline void AddOrUpdateKeyInPlist(NSString* path, id key, id value)
{
	id plist = [NSMutableDictionary dictionaryWithContentsOfFile:path];
	[plist setObject:value forKey:key];
	[plist writeToFile:path atomically:YES];
	
}

inline id GetValueFromPlist(NSString* path, id key)
{
	id plist = [NSDictionary dictionaryWithContentsOfFile:path];
	return [plist objectForKey:key];
}