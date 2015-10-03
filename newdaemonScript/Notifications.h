
#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>


#define CopiedOrigSoundBehaviorPlistPath @"/private/var/mobile/Library/SilentMe/.OrigSystemSoundBehaviour.plist"
#define OrigSystemSoundBehaviourPlistPath @"/System/Library/PrivateFrameworks/Celestial.framework/SystemSoundBehaviour.plist"

#define RingerToggleStatusKey @"ringerToggleStatus"
//static CFStringRef RingerToggleStatusKey;// = CFSTR("ringerToggleStatus");

static void callback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo); 
 void WriteSilentSwitchStatus();
 void FixSilentSwitch();
 void UnfixSilentSwitch();

