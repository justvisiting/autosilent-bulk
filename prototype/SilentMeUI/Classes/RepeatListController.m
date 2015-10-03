//
//  RepeatListController.m
//  SilentMe
//
//  Created by god on 11/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "RepeatListController.h"

static NSString * const RepeatTitle = @"Select Repeat Days";
static NSString * const DoneLabel = @"Done";
@implementation RepeatListController

- (RepeatListController *) init
{
	self = [super init];
	return self;
}

- (RepeatListController *) initWithSchedule:(Schedule *) sched
{
	if (self = [super init])
		self.title = NSLocalizedString(RepeatTitle, @"");
	
	schedule = sched;
	
	dataSource = [[NSArray arrayWithObjects: NSLocalizedString(@"Sunday",@""),
						NSLocalizedString(@"Monday",@""), 
						NSLocalizedString(@"Tuesday",@""), 
						NSLocalizedString(@"Wednesday",@""),
						NSLocalizedString(@"Thursday",@""),
						NSLocalizedString(@"Friday",@""),
						NSLocalizedString(@"Saturday",@""), nil] retain];
	userSelectedDays = [[NSMutableArray alloc] initWithCapacity:7];
	
	[self initWithStyle:UITableViewStylePlain];
	return self;
}

#pragma mark UITableViewDataSource Methods

// Return a cell for the specified index path
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSInteger row = [indexPath row];
    //NSInteger section = [indexPath section];
	
	NSString * day = (NSString *) [dataSource objectAtIndex:row];
	
	UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileCheckMarkCell"];
	if (!cell) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"ProfileCheckMarkCell"] autorelease];
	}
	cell.text = day;
	
	if( [schedule IsDayApplicable:row+1])
	{
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		cell.hidesAccessoryWhenEditing = YES;
		oldIndexPath = indexPath;
		[self addDay:row+1];
	}
	
	
	return cell;
	
	//UITableViewCell *tableCell = [[sec cellAtIndex:row] getTableViewCell:tableView];
	
}

-(void) addDay:(NSInteger) day
{
	int i = 0;
	
	for(i =0; i < [userSelectedDays count] ; i++)
	{
		int currDay = [(NSNumber*)[userSelectedDays objectAtIndex:i] intValue];
		if (  currDay == day )
			return;
		if ( currDay > day)
			break;
	}
	
	if ( i < [userSelectedDays count] )
		[userSelectedDays insertObject:[NSNumber numberWithInt:day] atIndex:i];
	else
		[userSelectedDays addObject:[NSNumber numberWithInt:day]];
		
}
-(void) removeDay:(NSInteger) day
{
	int i = 0;
	
	for(i =0; i < [userSelectedDays count] ; i++)
	{
		int currDay = [(NSNumber*)[userSelectedDays objectAtIndex:i] intValue];
		if (  currDay == day )
		{
			[userSelectedDays removeObjectAtIndex:i];
			return;
		}
	}
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

	if ( [[tableView cellForRowAtIndexPath:newIndexPath] accessoryType] == UITableViewCellAccessoryCheckmark)
	{
		[tableView cellForRowAtIndexPath:newIndexPath].accessoryType = UITableViewCellAccessoryNone;
		
		[self removeDay:row+1];
	}
	else
	{
		[tableView cellForRowAtIndexPath:newIndexPath].accessoryType = UITableViewCellAccessoryCheckmark;
		[self addDay:row+1];
	}
	//[schedule SetRepeatArray:userSelectedDays];
}

- (void)loadView
{
    [super loadView];
	
	UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]
									initWithTitle:NSLocalizedString(DoneLabel,@"")
									style:UIBarButtonItemStyleDone
									target:self
									action:@selector(RepeatListDone)];
	
	self.navigationItem.rightBarButtonItem = doneButton;
	[doneButton release];
}

-(void) RepeatListDone
{
	[schedule SetRepeatArray:userSelectedDays];
	[[self navigationController] popViewControllerAnimated:YES];
}

@end