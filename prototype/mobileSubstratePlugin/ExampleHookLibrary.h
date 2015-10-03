/*
 *  ExampleHookLibrary.h
 *  
 *
 *  Created by John on 10/4/08.
 *  Copyright 2008 Gojohnnyboi. All rights reserved.
 *
 */

#import "ExampleHookProtocol.h"
#import <Celestial/AVItem.h>
#import <Celestial/AVQueue.h>
#import <Celestial/AVController.h>
#import <AudioToolbox/AudioToolbox.h>
//#import <AVFoundation/AVAudioPlayer.h>

// Our method to override the launch of the icon
static void __$ExampleHook_AppIcon_Launch(SBApplicationIcon<ExampleHook> *_SBApplicationIcon);

//static void __$ExampleHook_AppIcon_Launch(VolumeControl<ExampleHook> *_VolumeControl);

static void __$ExampleHook_AppIcon_handleVolumeEvent(VolumeControl<ExampleHook> *_VolumeControl);

static void __$ExampleHook_AppIcon_systemVolumeChanged(VolumeControl<ExampleHook> *_VolumeControl);

/*
- (void)__OriginalMethodPrefix_ringOrVibrate;
- (void)__OriginalMethodPrefix_stopRingingOrVibrating;
- (void)__OriginalMethodPrefix_ringerChanged;
- (void)__OriginalMethodPrefix__ringIfNecessary;
- (void)__OriginalMethodPrefix_answerCall;
*/

//works
static void __$ExampleHook_AppIcon_ringOrVibrate(SBCallAlertDisplay<ExampleHook> *_SBCallAlertDisplay);

//works
static void __$ExampleHook_AppIcon_stopRingingOrVibrating(SBCallAlertDisplay<ExampleHook> *_SBCallAlertDisplay);

static void __$ExampleHook_AppIcon_ringerChanged(SBCallAlertDisplay<ExampleHook> *_SBCallAlertDisplay);

static void __$ExampleHook_AppIcon__ringIfNecessary(SBCallAlertDisplay<ExampleHook> *_SBCallAlertDisplay);

static void __$ExampleHook_AppIcon_answerCall(SBCallAlertDisplay<ExampleHook> *_SBCallAlertDisplay);

static void __$ExampleHook_AppIcon_revealEvent(SBCalendarAlertItem<ExampleHook> *_SBCalendarAlertItem);

static void __$ExampleHook_AppIcon_volumechanged(SpringBoard<ExampleHook> *_SpringBoard);

// Our intiialization point that will be called when the dylib is loaded
extern "C" void ExampleHookInitialize();


inline BOOL WriteListToFile(CFStringRef url, CFPropertyListRef dataToWrite);
inline void Log(CFStringRef message);
void	InitSBCallAlertDisplay();
void	InitSBCalendarAlertItem();
void InitSpringBoard();
void 	InitVolumeControlView();
void InitSBDisplay();
void InitSBMediaController();
void InitSBUIController();



@interface MainItem : NSObject
{
    AVController *av;
    AVItem       *item1, *item2;
    AVQueue      *avq;
}

- (void)initWithFrame;
- (void)stopRinging;
- (void)dealloc;

@end