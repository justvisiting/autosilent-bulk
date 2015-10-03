//
//  ScheduleViewController.h
//  SilentMe
//
//  Created by god on 11/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BaseController.h"

@class Schedule;

@interface ScheduleViewController : BaseController {

	Schedule* schedule;
}

-(ScheduleViewController*) initWithSchedule:(Schedule*)prof;
-(void) DeleteSchedule;
-(void) SaveSchedule;
@end
