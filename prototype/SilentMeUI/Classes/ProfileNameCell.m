//
//  ProfileNameCell.m
//  SilentMe
//
//  Created by god on 11/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ProfileNameCell.h"
#import "TextFieldController.h"
#import "Section.h"
#import "TextFieldCell.h"

static NSString * const NameLabel = @"Name";
static NSString * const None = @"None";

@implementation ProfileNameCell
- (NameCell*) initWithProfile: (Profile *) prof nextControllerName: (NSString*)controllerClassName nextDataSource:(NSMutableArray*)nextDs
{
	self = [super init];
	
    if ( self ) {
		cellIdentifier = @"ProfileNameCell";
		nextViewControllerClassName =  controllerClassName ;
		nextDataSource = nextDs;
		profileforName = prof;
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
	TextFieldController* baseContrl = (TextFieldController*)[ TextFieldController alloc];
	NSMutableArray * viewDataSource = [[NSMutableArray alloc] init];
	Section* nameSec = [[Section alloc] initWithHeader:@""];
	TextFieldCell * nameCell = [[TextFieldCell alloc] initWithTitle:[self GetName] Profile:profileforName];
	[nameSec addCell:nameCell];
	[viewDataSource addObject:nameSec]; 
	baseContrl = [baseContrl initWithDataSource:viewDataSource title:[self GetName] textField:nameCell];
	
	[[currentController navigationController] pushViewController:baseContrl animated:YES];
	//}
}

-(NSString*) GetName
{
	if (profileforName != nil)
	{
		return [profileforName Name];
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
