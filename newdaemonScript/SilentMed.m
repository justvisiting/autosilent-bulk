#import "constants.h"
#include <CoreFoundation/CoreFoundation.h>

#if IS_IPHONE
#import <UIKit/UIHardware.h>
#endif

#import "Notifications.h"
#import "powerMgmt.h"
#import "scheduler.h"
#import "Common.h"
#import "configManager.h"
#import "logger.h"
	//#import "FMDatabase.h"

BOOL CreateLogDir();
/*
void TestCode()
{
	FMDatabase* db = [FMDatabase databaseWithPath:@"/private/var/mobile/Library/Calendar/Calendar.sqlitedb"];
	if (![db open]) {
		return;
	}
	
	
	[db setBusyRetryTimeout:5000];
	
	NSString * calenderListQuery = [NSString stringWithFormat: @"select Store.external_id as external_id, Calendar.ROWID as CalendarId from Store, Calendar where (Store.disabled = 0) AND (Calendar.store_id = Store.ROWID) AND (Calendar.ROWID != 1) AND (Store.ROWID = 30) "];
	
	
	FMResultSet *rs = [db executeQuery:
					   calenderListQuery];
	
	if (rs == nil)
		return;
	int i =56;
	NSString * external_idColumnName = [[NSString alloc] initWithString:@"external_id"];
	NSMutableString * ident= [[NSMutableString alloc] init];
	while ([rs next]) {
		
		//This part of the code is not working. Crashing in the 2 lines next
		if ([rs stringForColumn:external_idColumnName] != nil)
			[ident setString:[rs stringForColumn:external_idColumnName]];
		//int calId = [rs intForColumn:@"CalendarId"];
		
		//Calendar * calendar = [[Calendar alloc] initWithIdentifier:ident calenderId:calId];
		//Calendar * calendar = [[Calendar alloc] initWithIdentifier:@"BFB8498D-B6A2-4A07-883A-54265F793F8D" calenderId:i++];
		//[calendarList addObject:calendar];
	}
	
	// close the result set.
	// it'll also close when it's dealloc'd, but we're closing the database before
	// the autorelease pool closes, so sqlite will complain about it.
	[rs close];  
	[db close];
	
}
*/

void BasicTest() {
	[[powerMgmt Instance] RegisterSource];
}
int main (int argc, const char * argv[]) {
		NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	[logger initLogger:@"D"];
		
	NSDate* dateUntilManulMode = [configManager GetDateUntilWhichManulModeIsApplied];		
	
	if(dateUntilManulMode == nil)
	{
		NSInteger oneDay = 24*60*60;
		dateUntilManulMode = [NSDate dateWithTimeIntervalSinceNow:(NSTimeInterval)oneDay];
		[configManager SetDateUntilWhichManulModeIsApplied:dateUntilManulMode];
	}

	if(argc > 1)
	{
		NSLog(@"args great than 1");
		NSString* disableApp = [NSString stringWithCString:argv[1] encoding:1];
		
		if(disableApp != NULL && [disableApp caseInsensitiveCompare:@"1"] == NSOrderedSame)
		{
			[[scheduler Instance] PerformAllActions:@"console" override:YES isManulModeApplicable:NO manualMode:NO];
			
		}
		else			
		{
			[[scheduler Instance] PerformAllActions:@"console" override:YES  isManulModeApplicable:NO manualMode:NO];
		}
		
		UnfixSilentSwitch();
	}
	else
	{
	
		int ringerState = 0;
#if IS_IPHONE
		ringerState = [ UIHardware ringerState];
#endif
		
	[configManager SetSilentSwitchStatus:ringerState];
	CreateLogDir();
	RegisterNotification();
	InitializeCustomList();
	[[powerMgmt Instance] RegisterSource];
	
		NSLog(@"ok, got signal to exit");
	[[powerMgmt Instance] RemoveSource];
	}
    return 0;
}


 BOOL CreateLogDir()
{
	
	NSString* path = @"/private/var/mobile/Library/SilentMe";
	BOOL isDir = TRUE;
	NSError* errord;
	
	if(!FileExists(path, isDir))
	{
		NSFileManager *fm = [NSFileManager defaultManager];
		
		BOOL rv = [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&errord];
	}
	
	return TRUE;
}
