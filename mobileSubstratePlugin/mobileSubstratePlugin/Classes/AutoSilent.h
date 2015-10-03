#import "AutoSilentProtocol.h"
#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>

// Our intiialization point that will be called when the dylib is loaded
extern "C" void AutoSilentInitialize();
//extern "C" void * _CTServerConnectionCreate(CFAllocatorRef, int (*)(void *, CFStringRef, CFDictionaryRef, void *), int *);
//extern "C" int _CTServerConnectionSetVibratorState(int *, void *, int, int, float, float, float);


//inline BOOL WriteListToFile(CFStringRef url, CFPropertyListRef dataToWrite);
void	InitSBCallAlertDisplay();
void	InitSBCalendarAlertItem();
void InitSpringBoard();
void 	InitVolumeControlView();
void InitSBDisplay();
void InitSBMediaController();
void InitSBUIController();
void InitCurrentStatus();
void InitObserver();
BOOL isCurrentlySilent();
BOOL GetRingerSetting();
void StartVibrate();
void StopVibrate();
void StartRing();
void StopRing();
void InitVibrateMode();
BOOL GetVibrateSetting();
inline BOOL GetSilentSwithSetting();
inline void SetRingTonePath();
inline BOOL GetSystemVibrateSetting();
inline BOOL GetValue(CFStringRef fileUrl, CFStringRef key, BOOL defaultVal);




