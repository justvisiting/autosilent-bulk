//
//  PowerMgmt.m
//  newdaemon
//
//  Created by god on 10/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "powerMgmt.h"
#import <IOKit/pwr_mgt/IOPMLib.h>
#import <IOKit/IOMessage.h>
#import "BaseEvent.h"
#import "logger.h"
#import "constants.h"
#import "scheduleInfo.h"
#import "scheduler.h"
#import "configManager.h"
#import <UIKit/UIKit.h>

#if !IS_IPHONE
#include <mach/mach_port.h>
#include <mach/mach_interface.h>
#include <mach/mach_init.h>
#endif


io_connect_t root_port;
io_object_t notifier;
IONotificationPortRef notificationPort;
static	powerMgmt* powerInstance;
NSTimer* NonSleepWakeUpDueToEventTimer = nil;

 void RegularCallBackInNonSleep(CFRunLoopRef timer, void *info)
{
	NSLog(@"called regualar call back in non sleep");
#if  !IS_IPHONE
	
	int rv = rand() % 2;
	
	BOOL isEnabled = NO;
	
	if(rv == 1)
	{
		isEnabled = YES;
	}
	
	NSNumber* boolNum = [NSNumber numberWithBool:isEnabled];
	NSMutableDictionary* settingsDict = [configManager SettingsDict];
	
	//[settingsDict setValue:boolNum forKey:AutomaticEnabledKey];
	//[settingsDict writeToFile:settingsPath atomically:YES];
	
	isEnabled = NO;
	rv  = rand() % 2;
	if(rv == 1)
	{
		isEnabled = YES;
	}
	 boolNum = [NSNumber numberWithBool:isEnabled];
	settingsDict = [configManager SettingsDict];
	
	[settingsDict setValue:boolNum forKey:ManualOrAutomaticSelectedKey];
	[settingsDict writeToFile:settingsPath atomically:YES];
	
	[configManager SetManualMode:isEnabled];
	
	[configManager RefreshAll];
	
	
#endif
	[[scheduler Instance] PerformAllActions:@"RegularCallbackFromNonSleep" override:NO  isManulModeApplicable:NO manualMode:NO];
}

 void ArrangeWakeUp(NSDate* date, WakeUpEventType eventType)
{
	
	if(eventType == (int)WakeUpDuringNonSleep)
	{
		ArrangWakeUpCallAtDateInNonSleep(date);
	}
	else if (eventType == (int)WakeUpDuringSleep)
	{
		ArrangWakeUpCallAtDateInSleep(date);	
	}
}

 void ArrangWakeUpCallAtDateInNonSleep(NSDate* date)
{
	[logger Log:[NSString stringWithFormat:@"wake up arranged during non-sleep time %@", [date description]]];
	
	//wake up when phone is not in sleep mode
	NSTimeInterval intv = [date timeIntervalSinceNow];
	// (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)seconds target:(id)target selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)repeat
	if(NonSleepWakeUpDueToEventTimer != nil)
	{
			//[NonSleepWakeUpDueToEventTimer invalidate];
	}
	
	NonSleepWakeUpDueToEventTimer = [NSTimer scheduledTimerWithTimeInterval:intv target:[powerMgmt Instance] selector:@selector (CallbackWhenNotInSleep:) userInfo:nil repeats:NO];

}

 void ArrangWakeUpCallAtDateInSleep(NSDate* date)
{
	[logger Log:[NSString stringWithFormat:@"wake up arranged during sleep time %@", [date description]]];
#if IS_IPHONE
	//wake up when phone is in sleep mode
	//CPSchedulePowerUpAtDate((CFDateRef)date); // From AppSupport framework
	// ios 4.0 workaround
	[configManager SetNextWakeUpTime:date];
	PostNotification(NotificationArrangeWakeUp);
#endif
}

 void powerCallback(void *refCon, io_service_t service, natural_t messageType, void *messageArgument)
{	
	switch (messageType)
    {
        case kIOMessageSystemWillSleep:
			/* The system WILL go to sleep. If you do not call IOAllowPowerChange or
			 IOCancelPowerChange to acknowledge this message, sleep will be
			 delayed by 30 seconds.
			 
			 NOTE: If you call IOCancelPowerChange to deny sleep it returns kIOReturnSuccess,
			 however the system WILL still go to sleep.
			 */
			
            // we cannot deny forced sleep
			//Log(CFSTR("powerMessageReceived kIOMessageSystemWillSleep"));
			[[scheduler Instance] PerformAllActions:@"GoingToSleep" override:NO  isManulModeApplicable:NO manualMode:NO];
			[scheduleInfo SetNexWakeUpEvent:WakeUpDuringSleep];
#if IS_IPHONE
            IOAllowPowerChange(root_port, (long)messageArgument);  
#endif
            break;
        case kIOMessageCanSystemSleep:
			/*
			 Idle sleep is about to kick in.
			 Applications have a chance to prevent sleep by calling IOCancelPowerChange.
			 Most applications should not prevent idle sleep.
			 
			 Power Management waits up to 30 seconds for you to either allow or deny idle sleep.
			 If you don't acknowledge this power change by calling either IOAllowPowerChange
			 or IOCancelPowerChange, the system will wait 30 seconds then go to sleep.
			 */
			
			//Log(CFSTR("powerMessageReceived kIOMessageCanSystemSleep"));
			
			//cancel the change to prevent sleep
			//IOCancelPowerChange(root_port, (long)messageArgument);
			//PerformAction(@"GoingToSleep", NO);
#if IS_IPHONE
			IOAllowPowerChange(root_port, (long)messageArgument);	
#endif
            break; 
        case kIOMessageSystemHasPoweredOn:
            //Log(CFSTR("powerMessageReceived kIOMessageSystemHasPoweredOn"));
			[scheduleInfo SetNexWakeUpEvent:WakeUpDuringNonSleep forceOverride:YES];
			[[scheduler Instance] PerformAllActions:@"SleepWakeup" override:NO  isManulModeApplicable:NO manualMode:NO];
            break;
    }
}



