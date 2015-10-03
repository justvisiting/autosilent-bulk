//
//  Logger.m
//  Util
//
//  Created by god on 5/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <CoreFoundation/CoreFoundation.h>
#import <UIKit/UIKit.h>
#import "Logger.h"
#import "Util.h"

static CFStringRef GlobalLogFilePath = CFSTR("/private/var/mobile/Library/SilentMe/global.plist");
static CFMutableDictionaryRef LogDictionary;



@implementation Logger
+ (void) initialize {
	//if ([self class] == [NSObject class]) {
		
		LogDictionary = CFDictionaryCreateMutable(kCFAllocatorDefault, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
	//}
	// Initialization for this class and any subclasses
}

+ (BOOL) WriteListToFile:(CFStringRef) url dtWrite:(CFPropertyListRef) dataToWrite
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

+ (void) Log:(NSString*) message
{
	NSLog(message);
	//printf("\n");
	
	NSDate* date = [NSDate date];
	NSString* apendMessage = [((NSString*)message) stringByAppendingString:[date description]];
	
	CFDictionarySetValue(LogDictionary, message, apendMessage);
	
	[Logger WriteListToFile:GlobalLogFilePath dtWrite:LogDictionary];
	
}

@end