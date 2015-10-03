//
//  TextViewCell.m
//  SilentMe
//
//  Created by god on 11/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TextViewCell.h"

static NSString * const CalendarUsageMessage = @"CalendarUsageMessage"; 

@implementation TextViewCell

- (TextViewCell*)initWithTitle: (NSString *) t 
{
	self = [super init];
	
	title = t;
	
	text = NSLocalizedString(CalendarUsageMessage,@"") ;
	height = 190.0f;
	
	return self;
}

- (TextViewCell*)initForCredit:(NSString *) t
{
	self = [super init];
	
	text = t;
	height = 50.0f;
	
	return self;
}

- (UITableViewCell *) getTableViewCell:(UITableView *) tableView
{
	
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: @"TextViewCell" ] ;
	if (!cell) {
		cell = [[[UITableViewCell alloc] initWithFrame: CGRectZero reuseIdentifier: @"TextViewCell"] autorelease] ;

		UITextView * textView = [[UITextView alloc] initWithFrame:CGRectMake(20.0, 6.0, 280.0, height-15.0f)];
		[textView setEditable:NO];
		[textView setScrollEnabled:YES];
		[textView setIndicatorStyle:UIScrollViewIndicatorStyleBlack];
		//
		[textView setBackgroundColor:[UIColor whiteColor]];
		[textView setAlpha:1];
		//[textView setOpaque:YES];
		[textView setTextColor:[UIColor blackColor]];
		[textView setFont:[UIFont systemFontOfSize:14.0f]];
		
		//[ textView setMarginTop: 20 ];
		[cell addSubview: textView] ;
	}
	UITextView* tf = [[cell subviews] lastObject] ;
	[ tf setText:text ];

	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	return cell;
}
-(CGFloat) getHeight
{
	return height;
}
@end
