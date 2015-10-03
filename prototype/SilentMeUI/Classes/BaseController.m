#import "BaseController.h"
#import "Section.h"
#import "BaseCell.h"

@implementation BaseController

- (BaseController *) init
{
	self = [super init];
	return self;
}

- (BaseController *) initWithDataSource:(NSMutableArray *) ds title:(NSString*)scheduleName
{
	if (self = [super init])
		self.title = scheduleName;
	
	dataSource = ds;
	[self initWithStyle:UITableViewStyleGrouped];
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
	[[sec cellAtIndex:row] cellSelected:self];
}

- (void)loadView
{
    [super loadView];
}

- (void)viewWillAppear:(BOOL)animated
{
	[self.tableView reloadData];
	[super viewWillAppear:animated];
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

@end