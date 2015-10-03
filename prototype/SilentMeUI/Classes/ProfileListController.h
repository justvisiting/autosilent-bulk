//
//  ProfileListController.h
//  SilentMe
//
//  Created by god on 11/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CGGeometry.h>
#import "Schedule.h"

@interface ProfileListController : UITableViewController {

	NSIndexPath * oldIndexPath;
	Schedule * schedule;
	NSMutableArray * dataSource;
}
- (ProfileListController *) init;
- (ProfileListController *) initWithSchedule:(Schedule *) schedule;
-(void) CreateProfile;
- (ProfileListController *) initForManualScedule;
@end
