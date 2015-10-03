//
//  settingsManager.m
//  newdaemon
//
//  Created by god on 10/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#include <UIKit/UIKit.h>
#include <dlfcn.h>
#include <stdio.h>
#include <unistd.h>
	//#include <GraphicsServices/GSEvent.h>

#import "settingsManager.h"
#import "configManager.h"
#import "constants.h"
#import "profile.h"
#import "logger.h"


 void WriteToFileAndNotify(id list, id key, id value, NSString* filePath, NSString* fileId)
{
	
	NSString* logString  = [[NSString alloc] initWithFormat:@"writing into %s, for key %s, value %@"
							, [filePath UTF8String], [key UTF8String], value]; 
	[logger Log:logString level:Information];
	[logString release];
	
	[list setObject:value forKey:key];
	
	[list writeToFile:filePath atomically:YES];
	
//	Log(CFSTR("updating phone setting file"));
	
	chown([filePath UTF8String], 501, 501);
#if IS_IPHONE
		GSSendAppPreferencesChanged((CFStringRef)fileId, key);
#endif
	
	
	//Log(CFSTR("done updating phone settings"));
	
	
}

void ApplyWriteAndNotifyForBoolValue(NSDictionary* newProfileDict, NSDictionary* expectedDict, NSString* key
	, NSString* targetPath, NSString* targetId, NSMutableDictionary* targetDict)
{
	
	BOOL currentSetting = [[targetDict valueForKey:key] boolValue];
	BOOL applySetting = YES;
	
	if(expectedDict != nil)
	{
			BOOL expectedSetting = [[expectedDict valueForKey:key] boolValue];
			
			//if user did not over ride apply new value else keep the old one
			if(expectedSetting != currentSetting)
			{	
				applySetting = NO;
			}
				
			
	}
	
	id newSetting = [newProfileDict valueForKey:key];
	
	if(newSetting != nil)
	{
		WriteToFileAndNotify(targetDict, key, newSetting, targetPath, targetId);
	}
	
}

void ApplyWriteAndNotifyForIntValue(NSDictionary* newProfileDict, NSDictionary* expectedDict, NSString* key
									   , NSString* targetPath, NSString* targetId, NSMutableDictionary* targetDict)
{
	
	int currentSetting = [[targetDict valueForKey:key] intValue];
	BOOL applySetting = YES;
	
	if(expectedDict != nil)
	{
		int expectedSetting = [[expectedDict valueForKey:key] intValue];
		
		//if user did not over ride apply new value else keep the old one
		if(expectedSetting != currentSetting)
		{	
			applySetting = NO;
		}
		
	}
	
	id newSetting = [newProfileDict valueForKey:key];
	
	if(newSetting != nil)
	{
		WriteToFileAndNotify(targetDict, key, newSetting, targetPath, targetId);
	}
	
}

void ApplyWriteAndNotifyForStringValue(NSDictionary* newProfileDict, NSDictionary* expectedDict, NSString* key
									  , NSString* targetPath, NSString* targetId, NSMutableDictionary* targetDict)
{
	
	NSString* currentSetting = [targetDict valueForKey:key] ;
	BOOL doApplySetting = YES;
	
	if(expectedDict != nil)
	{
		NSString* expectedSetting = [expectedDict valueForKey:key];
		
		//if user did not over ride apply new value else keep the old one
		if(expectedSetting != nil && currentSetting != nil && [expectedSetting compare:currentSetting options:NSCaseInsensitiveSearch] != NSOrderedSame)
		{	
			doApplySetting = NO;
		}
		
	}
	
	if(doApplySetting)
	{
	id newSetting = [newProfileDict valueForKey:key];
	
	if(newSetting != nil)
	{
		WriteToFileAndNotify(targetDict, key, newSetting, targetPath, targetId);
	}
	}
	
}

