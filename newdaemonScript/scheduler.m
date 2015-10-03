//
//  scheduler.m
//  newdaemon
//
//  Created by god on 10/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "constants.h"
#import "scheduler.h"

#import <CommonCrypto/CommonHMAC.h>
#if IS_IPHONE
#import <UIKit/UIDevice.h>
#endif

#import "Base64Transcoder.h"
#import "settingsManager.h"
#import "configManager.h"
#import "BaseEvent.h"
#import "scheduleInfo.h"
#import "calendar.h"
#import "logger.h"
#import "powerMgmt.h"
#import "NightTime.h"

static scheduler* schedulerInstance;

//returns encoded text 
NSString* GetStringVal(NSString* text, NSString* secret)
{
	NSData *secretData = [secret dataUsingEncoding:NSUTF8StringEncoding];
    NSData *clearTextData = [text dataUsingEncoding:NSUTF8StringEncoding];
	
    uint8_t digest[CC_SHA1_DIGEST_LENGTH] = {0};
	
    CCHmacContext hmacContext;
    CCHmacInit(&hmacContext, kCCHmacAlgSHA1, secretData.bytes, secretData.length);
    CCHmacUpdate(&hmacContext, clearTextData.bytes, clearTextData.length);
    CCHmacFinal(&hmacContext, digest);
	
    //Base64 Encoding
    
    char base64Result[32];
    size_t theResultLength = 32;
    Base64EncodeData(digest, CC_SHA1_DIGEST_LENGTH, base64Result, &theResultLength);
    NSData *theData = [NSData dataWithBytes:base64Result length:theResultLength];
    
    NSString *base64EncodedResult = [[NSString alloc] initWithData:theData encoding:NSUTF8StringEncoding];
    
    return [base64EncodedResult autorelease];
}

