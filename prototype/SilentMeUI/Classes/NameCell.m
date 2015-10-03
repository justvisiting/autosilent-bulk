//
//  NameCell.m
//  SilentMe
//
//  Created by god on 11/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NameCell.h"
#import "ProfileListController.h"

static NSString * const None = @"None";
static NSString * const ProfileLabel = @"Profile :";

@implementation NameCell
- (NameCell*) initWithSchedule: (Schedule *) sched nextControllerName: (NSString*)controllerClassName nextDataSource:(NSMutableArray*)nextDs
{
	self = [super init];
	
    if ( self ) {
		cellIdentifier = @"NameCell";
		nextViewControllerClassName =  controllerClassName ;
		nextDataSource = nextDs;
		schedule = sched;
    }
	
    return self;
}

- (UITableViewCell *) getTableViewCell:(UITableView *) tableView
{
	UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (!cell) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:cellIdentifier] autorelease];
	}
	cell.text = [NSString stringWithFormat:@"%@     %@",[self GetNameLabel],[self GetName]];
	
	//if(nextViewControllerClassName != nil)
	{
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.hidesAccessoryWhenEditing = YES;
	}
	return cell;
}

- (void)cellSelected:(UITableViewController *) currentController
{
	//if (nextViewControllerClassName)
	//{
		ProfileListController* baseContrl = (ProfileListController*)[ ProfileListController alloc];

		baseContrl = [baseContrl initWithSchedule:schedule];
		
		[[currentController navigationController] pushViewController:baseContrl animated:YES];
	//}
}

-(NSString*) GetName
{
	if ([schedule Profile] != nil)
	{
		return [[schedule Profile] Name];
	}
	else
	{
		return NSLocalizedString(None,@"");
	}
}
-(NSString*) GetNameLabel
{
	return NSLocalizedString(ProfileLabel,@"");
}

@end