@implementation settingsManager
+ (void) ApplyProfile: (int) newProfile oldProf:(int) oldProfile
{
	if(oldProfile == DefaultProfile || oldProfile <= 0)
	{//	//default profile or no profile
		NSDictionary* currentSettings = [settingsManager GetCurrentSettings];
		[currentSettings writeToFile:DefaultProfilePlist atomically: YES];
	}
	
	[settingsManager ApplySettingsOfProfileId:newProfile oldPf:oldProfile];
}

+ (void) ApplySettingsOfProfileId: (int) newProfile oldPf: (int) oldProfile
{
	[logger Log:[NSString stringWithFormat:@"applying profile newProf:%d oldProf:%d"
				 ,newProfile, oldProfile]];
	
	profile* newProfileInfo = [[profile alloc] initFromId:newProfile];
	profile* oldProfileInfo = nil;
	
	//if new profile is default then dont override any settings 
	//which user might have changed when a profile was active. 
	//that;s the reason oldprofile is passed
	if(newProfile == DefaultProfile)
	{
		oldProfileInfo = [[profile alloc] initFromId:oldProfile];
	}
	
	if(newProfileInfo != nil && [newProfileInfo IsInitialized])
	{
		[settingsManager ApplyProfileSettings:newProfileInfo oldPfInfo:oldProfileInfo];
		[configManager SetCurrentProfile:newProfile];
	}
	
	[newProfileInfo release];
	
	if(oldProfileInfo != nil)
	{
		[oldProfileInfo release];
	}
}

+ (void) ApplyProfileSettings:(profile*) newProfileInfo oldPfInfo:(profile*) oldProfileInfo
{
		[newProfileInfo Print];
		[settingsManager ApplySpringBoardSettings:newProfileInfo expProfile:oldProfileInfo];
		[settingsManager ApplyPhonePlistSettings:newProfileInfo expProfile:oldProfileInfo];
		[settingsManager ApplyEmailPlistSettings:newProfileInfo expProfile:oldProfileInfo];
		[settingsManager ApplySoundsPlistSettings:newProfileInfo expProfile:oldProfileInfo];
		[settingsManager ApplyPushNotification:newProfileInfo expProfile:oldProfileInfo];
}

+ (NSDictionary*) GetCurrentSettings
{
	NSMutableDictionary* currentSettings = [[NSMutableDictionary alloc] init];
	if(currentSettings != nil)
	{
		[settingsManager AddSpringBoardSettings:currentSettings];
		[settingsManager AddEmailPlistSettings:currentSettings];
		[settingsManager AddPhonePlistSettings:currentSettings];
		[settingsManager AddSoundsPlistSettings:currentSettings];
	
		[currentSettings setObject:[NSNumber numberWithBool:YES] forKey:PushNotificationEnabled];
	}
	
	return currentSettings;

}



+ (void) ApplyPushNotification:(profile*) newprofile  expProfile: (profile*) expectedtProfile
{
	NSString *cmd = nil;
		if([newprofile PushNotification])
		{
			cmd = @"/bin/launchctl load /System/Library/LaunchDaemons/com.apple.apsd.plist";
		}
		else
		{
			cmd = @"/bin/launchctl unload /System/Library/LaunchDaemons/com.apple.apsd.plist";
		}
		
		system([cmd UTF8String]);

}

