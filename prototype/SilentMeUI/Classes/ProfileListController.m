//
//  ProfileListController.m
//  SilentMe
//
//  Created by god on 11/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ProfileListController.h"
#import "Profile.h"
#import "ProfileViewController.h"
#import "ManualSchedule.h"

static NSString * const ProfileSelectTitle = @"Select Profile";

@implementation ProfileListController

- (ProfileListController *) init
{
	self = [super init];
	return self;
}

- (ProfileListController *) initWithSchedule:(Schedule *) sched
{
	if (self = [super init])
		self.title = NSLocalizedString(ProfileSelectTitle, @"");
	
	schedule = sched;
	
	dataSource = [Profile GetProfileArray];
	[self initWithStyle:UITableViewStylePlain];
	return self;
}

- (ProfileListController *) initForManualScedule
{
	if (self = [super init])
		self.title = NSLocalizedString(ProfileSelectTitle, @"");
	
	schedule = [ManualSchedule Schedule];
	
	dataSource = [Profile GetProfileArray];
	//[dataSource insertObject:[Profile GetDefaultProfile] atIndex:0];
	[self initWithStyle:UITableViewStylePlain];
	return self;
}

#pragma mark UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1; //[dataSource count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [dataSource count];
}

// Return a cell for the specified index path
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSInteger row = [indexPath row];
    //NSInteger section = [indexPath section];
	
	Profile * prof = (Profile *) [dataSource objectAtIndex:row];
	
	UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileCheckMarkCell"];
	if (!cell) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"ProfileCheckMarkCell"] autorelease];
	}
	cell.text = [prof Name];
	cell.accessoryType = UITableViewCellAccessoryNone;
	
	if( [schedule Profile] == prof)
	{
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		cell.hidesAccessoryWhenEditing = YES;
		oldIndexPath = indexPath;
	}


	return cell;
	
	//UITableViewCell *tableCell = [[sec cellAtIndex:row] getTableViewCell:tableView];
	
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return @"";
}
#pragma mark UITableViewDelegateMethods

// Respond to user selection
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)newIndexPath
{
	NSInteger row = [newIndexPath row];
	
	Profile * prof = (Profile *) [dataSource objectAtIndex:row];
	if ( [[tableView cellForRowAtIndexPath:newIndexPath] accessoryType] != UITableViewCellAccessoryCheckmark)
	{
		[tableView cellForRowAtIndexPath:oldIndexPath].accessoryType = UITableViewCellAccessoryNone;
		[tableView cellForRowAtIndexPath:newIndexPath].accessoryType = UITableViewCellAccessoryCheckmark;
		[schedule SetProfile:prof];
	}
	oldIndexPath = newIndexPath;
	
}

- (void)loadView
{
    [super loadView];
	UIBarButtonItem * addProfile = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
																				 target:self
																				 action:@selector(CreateProfile)];
	self.navigationItem.rightBarButtonItem = addProfile;
}

-(void) CreateProfile
{
	Profile* newProfile = [Profile CreateNewProfile];
	ProfileViewController* baseContrl = (ProfileViewController*)[ProfileViewController alloc];
	
	baseContrl = [baseContrl initWithProfile:newProfile];
	
	[[self navigationController] pushViewController:baseContrl animated:YES];
	//[[self navigationController] pushViewController:<#(UIViewController *)viewController#> animated:<#(BOOL)animated#>
}

- (void)viewWillAppear:(BOOL)animated
{
	[self.tableView reloadData];
	[super viewWillAppear:animated];
}
@end
