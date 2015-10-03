//
//  CoreEvent.h
//  Util
//
//  Created by god on 10/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>

@interface BaseEvent : NSObject {

	NSDate* start;
	NSDate* end;
	//+2 seconds for error margin
	NSDate* startWithDelta;
	NSDate* endWithDelta;
	BOOL wakeUpArrangedForStart;
	BOOL wakeUpArrangedForEnd;
}

-(BaseEvent*) initWithStartDate: (NSDate*) stDate endDate: (NSDate*) edDate;
-(void) setStartDate: (NSDate*) date;
-(NSDate*) getStartDate;
-(NSDate*) getStartDateWithDelta;
-(NSDate*) getEndDateWithDelta;
-(void) SetwakeUpArrangedForStartFlag:(BOOL) flag;
-(BOOL) GetwakeUpArrangedForStartFlag;

-(void) setEndDate: (NSDate*) date;
-(NSDate*) getEndDate;
-(void) SetwakeUpArrangedForEndFlag:(BOOL) flag;
-(BOOL) GetwakeUpArrangedForEndFlag;
-(void) Print;
@end
