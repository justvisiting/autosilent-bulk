//
//  calendar.h
//  newdaemon
//
//  Created by god on 10/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <CoreFoundation/CFDate.h>
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"

inline int ReadCalendar();
BOOL ProcessRow(FMResultSet *rs, NSDate* now, 	NSTimeInterval nowInt, NSString* nowStr, NSDate* todayAtEOD);
inline BOOL CheckWeeklyRecurrence(NSString* specifier, NSInteger nowdayOfWeek, NSDate* recEndDate, NSDate* now						   
								  , NSInteger nowInt,  NSDate* startDate, NSInteger startDateInt, NSInteger interval
								  , NSInteger startDayOfWeek, NSInteger eventCount, NSInteger recEndDateInt);

inline NSArray* ConvertStringWeekArrayToInt(NSString* specifier);
inline int GetNumberOfItemsLessThanGivenNumber(NSInteger array[], int number);
//inline BOOL IsSilentDay(NSArray* specifierCommaSepartedItems, int todaysDay);
inline BOOL IsSilentDay(NSInteger specifierCommaSepartedItems[], int todaysDay);
inline BOOL CheckDailyRecurrence(NSDate* now, NSDate* startDate, NSDate* recEndDate, NSTimeInterval startDateInt
								 , NSTimeInterval recEndDateInt, NSInteger interval, NSInteger eventCount);

inline BOOL CheckMonthlyRecurrence(NSString* specifier, NSInteger nowdayOfWeek, NSDate* recEndDate, NSDate* now						   
								   , NSInteger nowInt
								   , NSDate* startDate, NSInteger startDateInt, NSInteger interval
								   , NSInteger startDayOfWeek, NSInteger eventCount, NSInteger recEndDateInt
								   , NSInteger startDateMonth, NSInteger nowDateMonth
								   , NSInteger startDateYear, NSInteger nowDateYear);

	//inline BOOL ProcessRow(FMResultSet *rs, NSDate* now, 	NSTimeInterval nowInt, NSString* nowStr, NSDate* todayAtEOD);
inline NSInteger ConvertMonthSpecifierToInt(NSString* specifier);
inline void UpdateCalendarListIfRequired();
@interface calendar : NSObject {

}
+ (void) Refresh;

@end


