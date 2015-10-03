#import "ManualTimeCell.h"

@interface ScheduleTimeCell : ManualTimeCell
{
}

- (ScheduleTimeCell*) initWithTitle: (NSString *) t 
			nextControllerName: (NSString*)controllerClassName 
			 nextDataSource:(NSMutableArray*)nextDs
			intTag:(NSString*)tag  
			dict:(BaseDictionary*) dict;
- (ScheduleTimeCell*) initWithTitle: (NSString *) t intTag:(NSString*)tag  dict:(BaseDictionary*) dict;

@end