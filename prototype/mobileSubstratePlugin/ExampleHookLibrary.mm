/*
 *  ExampleHookLibrary.mm
 *  
 *
 *  Created by John on 10/4/08.
 *  Copyright 2008 Gojohnnyboi. All rights reserved.
 *
 */


#import "ExampleHookLibrary.h"
#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <UIKit/UIKit.h>
#import <Celestial/AVSystemController.h>
#import <CoreGraphics/CoreGraphics.h>
#import <GraphicsServices/GraphicsServices.h>
#import "Finch.h"
#import "Sound+IO.h"
#import "RevolverSound.h"

extern "C" void GSEventPlaySoundAtPath(NSString* msg);
static CFStringRef LogFilePath = CFSTR("/private/var/mobile/Library/SilentMe/plugin.plist");
CFMutableDictionaryRef LogDictionary;
MainItem* playObj;
Float32 readSessionCategory = kAudioSessionCategory_MediaPlayback;

SystemSoundID pmph;

static void __$ExampleHook_AppIcon_Launch(SBApplicationIcon<ExampleHook> *_SBApplicationIcon) {
//ringerChanged
//
 //{
//	 Log(CFSTR("launch"));
	 
	 // If at any point we wanted to have it actually launch we should do:
	 [_SBApplicationIcon __OriginalMethodPrefix_launch];
}


static void __$ExampleHook_AppIcon__systemVolumeChanged(VolumeControl<ExampleHook> *_VolumeControl)
{
	
	Log(CFSTR("systemVolumeChanged"));
	// If at any point we wanted to have it actually launch we should do:
	// [_VolumeControl __OriginalMethodPrefix_systemVolumeChanged];
}

static void __$ExampleHook_AppIcon__volumeModeForCategory(VolumeControl<ExampleHook> *_VolumeControl)
{
	Log(CFSTR("_volumeModeForCategory"));
}


static void __$ExampleHook_AppIcon_handleVolumeEvent(VolumeControl<ExampleHook> *_VolumeControl)
{
	Log(CFSTR("t"));
	
	// If at any point we wanted to have it actually launch we should do:
	// [_VolumeControl __OriginalMethodPrefix_handleVolumeEvent];
}




static void __$ExampleHook_AppIcon_setMode(VolumeControl<ExampleHook> *_VolumeControlView)
{
	Log(CFSTR("t"));
	
	// If at any point we wanted to have it actually launch we should do:
	// [_VolumeControl __OriginalMethodPrefix_handleVolumeEvent];
}


static void __$ExampleHook_AppIcon_setVolume(VolumeControlView<ExampleHook> *_VolumeControlView)
{
	Log(CFSTR("t"));
	
	// If at any point we wanted to have it actually launch we should do:
	// [_VolumeControl __OriginalMethodPrefix_handleVolumeEvent];
}

static void __$ExampleHook_AppIcon_answerIncomingCall(SBTelephonyManager<ExampleHook> *_SBTelephonyManager)
{
	Log(CFSTR("answerincoming call"));
	
	// If at any point we wanted to have it actually launch we should do:
	// [_VolumeControl __OriginalMethodPrefix_handleVolumeEvent];
}


static void __$ExampleHook_AppIcon_ringOrVibrate(SBCallAlertDisplay<ExampleHook> *_SBCallAlertDisplay)
{
	Log(CFSTR("ring or vibrate"));
	
		[playObj initWithFrame];
	// If at any point we wanted to have it actually launch we should do:
	//[_SBCallAlertDisplay __OriginalMethodPrefix_ringOrVibrate];
}



static void __$ExampleHook_AppIcon_stopRingingOrVibrating(SBCallAlertDisplay<ExampleHook> *_SBCallAlertDisplay)
{
	[playObj stopRinging];

	Log(CFSTR("stop ringing or vibrating1"));
	
	// If at any point we wanted to have it actually launch we should do:
	 [_SBCallAlertDisplay __OriginalMethodPrefix_stopRingingOrVibrating];
}


static void __$ExampleHook_AppIcon_ringerChanged(SBCallAlertDisplay<ExampleHook> *_SBCallAlertDisplay)
{
	Log(CFSTR("ringer changed"));
	
	// If at any point we wanted to have it actually launch we should do:
	// [_VolumeControl __OriginalMethodPrefix_handleVolumeEvent];
}


