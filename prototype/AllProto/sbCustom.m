//does not work
#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIApplication.h>
#include <dlfcn.h>
#include <stdio.h>
#import <unistd.h>
#import <AudioToolbox/AudioToolbox.h>
//#import <CoreTelephony/CoreTelephony.h>
#import <objc/message.h>
#import <SpringBoard/SBApplication.h>

// Framework Paths
#define SBSERVPATH  "/System/Library/PrivateFrameworks/SpringBoardServices.framework/SpringBoardServices"
#define UIKITPATH "/System/Library/Framework/UIKit.framework/UIKit"

#define	kAppNetwork	CFSTR("com.apple.preferences.network")
#define	kKeyWifiNetwork	CFSTR("wifi-network")

void TurnItOn()
{
	CFPreferencesSetAppValue(kKeyWifiNetwork, kCFBooleanTrue, kAppNetwork);	
	CFPreferencesAppSynchronize(kAppNetwork);	
}

void TurnItOff()
{
	CFPreferencesSetAppValue(kKeyWifiNetwork, kCFBooleanFalse, kAppNetwork);	
	CFPreferencesAppSynchronize(kAppNetwork);	
}

static void* connection = nil;
static int x = 0;
static int intensity = 20;
extern void * _CTServerConnectionCreate(CFAllocatorRef, int (*)(void *, CFStringRef, CFDictionaryRef, void *), int *);
extern int _CTServerConnectionSetVibratorState(int *, void *, int, int, float, float, float);

int callback(void *connection, CFStringRef string, CFDictionaryRef dictionary, void *data) {
	NSLog(@"vibrated was called");
	return 1;
}


inline void StartVibrate()
{
	NSLog(@"In start vibrate");
	int rv = _CTServerConnectionSetVibratorState(&x, connection, 3, intensity, 0, 0, 0);
		NSLog(@"In start vibrate out %d, %d", x, rv);
	//_CTServerConnectionSetVibratorState(&x, connection, 3, 20.0, 1.0, 1.0, 2.0);
}

inline void StopVibrate()
{
	NSLog(@"stop vibrate");
	_CTServerConnectionSetVibratorState(&x, connection, 0, 0, 0, 0, 0);
}



int __vibrator(int seconds) {
	//printf("__vibrator()\n");
	//int* conn = __vibratorInit();
	
	connection = _CTServerConnectionCreate(kCFAllocatorDefault, &callback, &x);
	
	NSLog(@" conn %d, %d", connection, x);
	StartVibrate();
	
	//__vibratorStart(connection);
	time_t now = time(0);
	while(time(0) - now < seconds)
	{
	}
	//__vibratorStop(connection);
	StopVibrate();
	return 1;
}


BOOL detectStatus()
{
    void *libHandle = dlopen("/System/Library/PrivateFrameworks/CoreTelephony.framework/CoreTelephony", RTLD_LOCAL | RTLD_LAZY);
    int (*AirplaneMode)() = dlsym(libHandle, "CTPowerGetAirplaneMode");
    int status = AirplaneMode();
    return !status;
}

