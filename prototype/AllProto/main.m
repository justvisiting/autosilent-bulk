#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>

#import "WifiToggle.h"
#import "3gToggle.h"

int main(int argc, char **argv)
 {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    // insert code here...
  //  CFShow(CFSTR("Hello, World!\n"));
	DisableWifi();
	 Toggle3g();
    return 0;
}
