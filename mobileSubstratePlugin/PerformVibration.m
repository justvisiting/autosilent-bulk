//
//  PerformVibration.m
//  mobileSubstratePlugin
//
//  Created by god on 9/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PerformVibration.h"
#import <AudioToolbox/AudioToolbox.h>

@interface PerformVibration ()

- (void)finish;

@end

@implementation PerformVibration

@synthesize isExecuting = _isExecuting;
@synthesize isFinished = _isFinished;

- (id)init
{
    self = [super init];
    if (self == nil)
        return nil;
    
    _isExecuting = NO;
    _isFinished = NO;
    shouldVibrate = YES;
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (BOOL)isConcurrent
{
    return NO;
}

- (void)start
{
	while(shouldVibrate)
	{
		AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
		[NSThread sleepForTimeInterval:1.0];
	}
	
}

- (void)Stop
{
	shouldVibrate = NO;
	[self finish];
}

- (void)finish
{
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
	
    _isExecuting = NO;
    _isFinished = YES;
	
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}


@end
