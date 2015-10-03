#import "ManualTimeSetterController.h"
#import "SingletonDataSources.h"
#import "Section.h"
#import "BaseCell.h"
#import "Model.h"
#import "Constants.h"

static NSString* const ManualTableTitle = @"Manual Settings";
static const int tableViewTag = 999;

@implementation ManualTimeSetterController

- (ManualTimeSetterController *) initWithDataSource:(NSMutableArray*)ds title:(NSString*) scheduleName
{
	if (self = (ManualTimeSetterController *)[super init])
	{
		self.title = NSLocalizedString(ManualTableTitle, @"");
		dataSource =  ds;
	}
	[self initWithStyle:UITableViewStyleGrouped];
	origEnabled =  [[Model GetModel] GetBoolValue:ManualMode];
	originalSeconds = [ (NSDate*)[[Model GetModel] GetValue:ManualEndTime] timeIntervalSince1970];

	return self;
}

- (ManualTimeSetterController *) init
{
	if (self = (ManualTimeSetterController *)[super init])
	{
		self.title = NSLocalizedString(ManualTableTitle, @"");
		dataSource = GetManualTimeSetterDataSource();
	}
	[self initWithStyle:UITableViewStyleGrouped];
	origEnabled =  [[Model GetModel] GetBoolValueFromDaemon:ManualMode];
	originalSeconds = [ (NSDate*)[[Model GetModel] GetValueFromDaemon:ManualEndTime] timeIntervalSince1970];
	return self;
}

#pragma mark UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [dataSource count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	Section * sec = (Section *) [dataSource objectAtIndex:section];
	return [sec cellCount];
}

// Return a cell for the specified index path
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSInteger row = [indexPath row];
    NSInteger section = [indexPath section];
	
	Section * sec = (Section *) [dataSource objectAtIndex:section];
	
	UITableViewCell *tableCell = [[sec cellAtIndex:row] getTableViewCell:tableView];
	
	return tableCell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    Section * sec = (Section *) [dataSource objectAtIndex:section];
	return [sec header];
}

#pragma mark UITableViewDelegateMethods

// Respond to user selection
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)newIndexPath
{
	NSInteger row = [newIndexPath row];
    NSInteger section = [newIndexPath section];
	
	Section * sec = (Section *) [dataSource objectAtIndex:section];
	[pickerView setDate:[[sec cellAtIndex:row] getTime] ];

}

-(void) setTime:(UIDatePicker*)picker
{
	UITableView * tableView = (UITableView *)[self.view viewWithTag:tableViewTag];
	NSIndexPath* selectedIndexPath =  [tableView indexPathForSelectedRow];

	if ( selectedIndexPath != nil)
	{
		UITableViewCell *uiCell = [tableView cellForRowAtIndexPath:selectedIndexPath];
		
		NSInteger row = [selectedIndexPath row];
		NSInteger section = [selectedIndexPath section];
		
		Section * sec = (Section *) [dataSource objectAtIndex:section];
		
		[[sec cellAtIndex:row] setTime:picker cell:uiCell];
		
	}
}

#pragma mark Controller's loadView method
- (void)loadView
{
    //[super loadView];
	
	//return;
	
	self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.view.backgroundColor = [UIColor lightGrayColor];

    float height = 432.0f;	
	CGRect frame = CGRectMake(0.0f, 0.0f, 320.0f, height);
    UITableView * tableView = [[UITableView alloc] initWithFrame:frame style: UITableViewStyleGrouped];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
	[tableView setTag:tableViewTag];
    [self.view addSubview:tableView];
    [tableView release];
	
	height = 216.0f;
	
	pickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0f, 416.0f - height, 320.0f, height)];
	[pickerView setDatePickerMode:UIDatePickerModeDateAndTime];
	//[pickerView setDate:[[sec cellAtIndex:row] getTime] ];
	pickerView.minuteInterval = 5;
	[pickerView addTarget:self action:@selector(setTime:) forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:pickerView];
}

- (void)viewWillDisappear:(BOOL)animated
{
	int currEnabled =  [[Model GetModel] GetBoolValue:ManualMode];
	NSTimeInterval currSeconds = [ (NSDate*)[[Model GetModel] GetValue:ManualEndTime] timeIntervalSince1970];
    
	if ( origEnabled != currEnabled || currSeconds != originalSeconds )
	{
		if (currEnabled)
		{
			[BaseDictionary PostInterProcessNotification:NotificaitonManualModeSwitchedByUIOn];
		}
		else
		{
			[BaseDictionary PostInterProcessNotification:NotificaitonManualModeSwitchedByUIOff];
		}
	}
}

-(void)viewDidLoad
{
	[super viewDidLoad];
	
	UITableView* table = (UITableView*)[self.view viewWithTag:tableViewTag];
	[table selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:0];
	[self tableView:table didSelectRowAtIndexPath: [NSIndexPath indexPathForRow:0 inSection:0]];
}

-(void) dealloc
{
    [super dealloc];
}

@end
