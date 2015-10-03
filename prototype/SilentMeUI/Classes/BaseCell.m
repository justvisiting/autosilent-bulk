#import "BaseCell.h"
#import "BaseController.h"
#import "Schedule.h"
#import "Profile.h"
#import "ProfileViewController.h"
#import "ScheduleViewController.h"

@implementation BaseCell
- (BaseCell*) initWithTitle: (NSString *) t
{
	return [self initWithTitle:t nextControllerName:nil nextDataSource:nil];
}

- (BaseCell*) initSmallFontWithTitle: (NSString *) t;
{
	self = [self initWithTitle:t nextControllerName:nil nextDataSource:nil];
	smallfont = YES;
	return self;
}

- (BaseCell*) initWithTitle: (NSString *) t nextControllerName: (NSString*)controllerClassName nextDataSource:(NSMutableArray*)nextDs
{
	self = [super init];
	
    if ( self ) {
        title = t;
		cellIdentifier = @"BasicCell";
		nextViewControllerClassName =  controllerClassName ;
		nextDataSource = nextDs;
		CreateSchedule = NO;
		profile = nil;
    }
	
    return self;
}

- (BaseCell*) initWithTitle: (NSString *) t nextControllerName: (NSString*)controllerClassName nextDataSource:(NSMutableArray*)nextDs CreateSchedule:(bool)ScheduleCreate
{
	self = [super init];
	
    if ( self ) {
        title = t;
		cellIdentifier = @"BasicCell";
		nextViewControllerClassName =  controllerClassName ;
		nextDataSource = nextDs;
		CreateSchedule = ScheduleCreate;
		profile = nil;
    }
	
    return self;
}

- (BaseCell*) initWithTitle:(NSString *)t Profile:(Profile*)prof
{
	self = [super init];
	
    if ( self ) {
        title = t;
		cellIdentifier = @"BasicCell";
		nextViewControllerClassName =  @"ProfileViewController" ;
		profile = prof;
		nextDataSource = [profile ViewDataSource];
		CreateSchedule = NO;
		profile = prof;
    }
	return self;
}

- (UITableViewCell *) getTableViewCell:(UITableView *) tableView
{
	UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (!cell) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:cellIdentifier] autorelease];
	}
	cell.text = title;
	//cell.lineBreakMode = UILineBreakModeWordWrap;
	if (smallfont)
	cell.font = [UIFont boldSystemFontOfSize:14];
	if(nextViewControllerClassName != nil)
	{
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.hidesAccessoryWhenEditing = YES;
	}
	return cell;
}

- (void) accessoryButtonTapped:(UITableViewController *) currentController
{
	if (nextViewControllerClassName)
	{
		[[currentController navigationController] pushViewController: (UIViewController*)[[NSClassFromString(nextViewControllerClassName) alloc] init] 
														animated:YES];
	}
}

- (void)cellSelected:(UITableViewController *) currentController
{
	if (CreateSchedule)
	{
		Schedule* newSchedule = [Schedule CreateNewSchedule];
		nextDataSource = [newSchedule ViewDataSource];
		ScheduleViewController * baseContrller = [[ScheduleViewController alloc] initWithSchedule:newSchedule];
		[[currentController navigationController] pushViewController:baseContrller animated:YES];
		return;
	}
	
	if (profile!=nil)
	{
		ProfileViewController* baseContrl = [ProfileViewController alloc];
		
		baseContrl = [baseContrl initWithProfile:(Profile*)profile];
		
		[[currentController navigationController] pushViewController:baseContrl animated:YES];
		return;
	}
	
	if (nextViewControllerClassName)
	{
		BaseController* baseContrl = (BaseController*)[NSClassFromString(nextViewControllerClassName) alloc];

		baseContrl = [baseContrl initWithDataSource:nextDataSource title:title];

		[[currentController navigationController] pushViewController:baseContrl animated:YES];
	}
}


- (NSDate *) getTime
{
	return nil;
}

-(int) getTimeInSeconds
{
	return -1;
}

- (void) switchMe: (UIControl *) sender
{
	
}

- (void) setAuxString:(NSString*) auxString
{
}

-(void) setTime:(UIDatePicker*)datePicker cell:(UITableViewCell*)uicell
{
}

-(int) getIntValue
{
	return -1;
}

-(bool) getBoolValue
{
	return NO;
}

-(CGFloat) getHeight
{
	return 0.0f;
}
@end