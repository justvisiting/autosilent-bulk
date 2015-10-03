//
//  TextFieldController.m
//  SilentMe
//
//  Created by god on 11/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TextFieldController.h"
#import "TextFieldCell.h"

static NSString* const DoneLabel = @"Done";
static NSString* const CancelLabel = @"Cancel";

@implementation TextFieldController
- (TextFieldController *) initWithDataSource:(NSMutableArray*)ds title:(NSString*) scheduleName textField:(TextFieldCell*) textCell
{
	self = [super initWithDataSource:ds title:scheduleName];
	textField = textCell;
	return self;
	
}

- (void)loadView
{
    [super loadView];
	UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]
									initWithBarButtonSystemItem:UIBarButtonSystemItemDone
									target:self
									action:@selector(SaveText)];
	
	self.navigationItem.rightBarButtonItem = doneButton;
	[doneButton release];
	
	UIBarButtonItem * cancelButton = [[UIBarButtonItem alloc]
									initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
									target:self
									action:@selector(Cancel)];
	
	self.navigationItem.leftBarButtonItem = cancelButton;
	[cancelButton release];
}

-(void)SaveText
{
	
	[textField textFieldShouldReturn:textField->textField];
	if ( [textField->textField text] != nil && [[textField->textField text] length] > 0) 
	[[self navigationController] popViewControllerAnimated:YES];
}

-(void)Cancel
{
	[[self navigationController] popViewControllerAnimated:YES];
}

@end
