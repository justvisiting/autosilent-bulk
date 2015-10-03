//
//  logger.m
//  newdaemon
//
//  Created by god on 10/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import <CoreFoundation/CoreFoundation.h>

#import "logger.h"
#define GlobalLogFilePath @"/private/var/mobile/Library/SilentMe/Log.plist"
static LogLevelType LogLevel = CriticalError | Warning ;

static int MaxItemCountInLoggingFile = 50;
static NSMutableArray* InfoLogArray;
static NSMutableArray* ErrorLogArray;
static NSMutableArray* WarningLogArray;
static int InfofileCounter = 0;
static int WarningfileCounter = 0;
static int ErrorfileCounter = 0;

NSString* InfofilePath;
NSString* ErrorfilePath;
NSString* WarningfilePath;
NSString* name = @"D";

 void Log(CFStringRef msg)
{
	//[logger Log:(NSString*)msg];
}


@implementation logger
+ (void) initLogger:(NSString*) source
{
	[source retain];
	name = source;
	
	InfoLogArray = [[NSMutableArray alloc] init];
	InfofilePath = 
	[[NSString stringWithFormat:@"/private/var/mobile/Library/SilentMe/Info%@.plist", name] retain];

	WarningLogArray = [[NSMutableArray alloc] init];
	WarningfilePath = 
	[[NSString stringWithFormat:@"/private/var/mobile/Library/SilentMe/Warn%@.plist", name] retain];

	ErrorLogArray = [[NSMutableArray alloc] init];
	ErrorfilePath = 
	[[NSString stringWithFormat:@"/private/var/mobile/Library/SilentMe/Error%@.plist", name] retain];

}

+ (void) LogMessage: (NSMutableArray*) LogArray filePath:(NSString*) path msg:(NSString*) message
{
	
	NSDate* date = [NSDate date];
	NSString* apendMessage = [((NSString*)message) stringByAppendingString:[date description]];
	[LogArray addObject:apendMessage];
	[LogArray writeToFile:path atomically:YES];
	
}

+ (void) Log: (NSString*) message level: (LogLevelType) level
{
	
		//NSLog(message);
	
	if((level & LogLevel & Information) != 0)
	{
		[logger LogMessage:InfoLogArray filePath:InfofilePath msg:message];
		
		if([InfoLogArray count] >= MaxItemCountInLoggingFile*5)
		{
			[InfoLogArray removeAllObjects];
			InfofileCounter++;
			int fileNumber = InfofileCounter % 5;
			
			[InfofilePath release];
			InfofilePath = [[NSString stringWithFormat:@"/private/var/mobile/Library/SilentMe/Info%@%d.plist", name ,fileNumber] retain];

		}
	}
	if((level & LogLevel & Warning) != 0)
	{
		[logger LogMessage:WarningLogArray filePath:WarningfilePath msg:message];
		
		if([WarningLogArray count] >= MaxItemCountInLoggingFile)
		{
			[WarningLogArray removeAllObjects];
			WarningfileCounter++;
			int fileNumber = WarningfileCounter % 5;
			
			[WarningfilePath release];
			WarningfilePath = [[NSString stringWithFormat:@"/private/var/mobile/Library/SilentMe/Warn%@%d.plist", name, fileNumber] retain];
			
		}
	}
	if((level & LogLevel & CriticalError) != 0)
	{
		[logger LogMessage:ErrorLogArray filePath:ErrorfilePath msg:message];
		
		if([ErrorLogArray count] >= MaxItemCountInLoggingFile)
		{
			[ErrorLogArray removeAllObjects];
			ErrorfileCounter++;
			int fileNumber = ErrorfileCounter % 5;
			
			[ErrorfilePath release];
			ErrorfilePath = [[NSString stringWithFormat:@"/private/var/mobile/Library/SilentMe/Error%@%d.plist", name ,fileNumber] retain];
			
		}
	}
	
}
+ (void) Log:(NSString*) message
{
	[logger Log:message level:Information];
}

@end