void disablePhone()
{


    void *libHandle = dlopen("/System/Library/PrivateFrameworks/CoreTelephony.framework/CoreTelephony", RTLD_LOCAL | RTLD_LAZY);
	
	//_CTServerConnectionSetVoiceMute
	//_CTSetVoiceMute
	if(libHandle == NULL)
	{
		printf("count not find core telephony lib \n");
		
	}
	
	//bus error
    int (*enable)(int mode) = dlsym(libHandle, "CTServerConnectionSetWifiPower");
	
	NSLog(@"_CTServerConnectionSetWifiPower");
    //enable(0);

	int (*enable1)(void) = dlsym(libHandle, "CTServerConnectionSetWifiPower");
	
	NSLog(@"_CTServerConnectionSetWifiPower 1");
   enable1();

	
	//bus error
//	int (*enable1)(void) = dlsym(libHandle, "_CTServerConnectionSetChannelMute");
//	NSLog(@"_CTServerConnectionSetChannelMute 1");
//	enable1();
	
	
	//bus error
	//int(*enable2)(int mode) = dlsym(libHandle, "_CTServerConnectionSetMasterMute");
	
	//	NSLog(@"_CTServerConnectionSetMasterMute");
  // enable2(1);

	//bus error
//	int (*enable3)(void) = dlsym(libHandle, "_CTServerConnectionSetMasterMute");

//		NSLog(@"_CTServerConnectionSetMasterMute 1");
//	enable3();

	//bus error
	//int (*enable4)(int mode) = dlsym(libHandle, "_CTServerConnectionSetVoiceMute");
	
	//	NSLog(@"_CTServerConnectionSetVoiceMute");
    //enable4(1);

	// bus error
//	int (*enable5)(void) = dlsym(libHandle, "_CTServerConnectionSetVoiceMute");
//		NSLog(@"_CTServerConnectionSetVoiceMute 1");
//	enable5();

	int (*enable6)(int mode) = dlsym(libHandle, "_CTSetChannelMute");
	
		NSLog(@"_CTSetChannelMute");
    enable6(1);

	int (*enable7)(void) = dlsym(libHandle, "_CTSetChannelMute");

		NSLog(@"_CTSetChannelMute 1");
	enable7();

	
	int (*enable8)(int mode) = dlsym(libHandle, "_CTSetMasterMute");
	
		NSLog(@"_CTSetMasterMute");
	enable8(1);
	
	int (*enable9)(void) = dlsym(libHandle, "_CTSetMasterMute");

	NSLog(@"_CTSetMasterMute 1");
	enable9();
	
	int (*enable10)(int mode) = dlsym(libHandle, "_CTSetVoiceMute");
	
		NSLog(@"_CTSetVoiceMute");
    enable10(1);

	int (*enable11)(void) = dlsym(libHandle, "_CTSetVoiceMute");

		NSLog(@"_CTSetVoiceMute 1");
	enable11();
	
}
void enablePhone()
{
    void *libHandle = dlopen("/System/Library/PrivateFrameworks/CoreTelephony.framework/CoreTelephony", RTLD_LOCAL | RTLD_LAZY);
    int (*enable)(int mode) = dlsym(libHandle, "CTPowerSetAirplaneMode");
    enable(0);
}

int main(int argc, char **argv)
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	TurnItOff();
	
	AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
//__vibrator(8);
	
	Class $SBStatusBarController = objc_getClass("SBStatusBarController");
	
	NSLog(@"setting status bar icon");
	
	if($SBStatusBarController != nil)
	{
		NSLog(@" really setting status bar icon");
		[[$SBStatusBarController sharedStatusBarController] addStatusBarItem:@"Bluetoooth"];
	}
	
   //
   // For testing try issuing the following: 
   //         ap y; sleep 5; ./ap n
   //

   if (argc < 2)
   {
      printf("Usage: %s (y | n)\n", argv[0]);
      exit(-1);
   }

   // Argument used to switch airplane mode off or on
   BOOL yorn = [[[NSString stringWithCString:argv[1]] 
                    uppercaseString] hasPrefix:@"Y"];

	if(yorn)
	{
		enablePhone();
	}
	else
	{
	disablePhone();
	}
	//enablePhone();
   // Fetch the SpringBoard server port
//   mach_port_t *p;
  // void *uikit = dlopen(UIKITPATH, RTLD_LAZY);
  // int (*SBSSpringBoardServerPort)() = 
    //     dlsym(uikit, "SBSSpringBoardServerPort");
   //p = SBSSpringBoardServerPort(); 
   //dlclose(uikit);

   // Link to SBSetAirplaneModeEnabled
//   void *sbserv = dlopen(SBSERVPATH, RTLD_LAZY);
  // int (*setAPMode)(mach_port_t* port, BOOL yorn) = 
    //     dlsym(sbserv, "SBSetAirplaneModeEnabled");
   //setAPMode(p, yorn);
   //dlclose(sbserv);

   //[pool release];
}


/*
 int callback(void *connection, CFStringRef string, CFDictionaryRef dictionary, void *data) {
 return 1;
 }
 
 int* __vibratorInit(void) {
 int x;
 printf("__vibrateInit()\n");
 return _CTServerConnectionCreate(kCFAllocatorDefault, callback, &x);
 }
 
 int __vibratorStart(int* conn) {
 int x = 0;
 return _CTServerConnectionSetVibratorState(&x, conn, 3, 20.0, 1.0, 1.0, 2.0);
 }
 
 int __vibratorStop(int* conn) {
 int x = 0;
 return _CTServerConnectionSetVibratorState(&x, conn, 0, 10, 10, 10, 10);
 }
 
 int __vibrator(int seconds) {
 printf("__vibrator()\n");
 int *conn = __vibratorInit();
 printf("__vibratorStart(%d)\n", conn);
 __vibratorStart(conn);
 printf("__vibratorStartdone(%d)\n", conn);
 time_t now = time(0);
 while(time(0) - now < seconds)
 {
 }
 printf("__vibratorStop\n");
 __vibratorStop(conn);
 return 1;
 }
 
 
 int main(int argc, char **argv)
 {
 NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
 __vibrator(4);
 }
 */