+ (void) ApplySpringBoardSettings:(profile*) newprofile  expProfile: (profile*) expectedtProfile
{
	[logger Log:@"applying spring board settings"];
	id plist = [NSMutableDictionary dictionaryWithContentsOfFile:SpringBoardPlistPathString];
	
	if(plist != nil)
	{
		
		NSDictionary* expectedDict = nil;
		
			if(expectedtProfile != nil)
			{
				expectedDict = [expectedtProfile GetSettingsCollection];
			}
			
			NSDictionary* newProfileDict = [newprofile GetSettingsCollection];
			
			if(newProfileDict != nil)
			{
				//apply ringtone
				ApplyWriteAndNotifyForStringValue(newProfileDict, expectedDict, RingtoneKey
					, SpringBoardPlistPathString, SpringBoardPlistPathId, plist);			

				//apply vibrate
				ApplyWriteAndNotifyForBoolValue(newProfileDict, expectedDict, VibrateKey
												  , SpringBoardPlistPathString, SpringBoardPlistPathId, plist);			

				//lock unlock
				ApplyWriteAndNotifyForBoolValue(newProfileDict, expectedDict, LockUnlockSoundKey
												, SpringBoardPlistPathString, SpringBoardPlistPathId, plist);			
			
		
				//calendar alarm
				ApplyWriteAndNotifyForStringValue(newProfileDict, expectedDict, CalAlarmSoundKey
												, SpringBoardPlistPathString, SpringBoardPlistPathId, plist);			
		
				
				//sms sound key, hack for 4.2.1+
				if([[newProfileDict valueForKey:SmsSoundKeyiOS421Plus] isKindOfClass:[NSString class]])
				{
					ApplyWriteAndNotifyForStringValue(newProfileDict, expectedDict, SmsSoundKeyiOS421Plus
													  , SpringBoardPlistPathString, SpringBoardPlistPathId, plist);								
				}
				else {
					
					ApplyWriteAndNotifyForIntValue(newProfileDict, expectedDict, SmsSoundKey
												  , SpringBoardPlistPathString, SpringBoardPlistPathId, plist);			
				}
			}
			
	}
}

+(void) ApplyPhonePlistSettings:(profile*) newprofile  expProfile: (profile*) expectedtProfile
{
		[logger Log:@"applying phone plist settings"];
	id plist = [NSMutableDictionary dictionaryWithContentsOfFile:MobilePhonePlistPathString];
	if(plist != nil)
	{
		NSDictionary* expectedDict = nil;
		if(expectedtProfile != nil)
		{
			expectedDict = [expectedtProfile GetSettingsCollection];
		}
		
		NSDictionary* newProfileDict = [newprofile GetSettingsCollection];
		
		if(newProfileDict != nil)
		{
			ApplyWriteAndNotifyForBoolValue(newProfileDict, expectedDict, VoiceMailKey
											, MobilePhonePlistPathString, MobilePhonePlistId
											, plist);			
		}
				
	}
}

+(void) ApplyEmailPlistSettings:(profile*) newprofile  expProfile: (profile*) expectedtProfile
{
		[logger Log:@"applying emailplist settings"];
	id plist = [NSMutableDictionary dictionaryWithContentsOfFile:MobileEmailPlistPathString];

	NSDictionary* expectedDict = nil;
	
	if(plist != NULL)
	{
		if(expectedtProfile != nil)
		{
			expectedDict = [expectedtProfile GetSettingsCollection];
		}
		
		NSDictionary* newProfileDict = [newprofile GetSettingsCollection];
					
		if(newProfileDict != nil)
		{
			ApplyWriteAndNotifyForBoolValue(newProfileDict, expectedDict, NewMailKey
											, MobileEmailPlistPathString, MobileEmailPlistId
											, plist);			
			ApplyWriteAndNotifyForBoolValue(newProfileDict, expectedDict, SentMailKey
											, MobileEmailPlistPathString, MobileEmailPlistId
											, plist);			
			
		}

	}	
}


+(void) ApplySoundsPlistSettings:(profile*) newprofile  expProfile: (profile*) expectedtProfile
{
	[logger Log:@"applying sounds plist settings"];
	id plist = [NSMutableDictionary dictionaryWithContentsOfFile:SoundPlistPathString];
	
	NSDictionary* expectedDict = nil;
	
	if(plist != NULL)
	{
		if(expectedtProfile != nil)
		{
			expectedDict = [expectedtProfile GetSettingsCollection];
		}
		
		NSDictionary* newProfileDict = [newprofile GetSettingsCollection];
		
		if(newProfileDict != nil)
		{
			ApplyWriteAndNotifyForBoolValue(newProfileDict, expectedDict, KeyboardSoundKey
											, SoundPlistPathString, SoundPlistId
											, plist);			
		}
		
	}	
}


