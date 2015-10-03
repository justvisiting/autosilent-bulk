//
//  CheckAppType.h
//  Util
//
//  Created by god on 7/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

//#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>

inline NSString* GetEncodedText(NSString* clearText, NSString* key);
inline int CheckVal(CFDictionaryRef settingsDict, NSString* key, CFMutableDictionaryRef mutableDeamonSettingsDict);