#import "constants.h"
#include <stdio.h>
#include <notify.h>
#include <unistd.h>
#include <stdarg.h>
#include "Notifications.h"
#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>

#if IS_IPHONE
#import <UIKit/UIHardware.h>
#endif

#import "scheduler.h"
#import "logger.h"
#import "NightTime.h"
#import "powerMgmt.h"
#import "configManager.h"
#import "Common.h"

static NSLock* notificationsCallBackLock;
static NSTimeInterval DefaultSecondsToBeAddedForManualMode = 7 * 24 * 60 * 60; //7 days

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
	[notificationsCallBackLock lock];
	if(name != NULL)
	{
		NSString* logStr = @"callback ";
		
		logStr = [logStr stringByAppendingString:(NSString*)name];
		[logger Log:logStr];
	}	
	
	if (CFStringCompare((CFStringRef)NotificaitonScheduleChanged, name, kCFCompareCaseInsensitive) == kCFCompareEqualTo)
	{
		[configManager Refresh];
		InitializeCustomList(); //refresh custom schedule
		[[scheduler Instance] PerformAllActions:(NSString*)NotificaitonScheduleChanged override:NO  isManulModeApplicable:NO manualMode:NO];
		[[powerMgmt Instance] UpdatePowerModeDueToChangeInCalendarSyncSettting];
	}
	else if (CFStringCompare((CFStringRef)NotificaitonProfileChanged, name, kCFCompareCaseInsensitive) == kCFCompareEqualTo)
	{
		[configManager Refresh];
		[[scheduler Instance] Run:(NSString*)NotificaitonProfileChanged overide:YES];
		[[scheduler Instance] PerformAllActions:(NSString*)NotificaitonProfileChanged override:NO  isManulModeApplicable:NO manualMode:NO];
	}
	else if (CFStringCompare((CFStringRef)NotificaitonRunDaemon, name, kCFCompareCaseInsensitive) == kCFCompareEqualTo)
	{
		[configManager Refresh];
		InitializeCustomList(); //refresh custom schedule -----required, scenario when automatic is enabled/disabled
		[[scheduler Instance] PerformAllActions:(NSString*)NotificaitonRunDaemon override:NO  isManulModeApplicable:NO manualMode:NO];
		[[powerMgmt Instance] UpdatePowerModeDueToChangeInCalendarSyncSettting];
	}
	else if (CFStringCompare((CFStringRef)NotificaitonSilentSwitchChanged, name, kCFCompareCaseInsensitive) == kCFCompareEqualTo)
	{
		[logger Log:@"com.apple.springboard.ringerstate notification received"];
		
		int ringerState = 0;
#if IS_IPHONE
		ringerState = [UIHardware ringerState];
#endif
		
		WriteSilentSwitchStatus();
		
		if( ringerState)
		{
			PostNotification((CFStringRef)NotificaitonringerToggleStatusOn);
		}
		else
		{
			PostNotification((CFStringRef)NotificaitonringerToggleStatusOff);
		}
		
		//this is also called when springboard restarts..since the silent status bar
		//icon goes away every time there is restart..post notification to update icon status again.
		PostNotification(NotificationSilentStatusChanged);
		
	}
	else if(CFStringCompare((CFStringRef)NotificaitonManualModeSwitchedByUIOn, name, kCFCompareCaseInsensitive) == kCFCompareEqualTo)
	{
		[configManager Refresh];
		[[scheduler Instance] PerformAllActions:(NSString*)name override:NO  isManulModeApplicable:YES manualMode:YES manualModeDate:[configManager GetDateUntilWhichManulModeIsAppliedFromUI]];
		
	}
	else if( CFStringCompare((CFStringRef)NotificaitonManualModeProfileChanged, name, kCFCompareCaseInsensitive) == kCFCompareEqualTo)
	{
		[configManager Refresh];
		[[scheduler Instance] PerformAllActions:(NSString*)name override:NO  isManulModeApplicable:NO manualMode:NO manualModeDate:[configManager GetDateUntilWhichManulModeIsAppliedFromUI]];
	}
	else if(CFStringCompare((CFStringRef)NotificaitonManualModeSwitchedByUIOff, name, kCFCompareCaseInsensitive) == kCFCompareEqualTo)
	{
		[configManager Refresh];
		[[scheduler Instance] PerformAllActions:(NSString*)name override:NO  isManulModeApplicable:YES manualMode:NO manualModeDate:nil];
		
	}
	else if(CFStringCompare((CFStringRef)RequestManulModeChangeToOn, name, kCFCompareCaseInsensitive) == kCFCompareEqualTo)
	{
		NSDate* date = [NSDate dateWithTimeIntervalSinceNow:DefaultSecondsToBeAddedForManualMode];
		
		[[scheduler Instance] PerformAllActions:(NSString*)name override:NO  isManulModeApplicable:YES manualMode:YES manualModeDate:date];		
	}
	else if(CFStringCompare((CFStringRef)RequestManulModeChangeToOff, name, kCFCompareCaseInsensitive) == kCFCompareEqualTo)
	{
		NSDate* date = [NSDate dateWithTimeIntervalSinceNow:DefaultSecondsToBeAddedForManualMode];
		[[scheduler Instance] PerformAllActions:(NSString*)name override:NO  isManulModeApplicable:YES manualMode:NO manualModeDate:date];		
	}	
	else if(CFStringCompare((CFStringRef)NotificaitonByPassSilentSwitchOn, name, kCFCompareCaseInsensitive) == kCFCompareEqualTo)
	{
		FixSilentSwitch();
	}
	else if(CFStringCompare((CFStringRef)NotificaitonByPassSilentSwitchOff, name, kCFCompareCaseInsensitive) == kCFCompareEqualTo)
	{
		UnfixSilentSwitch();
	}
	
	[notificationsCallBackLock unlock];
}


 void RegisterNotification()
{
	notificationsCallBackLock = [[NSLock alloc] init];
	
	CFNotificationCenterRef notificationCenter = CFNotificationCenterGetDarwinNotifyCenter();
	CFNotificationCenterAddObserver(
									notificationCenter, //center
									NULL, // observer
									callback, // callback
									(CFStringRef)NotificaitonRunDaemon, // name
									NULL, // object
									CFNotificationSuspensionBehaviorHold
									); 
	//this is standard notification
	CFNotificationCenterAddObserver(
									notificationCenter, //center
									NULL, // observer
									callback, // callback
									(CFStringRef)NotificaitonSilentSwitchChanged, // name
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
									(CFStringRef)NotificaitonManualModeProfileChanged, // name
									NULL, // object
									CFNotificationSuspensionBehaviorHold
									);

	CFNotificationCenterAddObserver(
									notificationCenter, //center
									NULL, // observer
									callback, // callback
									(CFStringRef)NotificaitonManualModeSwitchedByUIOn, // name
									NULL, // object
									CFNotificationSuspensionBehaviorHold
									); 
	CFNotificationCenterAddObserver(
									notificationCenter, //center
									NULL, // observer
									callback, // callback
									RequestManulModeChangeToOn, // name
									NULL, // object
									CFNotificationSuspensionBehaviorHold
									); 
	
	CFNotificationCenterAddObserver(
									notificationCenter, //center
									NULL, // observer
									callback, // callback
									RequestManulModeChangeToOff, // name
									NULL, // object
									CFNotificationSuspensionBehaviorHold
									); 
	
	
	CFNotificationCenterAddObserver(
									notificationCenter, //center
									NULL, // observer
									callback, // callback
									(CFStringRef)NotificaitonManualModeSwitchedByUIOff, // name
									NULL, // object
									CFNotificationSuspensionBehaviorHold
									); 

	CFNotificationCenterAddObserver(
									notificationCenter, //center
									NULL, // observer
									callback, // callback
									(CFStringRef)NotificaitonScheduleChanged, // name
									NULL, // object
									CFNotificationSuspensionBehaviorHold
									); 

	CFNotificationCenterAddObserver(
									notificationCenter, //center
									NULL, // observer
									callback, // callback
									(CFStringRef)NotificaitonProfileChanged, // name
									NULL, // object
									CFNotificationSuspensionBehaviorHold
									); 
	
	
}

 void WriteSilentSwitchStatus()
{
	
	int ringerState = 0;
#if IS_IPHONE
	ringerState = [UIHardware ringerState];
#endif
	[configManager SetSilentSwitchStatus:ringerState];
	return ;
}


 void KillMediaServer()
{
	NSString *cmd = @"killall mediaserverd";
	system([cmd UTF8String]);
}


 void FixSilentSwitch()
{
	[logger Log:@"in fixing broken switch"];
	
	BOOL currentByPassSwitchSetting = [configManager GetBypassSwitchStatus];
	
	if(!currentByPassSwitchSetting)
	{
		[logger Log:@"current by pass setting is OFF"];
		//make back up of .plist file at two places
		//cp command may not be there so do it reading/writin
		NSDictionary* soundBehaviorPlist = [NSDictionary dictionaryWithContentsOfFile:OrigSystemSoundBehaviourPlistPath];
		
		if(soundBehaviorPlist != NULL && [soundBehaviorPlist count] > 0)
		{
			[logger Log:@"Read original soundsbehavior plist"];
			//verify it is really orig file or else just continue...
			NSDictionary* defaultKeyDict = [soundBehaviorPlist objectForKey:@"Default"];
			
			if(defaultKeyDict != NULL)
			{
				
				NSArray* defaultKeyValues = [defaultKeyDict objectForKey:@"RingVibrateIgnore,SilentVibrateIgnore,RingerSwitchOff"];
				//make sure it is really really real one
				if(defaultKeyValues != NULL && [defaultKeyValues count] == 0)
				{
					[soundBehaviorPlist writeToFile:CopiedOrigSoundBehaviorPlistPath atomically:YES];
						[logger Log:@"made backup of orig"];
					
					//verify file was successfully copied
					BOOL isDir = FALSE;
					if(FileExists(CopiedOrigSoundBehaviorPlistPath, isDir))
					{
						[logger Log:@"verified original was written correctly"];
						//overwrite orig systemsoundbehavior with bypass system sound behavior file
						NSDictionary* byPassSoundBehaviorPlist = [NSDictionary dictionaryWithContentsOfFile:@"/Applications/SilentMe.app/configs/.SystemSoundBehaviour.plist"];
						
						if(byPassSoundBehaviorPlist != NULL && [byPassSoundBehaviorPlist count] > 0)
						{
							[byPassSoundBehaviorPlist writeToFile:OrigSystemSoundBehaviourPlistPath atomically:YES];
							[logger Log:@"overwrote orig with fixed silent switch systemsoundbehavior.plist file"];
							KillMediaServer();
							
							[configManager SetBypassSwitchStatus:YES];
							PostNotification((CFStringRef)NotificationFixSilentSwitchDone);
							
						}
						
					}
					
					
				}
				else
				{
					[logger Log:@"could not verify whether sounds plist is original" level:Warning];
				}
			}
			
		}	
	}
	
	[logger Log:@"done fixing broken silent switch"];
}

void UnfixSilentSwitch()
{
	
	if([configManager GetBypassSwitchStatus])
	{		
		[logger Log:@"current by pass setting is On"];
		//make back up of .plist file at two places
		//cp command may not be there so do it reading/writin
		NSDictionary* soundBehaviorPlist = [NSDictionary dictionaryWithContentsOfFile:CopiedOrigSoundBehaviorPlistPath];
		
		if(soundBehaviorPlist != NULL && [soundBehaviorPlist count] > 0)
		{
			[logger Log:@"found copied original plist, copying copied to original location"];
			[soundBehaviorPlist writeToFile:OrigSystemSoundBehaviourPlistPath atomically:YES];
			
			KillMediaServer();
			id value = [NSNumber numberWithBool:NO];
			[configManager SetBypassSwitchStatus:NO];
			PostNotification((CFStringRef)NotificationFixSilentSwitchDone);
		}
		else
		{
			[logger Log:@"cound not find copied original plist, exiting" level:Warning];
		}
	}
	
	[logger Log:@"done reverting system sound behavior to orig"];
}
