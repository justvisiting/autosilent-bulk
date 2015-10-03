#import <UIKit/UIKit.h>
#import <UIKit/UIApplication.h>
#include <dlfcn.h>
#include <stdio.h>
#import <unistd.h>
//#import <CoreTelephony/CoreTelephony.h>
#import "AirplaneMode.h"

// Framework Paths
#define SBSERVPATH  "/System/Library/PrivateFrameworks/SpringBoardServices.framework/SpringBoardServices"
#define UIKITPATH "/System/Library/Framework/UIKit.framework/UIKit"

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
	if(libHandle == NULL)
	{
		printf("count not find core telephony lib \n");
		
	}
	
    int (*enable)(int mode) = dlsym(libHandle, "CTPowerSetAirplaneMode");
	
    enable(1);
}
void enablePhone()
{
    void *libHandle = dlopen("/System/Library/PrivateFrameworks/CoreTelephony.framework/CoreTelephony", RTLD_LOCAL | RTLD_LAZY);
    int (*enable)(int mode) = dlsym(libHandle, "CTPowerSetAirplaneMode");
    enable(0);
}

int main1(int argc, char **argv)
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

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


