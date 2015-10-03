#import <Foundation/Foundation.h>
#import "../newdaemonScript/constants.h"
#import "Calendar.h"

void convertSettingsPlist()
{
	
	//read original settings file
	NSDictionary* origSettings = 
	[NSDictionary dictionaryWithContentsOfFile:@"/Applications/SilentMe.app/settings.plist"];
	
	NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:5];
	
	
	[dict setValue:[NSNumber numberWithBool:YES] forKey:AppEnabledKey];
	[dict setValue:[NSNumber numberWithBool:YES] forKey:AutomaticEnabledKey];
	
	id calSync = [origSettings objectForKey:CalendarSyncEnabledKey];
	
	if(calSync != nil)
	{
		[dict setValue:calSync forKey:CalendarSyncEnabledKey];
	}
	else
	{
		[dict setValue:[NSNumber numberWithBool:YES] forKey:CalendarSyncEnabledKey];
	}

	[dict writeToFile:settingsPath atomically:YES];
}

void SetValue(NSDictionary* origDict, NSMutableDictionary* destDict, id key)
{
	id val = [origDict objectForKey:key];
	
	if(val != nil)
	{
		[destDict setValue:val forKey:key];
	}
	
}

void convertProfilePlist()
		{
			//read original settings file
			NSDictionary* origSettings = 
			[NSDictionary dictionaryWithContentsOfFile:@"/Applications/SilentMe.app/settings.plist"];
			
			NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithContentsOfFile:ProfilesFilePath];

			NSMutableDictionary* silentProfile = [dict objectForKey:@"1"];
			
			SetValue(origSettings,silentProfile, CalAlertEnabled);
			SetValue(origSettings,silentProfile, PhoneEnabled);
			SetValue(origSettings,silentProfile, KeyboardSoundEnabled);
			SetValue(origSettings,silentProfile, LockUnlockEnabled);
			SetValue(origSettings,silentProfile, NewMailEnabled);
			SetValue(origSettings,silentProfile, SmsAlertEnabled);
			SetValue(origSettings,silentProfile, VibrateEnabled);
			SetValue(origSettings,silentProfile, VoiceMailEnabled);			
			
			[dict writeToFile:ProfilesFilePath atomically:YES];
}

void convertSchedulePlist()
{
	//read original settings file
	NSDictionary* origSettings = 
	[NSDictionary dictionaryWithContentsOfFile:@"/Applications/SilentMe.app/settings.plist"];
	
	NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithContentsOfFile:ScheduleFilePath];
	
	NSMutableDictionary* weekday = [dict objectForKey:@"1"];
	
	id weekdayEndTime = [origSettings objectForKey:@"WeekdayQuiteEndTime"];
	[weekday setValue:weekdayEndTime forKey:ScheduleEndTimeKey];
	
	id weekdayStartTime = [origSettings objectForKey:@"WeekdayQuiteStartTime"];
	[weekday setValue:weekdayStartTime forKey:ScheduleStartTimeKey];

	id weekdayEnabled = [origSettings objectForKey:@"WeekdayNightEnabled"];
	[weekday setValue:weekdayEnabled forKey:ScheduleEnabledKey];

	NSMutableDictionary* weekend = [dict objectForKey:@"2"];
	id weekendEndTime = [origSettings objectForKey:@"WeekendQuiteStartTime"];
	[weekend setValue:weekendEndTime forKey:ScheduleStartTimeKey];
	
	id weekendStartTime = [origSettings objectForKey:@"WeekendQuiteEndTime"];
	[weekend setValue:weekendStartTime forKey:ScheduleEndTimeKey];
	
	id weekendEnabled = [origSettings objectForKey:@"WeekendNightEnabled"];
	[weekend setValue:weekendEnabled forKey:ScheduleEnabledKey];	
	
	[dict writeToFile:ScheduleFilePath atomically:YES];
}

void Copy2Xto3X()
{
	//update settings.plist
	NSDictionary* settings = 
	[NSDictionary dictionaryWithContentsOfFile:settingsPath];

	NSDictionary* oldSettings = 
		[NSDictionary dictionaryWithContentsOfFile:@"/private/var/mobile/Library/SilentMe/settings.plist"];
	//copy automatic enabled, CalSyncEnabled,key
	id automaticEnabled = [oldSettings objectForKey:AutomaticEnabledKey];
	[settings setValue:automaticEnabled forKey:AutomaticEnabledKey];
	
	//cal sync enabled
	id calSync = [oldSettings objectForKey:CalSyncEnabled];
	[settings setValue:calSync forKey:CalSyncEnabled];
	
	//key
	id key = [oldSettings objectForKey:ActivationTag];
	[settings setValue:key forKey:ActivationTag];
	[settings writeToFile:settingsPath atomically:YES];
	
	//update schedule.plist
	//enabled, start/endtime.
	NSDictionary* schedule = 
	[NSDictionary dictionaryWithContentsOfFile:ScheduleFilePath];
	
	NSDictionary* oldSchedule = 
	[NSDictionary dictionaryWithContentsOfFile:@"/private/var/mobile/Library/SilentMe/schedule.plist"];
	
	id weekdayDict = [schedule objectForKey:@"1"];
	id oldWeekdayDict = [oldSchedule objectForKey:@"1"];
	
	SetValue(oldWeekdayDict, weekdayDict, ScheduleEnabledKey);
	SetValue(oldWeekdayDict, weekdayDict, ScheduleStartTimeKey);
	SetValue(oldWeekdayDict, weekdayDict, ScheduleEndTimeKey);
	
	id weekendDict = [schedule objectForKey:@"2"];
	id oldWeekendDict = [oldSchedule objectForKey:@"2"];
	
	SetValue(oldWeekendDict, weekendDict, ScheduleEnabledKey);
	SetValue(oldWeekendDict, weekendDict, ScheduleStartTimeKey);
	SetValue(oldWeekendDict, weekendDict, ScheduleEndTimeKey);
	
	[schedule writeToFile:ScheduleFilePath atomically:YES];
	
}


int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

	NSDictionary* settings = 
	[NSDictionary dictionaryWithContentsOfFile:@"/Applications/SilentMe.app/settings.plist"];
	
	
	id weekdayEndTime = [settings objectForKey:@"WeekdayQuiteEndTime"];
	//1.x to 2.0
	if(weekdayEndTime != nil)
	{
		convertProfilePlist();
		convertSchedulePlist();
		convertSettingsPlist();	
	}
	
	//2.0 to 3.0
	Copy2Xto3X();
	
	[Calendar InitCalenderList];
	
    return 0;
}
