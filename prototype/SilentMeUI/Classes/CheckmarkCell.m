//
//  CheckmarkCell.m
//  SilentMe
//
//  Created by god on 12/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CheckmarkCell.h"

#import "Model.h"

@implementation CheckmarkCell


- (CheckmarkCell*) initWithTitle: (NSString *) t boolTag:(NSString *) tag  dict:(BaseDictionary*) dict
{
	return (CheckmarkCell*)[self initWithTitle:t nextControllerName:nil nextDataSource:nil boolTag:tag dict:dict];
}


- (CheckmarkCell*) initWithTitle: (NSString *) t nextControllerName: (NSString*)controllerClassName
			  nextDataSource:(NSMutableArray*)nextDs boolTag:(NSString *) tag  dict:(BaseDictionary*) dict
{
	self = [super init];
	
    if ( self ) {
        title = t;
		cellIdentifier = @"CheckMarkCell";
		nextViewControllerClassName =  controllerClassName ;
		nextDataSource = nextDs;
		intTag = nil;
		boolTag = tag;
		basedict = dict;
    }
    return self;
}

- (UITableViewCell *) getTableViewCell:(UITableView *) tableView
{
	 cell = nil;//[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if (!cell) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:cellIdentifier] autorelease];
		//cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	cell.text = title;
	
	[self updateCheckmark];
    // Set up the cell
	cell.font = [UIFont boldSystemFontOfSize:14];
	if(nextViewControllerClassName != nil)
	{
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.hidesAccessoryWhenEditing = YES;
	}
	return cell;	
}

- (void)cellSelected:(UITableViewController *) currentController
{
	[self switchMe];
}

- (void) switchMe
{
	bool value = [basedict GetBoolValue:boolTag];
	
	if(value)
	{
		[basedict SetBoolValue:boolTag value:NO];
	}
	else
	{
		[basedict SetBoolValue:boolTag value:YES];
	}
	[self updateCheckmark];
}

- (void) updateCheckmark{

	bool value = [basedict GetBoolValue:boolTag];

	if(value)
	{
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
	else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}

	
}

@end
