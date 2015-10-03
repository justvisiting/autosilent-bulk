/*
 *  ExampleHookProtocol.h
 *  
 *
 *  Created by John on 10/4/08.
 *  Copyright 2008 Gojohnnyboi. All rights reserved.
 *
 */

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
#import <SpringBoard/SBDisplay.h>
#import <SpringBoard/SBMediaController.h>
#import <SpringBoard/SBDeleteIconAlertItem.h>
#import <objc/runtime.h>
#import "substrate.h"

// We import our headers, "SpringBoard" being the dumped headers placed in your include directory.

@protocol ExampleHook

// When we redirect the "launch" method, we will specify this prefix, which
// will allow us to call the original method if desired.
- (void)__OriginalMethodPrefix_launch;
- (void)__OriginalMethodPrefix_systemVolumeChanged;
- (void)__OriginalMethodPrefix_handleVolumeEvent;
- (void)__OriginalMethodPrefix_setVolume;
- (void)__OriginalMethodPrefix_setMode;
//call alert display
//SBCallAlertDisplay
- (void)__OriginalMethodPrefix_ringOrVibrate;
- (void)__OriginalMethodPrefix_stopRingingOrVibrating;
- (void)__OriginalMethodPrefix_ringerChanged;
- (void)__OriginalMethodPrefix__ringIfNecessary;
- (void)__OriginalMethodPrefix_answerCall;
//SBCalendarAlertItem
- (void)__OriginalMethodPrefix_revealEvent;
//- (void)__OriginalMethodPrefix_answerCall;
//- (void)__OriginalMethodPrefix_answerCall;
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
//AudioServicesPlayAlertSound is preferred against AudioServicesPlaySystemSound




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