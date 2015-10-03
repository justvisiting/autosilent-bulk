//
//  ManualProfileCell.m
//  SilentMe
//
//  Created by god on 12/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ManualProfileCell.h"
#import "ProfileListController.h"
#import "ManualSchedule.h"
#import "Constants.h"

static NSString * const SetProfile = @"Profile :";

@implementation ManualProfileCell
- (ManualProfileCell*) init
{
	self = [super init];
	
    if ( self ) {
		cellIdentifier = @"ManualProfileCell";
		nextViewControllerClassName =  nil ;
		nextDataSource = nil;
		schedule = [ManualSchedule Schedule];
    }
	
    return self;
}

- (void)cellSelected:(UITableViewController *) currentController
{
	//if (nextViewControllerClassName)
	//{
	ProfileListController* baseContrl = (ProfileListController*)[ ProfileListController alloc];
	
	baseContrl = [baseContrl initForManualScedule];
	
	[[currentController navigationController] pushViewController:baseContrl animated:YES];
	//}
}

-(NSString*) GetName
{
	if ([schedule Profile] != nil && [[schedule Profile] GetProfileId] != DefaultProfileId)
	{
		return [[schedule Profile] Name];
	}
	else
	{
		return @"Silent";
	}
}
-(NSString*) GetNameLabel
{
	return NSLocalizedString(SetProfile,@"");
}

@end
