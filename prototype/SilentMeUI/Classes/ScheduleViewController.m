//
//  ScheduleViewController.m
//  SilentMe
//
//  Created by god on 11/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ScheduleViewController.h"
#import "Schedule.h"


static NSString* const DoneLabel = @"Done";
static NSString* const DeleteLabel = @"Delete";
static NSString* const NewScheduleTitle = @"New Schedule";
static NSString* const EmptyNameScheduleMessage = @"Cannot save schedule with empty name";

@implementation ScheduleViewController
-(ScheduleViewController*) initWithSchedule:(Schedule*)sched
{
	self = [super initWithDataSource:[sched ViewDataSource] title:[sched Name]];
	
	schedule  = sched;
	return self;
}

- (void)loadView
{
    [super loadView];
	
	if ( schedule!= nil && [schedule IsNotCommited])
	{
		UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]
										initWithTitle:NSLocalizedString(DoneLabel,@"")
										style:UIBarButtonItemStyleDone
										target:self
										action:@selector(SaveSchedule)];
		
		self.navigationItem.rightBarButtonItem = doneButton;
		[doneButton release];
	}
	
	if (schedule!= nil && ![schedule IsNotCommited] )
	{
		UIBarButtonItem * deleteButton = [[UIBarButtonItem alloc]
										  initWithTitle:NSLocalizedString(DeleteLabel,@"")
										  style:UIBarButtonItemStyleDone
										  target:self
										  action:@selector(DeleteSchedule)];
		
		self.navigationItem.rightBarButtonItem = deleteButton;
		[deleteButton release];
	}
}

-(void) SaveSchedule
{
	if ([schedule Name] == nil || [[schedule Name] length] == 0)
	{
		UIAlertView *baseAlert = [[[UIAlertView alloc]
								   initWithTitle:NSLocalizedString(@"Save Alert",@"")
								   message:NSLocalizedString(EmptyNameScheduleMessage,@"")
								   delegate:nil cancelButtonTitle:@"OK"
								   otherButtonTitles:nil] autorelease];
		// [baseAlert setNumberOfRows:3];
		[baseAlert show];
		return;
	}
	[Schedule SaveNewSchedule:schedule];
	[[self navigationController] popViewControllerAnimated:YES];
}

-(void) DeleteSchedule
{
	[Schedule DeleteSchedule:schedule];
	[[self navigationController] popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
	[self.tableView reloadData];
	self.title = [schedule Name];
	if (self.title == nil || [self.title length] == 0)
	{
		self.title = NSLocalizedString(NewScheduleTitle,@"");
	}
	[super viewWillAppear:animated];
}




@end