static void __$ExampleHook_AppIcon__ringIfNecessary(SBCallAlertDisplay<ExampleHook> *_SBCallAlertDisplay)
{

	Log(CFSTR("ringifnecessary"));
	
	// If at any point we wanted to have it actually launch we should do:
	[_SBCallAlertDisplay __OriginalMethodPrefix__ringIfNecessary];
}


static void __$ExampleHook_AppIcon_answerCall(SBCallAlertDisplay<ExampleHook> *_SBCallAlertDisplay)
{
	Log(CFSTR("answercall"));
	
	// If at any point we wanted to have it actually launch we should do:
	// [_VolumeControl __OriginalMethodPrefix_handleVolumeEvent];
}

static void __$ExampleHook_AppIcon_revealEvent(SBCalendarAlertItem<ExampleHook> *_SBCalendarAlertItem)
{
	Log(CFSTR("reveal event"));
}

static void __$ExampleHook_AppIcon_alarmsDidFire(SBCalendarAlertItem<ExampleHook> *_SBCalendarAlertItem)
{
	Log(CFSTR("alarms did fire"));
}

static void __$ExampleHook_AppIcon_willActivate(SBCalendarAlertItem<ExampleHook> *_SBCalendarAlertItem)
{
	Log(CFSTR("will activate"));
}

static void __$ExampleHook_AppIcon_volumechanged(SpringBoard<ExampleHook> *_SpringBoard)
{
	Log(CFSTR(" springboard volumechanged"));
}

static void __$ExampleHook_AppIcon_sbringerChanged(SpringBoard<ExampleHook> *_SpringBoard)
{
	Log(CFSTR("sb ringer changed"));
	
	// If at any point we wanted to have it actually launch we should do:
	// [_VolumeControl __OriginalMethodPrefix_handleVolumeEvent];
}

static void __$ExampleHook_AppIcon_setSystemVolumeHUDEnabled(SBDisplay<ExampleHook> *_SBDisplay)
{
	Log(CFSTR("SBDisplay"));
	
	// If at any point we wanted to have it actually launch we should do:
	// [_VolumeControl __OriginalMethodPrefix_handleVolumeEvent];
}

static void __$ExampleHook_AppIcon_vcvsetVolume(VolumeControlView<ExampleHook> *_VolumeControlView)
{
	Log(CFSTR("VolumeControlView setvolume"));
	
	// If at any point we wanted to have it actually launch we should do:
	// [_VolumeControl __OriginalMethodPrefix_handleVolumeEvent];
}

static void __$ExampleHook_AppIcon_vcvsetMode(VolumeControlView<ExampleHook> *_VolumeControlView)
{
	Log(CFSTR("VolumeControlView setMode"));
	
	// If at any point we wanted to have it actually launch we should do:
	// [_VolumeControl __OriginalMethodPrefix_handleVolumeEvent];
}



static void __$ExampleHook_AppIcon_SBUIControllerhandleVolumeEvent(SBUIController<ExampleHook> *_SBUIController)
{
	Log(CFSTR("SBUIController handleVolumeEvent"));
}

static void __$ExampleHook_AppIcon_SBCallAlertDisplayhandleVolumeEvent(SBCallAlertDisplay<ExampleHook> *_SBCallAlertDisplay)
{
	Log(CFSTR("SBCallAlertDisplay handleVolumeEvent"));
}


static void __$ExampleHook_AppIcon_SBMediaControllerhandleVolumeEvent(SBMediaController<ExampleHook> *_SBMediaController)
{
	Log(CFSTR("SBMediaController handleVolumeEvent"));
}



