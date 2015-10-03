//
//  Shared.h
//  Util
//
//  Created by god on 10/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseEvent.h"
#import "PowerMgmt.h"

@interface Shared : NSObject {
	NSMutableArray* calendarList;
}
+ (void) PrintAllList;
+ (Shared*) CalendarInstance;
+ (Shared*) CustomScheduleInstance;
+ (void) SetNexWakeUpEvent:(WakeUpEventType) eventType;
//- (NSMutableArray*)GetCalendarList;
- (void)AddObjectToCalendarList: (BaseEvent*) event;
- (void)RemoveLastObjectOfCalendarList;
- (void)SortCalendarList;
- (void)ClearCalendarList;
- (void)SetNexWakeUpEvent: (WakeUpEventType) eventType;
- (BaseEvent*) GetEventWhichMightResultIntoChangeInProfile;
- (void) PrintAllList;
@end
