//
//  NameCell.h
//  SilentMe
//
//  Created by god on 11/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BaseCell.h"
#import "Schedule.h"

@interface NameCell : BaseCell {

	Schedule * schedule;
}

- (NameCell*) initWithSchedule: (Schedule *) sched nextControllerName: (NSString*)controllerClassName nextDataSource:(NSMutableArray*)nextDs;
-(NSString*) GetName;
-(NSString*) GetNameLabel;

@end
