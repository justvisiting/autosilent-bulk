//
//  settingsManager.h
//  newdaemon
//
//  Created by god on 10/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "profile.h"

@interface settingsManager : NSObject {

}
//+ (void) SetSetting(NSDictionary*) settings pt:(NSString*) path;
+ (void) ApplyProfile: (int) newProfile oldProf:(int) oldProfile;
@end

@interface settingsManager()
+ (void) ApplySettingsOfProfileId: (int) newProfile oldPf: (int) oldProfile;
+ (void) ApplyProfileSettings:(profile*) newProfileInfo oldPfInfo:(profile*) oldProfileInfo;
+ (NSDictionary*) GetCurrentSettings;
+ (void) ApplySpringBoardSettings:(profile*) newprofile  expProfile: (profile*) expectedtProfile;
+(void) ApplyPhonePlistSettings:(profile*) newprofile  expProfile: (profile*) expectedtProfile;
+(void) ApplyEmailPlistSettings:(profile*) newprofile  expProfile: (profile*) expectedtProfile;
+(void) ApplySoundsPlistSettings:(profile*) newprofile  expProfile: (profile*) expectedtProfile;

+ (void) ApplyPushNotification:(profile*) newprofile  expProfile: (profile*) expectedtProfile;
+ (void) AddSpringBoardSettings:(NSMutableDictionary*) origList;
+ (void) AddPhonePlistSettings:(NSMutableDictionary*) origList;
+ (void) AddEmailPlistSettings:(NSMutableDictionary*) origList;
+(void) AddSoundsPlistSettings:(NSMutableDictionary*) origList;

@end
