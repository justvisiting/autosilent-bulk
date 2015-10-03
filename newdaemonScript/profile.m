//
//  profile.m
//  newdaemon
//
//  Created by god on 10/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "profile.h"
#import "constants.h"
#import "logger.h"

@implementation profile
+ (NSDictionary*) ConvertSettingsToProfileDict:(NSDictionary*) settingsList
{
	NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:11];
	NSDictionary* springBoardDict = [NSDictionary dictionaryWithContentsOfFile:SpringBoardPlistPathString];
	
	//name
	[dict setObject:[settingsList objectForKey:NameKey] forKey:NameKey];
	
	if(![[settingsList objectForKey:PhoneEnabled] boolValue])
	{//if disabled then set to nil
		[dict setObject:@"system:SilentAuto" forKey:RingtoneKey];
	}
    //by definistion if rintone is ON, it should return 
	//ringtone when on profile is active but since it is not required/
	//for now it is not set
	
	if([[settingsList objectForKey:CalAlertEnabled] boolValue])
	{
		[dict setObject:@"/Applications/MobileCal.app/alarm.aiff" forKey:CalAlarmSoundKey];
	}
	else
	{
		[dict setObject:@"" forKey:CalAlarmSoundKey];
	}
	
	[dict setObject:[settingsList objectForKey:KeyboardSoundEnabled] forKey:KeyboardSoundKey];
	[dict setObject:[settingsList objectForKey:LockUnlockSoundEnabled] forKey:LockUnlockSoundKey];
	[dict setObject:[settingsList objectForKey:NewMailEnabled] forKey:NewMailKey];

	id val = [settingsList objectForKey:SentMailEnabled];
	if(val != nil)
	{
		[dict setObject:[settingsList objectForKey:SentMailEnabled] forKey:SentMailKey];
	}
	
	
	id smsVal = [springBoardDict objectForKey:SmsSoundKeyiOS421Plus];
	val = [settingsList objectForKey:SmsAlertEnabled];
	BOOL smsEnabled = [val boolValue];
	
	if(smsVal != nil) { //iOS 4.2.1+
		if(val != nil) {
			if(!smsEnabled){
				smsVal = @"<none>";
			}
		}
		
		[dict setObject:smsVal forKey:SmsSoundKeyiOS421Plus];		
	}
	else {
		if(val != nil)
		{
			id smsIntVal = nil;
			if(smsEnabled) {
				smsIntVal = [springBoardDict objectForKey:SmsSoundKey];
				if(smsIntVal == nil) {
					smsIntVal = [NSNumber numberWithInt:1];
				}
			}
			else {
				smsIntVal = [NSNumber numberWithInt:0];
			}
			
			[dict setObject:smsIntVal forKey:SmsSoundKey];		
			
		}
		else {
			[dict setObject:[NSNumber numberWithInt:0] forKey:SmsSoundKey];
		}
	}
	

	
	[dict setObject:[settingsList objectForKey:VibrateEnabled] forKey:VibrateKey];
	[dict setObject:[settingsList objectForKey:VoiceMailEnabled] forKey:VoiceMailKey];
	
	id pushNotif =  [settingsList objectForKey:PushNotificationEnabled];
	
	if(pushNotif == nil)
	{
		pushNotif = [NSNumber numberWithBool:NO];
	}
	
	[dict setObject:pushNotif forKey:PushNotificationEnabled];
	
	return dict;
}

- (NSDictionary*) GetSettingsCollection
{
	return valueCollection;
}
- (void) dealloc
{
	if(valueCollection != nil)
	{
		[valueCollection release];
	}
	
	[super dealloc];
}

