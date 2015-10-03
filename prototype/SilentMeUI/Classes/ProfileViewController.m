//
//  ProfileViewController.m
//  SilentMe
//
//  Created by god on 11/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ProfileViewController.h"
#import "Constants.h"

static NSString* const DoneLabel = @"Done";
static NSString* const DeleteLabel = @"Delete";
static NSString* const CannotDeleteMessage = @"Cannot delete the profile, at least one schedule is using it";
static NSString* const CannotDeleteTitle = @"Delete Alert";
static NSString* const SaveAlertTitle = @"Save Alert";
static NSString* const NewProfileTitle = @"New Profile";
static NSString* const SaveAlertMessage = @"Cannot save profile with empty name";
static NSString* const SaveAlertDuplicateMessage = @"A profile with same name already exist, please provide another name";

@implementation ProfileViewController

-(ProfileViewController*) initWithProfile:(Profile*)prof
{
	self = [super initWithDataSource:[prof ViewDataSource] title:[prof Name]];
	
	profile = prof;
		
	return self;
}

- (void)loadView
{
    [super loadView];
	
	if ( profile!= nil && [profile IsNotCommited])
	{
		UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]
										initWithTitle:NSLocalizedString(DoneLabel,@"")
										style:UIBarButtonItemStyleDone
										target:self
										action:@selector(SaveProfile)];
		
		self.navigationItem.rightBarButtonItem = doneButton;
		[doneButton release];
	}
	
	if (profile!= nil && ![profile IsNotCommited] && [profile GetProfileId] != SilentProfileId)
	{
		UIBarButtonItem * deleteButton = [[UIBarButtonItem alloc]
										  initWithTitle:NSLocalizedString(DeleteLabel,@"")
										  style:UIBarButtonItemStyleDone
										  target:self
										  action:@selector(DeleteProfile)];
		
		self.navigationItem.rightBarButtonItem = deleteButton;
		[deleteButton release];
	}
}

-(void) SaveProfile
{
	if ([profile Name] == nil || [[profile Name] length] == 0)
	{
		UIAlertView *baseAlert = [[[UIAlertView alloc]
								   initWithTitle:NSLocalizedString(SaveAlertTitle,@"")
								   message:NSLocalizedString(SaveAlertMessage,@"")
								   delegate:nil cancelButtonTitle:@"OK"
								   otherButtonTitles:nil] autorelease];
		// [baseAlert setNumberOfRows:3];
		[baseAlert show];
		return;
	}
	
	if ( [Profile IsNameDuplicate:[profile Name]])
	{
		UIAlertView *baseAlert = [[[UIAlertView alloc]
								   initWithTitle:NSLocalizedString(SaveAlertTitle,@"")
								   message:NSLocalizedString(SaveAlertMessage,@"")
								   delegate:nil cancelButtonTitle:@"OK"
								   otherButtonTitles:nil] autorelease];
		// [baseAlert setNumberOfRows:3];
		[baseAlert show];
		return;
	}
	
	[Profile SaveProfile:profile];
	[[self navigationController] popViewControllerAnimated:YES];
}

-(void) DeleteProfile
{
	if ([profile CanBeDeleted])
	{	
	[Profile DeleteProfile:profile];
	[[self navigationController] popViewControllerAnimated:YES];
	}
	else
	{
		UIAlertView *baseAlert = [[[UIAlertView alloc]
								   initWithTitle:NSLocalizedString(CannotDeleteTitle,@"")
								   message:NSLocalizedString(CannotDeleteMessage,@"")
								   delegate:nil cancelButtonTitle:@"OK"
								   otherButtonTitles:nil] autorelease];
		// [baseAlert setNumberOfRows:3];
		[baseAlert show];
	}
}

- (void)viewWillAppear:(BOOL)animated
{
	[self.tableView reloadData];
	self.title = [profile Name];
	if (self.title == nil || [self.title length] == 0)
	{
		self.title = NSLocalizedString(NewProfileTitle,@"");
	}
	[super viewWillAppear:animated];
}

@end
