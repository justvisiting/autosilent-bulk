//
//  configManager.m
//  newdaemon
//
//  Created by god on 10/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "configManager.h"
#import "constants.h"
#import "logger.h"

NSMutableDictionary* settingsDict;
NSMutableDictionary* daemonSettingsDict;
NSLock* configManagerLock;

@implementation configManager
//only to be used for testing
+ (NSMutableDictionary*) SettingsDict
{
	return settingsDict;
}

+ (void) initialize {
	configManagerLock = [[NSLock alloc] init];
	settingsDict = nil;
	daemonSettingsDict = nil;
	[configManager RefreshAll];
}

+ (void) RefreshAll
{
	[configManagerLock lock];
	if(settingsDict != nil)
	{
		[settingsDict release];
	}
	
	settingsDict = 
	[[NSMutableDictionary dictionaryWithContentsOfFile:settingsPath] retain];
	
	if(daemonSettingsDict != nil)
	{
		[daemonSettingsDict release];
	}
	daemonSettingsDict = 
	[[NSMutableDictionary dictionaryWithContentsOfFile:daemonPath] retain];
	
	//no need to refresh daemonSettingsDict as it is only changed by current process
	[configManagerLock unlock];
}

+ (void) Refresh
{
	[configManagerLock lock];
	if(settingsDict != nil)
	{
		[settingsDict release];
	}
	
	settingsDict = 
	[[NSMutableDictionary dictionaryWithContentsOfFile:settingsPath] retain];

	//no need to refresh daemonSettingsDict as it is only changed by current process
	[configManagerLock unlock];
}

+ (void) Write:(id) key  value:(id) val dictionary:(NSMutableDictionary*) dict path: (NSString*) pt
{
	[configManagerLock lock];
	[logger Log:[NSString stringWithFormat:@"final values %@, %@, %@", key, val, pt]];
	[dict setValue:val forKey:key];
	[dict writeToFile:pt atomically:YES];
	[configManagerLock unlock];
}

+ (int) GetCurrentApplicableScheduleValueInPlist
{
	id idInDict = [daemonSettingsDict objectForKey:CurrentScheduleKey];
	if(idInDict != nil)
	{
		return [idInDict intValue];
	}
	
	return DefaultScheduleIdWhenNoScheduleIsApplicable;
}

+ (void) SetCurrentApplicableSchedule: (int) scheduleId
{
	id idInDict = [daemonSettingsDict objectForKey:CurrentScheduleKey];
	if(idInDict == nil || [idInDict intValue] != scheduleId)
	{
		NSNumber* val = [NSNumber numberWithInt:scheduleId];
		[configManager Write:CurrentScheduleKey value:val dictionary:daemonSettingsDict path:daemonPath];
	}
}

+ (int) CurrentProfile
{
	return [[daemonSettingsDict objectForKey:CurrentProfileKey] intValue];
}

+ (NSString*) GetCurrentType
{
	return [settingsDict objectForKey:@"key"];
}

+ (NSString*) GetManualId
{
	return [settingsDict objectForKey:ManualId];
}

+ (void) SetCurrentProfile: (int) profileId
{
	NSNumber* val = [NSNumber numberWithInt:profileId];
	
	[configManager Write:CurrentProfileKey value:val dictionary:daemonSettingsDict path:daemonPath];

}

+ (void) SetBypassSwitchStatus: (BOOL) status
{
	NSNumber* val = [NSNumber numberWithBool:status];
	
	[configManager Write:ByPassSilentSwitchStatusKey value:val dictionary:daemonSettingsDict path:daemonPath];
	
}

+ (BOOL) GetBypassSwitchStatus
{
	return [[daemonSettingsDict objectForKey:ByPassSilentSwitchStatusKey] boolValue];	
}

+ (BOOL) GetSilentSwitchStatus
{
	//reading it from plist as this is also called in mobilesubstrate, 
	//where call to [UIHardware ringerstate] somehow hangs
	return [[daemonSettingsDict objectForKey:RingerToggleStatusKey] boolValue];
}

+ (void) SetSilentSwitchStatus: (BOOL) status 
{
	id val = [NSNumber numberWithBool:status];
	
	[configManager Write:RingerToggleStatusKey value:val dictionary:daemonSettingsDict path:daemonPath];	
}

+ (void) SetManualMode: (BOOL) mode
{
	id val = [NSNumber numberWithBool:mode];
	[configManager Write:ManualOrAutomaticSelectedKey value:val dictionary:daemonSettingsDict path:daemonPath];
	
}

+ (BOOL) AppEnabled
{
	return [[settingsDict objectForKey:AppEnabledKey] boolValue];
}

+ (BOOL) CalendarEnabled
{
	return ([configManager IsAutomaticMode] && [[settingsDict objectForKey:CalendarSyncEnabledKey] boolValue]);
}

+ (int) CalendarProfile
{
	return [[settingsDict objectForKey:CalendarProfileTag] intValue];
}

+ (NSDate*) GetDateUntilWhichManulModeIsAppliedFromUI
{
	return [settingsDict objectForKey:DateUntilManualModeIsApplicableKey];
}

+ (NSDate*) GetDateUntilWhichManulModeIsApplied
{
	return [daemonSettingsDict objectForKey:DateUntilManualModeIsApplicableKey];
}

+ (void) SetDateUntilWhichManulModeIsApplied:(NSDate*) date
{
	[configManager Write:DateUntilManualModeIsApplicableKey value:date  dictionary:daemonSettingsDict path:daemonPath];	
}

+ (BOOL) IsManualMode
{
	return [[daemonSettingsDict objectForKey:ManualOrAutomaticSelectedKey] boolValue];
}

+ (int) ManualProfile
{
	id num = [settingsDict objectForKey:ManualModeProfileKey]; 
	
	if(num != nil)
	{
		return [num intValue];
	}
	
	return SilentProfileId;
}



+ (BOOL) IsAutomaticMode
{
	return [[settingsDict objectForKey:AutomaticEnabledKey] boolValue];
}

+ (NSDictionary*) GetProfile:(int) profile
{
	if(profile == DefaultProfile)
	{
		return [NSMutableDictionary dictionaryWithContentsOfFile:DefaultProfilePlist];
	}
	else
	{

		NSDictionary* profileList = [NSDictionary dictionaryWithContentsOfFile:ProfilesFilePath];
		if(profileList != nil)
		{
			id profileNum = [NSString stringWithFormat:@"%d", profile];
			NSDictionary* profileInfo = [profileList objectForKey:profileNum];
			return profileInfo;
		}
	}
	
	return nil;
}

+ (BOOL) IsStatusIconEnabled
{
	return ![[settingsDict objectForKey:DisableStatusIconKey] boolValue];
}

+ (NSDictionary*) GetActiveCalendarList
{
	NSDictionary* dict = [NSDictionary dictionaryWithContentsOfFile:calendarFilePath];
	return dict;
	
}

+ (NSString*) GetSilentStringKeyword
{
	return [settingsDict objectForKey:NoAutoSilentCalendarStringKey];
}

+ (NSDate*) GetNextWakeUpTime
{
	return [daemonSettingsDict objectForKey:NextWakeUpTimeKey];
}

+ (void) SetNextWakeUpTime:(NSDate*)time
{
	[configManager Write:NextWakeUpTimeKey value:time dictionary:daemonSettingsDict path:daemonPath];
}

@end
