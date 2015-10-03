#include <stdio.h>
#include <notify.h>
#include <unistd.h>
#include <stdarg.h>
#include "Notifications.h"
#import "SilentMed.h"
#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <UIKit/UIHardware.h>

void kCalDatabaseChangedExternallyNotification();
void kCalEventOccurrenceCacheChangedNotification();
void kCalEventOccurrenceCacheRebuildDidBeginNotification();
void kCalChangeAddition();
void kCalChangeDeletion();
void kCalChangeModification();
inline int PostNotification(CFStringRef name)
{
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter() //center
										 , name
										 , NULL
										 , NULL
										 , TRUE);
	
}

inline void KillMediaServer()
{
	NSString *cmd = @"killall mediaserverd";
	system([cmd UTF8String]);
}

static void callback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) 
{
	if(name != NULL)
	{
		NSString* logStr = @"callback ";
		
		logStr = [logStr stringByAppendingString:name];
		//Log((CFStringRef) logStr);
	}	
	
	if (CFStringCompare(NotificaitonRunDaemon, name, kCFCompareCaseInsensitive) == kCFCompareEqualTo)
	{
		Repeat(NotificaitonRunDaemon);
	}
	else if (CFStringCompare(NotificaitonSilentSwitchChanged, name, kCFCompareCaseInsensitive) == kCFCompareEqualTo)
	{
		Log(CFSTR("com.apple.springboard.ringerstate notification received"));
		
		int ringerState = [UIHardware ringerState];
		
		
		if( ringerState)
		{
			PostNotification(NotificaitonringerToggleStatusOn);
		}
		else
		{
			PostNotification(NotificaitonringerToggleStatusOff);
		}
		
		WriteSilentSwitchStatus();
		
	}
	else if(CFStringCompare(NotificaitonByPassSilentSwitchOn, name, kCFCompareCaseInsensitive) == kCFCompareEqualTo)
	{
		FixSilentSwitch();
	}
	else if(CFStringCompare(NotificaitonByPassSilentSwitchOff, name, kCFCompareCaseInsensitive) == kCFCompareEqualTo)
	{
		UnfixSilentSwitch();
	}
}

inline void AddCalendarNotification()
{
	CFNotificationCenterRef notificationCenter = CFNotificationCenterGetDarwinNotifyCenter();
/*	CFNotificationCenterAddObserver(
									notificationCenter, //center
									NULL, // observer
									callback, // callback
									kCalDatabaseChangedExternallyNotification, // name
									NULL, // object
									CFNotificationSuspensionBehaviorHold
									); 

	CFNotificationCenterAddObserver(
									notificationCenter, //center
									NULL, // observer
									callback, // callback
									kCalEventOccurrenceCacheChangedNotification, // name
									NULL, // object
									CFNotificationSuspensionBehaviorHold
									); 
*/	
/*	CFNotificationCenterAddObserver(
									notificationCenter, //center
									NULL, // observer
									callback, // callback
									kCalEventOccurrenceCacheRebuildDidBeginNotification, // name
									NULL, // object
									CFNotificationSuspensionBehaviorHold
									); 
	
	
	CFNotificationCenterAddObserver(
									notificationCenter, //center
									NULL, // observer
									callback, // callback
									kCalChangeAddition, // name
									NULL, // object
									CFNotificationSuspensionBehaviorHold
									); 

	CFNotificationCenterAddObserver(
									notificationCenter, //center
									NULL, // observer
									callback, // callback
									kCalChangeDeletion, // name
									NULL, // object
									CFNotificationSuspensionBehaviorHold
									); 

	
	CFNotificationCenterAddObserver(
									notificationCenter, //center
									NULL, // observer
									callback, // callback
									kCalChangeModification, // name
									NULL, // object
									CFNotificationSuspensionBehaviorHold
									); 
	*/
}

inline int RegisterNotification()
{
	//AddCalendarNotification();
	CFNotificationCenterRef notificationCenter = CFNotificationCenterGetDarwinNotifyCenter();
	CFNotificationCenterAddObserver(
									notificationCenter, //center
									NULL, // observer
									callback, // callback
									NotificaitonRunDaemon, // name
									NULL, // object
									CFNotificationSuspensionBehaviorHold
									); 
	
	CFNotificationCenterAddObserver(
									notificationCenter, //center
									NULL, // observer
									callback, // callback
									NotificaitonSilentSwitchChanged, // name
									NULL, // object
									CFNotificationSuspensionBehaviorHold
									); 
	
	CFNotificationCenterAddObserver(
									notificationCenter, //center
									NULL, // observer
									callback, // callback
									NotificaitonByPassSilentSwitchOff, // name
									NULL, // object
									CFNotificationSuspensionBehaviorHold
									); 
	
	CFNotificationCenterAddObserver(
									notificationCenter, //center
									NULL, // observer
									callback, // callback
									NotificaitonByPassSilentSwitchOn, // name
									NULL, // object
									CFNotificationSuspensionBehaviorHold
									); 
	
	
}

inline void WriteSilentSwitchStatus()
{
	CFDictionaryRef deamonsettingDict = CreateListFromFile(DeamonSettingsPlistPath);
	
	CFMutableDictionaryRef mutableDeamonSettingsDict =  CFDictionaryCreateMutableCopy(kCFAllocatorDefault, 0, deamonsettingDict);
	
	
	int ringerState = [UIHardware ringerState];
	
	if (mutableDeamonSettingsDict == nil)
		return;
	
	if (ringerState)
	{
		CFDictionarySetValue(mutableDeamonSettingsDict, RingerToggleStatusKey, kCFBooleanTrue);
	}
	else
	{
		CFDictionarySetValue(mutableDeamonSettingsDict, RingerToggleStatusKey, kCFBooleanFalse);
		
	}
	
	WriteListToFile(DeamonSettingsPlistPath, mutableDeamonSettingsDict);
	CFRelease(mutableDeamonSettingsDict);
	return ;
}