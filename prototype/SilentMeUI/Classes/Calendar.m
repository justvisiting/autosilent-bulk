//
//  Calendar.m
//  SilentMe
//
//  Created by god on 11/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Calendar.h"
#import "CheckmarkCell.h"
#import "FMDatabase.h"
#import "Constants.h"
#import "CalenderSchedule.h"
#import <EventKit/EventKit.h>

static NSMutableArray* calendarList = nil;
static NSMutableDictionary * masterCalendarDict = nil;

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
	
	calendarList = [[NSMutableArray alloc] init];
	/*
	EKEventStore *eventStore = [[EKEventStore alloc] init];
	NSPredicate * pred = [eventStore predicateForEventsWithStartDate:[NSDate date] endDate:[NSDate dateWithTimeInterval:60*60*12 sinceDate:[NSDate date]] calendars:nil];
	NSArray * events = [eventStore eventsMatchingPredicate:pred];
	int j,i;
	for (j=0; j < [events count]; j++) {
		EKEvent* eve = [events objectAtIndex:j];
			//[[NSString stringWithFormat:@"%@-%@",[[eve calendar] title],[eve title]] retain] ;
		Calendar * calendar = [[Calendar alloc] initWithIdentifier:@"BGB8498D-B6A2-4A07-883A-54265F793F8D" calenderId:(j++ + 10) title:[[NSString stringWithFormat:@"%@-%@",[[eve calendar] title],[eve title]] retain]];
		[calendarList addObject:calendar];
	}
	for (i=0; i < [[eventStore calendars] count]; i++) {
		EKCalendar * cal = [[eventStore calendars] objectAtIndex:i];
		
		Calendar * calendar = [[Calendar alloc] initWithIdentifier:@"BFB8498D-B6A2-4A07-883A-54265F793F8D" calenderId:i++ title:[cal title]];
		[calendarList addObject:calendar];
	}
	EKCalendar* cal = [eventStore defaultCalendarForNewEvents];
	Calendar * calendar = [[Calendar alloc] initWithIdentifier:@"BBB8498D-B6A2-4A07-883A-54265F793F8D" calenderId:2 title:[cal title]];
	[calendarList addObject:calendar];

	*/
	
	FMDatabase* db = [FMDatabase databaseWithPath:@"/private/var/mobile/Library/Calendar/Calendar.sqlitedb"];
	if (![db open]) {
		return;
	}
	
	
	[db setBusyRetryTimeout:5000];
	
	NSString * calenderListQuery = [NSString stringWithFormat: @"select Store.external_id as external_id, Calendar.ROWID as CalendarId, Calendar.title as title, Calendar.store_id as store_id from Store, Calendar where (Store.disabled = 0 OR Store.disabled is NULL) AND (Calendar.store_id = Store.ROWID)"];
	
	
	FMResultSet *rs = [db executeQuery:
					   calenderListQuery];
	
	if (rs == nil)
		return;

	while ([rs next]) {

//This part of the code is not working. Crashing in the 2 lines next

		NSString* ident =[rs stringForColumn:@"external_id"];
		int calId = [rs intForColumn:@"CalendarId"];
		NSString* title =[rs stringForColumn:@"title"];
		int store_id = [rs intForColumn:@"store_id"];
		if (store_id == 1 && [title compare:@"Calendar" options:NSCaseInsensitiveSearch] == NSOrderedSame)
		{
			continue;
		}
		
		Calendar * calendar = [[Calendar alloc] initWithIdentifier:[NSString stringWithFormat:@"%d", calId] calenderId:calId title:title];
		//Calendar * calendar = [[Calendar alloc] initWithIdentifier:@"BFB8498D-B6A2-4A07-883A-54265F793F8D" calenderId:i++];
		[calendarList addObject:calendar];
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

- (Calendar*) initWithIdentifier:(NSString*)ident calenderId:(int)calId title:(NSString*)title
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
			displayName = [(NSString*)[currDict valueForKey:@"DisplayName"] retain] ;
			break;
		}
		
	}
	
	if ([title length] > 19)
		title = [title substringToIndex:18];

	if(title != nil && displayName != nil)
	{
		displayName = [[NSString stringWithFormat:@"%@-%@",title,displayName] retain] ;
	}
	else if (title != nil)
	{
		displayName = [[NSString stringWithFormat:@"%@",title] retain] ;
	}
	else
	{
		displayName = [[NSString stringWithFormat:@"%@",displayName] retain] ;
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
-(CheckmarkCell*)GetCell
{
	CheckmarkCell* onOffCell = [[[CheckmarkCell alloc] initWithTitle:displayName boolTag:EnabledTag dict:self] autorelease];
	
	return onOffCell;
}
-(BOOL) GetBoolValue:(NSString*) key
{
	return enabled;
}

-(void) SetBoolValue:(NSString*)key value:(BOOL)val
{
	enabled = val;
	
	if(enabled)
	{
		NSMutableDictionary * calDict = [[NSMutableDictionary alloc] init];
		[calDict setObject:identifier forKey:@"identifier"];
		[calDict setObject:displayName forKey:@"name"];
		[[Calendar MasterCalendarDict] setObject:calDict forKey:[NSString stringWithFormat:@"%d",calenderId]];
	}
	else
	{
		[[Calendar MasterCalendarDict] removeObjectForKey:[NSString stringWithFormat:@"%d",calenderId]];
	}
	[[Calendar MasterCalendarDict] writeToFile:calendarFilePath atomically:YES];
	[[CalenderSchedule Schedule] PostMyNotification:nil];
}

@end
