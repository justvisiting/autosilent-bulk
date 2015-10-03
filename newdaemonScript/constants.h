//
//  constants.h
//  newdaemon
//
//  Created by god on 10/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#define IS_IPHONE 1

#import <Foundation/Foundation.h>
#import "../prototype/SilentMeUI/Classes/Constants.h"

#define DefaultProfile 0
#define SilentProfile 1
#define ManualEventId 99999


#define DefaultProfilePlist @"/private/var/mobile/Library/SilentMe/defaultProfile.plist"

#define SpringBoardPlistPathString @"/private/var/mobile/Library/Preferences/com.apple.springboard.plist"
#define SpringBoardPlistPathId @"com.apple.springboard"

#define MobilePhonePlistPathString @"/private/var/mobile/Library/Preferences/com.apple.mobilephone.plist"
#define MobilePhonePlistId @"com.apple.mobilephone"

#define MobileEmailPlistPathString @"/private/var/mobile/Library/Preferences/com.apple.mobilemail.plist"
#define MobileEmailPlistId @"com.apple.mobilemail"


#define SoundPlistPathString @"/private/var/mobile/Library/Preferences/com.apple.preferences.sounds.plist"
#define SoundPlistId @"com.apple.preferences.sounds"

//profile plist key names as understood by apple plist and daemon
static NSString* const RingtoneKey = @"ringtone";
static NSString* const VibrateKey = @"ring-vibrate";
static NSString* const CalAlarmSoundKey = @"calendar-alarm";
static NSString* const NewMailKey = @"PlayNewMailSound"; //mobilemail.plist
static NSString* const SentMailKey = @"PlaySentMailSound"; //mobilemail.plist
static NSString* const SmsSoundKey = @"sms-sound";
static NSString* const SmsSoundKeyiOS421Plus = @"sms-sound-identifier";
static NSString* const KeyboardSoundKey = @"keyboard";
static NSString* const LockUnlockSoundKey = @"lock-unlock";
static NSString* const VoiceMailKey = @"VoicemailToneEnabled"; //mobilephone.plist
	

//daemon plist
#define ByPassSilentSwitchStatusKey @"ByPassSilentSwitchStatus"
#define RingerToggleStatusKey @"ringerToggleStatus"

//schedule plist key names
static NSString* const ScheduleNameKey = @"Name";
static NSString* const ScheduleStartTimeKey = @"StartTime";
static NSString* const ScheduleEndTimeKey = @"EndTime";
static NSString* const ScheduleRepeatInfoKey = @"RepeatInfo";
static NSString* const ScheduleProfileKey = @"Profile";
static NSString* const ScheduleEnabledKey = @"Enabled";


//profile plist key names as expected in profiles.plist
static NSString* const NameKey = @"Name";
static NSString* const LockUnlockSoundEnabled = @"LockUnLockSoundEnabled";


//notificaitons strings
static CFStringRef const RequestManulModeChangeToOn = CFSTR("com.iphonepackers.manualModeRequestOn");
static CFStringRef const RequestManulModeChangeToOff = CFSTR("com.iphonepackers.manualModeRequestOff");

//ios 4.0 - nextwakeup time key
static CFStringRef const NextWakeUpTimeKey = CFSTR("NextWakeUpTime");
static CFStringRef const NotificationArrangeWakeUp = CFSTR("com.iphonepackers.arrangwakeup");

typedef enum WakeUpEventTypeEnum
	{
		WakeUpDuringNonSleep
		, WakeUpDuringSleep
	} WakeUpEventType;

typedef enum LogLevelEnum
{
	Information = 1
	, Warning = 2
	, CriticalError = 4
} LogLevelType;


@interface constants : NSObject {

}

@end
