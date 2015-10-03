//
//  TextViewCell.h
//  SilentMe
//
//  Created by god on 11/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "BaseCell.h"

@class BaseController;

@interface TextViewCell : BaseCell {
	BaseController* controller;
	NSString * text;
	float height;
}
- (TextViewCell*)initWithTitle: (NSString *) t ;
- (TextViewCell*)initForCredit:(NSString *) t;

@end
