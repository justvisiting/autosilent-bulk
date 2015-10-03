//
//  ScheduleNameCell.m
//  SilentMe
//
//  Created by god on 11/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ScheduleNameCell.h"
#import "Schedule.h"
#import "BaseController.h"
#import "Section.h"
#import "TextFieldCell.h"
#import "TextFieldController.h"

static NSString * const NameLabel = @"Name";
static NSString * const None = @"None";

@implementation ScheduleNameCell
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
	TextFieldController* baseContrl = (TextFieldController*)[ TextFieldController alloc];
	NSMutableArray * viewDataSource = [[NSMutableArray alloc] init];
	Section* nameSec = [[Section alloc] initWithHeader:@""];
	TextFieldCell * nameCell = [[TextFieldCell alloc] initWithTitle:[self GetName] Schedule:schedule];
	[nameSec addCell:nameCell];
	[viewDataSource addObject:nameSec]; 
	baseContrl = [baseContrl initWithDataSource:viewDataSource title:[self GetName] textField:nameCell];
	
	[[currentController navigationController] pushViewController:baseContrl animated:YES];
	//}
}

-(NSString*) GetName
{
	if (schedule != nil)
	{
		return [schedule Name];
	}
	else
	{
		return NSLocalizedString(None,@"");
	}
}
-(NSString*) GetNameLabel
{
	return NSLocalizedString(NameLabel,@"");
}
@end
