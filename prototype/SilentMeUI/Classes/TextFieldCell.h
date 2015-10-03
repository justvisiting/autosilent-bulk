//
//  TextFieldCell.h
//  SilentMe
//
//  Created by god on 11/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseCell.h"
#import "Profile.h"
#import "Schedule.h"

@class BaseController;

@interface TextFieldCell : BaseCell {
	NSString * nameTag;
	BaseController* controller;
	NSString *placeholderLabel;

	@public
	UITextField * textField;
}
- (TextFieldCell*)initWithTitle: (NSString *) t Schedule:(Schedule *) sched ;
- (TextFieldCell*)initWithTitle: (NSString *) t Profile:(Profile *) profile;
- ( BOOL) textFieldShouldReturn: (UITextField *) textField;

@end
