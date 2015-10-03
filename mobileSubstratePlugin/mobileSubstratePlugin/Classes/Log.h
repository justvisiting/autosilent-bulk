//
//  Log.h
//  AllProto
//
//  Created by god on 9/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <UIKit/UIKit.h>

static NSString* LogFilePath = @"/private/var/mobile/Library/SilentMe/plugin.plist";
static NSMutableArray* LogArray;

static void Log(NSString* message)
{
	
	if(LogArray == nil)
	{
		LogArray = [[NSMutableArray alloc] init];
		
	}
	
	if([LogArray count] > 50)
	{
		[LogArray removeAllObjects];
	}
	
	
	NSDate* date = [NSDate date];
	NSString* apendMessage = [((NSString*)message) stringByAppendingString:[date description]];
	[LogArray addObject:apendMessage];
	[LogArray writeToFile:LogFilePath atomically:YES];
	
}
