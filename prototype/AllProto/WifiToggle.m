//yeah it works & it works

#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIApplication.h>
#include <dlfcn.h>
#include <stdio.h>
#import <unistd.h>

//com.apple.preferences.network
//__CTServerConnectionSetWifiPower
#define PreferencesFrameworkPath "/System/Library/Frameworks/Preferences.framework/Preferences"

void *airportHandle;
int (*open)(void *);
int (*bind)(void *, NSString *);
int (*close1)(void *);
int (*scan)(void *, NSArray **, void *);
int (*setPower)(void *, int);

BOOL currentWifiStatus()
{
	
}

void EnableWifi()
{
	void *libHandle =
	dlopen(PreferencesFrameworkPath,  RTLD_LAZY);
    int (*enable)(BOOL mode) = dlsym(libHandle, "_SetWiFiEnabled");
	enable(1);
}

void DisableWifi()
{
	//void *libHandle = dlopen("/System/Library/PrivateFrameworks/Preferences.framework/Preferences", RTLD_LAZY);
	void * libHandle = dlopen("/System/Library/SystemConfiguration/WiFiManager.bundle/WiFiManager", RTLD_LAZY);
	open = dlsym(libHandle, "Apple80211Open");
	bind = dlsym(libHandle, "Apple80211BindToInterface");
	close1 = dlsym(libHandle, "Apple80211Close");
	setPower = dlsym(libHandle, "Apple80211SetPower");
	
	NSLog(@"opening airport handle");
	
	open(&airportHandle);
	
	NSLog(@"binding airport handle");
	bind(airportHandle, @"en0");
	
	NSLog(@"setting power airport handle");
	setPower(airportHandle,0);
	
	time_t now = time(0);
	while(time(0) - now < 5)
	{
	}
	
	setPower(airportHandle,1);
	
	//scan = dlsym(libHandle, "Apple80211Scan");
	
	if(libHandle != NULL)
	{
		NSLog(@"got handle");
		
		int (*enable)(BOOL mode) = dlsym(libHandle, "setState");
		
		if(enable != NULL)
		{
			NSLog(@"got enable fn poointer");
			enable(FALSE);	
		}
		else
		{
			NSLog(@"null fn pointer");
		}
		
		
	}
	else
	{
		NSLog(@"lib handle is null");
	}
}