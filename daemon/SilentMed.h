/*
 *  SilentMe.h
 *   silentme
 *
 *  Created by god on 4/21/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

static CFStringRef const DeamonSettingsPlistPath = CFSTR("/Applications/SilentMe.app/daemonsettings.plist");


inline BOOL isEnabled();
inline BOOL CreateLogDir();
//inline BOOL IsQuiteTime();
inline CFPropertyListRef GetSpringBoardPref();
inline CFPropertyListRef CreateListFromFile(CFStringRef filePath);
inline BOOL UpdateRingTone(CFStringRef ringtone);
inline BOOL WriteListToFile(CFStringRef url, CFPropertyListRef dataToWrite);
inline void RestartSpringBoard();
//NSString *silentRingTone = @"system:silentRingtone"; 
//inline void RevertToOrigSettings(inline BOOL vibrateOrig, inline BOOL voiceMailOrig, inline BOOL emailOrig, inline BOOL calAlertsOrig, NSString* ringToneOrig, NSDictionary* currentExpectedsettingDict, NSMutableDictionary* currentSettingsDict);
//inline void RevertToOrigSettings(inline BOOL vibrateOrig, inline BOOL voiceMailOrig, inline BOOL emailOrig, inline BOOL calAlertsOrig, NSString* ringToneOrig, NSDictionary* currentExpectedsettingDict, CFMutableDictionaryRef currentSettingsDict);
//inline void RevertToOrigSettings(inline BOOL vibrateOrig, inline BOOL voiceMailOrig, inline BOOL emailOrig, inline BOOL calAlertsOrig, CFStringRef ringToneOrig, CFDictionaryRef currentExpectedsettingDict, CFMutableDictionaryRef currentSettingsDict);
//inline BOOL RevertSpringBoardToOrigSettings();

inline BOOL RevertSpringBoardToOrigSettings(CFDictionaryRef origSettingsDict, CFDictionaryRef currentExpectedsettingDict);
inline BOOL RevertMobilePhonePlistToOrigSettings(CFDictionaryRef origSettingsDict, CFDictionaryRef currentExpectedsettingDict);
inline BOOL RevertEmailPlistToOrigSettings(CFDictionaryRef origSettingsDict, CFDictionaryRef currentExpectedsettingDict);
inline BOOL RevertSoundsPlistToOrigSettings(CFDictionaryRef origSettingsDict, CFDictionaryRef currentExpectedsettingDict);
inline void SetValue(NSMutableDictionary* dict, id key, id value);
inline BOOL DidUserOverride(CFTypeRef expected, CFTypeRef actual);
//inline BOOL DidUserOverride(inline BOOL expected, inline BOOL current);
inline BOOL DidUserOverrideRingTone(CFStringRef expected, CFStringRef actual);
inline CFTypeRef GetValue(CFDictionaryRef dict, const  void* key);
inline int GetIntegerValue(CFDictionaryRef dict, const  void* key);
inline BOOL SettoSilentMode(CFDictionaryRef settingDict, CFDictionaryRef deamonSettings);
inline BOOL RevertToOrigSettings();
inline BOOL UpdateSettings(CFDictionaryRef settingDict, BOOL overrideAndDisableApp);
inline void SetBOOLValue(CFMutableDictionaryRef dict, const  void* key,  BOOL val);
inline BOOL SetSpringBoardToSilentMode(CFMutableDictionaryRef expectedDict, CFMutableDictionaryRef origDict, CFDictionaryRef settingDict, CFDictionaryRef deamonSettings);
inline BOOL SetPhonePlistToSilentSettings(CFMutableDictionaryRef expectedDict, CFMutableDictionaryRef origDict, CFDictionaryRef settingDict, CFDictionaryRef deamonSettings);
inline BOOL SetEmailPlistToSilentSettings(CFMutableDictionaryRef expectedDict, CFMutableDictionaryRef origDict, CFDictionaryRef settingDict, CFDictionaryRef deamonSettings);
inline void Test();
inline void Repeat(CFStringRef source);
inline BOOL WriteToSpringBoardAndNotify(CFDictionaryRef springBoardDict, CFStringRef key);
inline BOOL WriteToSpringBoardAndNotify1(NSMutableDictionary* springBoardDict, id key, id value);
//inline BOOL WriteToSpringBoardAndNotify1(id springBoardDict, id key, id value);
inline BOOL WriteToFileAndNotify(id list, id key, id value, NSString* filePath, NSString* fileId);
inline BOOL SetPhonePlistToSilentSettings1(id expectedList, id origList, CFDictionaryRef settingDict, CFDictionaryRef deamonSettings);
inline BOOL SetSpringBoardToSilentMode1(id expectedList, id origList, CFDictionaryRef settingDict, CFDictionaryRef deamonSettings);
inline BOOL SetEmailPlistToSilentSettings1(id expectedList, id origList, CFDictionaryRef settingDict, CFDictionaryRef deamonSettings);
inline BOOL SetSoundsPlistToSilentSettings(id expectedList, id origList, CFDictionaryRef settingDict, CFDictionaryRef deamonSettings);
inline void Run(CFStringRef source, BOOL overrideAndDisableApp);
inline BOOL GetBoolValue(CFDictionaryRef dict, const void* key);
inline CFStringRef GetStringValue(CFDictionaryRef dict, const void* key);



inline void Log(CFStringRef message);
inline void LogSilent(CFStringRef message);
inline BOOL FileExists(NSString* path, BOOL isDir);
inline void AddOrUpdateKeyInPlist(NSString* path, id key, id value);
inline void FixSilentSwitch();
inline id GetValueFromPlist(NSString* path, id key);
inline void SetCustomList();