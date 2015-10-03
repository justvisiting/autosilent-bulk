//
//  ProfileViewController.h
//  SilentMe
//
//  Created by god on 11/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BaseController.h"
#import "Profile.h"

@interface ProfileViewController : BaseController {

	Profile* profile;
}

-(ProfileViewController*) initWithProfile:(Profile*)prof;
-(void) SaveProfile;
-(void) DeleteProfile;
@end
