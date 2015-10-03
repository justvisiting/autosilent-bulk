
#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>

static CFStringRef const NotificaitonByPassSilentSwitchOff = CFSTR("com.iphonepackers.ByPassSilentSwitchOff");
static CFStringRef const NotificaitonByPassSilentSwitchOn = CFSTR("com.iphonepackers.ByPassSilentSwitchOn");

static CFStringRef const NotificaitonByPassSilentSwitchOffFixed = CFSTR("com.iphonepackers.ByPassSilentSwitchOffFixed");
static CFStringRef const NotificaitonByPassSilentSwitchOnFixed = CFSTR("com.iphonepackers.ByPassSilentSwitchOnFixed");

#define CopiedOrigSoundBehaviorPlistPath @"/private/var/mobile/Library/SilentMe/OrigSystemSoundBehaviour.plist"
#define OrigSystemSoundBehaviourPlistPath @"/System/Library/PrivateFrameworks/Celestial.framework/SystemSoundBehaviour.plist"

static CFStringRef const NotificaitonRunDaemon = CFSTR("com.iphonepackers.runsilentMed");
static CFStringRef const NotificaitonringerToggleStatusOn = CFSTR("com.iphonepackers.ringerToggleStatusOn");
static CFStringRef const NotificaitonringerToggleStatusOff = CFSTR("com.iphonepackers.ringerToggleStatusOff");
static CFStringRef const NotificaitonSilentSwitchChanged = CFSTR("com.apple.springboard.ringerstate");

static CFStringRef const RingerToggleStatusKey = CFSTR("ringerToggleStatus");
static void callback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo); 
inline void WriteSilentSwitchStatus();

