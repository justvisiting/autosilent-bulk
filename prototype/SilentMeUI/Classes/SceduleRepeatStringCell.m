//
//  SceduleRepeatStringCell.m
//  SilentMe
//
//  Created by god on 11/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SceduleRepeatStringCell.h"
#import "RepeatListController.h"

static NSString * const RepeatLabel = @"Repeats :";
static NSString * const None = @"None";

@implementation SceduleRepeatStringCell
- (void)cellSelected:(UITableViewController *) currentController
{
	//if (nextViewControllerClassName)
	//{
	RepeatListController* baseContrl = (RepeatListController*)[ RepeatListController alloc];
	
	baseContrl = [baseContrl initWithSchedule:schedule];
	
	[[currentController navigationController] pushViewController:baseContrl animated:YES];
	//}
}

-(NSString*) GetName
{
	if (schedule != nil)
	{
		return [schedule RepeatString];
	}
	else
	{
		return NSLocalizedString(None,@"");
	}
}
-(NSString*) GetNameLabel
{
	return NSLocalizedString(RepeatLabel,@"");
}
@end
