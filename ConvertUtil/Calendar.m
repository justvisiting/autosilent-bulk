//
//  Calendar.m
//  ConvertUtil
//
//  Created by god on 11/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Calendar.h"
#import "FMDatabase.h"
#import "../newdaemonScript/constants.h"

static NSMutableArray* calendarList = nil;
static NSMutableDictionary * masterCalendarDict = nil;

static NSString * const calendersettingsPath = @"/User/Library/Preferences/com.apple.accountsettings.plist";
static NSString * const EnabledTag = @"Enabled";
static NSString * const DefaultCalenderName = @"iPhone Calendar";
@implementation Calendar

+(NSMutableArray*)CalendarList
{
	if ( calendarList == nil)
	{
		[self InitCalenderList];
	}
	
	return calendarList;
}

+(void)InitCalenderList
{
	if ( calendarList != nil)
		return;
	
	NSDictionary* calDict = [NSDictionary dictionaryWithContentsOfFile:calendarFilePath];
	
	if(calDict != nil && [calDict count] > 0)
	{//dont override user settings.
		return;
	}
	
	calendarList = [[NSMutableArray alloc] init];
	
	
	FMDatabase* db = [FMDatabase databaseWithPath:@"/private/var/mobile/Library/Calendar/Calendar.sqlitedb"];
	if (![db open]) {
		return;
	}
	
	
	[db setBusyRetryTimeout:5000];
	
	NSString * calenderListQuery = [NSString stringWithFormat: @"select Store.external_id as external_id, Calendar.ROWID as CalendarId from Store, Calendar where (Store.disabled = 0) AND (Calendar.store_id = Store.ROWID) AND (Calendar.ROWID != 1) "];
	
	
	FMResultSet *rs = [db executeQuery:
					   calenderListQuery];
	
	if (rs == nil)
		return;
	
	while ([rs next]) {
		
		//This part of the code is not working. Crashing in the 2 lines next
		
		NSString* ident =[rs stringForColumn:@"external_id"];
		int calId = [rs intForColumn:@"CalendarId"];
		
		Calendar * calendar = [[Calendar alloc] initWithIdentifier:ident calenderId:calId];
		//Calendar * calendar = [[Calendar alloc] initWithIdentifier:@"BFB8498D-B6A2-4A07-883A-54265F793F8D" calenderId:i++];
		[calendarList addObject:calendar];
		[calendar SetBoolValue:nil value:YES];
	}
	
	// close the result set.
	// it'll also close when it's dealloc'd, but we're closing the database before
	// the autorelease pool closes, so sqlite will complain about it.
	[rs close];  
	[db close];
	
	
}

+(NSMutableDictionary*) MasterCalendarDict
{
	if (masterCalendarDict == nil)
	{
		masterCalendarDict = [[NSMutableDictionary dictionaryWithContentsOfFile:calendarFilePath] retain];
	}
	return masterCalendarDict;
}

- (Calendar*) initWithIdentifier:(NSString*)ident calenderId:(int)calId
{
	self = [super init];
	
	NSMutableDictionary * storeSettings = [NSMutableDictionary dictionaryWithContentsOfFile:calendersettingsPath];
	
	NSArray * array = (NSArray*) [ storeSettings valueForKey:@"Accounts"];
	
	int i;
	
	for (i=0; i< [array count]; i++) {
		NSDictionary * currDict = (NSDictionary*) [array objectAtIndex:i];
		NSString * currident = (NSString*) [currDict valueForKey:@"Identifier"];
		
		if([currident caseInsensitiveCompare:ident] == NSOrderedSame)
		{
			displayName = [(NSString*)[currDict valueForKey:@"DisplayName"] retain];
			break;
		}
		
	}
	
	identifier = [ident retain];
	calenderId = calId;
	
	if(identifier == nil)
	{
		identifier = @"";
		displayName = NSLocalizedString(DefaultCalenderName, @"");
	}
	
	NSMutableDictionary * caldict = (NSMutableDictionary*)[[Calendar MasterCalendarDict] valueForKey:[NSString stringWithFormat:@"%d",calId]];
	
	if (caldict == nil)
	{
		enabled = NO;
	}
	else
	{
		enabled = YES;
	}
	return self;
	
}

-(void) SetBoolValue:(NSString*)key value:(BOOL)val
{
	enabled = val;
	
	if(enabled)
	{
		NSMutableDictionary * calDict = [[NSMutableDictionary alloc] init];
		[calDict setObject:identifier forKey:@"identifier"];
		[[Calendar MasterCalendarDict] setObject:calDict forKey:[NSString stringWithFormat:@"%d",calenderId]];
	}
	else
	{
		[[Calendar MasterCalendarDict] removeObjectForKey:[NSString stringWithFormat:@"%d",calenderId]];
	}
	[[Calendar MasterCalendarDict] writeToFile:calendarFilePath atomically:YES];
}

@end
