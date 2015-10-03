//
//  anticrack.h
//
//  Created by Oliver Drobnik on 12.05.09.
//  Copyright 2009 Drobnik.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "anticrack_scan_result.h"

//int main (int argc, char *argv[]);

/*
 return value is a bitmask of
 
 1 ... info.plist is binary or text but originally was the other
 2 ... number of entries was modified
 4 ... there's a string with key 'SignerIdentitiy'
 8 ... byte size of info.plist is different

*/


static inline int cracked()
{
	// setting up an autorelease pool, so that our working memory is cleared after this block
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	int suspect = 0;
	NSString *infoPath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
	NSData *data = [NSData dataWithContentsOfFile:infoPath];
	NSString *sourceSt = [[[NSString alloc] initWithBytes:[data bytes] length:8 encoding:NSUTF8StringEncoding] autorelease];
	// load original info.plist
	NSDictionary *info = [NSDictionary dictionaryWithContentsOfFile:infoPath];

	
#ifdef INFO_PLIST_XML	
	suspect+=([sourceSt isEqualToString:@"<?xml ve"])?0:1;
#else
#ifdef INFO_PLIST_BIN
	suspect+=([sourceSt isEqualToString:@"bplist00"])?0:1; 
#else
	// no data on info.plist yet, just return 0
	NSLog(@"AntiCrack not armed. Build once more to activate.");
	return 0;
#endif	
#endif

#ifdef INFO_PLIST_SIZE	
	// check size
	suspect+=([data length]==INFO_PLIST_SIZE)?0:8;    
#endif

#ifdef INFO_PLIST_ENTRIES	
	suspect += ([info count]==INFO_PLIST_ENTRIES)?0:2;
#endif
	
	// check for presence of Apple fake signature
	
	// build 'SignerIdentity' string from class names
	// this obfuscates the string
	
	// for some 
	NSMutableString *error = [[NSMutableString alloc] init];
	[error appendString:[NSStringFromClass([NSString class]) substringWithRange:NSMakeRange(1, 1)]]; // S
	[error appendString:[NSStringFromClass([NSString class]) substringWithRange:NSMakeRange(5, 1)]]; // i
	[error appendString:[NSStringFromClass([NSString class]) substringWithRange:NSMakeRange(7, 1)]]; // g
	[error appendString:[NSStringFromClass([NSString class]) substringWithRange:NSMakeRange(6, 1)]]; // n
	[error appendString:[NSStringFromClass([NSNumber class]) substringWithRange:NSMakeRange(6, 2)]]; // er
	[error appendString:[NSStringFromClass([NSIndexPath class]) substringWithRange:NSMakeRange(2, 1)]]; // I
	[error appendString:[NSStringFromClass([NSIndexPath class]) substringWithRange:NSMakeRange(4, 2)]]; // de
	[error appendString:[NSStringFromClass([NSString class]) substringWithRange:NSMakeRange(6, 1)]]; // n
	[error appendString:[NSStringFromClass([NSIndexPath class]) substringWithRange:NSMakeRange(9, 1)]]; // t
	[error appendString:[NSStringFromClass([NSString class]) substringWithRange:NSMakeRange(5, 1)]]; // i
	[error appendString:[NSStringFromClass([NSIndexPath class]) substringWithRange:NSMakeRange(9, 1)]]; // t
	[error appendString:[NSStringFromClass([NSArray class]) substringWithRange:NSMakeRange(6, 1)]]; // y
	
	suspect+=(![info objectForKey: error])?0:4; 
	[error release];

	// we're releasing our working memory
	[pool drain];

	return suspect;
}
