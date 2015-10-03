#import "ScheduleTimeCell.h"
#import "Model.h"


@implementation ScheduleTimeCell


- (ScheduleTimeCell*) initWithTitle: (NSString *) t intTag:(NSString *) tag  dict:(BaseDictionary*) dict
{
	return (ScheduleTimeCell*)[self initWithTitle:t nextControllerName:nil nextDataSource:nil intTag:tag dict:dict];
}


- (ScheduleTimeCell*) initWithTitle: (NSString *) t nextControllerName: (NSString*)controllerClassName
					 nextDataSource:(NSMutableArray*)nextDs intTag:(NSString *) tag  dict:(BaseDictionary*) dict
{
	self = [super init];
	
    if ( self ) {
        title = t;
		nextViewControllerClassName =  controllerClassName;
		nextDataSource = nextDs;
		intTag = tag;
		timeInSeconds = [self getTimeInSeconds];
		basedict = dict;
		cellIdentifier = @"ScheduleTimeCell";
		dict = dict;
    }
	
    return self;
}

- (NSString*) getTimeString
{
	
	return	[[[self getTime] descriptionWithCalendarFormat:@"%I:%M %p" timeZone:nil locale:nil] description];
	
}

-(void) setTime:(UIDatePicker*)datePicker cell:(UITableViewCell*)cell
{
	if(cell == nil)
		return;
	
	int secondsElapsed  = [self GetTimeElapsedForTheday:[datePicker date]];
	
	
	[basedict SetIntegerValue:intTag value:secondsElapsed];
	
	cell.text = [NSString stringWithFormat:@"%@       %@",title,[self getTimeString]];
}

-(NSDate*) getTime
{
	return [self GetDateFromInteger:[self getTimeInSeconds]];
}

-(int) getTimeInSeconds
{
	return [basedict GetIntegerValue:intTag];
}


@end