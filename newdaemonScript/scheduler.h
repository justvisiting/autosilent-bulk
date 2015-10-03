//
//  scheduler.h
//  newdaemon
//
//  Created by god on 10/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface scheduler : NSObject {

 NSLock *completeLock;
	NSDate* appStartTime;
}
+ (scheduler*) Instance;
//- (void) PerformAllActions:(NSString*) source override:(BOOL) overrideAndDisableApp;
- (void) PerformAllActions:(NSString*) source override:(BOOL) overrideAndDisableApp isManulModeApplicable:(BOOL) manulModeApplicable manualMode: (BOOL) manualMode;
- (void) PerformAllActions:(NSString*) source override:(BOOL) overrideAndDisableApp isManulModeApplicable:(BOOL) manulModeApplicable manualMode: (BOOL) manualMode manualModeDate:(NSDate*) manualModeDate;

@end


@interface scheduler()
- (void) Run:(NSString*) source overide:(BOOL) overrideAndDisableApp;
- (void) SyncWithExternalSystem;
- (BOOL) UpdateSettings:(BOOL) overrideAndDisableApp;
- (void) KillItIfRequired;
@end
