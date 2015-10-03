//
//  CheckAppType.m
//  Util
//
//  Created by god on 7/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
///Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS2.2.sdk/usr/include/CommonCrypto/CommonHMAC.h


#import <CommonCrypto/CommonHMAC.h>
#import <UIKit/UIDevice.h>

//#import "OAHMAC_SHA1SignatureProvider.h"
#include "Base64Transcoder.h"
#import "CheckAppType.h"
#import "SilentMed.h"

static CFStringRef const CodeK = CFSTR("key");
static CFStringRef const IsCodeNotPreium = CFSTR("IsKeyNotValid");

inline NSString* GetEncodedText(NSString* text, NSString* secret)
{
	NSData *secretData = [secret dataUsingEncoding:NSUTF8StringEncoding];
    NSData *clearTextData = [text dataUsingEncoding:NSUTF8StringEncoding];
	
    uint8_t digest[CC_SHA1_DIGEST_LENGTH] = {0};
	
    CCHmacContext hmacContext;
    CCHmacInit(&hmacContext, kCCHmacAlgSHA1, secretData.bytes, secretData.length);
    CCHmacUpdate(&hmacContext, clearTextData.bytes, clearTextData.length);
    CCHmacFinal(&hmacContext, digest);
	
    //Base64 Encoding
    
    char base64Result[32];
    size_t theResultLength = 32;
    Base64EncodeData(digest, CC_SHA1_DIGEST_LENGTH, base64Result, &theResultLength);
    NSData *theData = [NSData dataWithBytes:base64Result length:theResultLength];
    
    NSString *base64EncodedResult = [[NSString alloc] initWithData:theData encoding:NSUTF8StringEncoding];
    
    return [base64EncodedResult autorelease];
}


inline int CheckVal(CFDictionaryRef settingsDict, NSString* key, CFMutableDictionaryRef mutableDeamonSettingsDict)
{
	int retVal = 2;
	
	CFStringRef codeV = GetStringValue(settingsDict, CodeK); //key
	
	NSString* uniqueId = [[UIDevice currentDevice] uniqueIdentifier]; 
	
	NSString* hash = GetEncodedText(uniqueId, key);
	
	//Log((CFStringRef)hash);
	
	if(hash != NULL && codeV != NULL && [hash compare:(NSString*)codeV options:NSCaseInsensitiveSearch] == NSOrderedSame)
	{
		//Log(CFSTR("preimulm edition"));
		retVal = 0;
		if (mutableDeamonSettingsDict != NULL)
		{
			CFDictionarySetValue(mutableDeamonSettingsDict, IsCodeNotPreium, kCFBooleanFalse);
		}
	}
	else 
	{
		//Log(CFSTR("lite edition"));
		
		if (mutableDeamonSettingsDict != NULL)
		{
			
			CFStringRef upTimeStr = CFSTR("DUpTime");
			
			CFDateRef startDate = CFDictionaryGetValue(mutableDeamonSettingsDict, upTimeStr);
			CFAbsoluteTime current = CFAbsoluteTimeGetCurrent();
			CFAbsoluteTime startDateAbs;
			
			
			
			//code for lite version
				if(startDate == NULL)
				{
					CFDateRef dateToSet = CFDateCreate(kCFAllocatorDefault, current);
					CFDictionarySetValue(mutableDeamonSettingsDict, upTimeStr, dateToSet);
				
					startDateAbs = current;
			
				}
				else
				{
					startDateAbs = CFDateGetAbsoluteTime(startDate);				
				}
			
			
			CFGregorianUnits units = CFAbsoluteTimeGetDifferenceAsGregorianUnits
					(current, startDateAbs, NULL, (kCFGregorianUnitsDays));
		    
			if(codeV != NULL && CFStringGetLength(codeV) != 0)
			{//key is present but not valid
				CFDictionarySetValue(mutableDeamonSettingsDict, IsCodeNotPreium, kCFBooleanTrue);
			}
		
			if(units.days >= 0 && units.days <=7)
			{
				retVal = 0;
			}
		}
	}
	
	return retVal;
}