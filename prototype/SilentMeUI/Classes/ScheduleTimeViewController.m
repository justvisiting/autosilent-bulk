#import "ScheduleTimeViewController.h"
#import "SingletonDataSources.h"
#import "Section.h"
#import "BaseCell.h"
#import "Schedule.h"

@implementation ScheduleTimeViewController


- (ScheduleTimeViewController *) init
{
	if (self = (ScheduleTimeViewController*)[super init])
	{
		self.title = nil;
	}
	[self initWithStyle:UITableViewStyleGrouped];
	return self;
}

- (ScheduleTimeViewController *) initWithDataSource:(NSMutableArray*)ds title:(NSString*) scheduleName
{
	if (self = (ScheduleTimeViewController*)[super init])
	{
		self.title = scheduleName;
		dataSource = ds;
	}
	[self initWithStyle:UITableViewStyleGrouped];
	return self;
}

#pragma mark UITableViewDelegateMethods

// Respond to user selection
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)newIndexPath
{
	NSInteger row = [newIndexPath row];
    NSInteger section = [newIndexPath section];
	
	Section * sec = (Section *) [dataSource objectAtIndex:section];
	
	NSDate* date = [[sec cellAtIndex:row] getTime] ;
	if (date != nil)
	{
		[pickerView setDate:date animated:YES];

	}
	else
	{
		[super tableView:tableView didSelectRowAtIndexPath:newIndexPath];
	}
}

#pragma mark Controller's loadView method
- (void)loadView
{
    //[super loadView];
	
	//return;
	
	self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.view.backgroundColor = [UIColor lightGrayColor];
	
    float height = 216.0f;	
	CGRect frame = CGRectMake(0.0f, 0.0f, 320.0f, height);
    tableViewImp = [[UITableView alloc] initWithFrame:frame style: UITableViewStyleGrouped];
    [tableViewImp setDelegate:self];
    [tableViewImp setDataSource:self];
    [self.view addSubview:tableViewImp];
	
	 height = 216.0f;
	
	 pickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0f, 416.0f - height, 320.0f, height)];
	[pickerView setDatePickerMode:UIDatePickerModeTime];
	pickerView.minuteInterval = 5;
	[pickerView addTarget:self action:@selector(setTime:) forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:pickerView];
	
	//[tableViewImp selectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
	//[self tableView:tableViewImp didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] ];
	
}


-(void) setTime:(UIDatePicker*)picker
{
	NSIndexPath* selectedIndexPath =  [tableViewImp indexPathForSelectedRow];
	
	if ( selectedIndexPath != nil)
	{
		UITableViewCell *uiCell = [tableViewImp cellForRowAtIndexPath:selectedIndexPath];
		
		NSInteger row = [selectedIndexPath row];
		NSInteger section = [selectedIndexPath section];
		
		Section * sec = (Section *) [dataSource objectAtIndex:section];
		
		[[sec cellAtIndex:row] setTime:picker cell:uiCell];
		
	}
}

- (void)viewWillAppear:(BOOL)animated
{
	[tableViewImp reloadData];
	[super viewWillAppear:animated];
}

-(void)viewDidLoad
{
	[super viewDidLoad];
	
	[tableViewImp selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:0];
	[self tableView:tableViewImp didSelectRowAtIndexPath: [NSIndexPath indexPathForRow:0 inSection:0]];
}

-(void) dealloc
{
    [super dealloc];
}

@end