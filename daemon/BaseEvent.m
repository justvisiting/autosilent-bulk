//
//  CoreEvent.m
//  Util
//
//  Created by god on 10/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BaseEvent.h"
#import "Logger.h"


@implementation BaseEvent

-(BaseEvent*) initWithStartDate: (NSDate*) stDate endDate: (NSDate*) edDate
{
	self = [super init];
	if(self)
	{
		[self setStartDate:stDate];
		[self setEndDate:edDate];
		wakeUpArrangedForStart = NO;
		wakeUpArrangedForEnd = NO;
	}
	
	[Logger Log:[NSString stringWithFormat:@"event created start %@ end %@", [start description], [end description]]];
	
	return self;
}

-(void) Print
{
	[Logger Log:[NSString stringWithFormat:@"BaseEvent startDate %@, endDate %@, startwithDelta %@, endWithDelta %@, wakeUpArrangedForStart %d, wakeUpArrangedForEnd %d"
							, [start description]
							, [end description]
							, [startWithDelta description]
							,[endWithDelta description]
							, wakeUpArrangedForStart
				 , wakeUpArrangedForEnd]];
}

-(void) setStartDate: (NSDate*) date
{
	[date retain];
	[start release];
	start = date;
	[startWithDelta release];
	startWithDelta = [[NSDate alloc] initWithTimeInterval:2 sinceDate:start];
}

-(void) setEndDate: (NSDate*) date
{
	[date retain];
	[end release];
	end = date;
	[endWithDelta release];
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

-(void) dealloc 
{
    [start release];
    [end release];

    [super dealloc];
}
@end