extern "C" void ExampleHookInitialize() {
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	
	LogDictionary = CFDictionaryCreateMutable(kCFAllocatorDefault, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);

	playObj = [MainItem alloc];
	
	// Get the SBApplicationIcon class
	//Class _$SBAppIcon = objc_getClass("SBApplicationIcon");
	Class _$SBAppIcon = objc_getClass("VolumeControl");
	
	// MSHookMessage is what we use to redirect the methods to our own
	//MSHookMessage(_$SBAppIcon, @selector(launch), (IMP) &__$ExampleHook_AppIcon_Launch, "__OriginalMethodPrefix_");
	MSHookMessage(_$SBAppIcon, @selector(_systemVolumeChanged), (IMP) &__$ExampleHook_AppIcon__systemVolumeChanged, "__OriginalMethodPrefix_");

	MSHookMessage(_$SBAppIcon, @selector(_volumeModeForCategory), (IMP) &__$ExampleHook_AppIcon__volumeModeForCategory, "__OriginalMethodPrefix_");

	MSHookMessage(_$SBAppIcon, @selector(handleVolumeEvent), (IMP) &__$ExampleHook_AppIcon_handleVolumeEvent, "__OriginalMethodPrefix_");

	MSHookMessage(_$SBAppIcon, @selector(setMode), (IMP) &__$ExampleHook_AppIcon_setMode, "__OriginalMethodPrefix_");

//	MSHookMessage(_$SBAppIcon, @selector(setVolume), (IMP) &__$ExampleHook_AppIcon_setVolume, "__OriginalMethodPrefix_");

//	MSHookMessage(_$SBAppIcon, @selector(answerIncomingCall), (IMP) &__$ExampleHook_AppIcon_answerIncomingCall, "__OriginalMethodPrefix_");
	
	InitSBCallAlertDisplay();
	InitSBCalendarAlertItem();
	InitSpringBoard();
	InitVolumeControlView();
	InitSBDisplay();
	InitSBUIController();
	InitSBMediaController();
	// We just redirected SBApplicationIcon's "launch" to our custom method, and now we are done.
	
	[pool release];
}

void 	InitVolumeControlView()
{
	Class _$SBAppIcon = objc_getClass("VolumeControlView");
	
	MSHookMessage(_$SBAppIcon, @selector(setMode), (IMP) &__$ExampleHook_AppIcon_vcvsetMode, "__OriginalMethodPrefix_");

	MSHookMessage(_$SBAppIcon, @selector(setVolume), (IMP) &__$ExampleHook_AppIcon_vcvsetVolume, "__OriginalMethodPrefix_");

}


void InitSBMediaController()
{
	Class _$SBAppIcon = objc_getClass("SBMediaController");
	
	MSHookMessage(_$SBAppIcon, @selector(handleVolumeEvent), (IMP) &__$ExampleHook_AppIcon_SBMediaControllerhandleVolumeEvent, "__OriginalMethodPrefix_");
	
}

void InitSBUIController()
{
	Class _$SBAppIcon = objc_getClass("SBUIController");
	
	MSHookMessage(_$SBAppIcon, @selector(handleVolumeEvent), (IMP) &__$ExampleHook_AppIcon_SBUIControllerhandleVolumeEvent, "__OriginalMethodPrefix_");
		
}


void InitSpringBoard()
{
	Class _$SBAppIcon = objc_getClass("SpringBoard");
	
	MSHookMessage(_$SBAppIcon, @selector(volumechanged), (IMP) &__$ExampleHook_AppIcon_volumechanged, "__OriginalMethodPrefix_");

	MSHookMessage(_$SBAppIcon, @selector(ringerChanged), (IMP) &__$ExampleHook_AppIcon_sbringerChanged, "__OriginalMethodPrefix_");

	
	

}

void InitSBDisplay()
{
	Class _$SBAppIcon = objc_getClass("SBDisplay");
	MSHookMessage(_$SBAppIcon, @selector(setSystemVolumeHUDEnabled), (IMP) &__$ExampleHook_AppIcon_setSystemVolumeHUDEnabled, "__OriginalMethodPrefix_");

}



void InitSBCalendarAlertItem()
{
	Class _$SBAppIcon = objc_getClass("SBCalendarAlertItem");
	
	MSHookMessage(_$SBAppIcon, @selector(revealEvent), (IMP) &__$ExampleHook_AppIcon_revealEvent, "__OriginalMethodPrefix_");
	MSHookMessage(_$SBAppIcon, @selector(alarmsDidFire), (IMP) &__$ExampleHook_AppIcon_alarmsDidFire, "__OriginalMethodPrefix_");
	MSHookMessage(_$SBAppIcon, @selector(willActivate), (IMP) &__$ExampleHook_AppIcon_willActivate, "__OriginalMethodPrefix_");
}	
/*
 - (void)__OriginalMethodPrefix_ringOrVibrate;
 - (void)__OriginalMethodPrefix_stopRingingOrVibrating;
 - (void)__OriginalMethodPrefix_ringerChanged;
 - (void)__OriginalMethodPrefix__ringIfNecessary;
 - (void)__OriginalMethodPrefix_answerCall;
 */
