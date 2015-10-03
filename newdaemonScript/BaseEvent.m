//
//  CoreEvent.m
//  Util
//
//  Created by god on 10/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BaseEvent.h"
#import "logger.h"


@implementation BaseEvent
-(BaseEvent*) initWithStartDate: (NSDate*) stDate endDate: (NSDate*) edDate name:(NSString*) nm eventId:(int) eId profileId:(int)pId  isCalEvent: (BOOL) calEvent
{
	self = [super init];
	if(self)
	{
		return [self initCtor:stDate endDate:edDate name:nm eventId:eId profileId:pId isCalEvent:calEvent];
	}
	
	return nil;
}

-(BaseEvent*) initWithStartDate: (NSDate*) stDate endDate: (NSDate*) edDate name:(NSString*) nm eventId:(int) eId
{
	self = [super init];
	if(self)
	{
		return [self initCtor:stDate endDate:edDate name:nm eventId:eId profileId:-1  isCalEvent:NO];
	}
	
	return nil;
}

-(BaseEvent*) initWithStartDate: (NSDate*) stDate endDate: (NSDate*) edDate name:(NSString*) nm
{
	self = [super init];
	if(self)
	{
		return [self initCtor:stDate endDate:edDate name:nm eventId:0 profileId:-1  isCalEvent:NO];
	}

	return nil;
}
-(BaseEvent*) initWithStartDate: (NSDate*) stDate endDate: (NSDate*) edDate
{
	self = [super init];
	if(self)
	{
		return [self initCtor:stDate endDate:edDate name:@"" eventId:0 profileId:-1  isCalEvent:NO];
	}
	
	return nil;
}

-(BaseEvent*) initCtor: (NSDate*) stDate endDate: (NSDate*) edDate name:(NSString*) nm eventId:(int) eId
			 profileId:(int) pId isCalEvent: (BOOL) calEvent
{
	
	[self setStartDate:stDate];
	[self setEndDate:edDate];
	wakeUpArrangedForStart = NO;
	wakeUpArrangedForEnd = NO;
	[nm retain];
	name=nm;
	eventId = eId;
	profileIdd = pId;
	isCalendarEvent = calEvent;
	[logger Log:[NSString stringWithFormat:@"event created start %@ end %@", [start description], [end description]] level:Information];
	
	
	
	
	return self;
}

-(int) EventId
{
	return eventId;
}

-(int) ProfileId
{
	return profileIdd;
}

-(void) Print
{
	[logger Log:[NSString stringWithFormat:@"BaseEvent name %@, id: %d , startDate %@, endDate %@, %@, %@, wakeUpFlagForStart:%d, wakeUpFlagForEnd:%d, wakeUpFlagForSleepStart:%d, wakeUpFlagForSleepEnd:%d, profile:%d"
							, name
							, eventId
							, [start description]
							, [end description]
							, [startWithDelta description]
							,[endWithDelta description]
							, wakeUpArrangedForStart
							, wakeUpArrangedForEnd
							, wakeUpArrangedDuringSleepForStart
							, wakeUpArrangedDuringSleepForEnd
	 						, profileIdd] 
		  level:Warning]	;
}

-(void) setStartDate: (NSDate*) date
{
	if(start != nil)
	{
		[start release];	
	}
	if(startWithDelta != nil)
	{
		[startWithDelta release];
	}
		
	[date retain];
	start = date;
	startWithDelta = [[NSDate alloc] initWithTimeInterval:2 sinceDate:start];
}

-(void) setEndDate: (NSDate*) date
{
	if(end != nil)
	{
		[end release];
	}
	if(endWithDelta != nil)
	{
		[endWithDelta release];
	}
	
	[date retain];
	end = date;
	endWithDelta = [[NSDate alloc] initWithTimeInterval:2 sinceDate:end];
}

-(NSDate*) getStartDate
{
	return start;
}

-(NSDate*) getStartDateWithDelta
{
	return startWithDelta;
}

-(NSDate*) getEndDate
{
	return end;
}

-(NSDate*) getEndDateWithDelta
{
	return endWithDelta;
}

-(void) SetwakeUpArrangedForStartFlag:(BOOL) flag
{
	wakeUpArrangedForStart = flag;
}

-(void) SetwakeUpArrangedForEndFlag:(BOOL) flag
{
	wakeUpArrangedForEnd = flag;
}

-(BOOL) GetwakeUpArrangedForStartFlag
{
	return wakeUpArrangedForStart;
}

-(BOOL) GetwakeUpArrangedForEndFlag
{
	return wakeUpArrangedForEnd;
}

-(void) SetwakeUpArrangedDuringSleepForStartFlag:(BOOL) flag
{
	wakeUpArrangedDuringSleepForStart = flag;
}

-(void) SetwakeUpArrangedDuringSleepForEndFlag:(BOOL) flag
{
	wakeUpArrangedDuringSleepForEnd = flag;
}

-(BOOL) GetwakeUpArrangedDuringSleepForStartFlag
{
	return wakeUpArrangedDuringSleepForStart;
}

-(BOOL) GetwakeUpArrangedDuringSleepForEndFlag
{
	return wakeUpArrangedDuringSleepForEnd;
}

-(BOOL) IsCalendarEventType
{
	return isCalendarEvent;
}

-(void) SetProfileId:(int)newProfileid
{
	profileIdd = newProfileid;
}

-(void) dealloc 
{
    [start release];
    [end release];
	[startWithDelta release];
	[endWithDelta release];

    [super dealloc];
}
@end