//phone enabled
//lock unlock sound enabled
//sms alert enabled
//vibrate enabled
// clendar alert

+ (void) AddSpringBoardSettings:(NSMutableDictionary*) origList
{
	id plist = [NSDictionary dictionaryWithContentsOfFile:SpringBoardPlistPathString];

	if(plist != nil)
	{
	//region ringtone
	id currentValue = [plist valueForKey:RingtoneKey];
	if(currentValue == NULL)
	{
		currentValue = @"system:Harp";
	}
	[origList setObject:currentValue forKey:RingtoneKey];
	
	//vibrate settings
	id currentVibrateSetting = [plist valueForKey:VibrateKey];
	
	if(currentVibrateSetting == NULL)
	{
		currentVibrateSetting = [NSNumber numberWithBool:TRUE];
	}
	[origList setObject:currentVibrateSetting forKey:VibrateKey];
	
	//lock unlock setting
	id currentLockUnlockSetting = [plist valueForKey:LockUnlockSoundKey];
	
	if(currentLockUnlockSetting == NULL)
	{
		currentLockUnlockSetting = [NSNumber numberWithBool:TRUE];
	}
	[origList setObject:currentLockUnlockSetting forKey:LockUnlockSoundKey];
	
	
	//calendar alaram
	id calendarAlarmSound = [plist valueForKey:CalAlarmSoundKey];
	
	if(calendarAlarmSound == NULL)
	{
		calendarAlarmSound = @"/Applications/MobileCal.app/alarm.aiff";
	}
	[origList setObject:calendarAlarmSound forKey:CalAlarmSoundKey];
	
	//sms sound
	id smsSound = [plist valueForKey:SmsSoundKeyiOS421Plus];
	
	if(smsSound != nil)
	{
		[origList setObject:smsSound forKey:SmsSoundKeyiOS421Plus];	
	}
	else {
		smsSound = [plist valueForKey:SmsSoundKey];
		if(smsSound == nil) {
			smsSound  = [NSNumber numberWithInt:1];
		}
		[origList setObject:smsSound forKey:SmsSoundKey];	
	}

	}
}

+(void) AddPhonePlistSettings: (NSMutableDictionary*) origList
{
	id plist = [NSDictionary dictionaryWithContentsOfFile:MobilePhonePlistPathString];
	if(plist != nil)
	{
		//voice mail setting
		id currentVoicemailSetting = [plist valueForKey:VoiceMailKey];
		if(currentVoicemailSetting == NULL)
		{
			currentVoicemailSetting = [NSNumber numberWithBool:TRUE];
		}
		[origList setObject:currentVoicemailSetting forKey:VoiceMailKey];
		
	}
}

+(void) AddEmailPlistSettings:(NSMutableDictionary*) origList
{
	id plist = [NSDictionary dictionaryWithContentsOfFile:MobileEmailPlistPathString];
	
	
	if(plist != NULL)
	{
		//new email
		id currentValue = [plist valueForKey:NewMailKey];
		if(currentValue == NULL)
		{
			currentValue = [NSNumber numberWithBool:TRUE];
		}
		[origList setObject:currentValue forKey:NewMailKey];
		
		//sent mail
		currentValue = [plist valueForKey:SentMailKey];
		if(currentValue == NULL)
		{
			currentValue = [NSNumber numberWithBool:TRUE];
		}
		[origList setObject:currentValue forKey:SentMailKey];
		
	}	
}

+(void) AddSoundsPlistSettings:(NSMutableDictionary*) origList
{
	id plist = [NSDictionary dictionaryWithContentsOfFile:SoundPlistPathString];
	
	
	if(plist != NULL)
	{
		//new email
		id currentValue = [plist valueForKey:KeyboardSoundKey];
		if(currentValue == NULL)
		{
			currentValue = [NSNumber numberWithBool:TRUE];
		}
		[origList setObject:currentValue forKey:KeyboardSoundKey];
		
	}	
}
@end