@implementation powerMgmt

+ (void) initialize {
	powerInstance = [[powerMgmt alloc] init];
}


+ (powerMgmt*) Instance
{
	return powerInstance;
}

+ (CFRunLoopTimerRef) GetTimer:(BOOL) repeating callback:(CFRunLoopTimerCallBack) callback
{
	// add timer
	CFAllocatorRef allocator = kCFAllocatorDefault;
	CFAbsoluteTime fireDate = CFAbsoluteTimeGetCurrent();
	CFTimeInterval interval;
	if(repeating)
	{
#if IS_IPHONE
		interval = 120;
#else
		interval = 5;
#endif
	}
	else
	{
		NSDate* now = [NSDate date];
		
		NSInteger secondElapsedToday = GetTimeElapsedForTheday(now);
		interval = (24*60*60-secondElapsedToday + 60*3);//interval going to next day midnight + 3 minutes
	}
	
	CFOptionFlags flags = 0;
	CFIndex order = 0;

	CFRunLoopTimerContext context = { 0, NULL, NULL, NULL, NULL };
	CFRunLoopTimerRef timer = CFRunLoopTimerCreate(allocator, fireDate, interval, flags, order, callback, &context);
	
	return timer;
}

-(id) init {
    self = [super init];
	lockObj = [[NSLock alloc] init];
	
    return self;
}

- (void) calendarChanged:(id) sender {
	
}

- (void)CallbackWhenNotInSleep:(NSTimer*)theTimer
{
	[logger Log:@"NonSleepWakeUpDueToEvent" level:Information];
	[[scheduler Instance] PerformAllActions:@"NonSleepWakeupDueToEvent" override:NO isManulModeApplicable:NO manualMode:NO];
}

- (void) AddTimer
{
	
	CFRunLoopTimerCallBack callback = (CFRunLoopTimerCallBack)RegularCallBackInNonSleep;	
	
	if(RepeatTimer == nil)
	{
		//if calendar is enabled then callback very frequently else non-frequently.
		if([configManager CalendarEnabled] && !repeatTimerForCalendarSync)
		{
			RepeatTimer = 	[powerMgmt GetTimer:YES callback:callback];
			repeatTimerForCalendarSync = YES;
			[logger Log:@"power mode changed to repeat mode"];
		}
		else 
		{
			RepeatTimer = 	[powerMgmt GetTimer:NO callback:callback];
			repeatTimerForCalendarSync = NO;
			[logger Log:@"power mode changed to non-repeat mode"];
		}
	
		CFRunLoopAddTimer(CFRunLoopGetCurrent(), RepeatTimer, kCFRunLoopDefaultMode);

	}
}

- (void) RegisterSource
{
#if IS_IPHONE

	// add power wake up
	root_port = IORegisterForSystemPower(self, &notificationPort, powerCallback, &notifier);
	
	// add the notification port to the application runloop
	CFRunLoopAddSource(CFRunLoopGetCurrent(),
					   IONotificationPortGetRunLoopSource(notificationPort),
					   kCFRunLoopCommonModes );
#endif	
	[self AddTimer];
    CFRunLoopRun();
}

-(void) UpdatePowerModeDueToChangeInCalendarSyncSettting
{
#if IS_IPHONE
	[lockObj lock];

	if(RepeatTimer != nil
	   &&
		((![configManager CalendarEnabled] && repeatTimerForCalendarSync)
			|| ([configManager CalendarEnabled] && !repeatTimerForCalendarSync)))
		
	{
			//[RepeatTimer invalidate];
		[RepeatTimer release];
		RepeatTimer = nil;
		repeatTimerForCalendarSync = NO;
		[logger Log:@"removed regular-callback"];
		
		[self AddTimer];
	}
	

	
	[lockObj unlock];
#endif
}

- (void) RemoveSource
{
#if IS_IPHONE
	// remove the sleep notification port from the application runloop
    CFRunLoopRemoveSource( CFRunLoopGetCurrent(),
						  IONotificationPortGetRunLoopSource(notificationPort),
						  kCFRunLoopCommonModes );
	
    // deregister for system sleep notifications
    IODeregisterForSystemPower( &notifier);
	
    // IORegisterForSystemPower implicitly opens the Root Power Domain IOService
    // so we close it here
    IOServiceClose( root_port );
	
    // destroy the notification port allocated by IORegisterForSystemPower
    IONotificationPortDestroy( notificationPort );
	
	if(RepeatTimer != nil)
	{
		[RepeatTimer invalidate];
	}
	
    CFRunLoopStop(CFRunLoopGetCurrent());
#endif
}


@end