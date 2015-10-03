//
//  scheduleInfo.m
//  newdaemon
//
//  Created by god on 10/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "scheduleInfo.h"
#import "calendar.h"
#import "logger.h"
#import "BaseEvent.h"
#import "constants.h"

scheduleInfo* calendarSchedule = nil;
scheduleInfo* customSchedule = nil;



@implementation scheduleInfo

+ (void) initialize {
	//	if ([self class] == [NSObject class]) {
	
	calendarSchedule = [[scheduleInfo alloc] init];
	calendarSchedule->name = @"calendarschedule";
	calendarSchedule->isCalendar = YES;
	
	customSchedule = [[scheduleInfo alloc] init];
	customSchedule->name = @"customschedule";
	customSchedule->isCalendar = NO;
	
}

+ (void) PrintAllList
{
	[calendarSchedule PrintAllList];
	[customSchedule PrintAllList];
}

+ (scheduleInfo*) CalendarInstance
{
	return calendarSchedule;
}

+ (scheduleInfo*)CustomScheduleInstance
{
	return customSchedule;
}

+ (BaseEvent*) GetEventWhichMightResultIntoChangeInProfile
{
	if(calendarSchedule != nil)
	{
		BaseEvent* rv = [calendarSchedule GetEventWhichMightResultIntoChangeInProfile];
		
		if(rv == nil)
		{
			return [customSchedule GetEventWhichMightResultIntoChangeInProfile];
		}
		
		return rv;
	}
	
	//just for compiler warnings...code should never reach here. 
	return nil;
}

- (NSMutableArray*)GetScheduleList 
{ 
	return calendarList; 
}

- (void)AddObjectToCalendarList: (BaseEvent*) event
{
	//not thread safe....but will live with it
	if(calendarList == nil)
	{
		calendarList = [[NSMutableArray alloc] init];
	}
	
	[calendarList addObject:event];
	[event release];
}

- (void)RemoveLastObjectOfCalendarList
{
	[logger Log:@"removign last event"];
	if(calendarList != nil && [calendarList count] > 0)
	{
		[calendarList removeLastObject];
	}
}

- (void)SortCalendarList
{
	if(calendarList != nil && [calendarList count] > 1)
	{
		NSSortDescriptor *startDateSorter = [[NSSortDescriptor alloc] initWithKey:@"getStartDate" ascending:NO];
		[calendarList sortUsingDescriptors:[NSArray arrayWithObject:startDateSorter]];
	}
	
}

- (void) ClearCalendarList
{
	[logger Log:[NSString stringWithFormat:@"clearing events %d", [calendarList count]]];
	if(calendarList != nil && [calendarList count] > 0)
	{
		[calendarList removeAllObjects];
	}
}

+ (BOOL) SetNexWakeUpEvent:(WakeUpEventType) eventType forceOverride:(bool)forceOverride
{
	BOOL rv = [calendarSchedule SetNexWakeUpEvent:eventType forceOverride:forceOverride];
	
	rv = rv | [customSchedule SetNexWakeUpEvent:eventType forceOverride:forceOverride];
	
}
+ (BOOL) SetNexWakeUpEvent:(WakeUpEventType) eventType
{
	return [scheduleInfo SetNexWakeUpEvent: eventType forceOverride:NO];
}


