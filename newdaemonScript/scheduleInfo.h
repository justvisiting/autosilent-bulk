//
//  scheduleInfo.h
//  newdaemon
//
//  Created by god on 10/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseEvent.h"
#import "constants.h"

@interface scheduleInfo : NSObject {
	NSMutableArray* calendarList;
	bool isCalendar;
	NSString* name;
}
+ (void) PrintAllList;
+ (scheduleInfo*) CalendarInstance;
+ (scheduleInfo*) CustomScheduleInstance;
//+ (BaseEvent*) GetNexWakeUpEvent:(WakeUpEventType) eventType;
+ (BOOL) SetNexWakeUpEvent:(WakeUpEventType) eventType;
+ (BOOL) SetNexWakeUpEvent:(WakeUpEventType) eventType forceOverride:(bool)forceOverride;

- (BOOL) SetNexWakeUpEvent:(WakeUpEventType) eventType forceOverride:(bool)forceOverride;
+ (BaseEvent*) GetEventWhichMightResultIntoChangeInProfile;
- (BaseEvent*) GetEventWhichMightResultIntoChangeInProfile;
- (void)AddObject: (BaseEvent*) event;

- (void)RemoveObject:(int)eventId;
- (void)Sort;
- (void)Clear;
//- (BaseEvent*) GetNexWakeUpEvent:(WakeUpEventType) eventType;
//- (BaseEvent*) GetEventWhichMightResultIntoChangeInProfile;
- (void) PrintAllList;
- (void) ApplyProfileToAllEveents:(int)newProfile;
@end
