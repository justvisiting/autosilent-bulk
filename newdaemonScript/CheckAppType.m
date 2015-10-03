//
//  CheckAppType.m
//  Util
//
//  Created by god on 7/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
///Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS2.2.sdk/usr/include/CommonCrypto/CommonHMAC.h


#import <CommonCrypto/CommonHMAC.h>

#if IS_IPHONE
#import <UIKit/UIDevice.h>
#endif

//#import "OAHMAC_SHA1SignatureProvider.h"
#include "Base64Transcoder.h"
#import "CheckAppType.h"
#import "configManager.h"

 NSString* GetEncodedText(NSString* text, NSString* secret)
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


 int CheckVal(NSString* key)
{
	int retVal = 2;
	
	NSString* codeV = [configManager GetCurrentType];
	
	NSString* uniqueId = nil;
#if IS_IPHONE
	uniqueId = [[UIDevice currentDevice] uniqueIdentifier]; 
#endif
	
	NSString* hash = GetEncodedText(uniqueId, key);
	
	if(hash != NULL && codeV != NULL && [hash compare:codeV options:NSCaseInsensitiveSearch] == NSOrderedSame)
	{
		retVal = 0;
	}
	else 
	{
		NSFileManager *fm = [NSFileManager defaultManager];
		NSError* err;
		
		NSDictionary* dict = [fm attributesOfItemAtPath:@"/Applications/SilentMe.app/SilentMe" error:&err];
		
		if(dict != nil)
		{
			NSDate* calModifiedDatetime = [dict objectForKey:NSFileModificationDate];
		
			if((int)[calModifiedDatetime timeIntervalSinceNow] > (-24*60*60*5))
			{
				NSString* manualMode = [configManager GetManualId];
				
				if(manualMode != nil)
				{
					NSDateFormatter *df = [[NSDateFormatter alloc] init];
					[df setDateFormat:@"yyyyMMdd"];
					NSDate *myDate = [df dateFromString: manualMode];
					if((int)[myDate timeIntervalSinceNow] > ((-24*60*60*5))
					{
						retVal = 0;
					}
					
				}
				else
					{
						retVal = 0;
					}
			}
		}
	}
	
	return retVal;
}