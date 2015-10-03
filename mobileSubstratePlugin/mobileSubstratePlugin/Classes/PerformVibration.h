#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>

@interface PerformVibration : NSOperation
{
    
    BOOL _isExecuting;
    BOOL _isFinished;
	volatile BOOL shouldVibrate;
}


@property (readonly) BOOL isExecuting;
@property (readonly) BOOL isFinished;
- (id)init;
-(void) Stop;
@end
