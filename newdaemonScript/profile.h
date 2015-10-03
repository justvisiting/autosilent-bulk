//
//  profile.h
//  newdaemon
//
//  Created by god on 10/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface profile : NSObject {

	@private
	NSString* ringtone;
	NSString* calendarAlertTone;
	bool keyboardSound;
	bool lockUnlockSound;
	bool newEmail;
	id smsSoundStringVal;
	int smsSound;
	bool vibrate;
	bool voicemail;
	bool pushNotification;
	bool initialized;
	NSDictionary* valueCollection;
	int profileId;
}
+ (NSDictionary*) ConvertSettingsToProfileDict:(NSDictionary*) settingsList;
-(void) Print;
- (profile*) initFromId: (int) profileIdentifier;
- (profile*) initFromDict: (NSDictionary*) settingsDict;
- (void) PopulateValues:(NSDictionary*) settingsDict;
- (NSDictionary*) GetSettingsCollection;
- (NSString*) RingTone;
- (NSString*) CalendarAlertTone;
- (BOOL) KeyBoardSoundEnabled;
- (BOOL) LockUnlockSoundEnabled;
- (BOOL) NewMailEnabled;
- (int) SMSSound;
- (BOOL) VibrateEnabled;
- (BOOL) VoiemailEnabled;
- (BOOL) IsInitialized;
- (int) GetProfileId;
- (BOOL) PushNotification;
@end
