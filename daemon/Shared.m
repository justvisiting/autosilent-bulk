//
//  Shared.m
//  Util
//
//  Created by god on 10/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Shared.h"
#import "PowerMgmt.h"
#import "Logger.h"

static Shared* calendar = nil;
static Shared* customSchedule = nil;

@implementation Shared

+ (void) initialize {
//	if ([self class] == [NSObject class]) {
	
		calendar = [[Shared alloc] init];
		customSchedule = [[Shared alloc] init];
//	}
	// Initialization for this class and any subclasses
}

+ (void) PrintAllList
{
	[calendar PrintAllList];
	[customSchedule PrintAllList];
}

+ (Shared*) CalendarInstance
{
	return calendar;
}

+ (Shared*)CustomScheduleInstance
{
	return customSchedule;
}

+ (void) SetNexWakeUpEvent:(WakeUpEventType) eventType
{
	[calendar SetNexWakeUpEvent:eventType];
	[customSchedule SetNexWakeUpEvent:eventType];
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
}

- (void)RemoveLastObjectOfCalendarList
{
		[Logger Log:@"removign last event"];
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
	[Logger Log:[NSString stringWithFormat:@"clearing events %d", [calendarList count]]];
		if(calendarList != nil && [calendarList count] > 0)
		{
			[calendarList removeAllObjects];
		}
}

- (void) SetNexWakeUpEvent:(WakeUpEventType) eventType
{
	NSDate* nowDate = [NSDate date];
	BOOL wakeUpDone = NO;
	
	while(!wakeUpDone && [calendarList count] > 0)
	{
		BaseEvent* event = [calendarList lastObject];
		
		if([[event getStartDate] compare:nowDate] == NSOrderedDescending)
		{
			if(![event GetwakeUpArrangedForStartFlag])
			{
				
				ArrangeWakeUpForChangingProfile([event getStartDateWithDelta], eventType);
				
				[event SetwakeUpArrangedForStartFlag:YES];
			
			}
			
			wakeUpDone = YES;
		}
		else if([[event getEndDate] compare:nowDate] == NSOrderedDescending)
		{
			if(![event GetwakeUpArrangedForEndFlag])
			{
				
				ArrangeWakeUpForChangingProfile([event getEndDateWithDelta], eventType);
				
				[event SetwakeUpArrangedForEndFlag:YES];
			}
			wakeUpDone = YES;
		}
		else
		{//event occurs in past, remove it
			[calendarList removeLastObject];
		}
	}
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
	[Logger Log:[NSString stringWithFormat:@"printing all instances in list no. of itmes in list %d", [calendarList count]]];
	NSEnumerator * enumerator = [calendarList objectEnumerator];
	id element;
	
	while(element = [enumerator nextObject])
    {
		[(BaseEvent*)element Print];
    }
}
@end
