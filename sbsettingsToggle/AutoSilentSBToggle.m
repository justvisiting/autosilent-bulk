#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>

#import "../newdaemon/constants.h"
#import "logger.h"

int minVersionSupported = 5.0;
int maxVersionSupported = 5.0;


BOOL isCapable()
{
	return YES;
}


BOOL isEnabled()
{
	//[logger Log:@"isenabledbled called"];
	NSDictionary* dic = [[NSDictionary alloc] initWithContentsOfFile:daemonPath];
	bool isManualOn = [[dic objectForKey:ManualOrAutomaticSelectedKey] boolValue];
	
	[dic release];
	
	return isManualOn;
}

void setState(BOOL Enabled)
{
	if(Enabled)
	{
		CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter() //center
										 , RequestManulModeChangeToOn
										 , NULL
										 , NULL
										 , TRUE);
	}
	else
	{
		CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter() //center
											 , RequestManulModeChangeToOff
											 , NULL
											 , NULL
											 , TRUE);
	}
}

float getDelayTime()
{
	return 1.0;
}

BOOL allowInCall()
{
	return YES;
}

BOOL getStateFast()
{
	return isEnabled();
}

int main1 (int argc, const char * argv[]) 
{
	
	isCapable();
	isEnabled();
	getStateFast();
	setState(YES);
	getStateFast();
	setState(NO);
	getStateFast();
}