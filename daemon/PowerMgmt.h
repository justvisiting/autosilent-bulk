//
//  PowerMgmt.h
//  Util
//
//  Created by god on 5/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <IOKit/pwr_mgt/IOPMLib.h>
#import <IOKit/IOMessage.h>
#import "BaseEvent.h"

typedef enum WakeUpEventTypeEnum
	{
		WakeUpDuringNonSleep
		, WakeUpDuringSleep
	} WakeUpEventType;


@interface PowerMgmt : NSObject
{	
}
+ (PowerMgmt*) Instance;
-  (void) RegisterSource;
-  (void) RemoveSource;
- (void)timerFireMethod:(NSTimer*)theTimer;

@end
 

//void RegisterSource();
inline void powerCallback(void *refCon, io_service_t service, natural_t messageType, void *messageArgument);
inline void ArrangWakeUpCall();
inline void ArrangWakeUpCallAtDate(NSDate* date);
inline void RepeatTimerCallBack(CFRunLoopRef timer, void *info);
inline void ArrangeWakeUpForChangingProfile(NSDate* date, WakeUpEventType eventType);
inline void ArrangWakeUpCallAtDateInNonSleep(NSDate* date);
inline void ArrangWakeUpCallAtDateInSleep(NSDate* date);


