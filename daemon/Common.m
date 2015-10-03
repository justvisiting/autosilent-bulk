//
//  Common.m
//  Util
//
//  Created by god on 5/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <CoreFoundation/CFDate.h>

#import "Common.h"
#import "Util.h"

inline NSInteger GetTimeElapsedForTheday(NSDate* date)
{
	NSCalendar *gregorian = [[NSCalendar alloc]
							 initWithCalendarIdentifier:NSGregorianCalendar];
	
	NSUInteger unitFlags = NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
	
	NSDateComponents *components = [gregorian components:unitFlags 
												fromDate:date];
	
	NSInteger hour  = [components hour];
	NSInteger minute = [components minute];
	NSInteger second =  [components second];
	
	NSInteger rv =	( hour * 60 + minute) * 60 + second; 
	
	
	NSString* dateStr = [date description];
	
	NSString* logStr = [[NSString alloc] initWithFormat:@"date= %@, no. of seonds elapsed on the day= %d"
						, dateStr, rv];
	
	[dateStr release];
	
	//Log((CFStringRef)logStr);
	
	[gregorian release];
	[logStr release];
	
	return rv;
	
}


inline NSInteger GetWeekInTheMonth(NSDate* date)
{
	NSCalendar *gregorian = [[NSCalendar alloc]
							 initWithCalendarIdentifier:NSGregorianCalendar];
	
	NSUInteger unitFlags = NSWeekdayOrdinalCalendarUnit | NSMonthCalendarUnit;
	
	NSDateComponents *components = [gregorian components:unitFlags 
												fromDate:date];
	
	NSInteger rv =	[components weekdayOrdinal];
	
	
	
	NSString* logStr = [[NSString alloc] initWithFormat:@"date= %@, no. of weeks in the month= %d"
						, [date description], rv];
	
	
	Log((CFStringRef)logStr);
	
	[gregorian release];
	[logStr release];
	
	return rv;
	
}


inline NSInteger GetDateInTheMonth(NSDate* date)
{
	NSCalendar *gregorian = [[NSCalendar alloc]
							 initWithCalendarIdentifier:NSGregorianCalendar];
	
	NSUInteger unitFlags = NSDayCalendarUnit | NSMonthCalendarUnit;
	
	NSDateComponents *components = [gregorian components:unitFlags 
												fromDate:date];
	
	NSInteger rv =	[components day];
	
	
	
	NSString* logStr = [[NSString alloc] initWithFormat:@"date= %@, day in the month= %d"
						, [date description], rv];
	
	
	Log((CFStringRef)logStr);
	
	[gregorian release];
	[logStr release];
	return rv;
	
}


inline NSInteger GetNumberOfWeeks(NSDate* startDate, NSDate* endDate)
{
	
	NSCalendar *gregorian = [[NSCalendar alloc]
							 initWithCalendarIdentifier:NSGregorianCalendar];
	
	NSUInteger unitFlags = NSWeekCalendarUnit;
	
	NSDateComponents *components = [gregorian components:unitFlags
												fromDate:startDate
												  toDate:endDate options:0];
	
	NSInteger rv =	[components week];
	
	//	NSString* logStr = [[NSString alloc] stringByAppendingFormat:@"start date= %@, end date = %@, no. of weeks= %d"
	//						, [startDate description], [endDate description], rv];
	
	NSString* logStr = [[NSString alloc] initWithFormat:@"start date= %@, end date =%@ , no. of weeks= %d"
						, [startDate description], [endDate description], rv];
	
	
	Log((CFStringRef)logStr);
	[gregorian release];
	[logStr release];
	return rv;
}

inline NSInteger GetNumberOfDays(NSDate* startDate, NSDate* endDate)
{
	
	NSCalendar *gregorian = [[NSCalendar alloc]
							 initWithCalendarIdentifier:NSGregorianCalendar];
	
	NSUInteger unitFlags = NSDayCalendarUnit;
	
	NSDateComponents *components = [gregorian components:unitFlags
												fromDate:startDate
												  toDate:endDate options:0];
	
	NSInteger rv =	[components day];
	
	NSString* logStr = [[NSString alloc] initWithFormat:@"start date= %@, end date = %@, no. of days= %d"
						, [startDate description], [endDate description], rv];
	
	
	Log((CFStringRef)logStr);
	[gregorian release];
	[logStr release];
	return rv;
	
	
}

inline NSInteger GetNumberOFMonths(NSDate* startDate, NSDate* endDate)
{
	NSCalendar *gregorian = [[NSCalendar alloc]
							 initWithCalendarIdentifier:NSGregorianCalendar];
	
	NSUInteger unitFlags = NSMonthCalendarUnit;
	
	NSDateComponents *components = [gregorian components:unitFlags
												fromDate:startDate
												  toDate:endDate options:0];
	NSInteger rv = [components month];
	
	NSString* logStr = [[NSString alloc] initWithFormat:@"start date= %@, end date = %@, no. of months= %d"
						, [startDate description], [endDate description], rv];
	
	
	
	Log((CFStringRef)logStr);
	[gregorian release];
	[logStr release];
	return rv;
	
	
}

inline NSInteger GetDayOfWeek(NSDate* date)
{
	
	NSCalendar *gregorian = [[NSCalendar alloc]
							 initWithCalendarIdentifier:NSGregorianCalendar];
	
	NSUInteger unitFlags =  NSWeekCalendarUnit | NSWeekdayCalendarUnit;
	
	NSDateComponents *components = [gregorian components:unitFlags 
												fromDate:date];
	
	NSInteger rv =	[components weekday] % 8;
	
	
	
	NSString* logStr = [[NSString alloc] initWithFormat:@"date= %@, day in the week= %d"
						, [date description], rv];
	
	
	Log((CFStringRef)logStr);
	
	[gregorian release];
	[logStr release];
	return rv;
	
}