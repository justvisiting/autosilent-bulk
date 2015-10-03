
//
//  PowerMgmt.m
//  Util
//
//  Created by god on 5/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <IOKit/pwr_mgt/IOPMLib.h>
#import <IOKit/IOMessage.h>
#import "PowerMgmt.h"
#import "BaseEvent.h"
#import "Shared.h"
#import "Logger.h"
#import "Util.h"


io_connect_t root_port;
io_object_t notifier;
static	PowerMgmt* powerInstance;


inline void TimerCallBack(CFRunLoopRef timer, void *info)
{
	UpdateCalendarListIfRequired();

	Repeat(CFSTR("timer call back"));
	[Shared SetNexWakeUpEvent:WakeUpDuringNonSleep];
	[Shared PrintAllList];
}

inline void ArrangeWakeUpForChangingProfile(NSDate* date, WakeUpEventType eventType)
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

inline void ArrangWakeUpCallAtDateInNonSleep(NSDate* date)
{
	[Logger Log:[NSString stringWithFormat:@"wake up arranged during non-sleep time %@", [date description]]];
	
	//wake up when phone is not in sleep mode
	NSTimer* timer = [[NSTimer alloc] initWithFireDate:date interval:0 target:[PowerMgmt Instance] selector:@selector (timerFireMethod:) userInfo:nil repeats:NO];
	
}

inline void ArrangWakeUpCallAtDateInSleep(NSDate* date)
{
	[Logger Log:[NSString stringWithFormat:@"wake up arranged during sleep time %@", [date description]]];
	//wake up when phone is in sleep mode
	CPSchedulePowerUpAtDate((CFDateRef)date); // From AppSupport framework
}

inline void ArrangWakeUpCall()
{
	NSDate *nextWake = [[NSDate alloc] initWithTimeIntervalSinceNow:120];
	
	ArrangWakeUpCallAtDateInSleep(nextWake);
	[nextWake release];
	
}

@implementation PowerMgmt

	+ (void) initialize {
	//	if ([self class] == [NSObject class]) {
			
			powerInstance = [[PowerMgmt alloc] init];
		
	//	}
		// Initialization for this class and any subclasses
	}
	

+ (PowerMgmt*) Instance
{
	return powerInstance;
}

- (void)timerFireMethod:(NSTimer*)theTimer
{
	Repeat(CFSTR("source Not in sleep timer fire"));
	[Shared SetNexWakeUpEvent:WakeUpDuringNonSleep];
}
	
- (void) RegisterSource
{

	IONotificationPortRef notificationPort;
	
	// add power wake up
	root_port = IORegisterForSystemPower(self, &notificationPort, powerCallback, &notifier);
	
	// add the notification port to the application runloop
	CFRunLoopAddSource(CFRunLoopGetCurrent(),
					   IONotificationPortGetRunLoopSource(notificationPort),
					   kCFRunLoopCommonModes );
	
	
	
	// add timer
	CFAllocatorRef allocator = kCFAllocatorDefault;
	CFAbsoluteTime fireDate = CFAbsoluteTimeGetCurrent();
	CFTimeInterval interval = 120;
	CFOptionFlags flags = 0;
	CFIndex order = 0;
	CFRunLoopTimerCallBack callback = (CFRunLoopTimerCallBack)TimerCallBack;
	CFRunLoopTimerContext context = { 0, NULL, NULL, NULL, NULL };
	CFRunLoopTimerRef timer = CFRunLoopTimerCreate(allocator, fireDate, interval, flags, order, callback, &context);
	CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, kCFRunLoopDefaultMode);
	
    CFRunLoopRun();
}


- (void) RemoveSource
{
	IONotificationPortRef  notifyPortRef;
	
	// remove the sleep notification port from the application runloop
    CFRunLoopRemoveSource( CFRunLoopGetCurrent(),
						  IONotificationPortGetRunLoopSource(notifyPortRef),
						  kCFRunLoopCommonModes );
	
    // deregister for system sleep notifications
    IODeregisterForSystemPower( &notifier);
	
    // IORegisterForSystemPower implicitly opens the Root Power Domain IOService
    // so we close it here
    IOServiceClose( root_port );
	
    // destroy the notification port allocated by IORegisterForSystemPower
    IONotificationPortDestroy( notifyPortRef );
	
	
	
	
	// add timer
	CFAllocatorRef allocator = kCFAllocatorDefault;
	CFAbsoluteTime fireDate = CFAbsoluteTimeGetCurrent();
	CFTimeInterval interval = 120;
	CFOptionFlags flags = 0;
	CFIndex order = 0;
	CFRunLoopTimerCallBack callback = (CFRunLoopTimerCallBack)TimerCallBack;
	CFRunLoopTimerContext context = { 0, NULL, NULL, NULL, NULL };
	CFRunLoopTimerRef timer = CFRunLoopTimerCreate(allocator, fireDate, interval, flags, order, callback, &context);
	CFRunLoopRemoveTimer(CFRunLoopGetCurrent(), timer, kCFRunLoopDefaultMode);
	
    CFRunLoopStop(CFRunLoopGetCurrent());
}


@end

inline void powerCallback(void *refCon, io_service_t service, natural_t messageType, void *messageArgument)
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
            IOAllowPowerChange(root_port, (long)messageArgument);  
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
			UpdateCalendarListIfRequired();
			[Shared SetNexWakeUpEvent:WakeUpDuringSleep];
			IOAllowPowerChange(root_port, (long)messageArgument);	
            break; 
        case kIOMessageSystemHasPoweredOn:
            //Log(CFSTR("powerMessageReceived kIOMessageSystemHasPoweredOn"));
			Repeat(CFSTR("source wake up guy"));
            break;
    }
}


//@end


