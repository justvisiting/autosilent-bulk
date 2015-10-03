//
//  PowerMgmt.h
//  newdaemon
//
//  Created by god on 10/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

 inline void ArrangWakeUpCallAtDateInNonSleep(NSDate* date);
inline  void ArrangWakeUpCallAtDateInSleep(NSDate* date);

@interface powerMgmt : NSObject {
@private

	BOOL repeatTimerForCalendarSync;
	CFRunLoopTimerRef RepeatTimer;
//CFRunLoopTimerRef AlmostNonRepeatTimer;
	NSLock* lockObj;
}
+ (powerMgmt*) Instance;
-  (void) RegisterSource;
-  (void) RemoveSource;
@end

@interface powerMgmt()
- (void)CallbackWhenNotInSleep:(NSTimer*)theTimer;
- (void)UpdatePowerModeDueToChangeInCalendarSyncSettting;
@end
