//
//  ProfileAddController.m
//  SilentMe
//
//  Created by god on 11/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ProfileAddController.h"
#import "Profile.h"
#import "ProfileViewController.h"

@implementation ProfileAddController

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

	dataSource = nil;
	[Profile DeleteProfileDataSource];
	dataSource = [Profile GetProfileDataSource];
	
	[self.tableView reloadData];
	[super viewWillAppear:animated];
}

@end
