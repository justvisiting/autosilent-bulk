//
//  ProfileNameCell.h
//  SilentMe
//
//  Created by god on 11/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NameCell.h"

@class Profile;

@interface ProfileNameCell : NameCell {
	Profile * profileforName;
}

- (NameCell*) initWithProfile: (Profile *) sched nextControllerName: (NSString*)controllerClassName nextDataSource:(NSMutableArray*)nextDs;
@end
