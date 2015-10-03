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
#import "Util.h"
#import "BaseEvent.h"
#import "Shared.h"


static CFStringRef const WeekendNightEnabled = CFSTR("WeekendNightEnabled");
static CFStringRef const WeekdayNightEnabled = CFSTR("WeekdayNightEnabled");
static CFStringRef const WeekendQuiteStartTime = CFSTR("WeekendQuiteStartTime");
static CFStringRef const WeekendQuiteEndTime = CFSTR("WeekendQuiteEndTime");
static CFStringRef const WeekdayQuiteStartTime = CFSTR("WeekdayQuiteStartTime");
static CFStringRef const WeekdayQuiteEndTime = CFSTR("WeekdayQuiteEndTime");

inline void InitializeCustomList(CFDictionaryRef dict)
{
	NSDate* date = [NSDate date];
	
	NSInteger dayOfWeek = GetDayOfWeek(date);
	
	if(dict != NULL)
	{
		BOOL isTodayWeekend = (dayOfWeek == 7 || dayOfWeek == 1); //weekday mon-fri. //weekend sat=7,sun=1
		CFNumberRef quiteStartTime = NULL;
		CFNumberRef quiteEndTime = NULL;
		
		if(isTodayWeekend && GetBoolValue(dict, WeekendNightEnabled))
		{
			quiteStartTime = CFDictionaryGetValue(dict, WeekendQuiteStartTime);
			quiteEndTime = CFDictionaryGetValue(dict, WeekendQuiteEndTime);
			
		}
		else if (!isTodayWeekend && GetBoolValue(dict, WeekdayNightEnabled))
		{
			quiteStartTime = CFDictionaryGetValue(dict, WeekdayQuiteStartTime);
			quiteEndTime = CFDictionaryGetValue(dict, WeekdayQuiteEndTime);
			
		}
		
		NSInteger todaysSecondsElapsed =  GetTimeElapsedForTheday(date);
		
		Log(CFSTR("quite start time not null and night quite time is applicable"));
		
		NSInteger startTime  = 0;
		NSInteger endTime = 0;
		
		if(quiteStartTime != NULL && quiteEndTime != NULL
		   && CFNumberGetValue(quiteStartTime, kCFNumberIntType, &startTime) 
		   && CFNumberGetValue(quiteEndTime, kCFNumberIntType, &endTime))
		{
			NSDate* todaysMidNightDate = [[NSDate date] dateByAddingTimeInterval:(NSTimeInterval)-todaysSecondsElapsed];
			
			NSDate* startDate = [todaysMidNightDate dateByAddingTimeInterval:(NSTimeInterval)startTime];
			NSDate* endDate = [todaysMidNightDate dateByAddingTimeInterval:(NSTimeInterval)endTime];
			
			BaseEvent* event = [[BaseEvent alloc] initWithStartDate:startDate endDate:endDate];
			
			Shared* customInstance = [Shared CustomScheduleInstance];
			[customInstance ClearCalendarList];
			
			[customInstance AddObjectToCalendarList:event];
			[customInstance SetNexWakeUpEvent:WakeUpDuringNonSleep];
		}
	}		
}
inline BOOL IsNightQuiteTime(CFDictionaryRef dict)
{
	Log(CFSTR("In night quite time"));
	
	NSDate* date = [NSDate date];
	
	NSInteger dayOfWeek = GetDayOfWeek(date);
	
	if(dict != NULL)
	{
		BOOL isTodayWeekend = (dayOfWeek == 7 || dayOfWeek == 1); //weekday mon-fri. //weekend sat=7,sun=1
		CFNumberRef quiteStartTime = NULL;
		CFNumberRef quiteEndTime = NULL;
		BOOL quiteTimeApplicable = FALSE;
		
		if(isTodayWeekend && GetBoolValue(dict, WeekendNightEnabled))
		{
			quiteStartTime = CFDictionaryGetValue(dict, WeekendQuiteStartTime);
			quiteEndTime = CFDictionaryGetValue(dict, WeekendQuiteEndTime);
			quiteTimeApplicable = TRUE;
			Log((CFStringRef)[NSString stringWithFormat:@"weekend quite time is applicable %d", dayOfWeek]);
		}
		else if (!isTodayWeekend && GetBoolValue(dict, WeekdayNightEnabled))
		{
			quiteStartTime = CFDictionaryGetValue(dict, WeekdayQuiteStartTime);
			quiteEndTime = CFDictionaryGetValue(dict, WeekdayQuiteEndTime);
			quiteTimeApplicable = TRUE;
			Log((CFStringRef)[NSString stringWithFormat:@"weekday quite time is applicable %d", dayOfWeek]);
		}
		
		
		if(quiteTimeApplicable && quiteStartTime != NULL && quiteEndTime != NULL)
		{
			
			
			NSInteger todaysSecondsElapsed =  GetTimeElapsedForTheday(date);
			
			Log(CFSTR("quite start time not null and night quite time is applicable"));
			
			NSInteger startTime  = 0;
			NSInteger endTime = 0;
			
			if(CFNumberGetValue(quiteStartTime, kCFNumberIntType, &startTime) 
			   && CFNumberGetValue(quiteEndTime, kCFNumberIntType, &endTime))
			{
				
				Log((CFStringRef)[NSString 
								  stringWithFormat:@"quite night timevalues, quiteStartTime %d, quiteEndTime %d, todays seconds elapsted %d"
								  , startTime, endTime, todaysSecondsElapsed]);
				
				if((startTime < endTime && startTime < todaysSecondsElapsed && endTime > todaysSecondsElapsed) // start end same day
				   ||(startTime > endTime && (todaysSecondsElapsed > startTime || todaysSecondsElapsed < endTime))) //start end different day
				{// fall in same day
					return TRUE;
				}
			}
		}
	}


return FALSE;

}