- (profile*) initFromId: (int) profileIdentifier
{
	self = [super init];
	if(self)
	{
		profileId = profileIdentifier;
		if(profileIdentifier == DefaultProfile)
		{
			valueCollection = 
			[[NSDictionary dictionaryWithContentsOfFile:DefaultProfilePlist] retain];
		}
		else
		{
			[logger Log:[NSString stringWithFormat:@"getting profile from plist for id: %d", profileIdentifier]];
			
			NSDictionary* temp = [NSDictionary dictionaryWithContentsOfFile:ProfilesFilePath];
			if(temp != nil)
			{
				[logger Log:@"found profiles plist"];
				
				id profileIdentifierNum = [[NSString alloc] initWithFormat:@"%d", profileIdentifier]; //[NSNumber numberWithInt:profileIdentifier];
				
				NSDictionary* setDict = [temp objectForKey:profileIdentifierNum];
				
				if(setDict != nil)
				{
					[logger Log:[NSString stringWithFormat:@"found profile %d", profileIdentifier]];
					valueCollection = [[profile ConvertSettingsToProfileDict:setDict] retain];
				}
				else
				{
					[logger Log:@"could not find profile in profiles plist" level:CriticalError];
				}
			}
			else
			{
				[logger Log:@"could not find profiles plist" level:CriticalError];
			}
		}
		
		[self PopulateValues:valueCollection];

	}
	
	return self;
}

- (void) Print
{
	NSString* str = [[NSString alloc] 
					 initWithFormat:@"ringtone: %@, calendarAlert: %@, keyboard:%d, lockunlock:%d, newMail:%d,smsAlert:%d,vibrate:%d,voicemail:%d,push notification:%d, id:%d"
					 , ringtone, calendarAlertTone, keyboardSound, lockUnlockSound, newEmail, smsSound, vibrate, voicemail, pushNotification, profileId];
	[logger Log:str];
	[str release];
}

- (profile*) initFromDict: (NSDictionary*) settingsDict
{
	self = [super init];
	if(self)
	{
		if(settingsDict == nil)
		{
			ringtone = nil;
			calendarAlertTone = nil;
			keyboardSound = NO;
			lockUnlockSound = NO;
			newEmail = NO;
			smsSound = 0;
			vibrate = NO;
			voicemail = NO;
			initialized = NO;
			profileId = -1;
		}
		else
		{
			valueCollection =  settingsDict;
			[valueCollection retain];
			[self PopulateValues:settingsDict];
		}
	}
	
	return self;
}

- (int) GetProfileId
{
	return profileId;
}

- (void) PopulateValues:(NSDictionary*) settingsDict
{
	if(settingsDict != nil)
	{
		ringtone = [settingsDict objectForKey:RingtoneKey];
		
		calendarAlertTone = [settingsDict objectForKey:CalAlarmSoundKey];
		
		keyboardSound = [[settingsDict objectForKey:KeyboardSoundKey] boolValue];
		lockUnlockSound = [[settingsDict objectForKey:LockUnlockSoundKey] boolValue];
		newEmail = [[settingsDict objectForKey:NewMailKey] boolValue];
		

		id smsSoundId = [settingsDict objectForKey:SmsSoundKeyiOS421Plus];
		if(smsSoundId != nil)
		{
			smsSoundStringVal = smsSoundId; 
		}
		else {
			id smsSoundId = [settingsDict objectForKey:SmsSoundKey];
			smsSound = [smsSoundId intValue];
		}

		
		vibrate = [[settingsDict objectForKey:VibrateKey] boolValue];
		voicemail = [[settingsDict objectForKey:VoiceMailKey] boolValue];
		pushNotification = [[settingsDict objectForKey:PushNotificationEnabled] boolValue];		
		
		initialized = YES;
	}
}

- (NSString*) RingTone
{
	return ringtone;
}
- (NSString*) CalendarAlertTone
{
	return calendarAlertTone;
}

- (BOOL) KeyBoardSoundEnabled
{
	return keyboardSound;
}
- (BOOL) LockUnlockSoundEnabled
{
	return lockUnlockSound;
}

- (BOOL) NewMailEnabled
{
	return newEmail;
}

-(id) SMSSoundStringVal
{
	return smsSoundStringVal;	
}

- (int) SMSSound
{
	return smsSound;
}
- (BOOL) VibrateEnabled
{
	return vibrate;
}

- (BOOL) VoiemailEnabled
{
	return voicemail;
}
- (BOOL) IsInitialized
{
	return initialized;
}
- (BOOL) PushNotification
{
	return pushNotification;
}

@end
