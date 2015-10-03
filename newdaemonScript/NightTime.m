//
//  NightTime.m
//  Util
//
//  Created by god on 5/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>

#import "Common.h"
#import "NightTime.h"
#import "BaseEvent.h"
#import "scheduleInfo.h"
#import "NightTime.h"
#import "logger.h"
#import "constants.h"
#import "configManager.h"


NSInteger sedondsInDay = 24*60*60;


 BOOL GetBoolValue(CFDictionaryRef dict, const void* key)
{
	CFBooleanRef val =  CFDictionaryGetValue(dict, key);
	
	if(val == NULL)
	{
		return FALSE;
	}
	
	
	BOOL rv = CFBooleanGetValue(val);
	
	return rv;
}

 BaseEvent* GetManualEvent()
{
	BaseEvent* rv = [[BaseEvent alloc] initWithStartDate:[NSDate date] endDate:[configManager GetDateUntilWhichManulModeIsApplied] name:@"Manual" eventId:ManualEventId profileId:SilentProfile isCalEvent:NO];
	return rv;
}

 void RemoveManulEvent()
{
	[[scheduleInfo CustomScheduleInstance] RemoveObject:ManualEventId];
}

 void AddManulEvent()
{
	if([configManager IsManualMode])
	{
		[[scheduleInfo CustomScheduleInstance] AddObject:GetManualEvent()];
	}	
}

 void AddOrUpdateManulEvent()
{
	RemoveManulEvent();
	AddManulEvent();
}

 void InitializeCustomList()
{
	NSDictionary* dictionary = [NSDictionary dictionaryWithContentsOfFile:ScheduleFilePath];
	
	NSDate* date = [NSDate date];
	
	NSInteger dayOfWeek = GetDayOfWeek(date);
	scheduleInfo* customInstance = [scheduleInfo CustomScheduleInstance];
	[customInstance Clear];
	
	if([configManager IsAutomaticMode])
	{
		NSInteger todaysSecondsElapsed =  GetTimeElapsedForTheday(date);
		NSDate* todaysMidNightDate = [[NSDate date] dateByAddingTimeInterval:(NSTimeInterval)-todaysSecondsElapsed];
		
		for (id key in dictionary) 
		{
			NSDictionary* schedule = [dictionary objectForKey:key];
			if(schedule != nil)
			{

				bool isEnabled = [[schedule objectForKey:ScheduleEnabledKey] boolValue];
				if(isEnabled)
				{
					NSInteger startSeconds = [[schedule objectForKey:ScheduleStartTimeKey] intValue];
					NSInteger endSeconds = [[schedule objectForKey:ScheduleEndTimeKey] intValue];
					
					NSArray* applicableDays = [schedule objectForKey:ScheduleRepeatInfoKey];
					BOOL isScheduleApplicableToday = NO;
					BOOL isTodayNextDay = NO;
					
					if(applicableDays != nil)
					{//BUG when time spans across days !!, on the day enddate is, the schedule will not be added. 
						for(id day in applicableDays)
						{
							NSInteger dayVal = [day intValue];
							if(dayVal == dayOfWeek)
							{
								isScheduleApplicableToday = YES;
								continue;
							}
							else if((dayVal == (dayOfWeek-1) || (dayOfWeek == 1 && (dayVal == 7)))
									&& (startSeconds > endSeconds))
							{
								isTodayNextDay = YES;
								continue;
							}
						}
					}
					
										
					if(isScheduleApplicableToday)
					{
						NSDate* startDate = [todaysMidNightDate 
											 dateByAddingTimeInterval:(NSTimeInterval)startSeconds];
						NSDate* endDate;
						NSInteger endSecondsFinalVal = endSeconds;
						
						if(endSeconds < startSeconds)
						{//schedule spans to next day
								endSecondsFinalVal = endSeconds + sedondsInDay;							
						}
						
						endDate = [todaysMidNightDate dateByAddingTimeInterval:(NSTimeInterval)endSecondsFinalVal];
						
						NSString* name  = [schedule objectForKey:ScheduleNameKey];
						int eventIdentifier = [key intValue];
						int profileIdentifier = [[schedule objectForKey:ScheduleProfileKey] intValue];

						BaseEvent* event = 
						[[BaseEvent alloc] initWithStartDate:startDate endDate:endDate name:name eventId:eventIdentifier profileId:profileIdentifier  isCalEvent:NO];
						
						[customInstance AddObject:event];
						
					}
					
					if(isTodayNextDay)
					{
						NSDate* startDate = todaysMidNightDate;
						NSDate* endDate = [todaysMidNightDate 
										   dateByAddingTimeInterval:(NSTimeInterval)endSeconds];
						
						NSString* name  = [schedule objectForKey:ScheduleNameKey];
						int profileIdentifier = [[schedule objectForKey:ScheduleProfileKey] intValue];
						int eventIdentifier = [key intValue];

						BaseEvent* event = 
						[[BaseEvent alloc] initWithStartDate:startDate endDate:endDate name:name eventId:eventIdentifier  profileId:profileIdentifier isCalEvent:NO];
						[customInstance AddObject:event];
						
					}
					
				}
			}
		}
		
		[customInstance Sort];
	}
	//finally add manul event
	AddManulEvent();
}
