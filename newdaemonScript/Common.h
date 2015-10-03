//
//  Common.h
//  Util
//
//  Created by god on 5/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <CoreFoundation/CFDate.h>
#import "constants.h"


inline NSInteger GetDateInTheMonth(NSDate* date);
inline NSInteger GetWeekInTheMonth(NSDate* date);
inline NSInteger GetNumberOFMonths(NSDate* startDate, NSDate* endDate);
inline NSInteger GetNumberOfDays(NSDate* startDate, NSDate* endDate);
inline NSInteger GetNumberOfWeeks(NSDate* startDate, NSDate* endDate);
inline NSInteger GetTimeElapsedForTheday(NSDate* date);
inline NSInteger GetDayOfWeek(NSDate* date);
inline BOOL FileExists(NSString* path, BOOL isDir);
inline NSInteger GetTimeElapsedForTheday(NSDate* date);

