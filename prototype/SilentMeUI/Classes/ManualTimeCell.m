#import "ManualTimeCell.h"
#import "Model.h"
#import "Constants.h"

@implementation ManualTimeCell
- (ManualTimeCell*) initWithTitle: (NSString *) t
{
	return (ManualTimeCell*)[self initWithTitle:t nextControllerName:nil nextDataSource:nil];
}

- (ManualTimeCell*) initWithTitle: (NSString *) t dateTag:(NSString *) tag  dict:(BaseDictionary*) dict
{
	return (ManualTimeCell*)[self initWithTitle:t nextControllerName:nil   nextDataSource:nil dateTag:tag dict:dict];
}


- (ManualTimeCell*) initWithTitle: (NSString *) t 
			   nextControllerName: (NSString*)controllerClassName 
				   nextDataSource:(NSMutableArray*)nextDs
{
	self = [super init];
	
    if ( self ) {
        title = t;
		cellIdentifier = @"ManualTimeCell";
		nextViewControllerClassName =  controllerClassName ;
		nextDataSource = nextDs;
		timeInSeconds = 0;
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ObserveManualModeOn:) name:NotificaitonManualModeSwitchedByUIOn object:nil];
    }
	
    return self;
}

- (ManualTimeCell*) initWithTitle: (NSString *) t 
			   nextControllerName: (NSString*)controllerClassName 
				   nextDataSource:(NSMutableArray*)nextDs dateTag:(NSString*)tag  dict:(BaseDictionary*) dict
{
	self = [super init];
	
    if ( self ) {
        title = t;
		cellIdentifier = @"ManualTimeCell";
		nextViewControllerClassName =  controllerClassName;
		nextDataSource = nextDs;
		dateTag = tag;
		timeInSeconds = [self getTimeInSeconds];
		basedict = dict;
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ObserveManualModeOn:) name:NotificaitonManualModeSwitchedByUIOn object:nil];
    }
	
    return self;
}

-(NSDate*) getTime
{
	 if ([[Model GetModel] GetValue:dateTag] != nil)
	 {
		 return (NSDate*) [[Model GetModel] GetValue:dateTag];
	 }
	else
	{
		return [NSDate date];
	}
}

-(int) getTimeInSeconds
{
	NSDate * date = [self getTime];
	if (date != nil)
	return [self GetTimeElapsedForTheday:date];
	else return 0;
	//return [basedict GetIntegerValue:dateTag];
}

-(void) setTime:(UIDatePicker*)datePicker cell:(UITableViewCell*)cell
{
	if(cell == nil)
		return;
	
	NSDate * date = [[datePicker date] retain];
	
	[basedict SetValue:dateTag value:date];
	//[self SendNotification];

	cell.text = [NSString stringWithFormat:@"%@     %@",title,[self getTimeString]];
}


-(void)SendNotification
{
	//hack special case
	if ([[Model GetModel] GetBoolValue:ManualMode])
	{
		[BaseDictionary PostInterProcessNotification:NotificaitonManualModeSwitchedByUIOn];
	}
	else
	{
		[BaseDictionary PostInterProcessNotification:NotificaitonManualModeSwitchedByUIOff];
	}
}

- (UITableViewCell *) getTableViewCell:(UITableView *) tableView
{
	myTableView = tableView;
	UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (!cell) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero] autorelease];
	}
	
	cell.text = [NSString stringWithFormat:@"%@     %@",title,[self getTimeString]];
	
	if(nextViewControllerClassName != nil)
	{
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.hidesAccessoryWhenEditing = YES;
	}
	return cell;
}

- (NSString*) getTimeString
{
	
	//int hours = [self getTimeInSeconds]/(60*60);
	//int mins = ([self getTimeInSeconds] % (60*60))/60;

	//return [NSString stringWithFormat:@"%d hr %d mins",hours,mins];
	//return [[[self getTime] descriptionWithCalendarFormat:
	//		 @"%a %b %e %Y %I:%M %p" timeZone:nil locale:nil] description];
	
	NSDate * currentDate = [NSDate date];
	int currentElapsedSeconds = [self GetTimeElapsedForTheday:currentDate];
	int difference = [[self getTime] timeIntervalSinceDate:currentDate];
	if (difference < 0) 
		return NSLocalizedString(@"Occurs in past", @"");
	
	difference = difference + currentElapsedSeconds;
	
	int dayDiff = difference/(60*60*24);
	
	
	if ( dayDiff == 0)
	{
		NSString* timeString = [[[self getTime] descriptionWithCalendarFormat:
								 @" %I:%M %p" timeZone:nil locale:nil] description];
		
		return [[NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"Today at", @"") ,timeString] retain];
	}
	
	if (dayDiff == 1)
	{
		NSString* timeString = [[[self getTime] descriptionWithCalendarFormat:
								 @" %I:%M %p" timeZone:nil locale:nil] description];
		
		return [[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Tomorrow at",@""),timeString] retain];
	}
	
	return [[[self getTime] descriptionWithCalendarFormat:
			 @"%a %b %e %I:%M %p" timeZone:nil locale:nil] description];

}

-(int) GetTimeElapsedForTheday:(NSDate*) date
{
	NSCalendar *gregorian = [[NSCalendar alloc]
							 initWithCalendarIdentifier:NSGregorianCalendar];
	
	NSUInteger unitFlags = NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
	
	NSDateComponents *components = [gregorian components:unitFlags 
												fromDate:date];
	
	int rv =	([components hour] * 60 + [components minute]) * 60 + [components second];
	
	
	[gregorian release];
	return rv;
	
}

- (NSDate*) GetDateFromInteger:(int) secondsElapsed
{
	
	NSDate * date = [NSDate date];
	int nowSeconds = [self GetTimeElapsedForTheday:date];
	secondsElapsed = secondsElapsed - nowSeconds;
	NSDate *returnDate = [[NSDate alloc] initWithTimeInterval:secondsElapsed sinceDate:date];
	return returnDate;
	
}

- (void) ObserveManualModeOn:(NSNotification*)notification
{
	NSDate * date = [[NSDate alloc] initWithTimeIntervalSinceNow:(3*60*60)];
	[basedict SetValue:dateTag value:date];
    
	[BaseDictionary PostInterProcessNotification:NotificaitonManualModeSwitchedByUIOn];
	[myTableView reloadData];
	//[self SendNotification];
	
	//cell.text = [NSString stringWithFormat:@"%@     %@",title,[self getTimeString]];
	//TODO fix doesnt show up immediately
}

@end