- (BOOL) SetNexWakeUpEvent:(WakeUpEventType) eventType forceOverride:(bool)forceOverride
{
	NSDate* nowDate = [NSDate date];
	[logger Log:[NSString stringWithFormat:@"going through events list to arrange next wakeup, %@", name]];
	
	while([calendarList count] > 0)
	{
		
		BaseEvent* event = [calendarList lastObject];
		[event Print];
		
		if([[event getStartDate] compare:nowDate] == NSOrderedDescending)
		{
			if(eventType == WakeUpDuringNonSleep && (![event GetwakeUpArrangedForStartFlag] || forceOverride))
			{
				[event Print];
				ArrangeWakeUp([event getStartDateWithDelta], eventType);
				[event SetwakeUpArrangedForStartFlag:YES];
			}
			else if(eventType == WakeUpDuringSleep && (![event GetwakeUpArrangedDuringSleepForStartFlag] || forceOverride))
			{
				[event Print];
				ArrangeWakeUp([event getStartDateWithDelta], eventType);
				[event SetwakeUpArrangedDuringSleepForStartFlag:YES];
			}
			
			return YES;
		}
		else if([[event getEndDate] compare:nowDate] == NSOrderedDescending)
		{
			if(eventType == WakeUpDuringNonSleep && (![event GetwakeUpArrangedForEndFlag]  || forceOverride))
			{
				ArrangeWakeUp([event getEndDateWithDelta], eventType);
				[event SetwakeUpArrangedForEndFlag:YES];
			}
			else if(eventType == WakeUpDuringSleep && (![event GetwakeUpArrangedDuringSleepForEndFlag] || forceOverride))
			{
				ArrangeWakeUp([event getEndDateWithDelta], eventType);
				[event SetwakeUpArrangedDuringSleepForEndFlag:YES];
			}
			return YES;

		}
		else
		{//event occurs in past, remove it
			[calendarList removeLastObject];
		}
	}
	
	return NO;
}


- (BaseEvent*) GetEventWhichMightResultIntoChangeInProfile
{
	NSDate* nowDate = [NSDate date];
	while([calendarList count] > 0)
	{
		BaseEvent* event = [calendarList lastObject];
		
		if([[event getStartDate] compare:nowDate] == NSOrderedAscending
		   && [[event getEndDate] compare:nowDate] == NSOrderedDescending)
		{//event for which now date falls in between of start & end time
			return event;
		}
		else if([[event getEndDate] compare:nowDate] == NSOrderedAscending)
		{//event finished in past, remove it
			[calendarList removeLastObject];
		}
		else
		{
			return nil;
		}
	}
	
	return nil;
}

-(void) PrintAllList
{
	[logger Log:[NSString stringWithFormat:@"printing all instances in list no. of itmes in list %@ count:%d", self->name, [calendarList count]] level:Warning];
	NSEnumerator * enumerator = [calendarList objectEnumerator];
	id element;
	
	while(element = [enumerator nextObject])
    {
		[(BaseEvent*)element Print];
    }
}

- (void) Sort
{
	if(calendarList != nil && [calendarList count] > 1)
	{
		NSSortDescriptor *startDateSorter = [[NSSortDescriptor alloc] initWithKey:@"getStartDate" ascending:NO];
		[calendarList sortUsingDescriptors:[NSArray arrayWithObject:startDateSorter]];
	}
	
}

- (void) Clear
{
	if(calendarList != nil && [calendarList count] > 0)
	{
		[calendarList removeAllObjects];
	}
}

- (void)RemoveObject:(int)eventId
{
	if(calendarList != nil && [calendarList count] > 0)
	{
		unsigned int i;
		
		for(i = 0; i < [calendarList count]; i++)
		{
			BaseEvent* event = (BaseEvent*)[calendarList objectAtIndex:i];
			if([event EventId] == eventId)
			{
				break;
			}
		}
		
		if(i < [calendarList count])
		{
			[calendarList removeObjectAtIndex:i];
		}
	}
}


- (void)AddObject: (BaseEvent*) event
{
	//not thread safe....but will live with it
	if(calendarList == nil)
	{
		calendarList = [[NSMutableArray alloc] init];
	}
	
	[calendarList addObject:event];
	[event release];
}

- (void) ApplyProfileToAllEveents:(int)newProfile
{
	if(calendarList != nil && [calendarList count] > 0)
	{
		NSEnumerator * enumerator = [calendarList objectEnumerator];
		id element;
	
		while(element = [enumerator nextObject])
		{
			[(BaseEvent*)element SetProfileId:newProfile];
		}
	}
}
@end
