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

@private
	NSDate* start;
	NSDate* end;
	//+2 seconds for error margin
	NSDate* startWithDelta;
	NSDate* endWithDelta;

	BOOL wakeUpArrangedForStart;
	BOOL wakeUpArrangedForEnd;

	BOOL wakeUpArrangedDuringSleepForStart;
	BOOL wakeUpArrangedDuringSleepForEnd;
	
	NSString* name;
	int eventId;
	int profileIdd;
	NSArray* repeatInfo;
	
	BOOL isCalendarEvent;
}
-(BaseEvent*) initWithStartDate: (NSDate*) stDate endDate: (NSDate*) edDate name:(NSString*) nm eventId:(int) eId profileId:(int)pId  isCalEvent:(BOOL) calEvent;
-(BaseEvent*) initWithStartDate: (NSDate*) stDate endDate: (NSDate*) edDate name:(NSString*) nm eventId:(int) eId;
-(BaseEvent*) initWithStartDate: (NSDate*) stDate endDate: (NSDate*) edDate name:(NSString*) nm;
-(BaseEvent*) initWithStartDate: (NSDate*) stDate endDate: (NSDate*) edDate;

-(int) EventId;
-(int) ProfileId;
-(void) SetProfileId:(int)newProfileid;
-(void) Print;

-(void) setStartDate: (NSDate*) date;
-(NSDate*) getStartDate;
-(void) setEndDate: (NSDate*) date;
-(NSDate*) getEndDate;

-(NSDate*) getStartDateWithDelta;
-(NSDate*) getEndDateWithDelta;


-(void) SetwakeUpArrangedForStartFlag:(BOOL) flag;
-(BOOL) GetwakeUpArrangedForStartFlag;
-(void) SetwakeUpArrangedForEndFlag:(BOOL) flag;
-(BOOL) GetwakeUpArrangedForEndFlag;

-(void) SetwakeUpArrangedDuringSleepForStartFlag:(BOOL) flag;
-(BOOL) GetwakeUpArrangedDuringSleepForStartFlag;
-(void) SetwakeUpArrangedDuringSleepForEndFlag:(BOOL) flag;
-(BOOL) GetwakeUpArrangedDuringSleepForEndFlag;

@end


@interface BaseEvent()
-(BaseEvent*) initCtor: (NSDate*) stDate endDate: (NSDate*) edDate name:(NSString*) nm eventId:(int) eId profileId:(int)pIdisCalEvent:(BOOL) calEvent;
@end