void InitSBCallAlertDisplay()
{
	Class _$SBAppIcon = objc_getClass("SBCallAlertDisplay");
	
	MSHookMessage(_$SBAppIcon, @selector(ringOrVibrate), (IMP) &__$ExampleHook_AppIcon_ringOrVibrate, "__OriginalMethodPrefix_");
	
	MSHookMessage(_$SBAppIcon, @selector(stopRingingOrVibrating), (IMP) &__$ExampleHook_AppIcon_stopRingingOrVibrating, "__OriginalMethodPrefix_");
	
	MSHookMessage(_$SBAppIcon, @selector(ringerChanged), (IMP) &__$ExampleHook_AppIcon_ringerChanged, "__OriginalMethodPrefix_");
	
	MSHookMessage(_$SBAppIcon, @selector(_ringIfNecessary), (IMP) &__$ExampleHook_AppIcon__ringIfNecessary, "__OriginalMethodPrefix_");

	MSHookMessage(_$SBAppIcon, @selector(answerCall), (IMP) &__$ExampleHook_AppIcon_answerCall, "__OriginalMethodPrefix_");
	
	MSHookMessage(_$SBAppIcon, @selector(handleVolumeEvent), (IMP) &__$ExampleHook_AppIcon_SBCallAlertDisplayhandleVolumeEvent, "__OriginalMethodPrefix_");


}

inline void Log(CFStringRef message)
{	 
	NSDate* date = [NSDate date];
	NSString* apendMessage = [((NSString*)message) stringByAppendingString:[date description]];
	
	CFDictionarySetValue(LogDictionary, message, apendMessage);
	
	 WriteListToFile(LogFilePath, LogDictionary);
}


inline BOOL WriteListToFile(CFStringRef url, CFPropertyListRef dataToWrite)
{
	if(url != NULL)
	{
		SInt32 errorCode;
		
		CFURLRef fileUrl = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, url, kCFURLPOSIXPathStyle, false);
		
		CFDataRef xmlData;
		Boolean status;
		
		// Convert the property list into XML data.
		xmlData = CFPropertyListCreateXMLData( kCFAllocatorDefault, dataToWrite);
		
		// Write the XML data to the file.
		status = CFURLWriteDataAndPropertiesToResource (
														fileUrl,                  // URL to use
														xmlData,                  // data to write
														NULL,
														&errorCode);
		
		CFRelease(xmlData);
		
		//TBD retry if fail
		
		CFRelease(fileUrl);
		
		return status;
	}
	
	return FALSE;
}


@implementation MainItem
- (void)initWithFrame {

	
	UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
	AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory);    

	UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
	AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,sizeof (audioRouteOverride),&audioRouteOverride);

	AudioSessionSetActive(true);
	
	
	
		Log(CFSTR("was in play ringtone"));
//it works in silent mode, 
	//yes it works in silent mode...!!!
	NSError *err;
	av = [ [ AVController alloc ] init ];
	[ av setMuted: NO ];
	[ av setVolume: 10.0 ];
	[ av setRepeatMode: 1 ];
	
	avq = [ [ AVQueue alloc ] init ];
	
	item1 = [ [ AVItem alloc ]
			 initWithPath:@"/Library/Ringtones/Harp.m4r" error:&err
			 ];
	if (err != nil)
				Log((CFStringRef)err);
	
	
	[ avq appendItem: item1 error: &err ];
	
	[ av setQueue: avq ];
	[ av play:nil ];
	Log(CFSTR("was in play ringtone"));
 
}

- (void)stopRinging
{
	[av pause];
	[avq removeAllItems];


}

- (void)dealloc
{
	Log(CFSTR("dealloc was called"));
}

@end
