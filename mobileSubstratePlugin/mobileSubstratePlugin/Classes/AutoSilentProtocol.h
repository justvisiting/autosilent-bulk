#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <SpringBoard/CDStructures.h>
#import <SpringBoard/SBApplicationIcon.h>
#import <SpringBoard/SBRingerHUDController.h>
#import <SpringBoard/VolumeControl.h>
#import <SpringBoard/SBTelephonyManager.h>
#import <SpringBoard/SBCallAlertDisplay.h>
#import <SpringBoard/SBCalendarAlertItem.h>
#import <SpringBoard/SpringBoard.h>
#import <objc/runtime.h>
#import "substrate.h"

// We import our headers, "SpringBoard" being the dumped headers placed in your include directory.

@protocol AutoSilent
- (void)__OriginalMethodPrefix_ringOrVibrate;
- (void)__OriginalMethodPrefix_stopRingingOrVibrating;
- (void)__OriginalMethodPrefix_ringerChanged;
@end


//http://blogs.oreilly.com/digitalmedia/2008/02/when-it-comes-to-the.html
//kCTIndicatorsVoiceMailNotification
//kCTCallStatusChangeNotification A call was received or ended.

//kCTSMSMessageReceivedNotification An SMS message was received.

//kCTUSSDSessionBeginNotification, kCTUSSDSessionStringNotification, and kCTUSSDSessionEndNotification USSD message sessions may use all three of these notifications.

//(void)volumeChanged:(struct __GSEvent *)fp8;
//stopRingingOrVibrating
//_ringIfNecessary
//_playMessageReceived
//AudioServicesPlaySystemSound




/*to get incoming call notifications, etc, etc.
 
 http://blogs.oreilly.com/digitalmedia/2008/02/when-it-comes-to-the.html
 
 
 

 to play uninterrputing audio
 http://tlxu.blogspot.com/
 http://blogs.oreilly.com/digitalmedia/2008/02/noninterrupting-audio-alerts.html
GSEventPlaySoundAtPath(@"/System/Library/CoreServices/SpringBoard.app/lock.aiff");

Add one line to LDFLAGS:
LDFLAGS += -framework GraphicsServices

Other related:
GSEventPlayAlertOrSystemSoundAtPath
GSEventPlaySoundLoopAtPath
GSEventPrimeSoundAtPath
GSEventStopSoundAtPath
*/