//
//  TextFieldCell.m
//  SilentMe
//
//  Created by god on 11/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TextFieldCell.h"

static NSString * const EnterScheduleName = @" Enter Schedule Name Here";
static NSString * const EnterProfileName = @" Enter Profile Name Here";
@implementation TextFieldCell


- (TextFieldCell*)initWithTitle: (NSString *) t Schedule:(Schedule *) sched 
{
	self = [super init];
	
    if ( self ) {
        title = t;
		cellIdentifier = @"TextFieldCell";
		nextViewControllerClassName =  nil ;
		nextDataSource = nil;
		intTag = nil;
		boolTag = nil;
		basedict = sched;
		nameTag = @"Name";
		placeholderLabel = NSLocalizedString( EnterScheduleName, @"") ;
		profile = nil;
    }
    return self;
}

- (TextFieldCell*)initWithTitle: (NSString *) t Profile:(Profile *) prof 
{
	self = [super init];
	
    if ( self ) {
        title = t;
		cellIdentifier = @"TextFieldCell";
		nextViewControllerClassName =  nil ;
		nextDataSource = nil;
		intTag = nil;
		boolTag = nil;
		basedict = prof;
		nameTag = @"Name";
		placeholderLabel = NSLocalizedString( EnterProfileName, @"");
		profile = prof;
    }
    return self;
}

- (UITableViewCell *) getTableViewCell:(UITableView *) tableView
{

	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: @"TextFieldCell" ] ;
	if (!cell) {
		cell = [[[UITableViewCell alloc] initWithFrame: CGRectZero reuseIdentifier: @"textCell"] autorelease] ;
		//UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake( 20.0f, 10.0f, 100.0f, 20.0f) ] ;
		//[label setText: @"Name: "] ;
		//[cell addSubview:label] ;
		//[label release] ;
		textField = [[UITextField alloc] initWithFrame: CGRectMake( 20.0f, 10.0f, 280.0f, 25.0f) ] ;
		[cell addSubview: textField] ;
	}
	UITextField* tf = [[cell subviews] lastObject] ;
	title = [ (NSString*)[basedict GetValue:nameTag] retain];
	if ( title == nil || [title length] == 0)
	{
		tf.placeholder = NSLocalizedString(placeholderLabel,@"") ;
	}
	else
	{
		tf.text = title;
	}
	
	tf.delegate = self;
	[tf becomeFirstResponder];
	//tf.borderStyle = UITextBorderStyleRoundedRect;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	return cell;
}

// TextField delegate handles return events and dismisses keyboard
- ( BOOL) textFieldShouldReturn: (UITextField *) textF
{ 
	if ([textF text] == nil || [[textF text] length] == 0)
	{
		UIAlertView *baseAlert = [[[UIAlertView alloc]
								   initWithTitle:NSLocalizedString(@"Save Alert",@"")
								   message:NSLocalizedString(@"Cannot Save an empty name",@"")
								   delegate:nil cancelButtonTitle:@"OK"
								   otherButtonTitles:nil] autorelease];
		// [baseAlert setNumberOfRows:3];
		[baseAlert show];
		return YES;
	}
	
	
	
	if(profile!=nil && [[profile Name] caseInsensitiveCompare:[textF text]] != NSOrderedSame && [Profile IsNameDuplicate:[textF text]])
	{
		UIAlertView *baseAlert = [[[UIAlertView alloc]
								   initWithTitle:NSLocalizedString(@"Save Alert",@"")
								   message:NSLocalizedString( @"Profile with same name already exists, please enter different name", @"")
								   delegate:nil cancelButtonTitle:@"OK"
								   otherButtonTitles:nil] autorelease];
		// [baseAlert setNumberOfRows:3];
		[baseAlert show];
		return YES;
	}
	
	[textF resignFirstResponder] ;
	[basedict SetValue:nameTag value:[textF text]];
	//[self notify: [NSString stringWithFormat: @"Hello %@", [textField text] ] ] ;
	return YES;
}

- (void)cellSelected:(UITableViewController *) currentController
{
}

@end