//
//  configManager.h
//  newdaemon
//
//  Created by god on 10/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface configManager : NSObject {
	
}
+ (NSMutableDictionary*) SettingsDict; //only to be used for testing
+ (void) Refresh;
+ (void) RefreshAll; //force read everything from disk

+ (BOOL) AppEnabled;
+ (BOOL) CalendarEnabled;
+ (BOOL) IsAutomaticMode;
+ (int) CalendarProfile;

//gets profile info
+ (int) CurrentProfile;
+ (void) SetCurrentProfile: (int) profileId;
+ (NSDictionary*) GetProfile:(int) profile; //used by mobilesubstrate
+ (BOOL) IsStatusIconEnabled;

//bypass silent switch settings
+ (BOOL) GetSilentSwitchStatus;
+ (void) SetSilentSwitchStatus: (BOOL) status;
+ (void) SetBypassSwitchStatus: (BOOL) status;
+ (BOOL) GetBypassSwitchStatus;

//general
+ (void) Write:(id) key  value:(id) val dictionary:(NSMutableDictionary*) dict path:(NSString*) pt;
+ (NSString*) GetCurrentType;


//manual mode 
+ (BOOL) IsManualMode;
+ (void) SetManualMode:(BOOL) mode;
+ (int) ManualProfile;
//sets date in daemonsettings
+ (void) SetDateUntilWhichManulModeIsApplied:(NSDate*) date;
//gets date from settings plist 
+ (NSDate*) GetDateUntilWhichManulModeIsAppliedFromUI;
//gets real date from daemon settings
+ (NSDate*) GetDateUntilWhichManulModeIsApplied;
+ (NSString*) GetManualId;

+ (void) SetCurrentApplicableSchedule: (int) scheduleId;
+ (int) GetCurrentApplicableScheduleValueInPlist;

+ (NSString*) GetSilentStringKeyword;
//calendar plist
+ (NSDictionary*) GetActiveCalendarList;
+ (NSDate*) GetNextWakeUpTime;
@end