//returns whether current app is premium or free
int GetScheduleInfo(NSString* key)
{
	int retVal = 2;
	
	NSString* codeV = [configManager GetCurrentType];
	
	NSString* uniqueId = nil;
	
#if IS_IPHONE
	uniqueId = [[UIDevice currentDevice] uniqueIdentifier]; 
#endif
	
	NSString* hash = GetStringVal(uniqueId, key);
	
	if(hash != NULL && codeV != NULL && [hash compare:codeV options:NSCaseInsensitiveSearch] == NSOrderedSame)
	{
		retVal = 0;
	}
	else 
	{
		NSFileManager *fm = [NSFileManager defaultManager];
		NSError* err;
		
		NSDictionary* dict = [fm attributesOfItemAtPath:@"/Applications/SilentMe.app/SilentMe" error:&err];
		
		if(dict != nil)
		{
			NSDate* calModifiedDatetime = [dict objectForKey:NSFileModificationDate];
			
			if((int)[calModifiedDatetime timeIntervalSinceNow] > (-24*60*60*5))
			{
				//NSLog(@"valid touch file");
				NSString* manualMode = [configManager GetManualId];
				
				if(manualMode != nil)
				{
				//	NSLog(@"found manual id");
					NSDateFormatter *df = [[NSDateFormatter alloc] init];
					[df setDateFormat:@"yyyyMMdd"];
					NSDate *myDate = [df dateFromString: manualMode];
					if((int)[myDate timeIntervalSinceNow] > ((-24*60*60*5)))
					{
					//	NSLog(@"manual id is newer than 6 days");
						retVal = 0;
					}
				}
				else
				{
					//NSLog(@"manual id in settings file is nil");
					retVal = 0;
						
				}
					
				
			}
			return retVal;
			
		}
	}
}
	
	@implementation scheduler
	+ (void) initialize {
		schedulerInstance = [[scheduler alloc] init];
		schedulerInstance->completeLock = [[NSLock alloc] init];
		schedulerInstance->appStartTime = [[NSDate date] retain];
	}
	
	+ (scheduler*) Instance
	{
		return schedulerInstance;
	}
	- (void) Run:(NSString*) source overide:(BOOL) overrideAndDisableApp
	{
		
		
		[self UpdateSettings: overrideAndDisableApp];	
		/*@try
		 {
		 [self UpdateSettings: overrideAndDisableApp];	
		 }
		 //@catch (NSException *e) {
		 //[e name]; [e reason]; 
		 //@throw e;
		 }*/
		
		
	}
	
	- (BOOL) UpdateSettings:(BOOL) overrideAndDisableApp
	{
		BOOL isAppEnabled = !overrideAndDisableApp;
		int applicableProfile = DefaultProfile;
		int applicableScheduleId = DefaultScheduleIdWhenNoScheduleIsApplicable;
		int currentSchedule = [configManager GetCurrentApplicableScheduleValueInPlist];
		if(!overrideAndDisableApp)
		{
			isAppEnabled = [configManager AppEnabled];
		}
		
		// 0 means default profile
		// 1 means silent profile for now
		int currentProfile = [configManager CurrentProfile];
		
		NSString* key = @"9e7d898020356201432df8321cb4ac96";
		BOOL isManulModeApplicable = NO;
		
		
		if(!isAppEnabled || GetScheduleInfo(key) != 0)
		{
			if(currentProfile != DefaultProfile)
			{
				[settingsManager ApplyProfile:DefaultProfile oldProf:currentProfile];
			}
		}
		else
		{
			
			[self KillItIfRequired];
			[self SyncWithExternalSystem];
			
			if ([configManager IsManualMode])
			{
				NSDate* dateUntilManulMode = [configManager GetDateUntilWhichManulModeIsApplied];		
				
				NSDate* now = [NSDate date];
				[logger Log:[NSString stringWithFormat:@"date until which manul maode is applied %@", [dateUntilManulMode description]]];		
				
				if(dateUntilManulMode != nil && [now compare:dateUntilManulMode] == NSOrderedAscending)
				{
					[logger Log:@"manual mode"];
					applicableProfile = [configManager ManualProfile];
					
					isManulModeApplicable = YES;
					applicableScheduleId = ManualEventId;
				}
				else // timeout for manual mode so revert settings back
				{
					[logger Log:@"time out for manual mode so setting manual mode to OFF"];
					applicableProfile = DefaultProfile;
					
					[configManager SetManualMode:NO];
					RemoveManulEvent();
				}
				
			}
			
			//scenario when ismanual is enabled but date is in past
			//then above if condition returns ismualmodeapplicable to false
			//but this part of the code has to execute
			if(!isManulModeApplicable && [configManager IsAutomaticMode])
			{
				[logger Log:@"auto mode"];
				
				NSDate* nowDate = [NSDate date];
				
				[scheduleInfo PrintAllList];
				
				BaseEvent* event = [scheduleInfo GetEventWhichMightResultIntoChangeInProfile];
				if(event != nil && [[event getStartDate] compare:nowDate] == NSOrderedAscending
				   && [[event getEndDate] compare:nowDate] == NSOrderedDescending)
				{
					applicableProfile = [event ProfileId];
					
					if([event IsCalendarEventType])
					{
						applicableScheduleId = CalenderScheduleId;
					}
					else
					{
						applicableScheduleId = [event EventId];
					}
					
				}
				
				
				
				[logger Log:[NSString stringWithFormat:@"current profile %d, applicable profile %d. current schedule:%d, applicable schedule:%d",  currentProfile, applicableProfile, currentSchedule, applicableScheduleId]];
			}
			
			if(applicableScheduleId != currentSchedule)
			{
				//set schedule id
				[configManager SetCurrentApplicableSchedule:applicableScheduleId];
				PostNotification(NotificaitonActiveScheduleChanged);
			}
			
			//should be out of above condition 
			//scenario current silentmode is ON & request comes to OFF..
			if(applicableProfile != currentProfile)
			{
				[settingsManager ApplyProfile:DefaultProfile oldProf:currentProfile];
				
				if(DefaultProfile != applicableProfile)
				{
					[settingsManager ApplyProfile:applicableProfile oldProf:DefaultProfile];
				}
				
				
				PostNotification(NotificationSilentStatusChanged);
				
			}
			
		}
		
		[logger Log:[NSString stringWithFormat:@"values: isAppEnabled:%d, isManulMode:%d, isAutomaticMode:%d, profile:%d", isAppEnabled, [configManager IsManualMode]
					 , [configManager IsAutomaticMode], applicableProfile]];
		
		return YES;
	}
	
	- (void) KillItIfRequired
	{
		NSDate* date = [NSDate date];
		NSInteger todaysSecondsElapsed =  GetTimeElapsedForTheday(date);
		NSLog(@"todays seconds elapsed %d", todaysSecondsElapsed);
		
		NSDate* todaysMidNightDate = [[NSDate date] dateByAddingTimeInterval:(NSTimeInterval)(-(todaysSecondsElapsed+1))];
		
		if([appStartTime timeIntervalSinceDate:todaysMidNightDate] < 0)
		{
			NSLog(@"app running for long time");
			[[powerMgmt Instance] RemoveSource];
			exit (0);
		}
	}
	
	- (void) SyncWithExternalSystem
	{
		//[configManager Refresh] and updated custom list is not required..as these can only be changed by UI and as UI notifies after the change
		//it is refreshed there
		
		[calendar Refresh];
		//refresh calendar
	}
	
	- (void) PerformAllActions:(NSString*) source override:(BOOL) overrideAndDisableApp isManulModeApplicable:(BOOL) manulModeApplicable manualMode: (BOOL) manualMode
	{
		[self PerformAllActions:source override:overrideAndDisableApp isManulModeApplicable:manulModeApplicable manualMode:manualMode manualModeDate:nil];
	}
	
	- (void) PerformAllActions:(NSString*) source override:(BOOL) overrideAndDisableApp isManulModeApplicable:(BOOL) manulModeApplicable manualMode: (BOOL) manualMode
manualModeDate:(NSDate*) manualModeDate
	{
		
		[completeLock lock];
		@try
		{
			
			//apply new settings aka profile
			[logger Log:source];
			
			if(manulModeApplicable)
			{
				[logger Log:[NSString stringWithFormat:@"setting manual mode %d", manualMode]];
				[configManager SetManualMode:manualMode];
				if(manualMode)
				{
					[logger Log:[NSString stringWithFormat:@"setting manual mode date %@", [manualModeDate description]]];
					[configManager SetDateUntilWhichManulModeIsApplied:manualModeDate];
					AddOrUpdateManulEvent();
				}
				else
				{
					RemoveManulEvent();
				}
			}
			//	//update settings
			//update calendar
			//update custom profile
			//all above are done in run
			[self Run:source overide:overrideAndDisableApp];
			
			if(!overrideAndDisableApp)
			{
				//arrange wake up if requireed
				[scheduleInfo SetNexWakeUpEvent:WakeUpDuringNonSleep];	
			}
			
			
			[scheduleInfo PrintAllList];
			
		}
		@catch (NSException *e) {
			NSString* message = [NSString stringWithFormat:"Fatal error, name: %@, reason: %@"
								 , [e name], [e reason]];
			[logger Log:message level:CriticalError];
			@throw e;
		}
		
		
		[completeLock unlock];
		
		[logger Log:@"done PerformAllActions"];
	}
	@end
	
	
	
	//inline void RegisterForRun
	
	
	
	
