#import "BaseCell.h"

@interface ManualTimeCell : BaseCell
{
	NSDate * time;
	UITableView * myTableView;
	int timeInSeconds;
}

- (ManualTimeCell*) initWithTitle: (NSString *) t 
			   nextControllerName: (NSString*)controllerClassName 
				nextDataSource:(NSMutableArray*)nextDs dateTag:(NSString*)tag  dict:(BaseDictionary*) dict;
- (ManualTimeCell*) initWithTitle: (NSString *) t dateTag:(NSString*)tag  dict:(BaseDictionary*) dict;

- (NSDate*) GetDateFromInteger:(int) secondsElapsed;
-(int) GetTimeElapsedForTheday:(NSDate*) date;

-(NSString*) getTimeString;

-(void)SendNotification;

- (void) ObserveManualModeOn:(NSNotification*)notification;

@end