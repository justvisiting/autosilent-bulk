#import "MainTableController.h"
#import "Section.h"
#import "BaseCell.h"
#import "ActivationHelper.h"
#import "MultipleTimeCell.h"
#import "Schedule.h"
#import "Constants.h"

static NSString *const MainTableTitle = @"Auto Silent";
@implementation MainTableController

- (MainTableController *) init
{
	if (self = [super init]) self.title = NSLocalizedString(MainTableTitle, @"");
	return self;
}

- (MainTableController *) initWithDataSource:(NSMutableArray *) ds
{
	if (self = [super init])
	{
		self.title = NSLocalizedString(MainTableTitle, @"");
		dataSource = ds;
	}
	[self initWithStyle:UITableViewStyleGrouped];
	[[NSNotificationCenter defaultCenter] 
		addObserver:self 
		selector:@selector(ObserveAutomaticValueChangeNotification:)
		name:AutomaticValueChangedNotification object:nil];
	[self ObserveAutomaticValueChangeNotification:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ObserveActiveScheduleChanged:) name:NotificaitonActiveScheduleChanged object:nil];
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

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	NSInteger row = [indexPath row];
    NSInteger section = [indexPath section];
	Section * sec = (Section *) [dataSource objectAtIndex:section];
	[[sec cellAtIndex:row] accessoryButtonTapped:self];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    Section * sec = (Section *) [dataSource objectAtIndex:section];
	return [sec header];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSInteger row = [indexPath row];
    NSInteger section = [indexPath section];
	Section * sec = (Section *) [dataSource objectAtIndex:section];
	
	CGFloat returnValue = [[sec cellAtIndex:row] getHeight];
	
	if (returnValue == 0.0f)
	{
		return 40.0f;
	}
	
	return returnValue;
	
}

#pragma mark UITableViewDelegateMethods

// Respond to user selection
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)newIndexPath
{
	
	NSInteger row = [newIndexPath row];
    NSInteger section = [newIndexPath section];
	Section * sec = (Section *) [dataSource objectAtIndex:section];
	[[sec cellAtIndex:row] cellSelected:self];
	
    //printf("User selected row %d\n", [newIndexPath row] + 1);
    //NSString *fontName = [[UIFont familyNames] objectAtIndex:[newIndexPath row]];
    //CFShow([UIFont fontNamesForFamilyName:fontName]);
    //[(UILabel *)self.navigationItem.titleView setFont:[UIFont fontWithName: fontName size:[UIFont systemFontSize]]];
}

#pragma mark Controller's loadView method
- (void)loadView
{
	[Model GetModel];
    [super loadView];
	
    // Add the custom title bar label
   // self.navigationItem.titleView = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 4.0f, 320.0f, 36.0f)];
    //[(UILabel *)self.navigationItem.titleView setText:@"Font Families"];
    //[(UILabel *)self.navigationItem.titleView setBackgroundColor:[UIColor clearColor]];
    //[(UILabel *)self.navigationItem.titleView setTextColor:[UIColor whiteColor]];
    //[(UILabel *)self.navigationItem.titleView setTextAlignment:UITextAlignmentCenter];
    //[(UILabel *)self.navigationItem.titleView setFont:[UIFont boldSystemFontOfSize:[UIFont systemFontSize]]];
}

-(void) viewDidLoad
{
	//TODO: FIX memory leak
	ActivationHelper * activationHelper = [[ActivationHelper alloc] initWithView:self.tableView controller:self];
	[activationHelper ActivateApp];
}

- (void)viewWillAppear:(BOOL)animated
{
	if ([[Model GetModel] GetBoolValue:AutomaticEnabledKey])
	{
		[self AddSchedules];
	}
	else
	{
		[self RemoveSchedules];
	}
	[self.tableView reloadData];
	[super viewWillAppear:animated];
}

-(void) dealloc
{
    [super dealloc];
}

-(void) RemoveSchedules
{
	Section * autoSection = (Section*)[dataSource objectAtIndex:2];
	
	if ([autoSection cellCount] == 2 )
		return;
	
	int i;
	NSMutableArray * array = [NSMutableArray array];
	for (i=2; i < [autoSection cellCount] ;i++)
	{
		[array addObject:[autoSection cellAtIndex:i]];
	}
	[autoSection removeObjectsInArray:array];
}

-(void) AddSchedules
{
	int i;
		
	[self RemoveSchedules];
	
	Section * autoSection = (Section*)[dataSource objectAtIndex:2];

	if ([autoSection cellCount] > 2 )
		return;
	
	for (i=0; i< [[Schedule CellsForSchedule] count]; i++) {
		MultipleTimeCell * cell = (MultipleTimeCell*) [[Schedule CellsForSchedule] objectAtIndex:i];
		[autoSection addCell:cell];
	}
}

- (void) ObserveAutomaticValueChangeNotification:(NSNotification*)notification
{
	if ([[Model GetModel] GetBoolValue:AutomaticEnabledKey])
	{
		[self AddSchedules];
	}
	else
	{
		[self RemoveSchedules];
	}
	[self.tableView reloadData];
}

-(void) ObserveActiveScheduleChanged:(NSNotification*)notification
{
		[self.tableView reloadData];
}
@end
