//
//  RepeatListController.h
//  SilentMe
//
//  Created by god on 11/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ProfileListController.h"


@interface RepeatListController : ProfileListController {

	NSMutableArray * userSelectedDays;
}

-(void) removeDay:(NSInteger) day;
-(void) addDay:(NSInteger) day;
-(void) RepeatListDone;

@end
