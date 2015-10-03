#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <CoreFoundation/CFDate.h>
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "Util.h"

#import "CalendarReader.h"
#import "Common.h"
#import "BaseEvent.h"
#import "Shared.h"
#import "Logger.h"

static NSInteger weekDaysArray[7];
static NSDate* lastCalendatUpdateTime;

static NSDate* lastCalendarUpdateTime = nil;


inline void	UpdateCalendarListIfRequired()
{
	NSDate* now = [NSDate date];
	BOOL updateCalRequired = NO;
	
	if(lastCalendarUpdateTime == nil)
	{
		updateCalRequired = YES;
			[Logger Log:@"update calendar requird cause initliazing it first time"];
	}
	else
	{

	NSFileManager *fm = [NSFileManager defaultManager];
	NSError* err;
	
	NSDictionary* dict = [fm attributesOfItemAtPath:@"/private/var/mobile/Library/Calendar/Calendar.sqlitedb" error:&err];
	
	if(dict != nil)
	{
		NSDate* calModifiedDatetime = [dict objectForKey:NSFileModificationDate];
		[Logger Log:[NSString stringWithFormat:@" checking calendar last update time dateUntilChangesWereDone:%@, CurrentCalendarDBLastModDate:%@"
					 , lastCalendarUpdateTime
					 , calModifiedDatetime]];
		
		if(calModifiedDatetime != nil && [calModifiedDatetime compare:lastCalendarUpdateTime] == NSOrderedDescending)
		{
			updateCalRequired = YES;
			[Logger Log:[NSString stringWithFormat:@"update calendar requird due to change in calendar db"]];
		}
	}
	}
	
	if(updateCalRequired)
	{
		
		
		[[Shared CalendarInstance]  ClearCalendarList];	
		ReadCalendar();
		[[Shared CalendarInstance] SortCalendarList];
		
	}
	
	lastCalendarUpdateTime = [now dateByAddingTimeInterval:(NSTimeInterval)-1];
}


inline void AddToSilentDay(NSDate* startDate, NSDate* endDate)
{
	//-(BaseEvent*) initWithStartDate: (NSDate*) stDate endDate: (NSDate*) edDate
	BaseEvent* event = [[BaseEvent alloc] initWithStartDate:startDate endDate:endDate];
	Shared* calendarInstance = [Shared CalendarInstance];
	[calendarInstance AddObjectToCalendarList:event];
}


inline int ReadCalendar()
{	
	FMDatabase* db = [FMDatabase databaseWithPath:@"/private/var/mobile/Library/Calendar/Calendar.sqlitedb"];
	if (![db open]) {
		Log(CFSTR("Could not open db."));
		//        [pool release];
		return 0;
	}
	
	
	[db setBusyRetryTimeout:5000];
	
	NSDate* now = [NSDate date];
	NSCalendar *calendar = [NSCalendar currentCalendar];
	
	NSDateComponents *comps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit 
										  fromDate:now];
	
	[comps setHour:23];
	[comps setMinute:59];
	[comps setSecond:59];
	
	NSDate *todayAtEOD = [calendar dateFromComponents:comps];
	
	NSTimeInterval todayAtEODInt = [todayAtEOD timeIntervalSinceReferenceDate];
	
	NSTimeInterval nowInt = [now timeIntervalSinceReferenceDate];
	Log((CFStringRef)([NSString stringWithFormat:@"now time %f", nowInt]));
	
	//busy = 0
	//tenative =2
	NSString* query = 	
	[NSString stringWithFormat:@"select Event.start_date as start_date, Event.summary as summary, Event.end_date as end_date, Event.all_day as all_day, Recurrence.frequency as frequency, Recurrence.interval as interval, Recurrence.count as count, Recurrence.end_date as Recend_date, Recurrence.specifier  as specifier from Event left outer join Recurrence on Event.ROWID=Recurrence.event_id where (Event.availability = 0  AND Event.start_date <= %f) AND ((Event.end_date > %f AND Recurrence.frequency IS NULL) OR (Recurrence.end_date=0 OR Recurrence.end_date > %f))"	
	 , todayAtEODInt, nowInt, nowInt];
	
	//select Event.start_date as start_date, Event.summary as summary, Event.end_date as end_date, Event.all_day as all_day
	//, Recurrence.frequency as frequency, Recurrence.interval as interval, Recurrence.count as count, Recurrence.end_date as Recend_date
	//, Recurrence.specifier  as specifier 
	//from Event left outer join Recurrence on Event.ROWID=Recurrence.event_id
	//where (Event.start_date <= now_date) 
	//			AND ((Event.end_date > now_date AND Recurrence.frequency IS NULL)  --no recurrence case
	//				   OR (Recurrence.end_date=0 OR Recurrence.end_date > (now date)) --recurrence case
	Log(CFSTR("started querying calendar db"));
	//Log((CFStringRef)query);
	
	FMResultSet *rs = [db executeQuery:
					   query];
	Log(CFSTR("completed query calendar db"));
	
	// @"select Event.start_date as start_date, Event.summary as summary, Event.end_date as end_date, Event.all_day as all_day
	//, Recurrence.frequency as frequency, Recurrence.interval as interval, Recurrence.count as count, Recurrence.end_date as Recend_date
	//, Recurrence.specifier  as specifier from Event left outer join Recurrence on Event.ROWID=Recurrence.event_id"];
	//ROWID Int primary key
	//start_date int 	//end_date int 	//all_day int 	//calendar_id int 	//orig_start_date int 	//status int 	//external_status 
	//external_id text
	//
	//eventChanges 
	//record int 	//type	int 	//calendar_id int 	//external_id text 	//store_id	int
	
	//recurrence
	//rowid int primary key
	//frequency int 	//interval int 	//week_start int 	//count	int 	//cached_end_date int 	//cached_end_date_tz text
	//end_date int 	//specifier text 	//by_month_months	int 	//event_id int
	
	//recurrenceChanges
	//record int 	//type int 	//external_id text 	//store_id int 	//event_id_tomb int 	//calendar_id int
	
	//	Log((CFStringRef) [now description]);
	
///	int rowId;
	
	 BOOL doSilent = FALSE;
	//int rowNumber = 0;
	NSString* nowStr = [now description];
	
	while ([rs next] && !doSilent) {
		doSilent = ProcessRow(rs, now, nowInt, nowStr, todayAtEOD);
	}
	
	[nowStr release];
	
	// close the result set.
	// it'll also close when it's dealloc'd, but we're closing the database before
	// the autorelease pool closes, so sqlite will complain about it.
	[rs close];  
	[db close];

	return doSilent;
}


inline BOOL ProcessRow(FMResultSet *rs, NSDate* now, 	NSTimeInterval nowInt, NSString* nowStr, NSDate* todayAtEOD)
{
	 BOOL doSilent = FALSE;
	BOOL isSilentDay = FALSE;
	NSString* summary;
	NSDate* startDate;
	NSDate* endDate;
	
	int startDateInt = [rs intForColumn:@"start_date"];
	int endDateInt = [rs intForColumn:@"end_date"];
	summary = [rs stringForColumn:@"summary"];
	
	//Log((CFStringRef)summary);
	
	//convert int to date
	//NSDate* startDateNs = [NSDate dateWithTimeIntervalSinceReferenceDate: startDateInt];
	//startDate = [startDateNs description]; 
	startDate = [NSDate dateWithTimeIntervalSinceReferenceDate: startDateInt];
	endDate = [NSDate dateWithTimeIntervalSinceReferenceDate:endDateInt];
	
	NSComparisonResult startDateCompare = [startDate compare: now];
	
	
	NSCalendar *calendar= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSCalendarUnit unitFlags = 
	NSYearCalendarUnit | NSMonthCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit
	| NSWeekdayCalendarUnit | NSSecondCalendarUnit;
	
	//		NSDate *date = [NSDate date];
	NSDateComponents *startDateComponent = [calendar components:unitFlags fromDate:startDate];
	NSDateComponents *endDateComponent = [calendar components:unitFlags fromDate:endDate];
	NSDateComponents *nowDateComponent = [calendar components:unitFlags fromDate:now];
	
	int startDateHour = [startDateComponent hour];
	int startDateMinute = [startDateComponent minute];
	int startDateSecond = [startDateComponent second];
	int startSecondsForToday = (((startDateHour * 60 ) + startDateMinute) * 60) + startDateSecond;
	int startDayOfWeek = [startDateComponent weekday] % 8;
	int startDateMonth = [startDateComponent month];
	int startDateYear = [startDateComponent year];
	
	int endDateHour = [endDateComponent hour];
	int endDateMinute = [endDateComponent minute];
	int endDateSecond = [endDateComponent second];
	int endSecondsForToday = (((endDateHour * 60 ) + endDateMinute) * 60) + endDateSecond;
	//int endDayOfWeek = [endDateComponent weekday] % 8;
	//int endDateMonth = [endDateComponent month];
	//int endDateYear = [endDateComponent year];
	
	
	int nowDateHour = [nowDateComponent hour];
	int nowDateMinute = [nowDateComponent minute];
	int nowDateSecond = [nowDateComponent second];
	int nowSecondsForToday = (((nowDateHour * 60 ) + nowDateMinute) * 60) + nowDateSecond;
	int nowdayOfWeek = [nowDateComponent weekday] % 8;
	int nowDateMonth = [nowDateComponent month];
	int nowDateYear = [nowDateComponent year];
	
	//endDate = [NSDate dateWithTimeIntervalSinceReferenceDate: [rs intForColumn:@"end_date"]],
	int frequency = [rs intForColumn:@"frequency"];
	
	/// ASSUMPTION: sql query filters event such only events having start date before today's midnight are returned
	//check for no recurrence case
	if(frequency <= 0)
	{
		NSComparisonResult endDatecomparedToTodaysEOD = [endDate compare:todayAtEOD];
		NSComparisonResult endDatecomparedToNow = [endDate compare:now];
		
		//enddate is earlier than todays' midnight && enddate is after now
		if(!(endDatecomparedToTodaysEOD == NSOrderedDescending) && !(endDatecomparedToNow == NSOrderedAscending))
		{
			[Logger Log:@"need to add to calendarlist"];
			isSilentDay = TRUE;
		}
	}
	else
	{
		NSInteger interval = [rs intForColumn:@"interval"];

		//the time for event is after now time (it does not consider date, consider only time of day)
		//and start date is earlier than today EOD date -- verifid by SQL query
		if(endSecondsForToday >= nowSecondsForToday)
		{
			Log(CFSTR("in recurrence"));		
			int recEndDateInt = [rs intForColumn:@"Recend_date"];
			
			NSDate* recEndDate = [NSDate dateWithTimeIntervalSinceReferenceDate: recEndDateInt];
			int eventCount = [rs intForColumn:@"count"];
			NSString* specifier = [rs stringForColumn:@"specifier"];				
			//recurrence end date after now
			//-1 is for no end date
			if(recEndDateInt == 0 || ([recEndDate compare:now] == NSOrderedDescending))
			{
				Log(CFSTR("recurrence end date is after current time"));	
				//NSDate* recurrenceEndDate = [NSDate dateWithTimeIntervalSinceReferenceDate: ]; 
				if(frequency == 1)
				{//daily recurrence
					isSilentDay = CheckDailyRecurrence(now, startDate, recEndDate, startDateInt, recEndDateInt, interval, eventCount);
					
				}
				else if(frequency == 2)
				{//weekly
					
					//region clean up
					int i = 0;
					
					for(i = 0; i < 7; i++)
					{
						weekDaysArray[i] = -1;
					}
					
					//end region
					
					isSilentDay = CheckWeeklyRecurrence(specifier, nowdayOfWeek, recEndDate, now
														, nowInt, startDate, startDateInt, interval
														, startDayOfWeek, eventCount, recEndDateInt);
					
				}
				else if (frequency == 3)
				{
					//region clean up
					int i = 0;
					
					for(i = 0; i < 7; i++)
					{
						weekDaysArray[i] = -1;
					}
					
					//end region
					
					isSilentDay = CheckMonthlyRecurrence(specifier, nowdayOfWeek, recEndDate, now, nowInt, startDate, startDateInt
														 , interval, startDayOfWeek, eventCount, recEndDateInt
														 , startDateMonth, nowDateMonth, startDateYear, nowDateYear);
				}
				
			}
			
			[specifier release];
			
		}
	}
	
	
	if(isSilentDay && startSecondsForToday <= nowSecondsForToday)
	{
		doSilent = TRUE;
	}
	
	
	if(isSilentDay)
	{
		
		NSDate* todaysMidNightDate = (NSDate*)[now dateByAddingTimeInterval:(NSTimeInterval)-nowSecondsForToday];
		

		NSDate* todaysStartDateForTheEvent = (NSDate*)[todaysMidNightDate dateByAddingTimeInterval:(NSTimeInterval)startSecondsForToday];
		
		NSDate* todaysEndDateForTheEvent = (NSDate*)[todaysMidNightDate dateByAddingTimeInterval:(NSTimeInterval)endSecondsForToday];
		
		[Logger Log:[NSString stringWithFormat:@"adding event midnight date:%@, todaysEventStartDate: %@, todaysEventEndDate:%@ nowDate: %@"
			, todaysMidNightDate
			, todaysStartDateForTheEvent
			, todaysEndDateForTheEvent
					 , now]];
		AddToSilentDay(todaysStartDateForTheEvent, todaysEndDateForTheEvent);		
	}
		
	if(!doSilent)
	{
		//LogSilent((CFStringRef)summary);
		NSString *noSilengLog = [[NSString alloc] initWithFormat:@"No silent done at : %@, startDate - H:%d, M:%d, S:%d."
								 , nowStr, startDateHour, startDateMinute, startDateSecond];
		
		Log((CFStringRef) noSilengLog);
		[noSilengLog release];
		
		noSilengLog = [[NSString alloc] initWithFormat:@"No silent done at : %@, endDate - H:%d, M:%d, S:%d."
					   , nowStr, endDateHour, endDateMinute, endDateSecond];
		
		Log((CFStringRef) noSilengLog);
		[noSilengLog release];
		
		noSilengLog = [[NSString alloc] initWithFormat:@"No silent done at : %@, currentDate - H:%d, M:%d, S:%d."
					   , nowStr, nowDateHour, nowDateMinute, nowDateSecond];
		
		Log((CFStringRef) noSilengLog);
		
		[noSilengLog release];
		
	}
	else
	{
		
		//LogSilent((CFStringRef)summary);
		
		NSString *silengLog = [[NSString alloc] initWithFormat:@"silent done at : %@, startDate - H:%d, M:%d, S:%d."
							   , nowStr, startDateHour, startDateMinute, startDateSecond];
		LogSilent((CFStringRef) silengLog);
		[silengLog release];
		
		silengLog = [[NSString alloc] initWithFormat:@"silent done at : %@, endDate - H:%d, M:%d, S:%d."
					 , nowStr, endDateHour, endDateMinute, endDateSecond];
		
		LogSilent((CFStringRef) silengLog);
		[silengLog release];			
		
		silengLog = [[NSString alloc] initWithFormat:@" silent done at : %@, currentDate - H:%d, M:%d, S:%d."
					 , nowStr, nowDateHour, nowDateMinute, nowDateSecond];
		
		LogSilent((CFStringRef) silengLog);
		[silengLog release];
		
		//break;
	}
	
	[startDate release];
	[endDate release];
	[summary release];
	[startDateComponent release];
	[endDateComponent release];
	[nowDateComponent release];
	[calendar release];
	
	return doSilent;
	
}

inline BOOL CheckMonthlyRecurrence(NSString* specifier, NSInteger nowdayOfWeek, NSDate* recEndDate, NSDate* now						   
							, NSInteger nowInt
							, NSDate* startDate, NSInteger startDateInt, NSInteger interval
							, NSInteger startDayOfWeek, NSInteger eventCount, NSInteger recEndDateInt
							, NSInteger startDateMonth, NSInteger nowDateMonth
							, NSInteger startDateYear, NSInteger nowDateYear)
{
	//it has two possibilities
	// e.g: 1) 3rd of every 4 months
	//2) 4th Tue of every 3 months
	
	 BOOL doSilent = FALSE;
	NSInteger silentDateInMonthInt = 0;
	
	if(specifier != NULL && [specifier compare:@""] != NSOrderedSame)
	{
		
		silentDateInMonthInt = ConvertMonthSpecifierToInt(specifier);
		
	}
	else
	{//set to start date
		Log((CFStringRef)specifier);
		silentDateInMonthInt = GetDateInTheMonth(startDate);	
	}
	
	//no of months passed from start date
	NSInteger numberOfMonthsFromStartDate = GetNumberOFMonths(startDate, now);
	NSInteger todaysMonthDay = GetDateInTheMonth(now);
	
	Log((CFStringRef)[NSString  
					  stringWithFormat:@"Monthly recurrence, # of months=%d, interval %d", numberOfMonthsFromStartDate, interval]);
	
	if(numberOfMonthsFromStartDate % interval == 0) //if the month falls in right interval
	{
		NSInteger numberOfTimesEventOccurred = numberOfMonthsFromStartDate / interval;
		
		
		
		if(todaysMonthDay == silentDateInMonthInt)
		{//implies specifier contains month and date in specifier is today's date of the month
			// and silentdateInMonthInt is non zero
			
			Log(CFSTR("3rd of every 4 month scenario"));
			Log((CFStringRef)[NSString stringWithFormat:@"monthly today is silent,number of times event occurred=%d"
							  , numberOfTimesEventOccurred]);
			
			if(recEndDateInt == 0 && eventCount != 0) //count based recurrence
			{
				
				if(numberOfTimesEventOccurred < eventCount)
				{
					Log(CFSTR("count based silent"));
					
					doSilent = TRUE;
				}
			}
			else if(eventCount == 0 || [now compare:recEndDate] != NSOrderedDescending)//time based..do silent
			{
				Log(CFSTR("time based silent"));
				
				doSilent = TRUE;
			}
			//}
		}
		else //4th tuesday of every 3 months scenario
		{
			NSInteger currentWeekInMonth = GetWeekInTheMonth(now);
			
			ConvertStringWeekArrayToInt(specifier);
			
			Log((CFStringRef)
				[NSString stringWithFormat
				 :@"monthly rec type 4th tues every 3 month, week in month=%d, weekToBeSilentOnValue=%d"
				 , currentWeekInMonth, weekDaysArray[nowdayOfWeek-1]]);
			
			//TBD last day of the month is not done. 
			if(weekDaysArray[nowdayOfWeek-1] == currentWeekInMonth)
			{
				if((recEndDateInt == 0 && eventCount != 0 && numberOfTimesEventOccurred < eventCount) //count based recurrence
				   || (eventCount == 0 || [now compare:recEndDate] != NSOrderedDescending))//time based..do silent
				{
					
					doSilent = TRUE;
					
				}
				
			}
			
		}
		//}
	}
	
	Log((CFStringRef)[NSString stringWithFormat:@"monthly result %d", doSilent]);
	
	return doSilent;
}





//return number of events occurred between two weekdays from a given array
inline NSInteger GetNumberOfItemsBetweenRange(NSInteger array[], NSInteger startRange, NSInteger endRange, NSInteger modulo)
{
	NSInteger rv = 0;
	
	//	if(array != NULL)
	{
		//int counter = startRange;
		//while(counter % modulo != endRange)
		{
			//			NSNumber* object;
			
			//			NSEnumerator *enumerator = [array objectEnumerator];
			NSInteger index = 0;
			
			for(index = 0; index < 7; index++)
				//			while(object = [enumerator nextObject])
			{
				if(array[index] == 0)//[object intValue];
				{
					NSInteger objectInt = index + 1;
					
					if((endRange > startRange && objectInt >= startRange && objectInt < endRange)
					   || (endRange < startRange && (objectInt >= startRange || objectInt < endRange)))
					{
						rv++;
					}
				}
			}
		}
	}
	
	return rv;
}

//assumes array is not null	
inline int GetNumberOfItemsLessThanGivenNumber(NSInteger array[], int number)
{
	//	int arrayCount = [array count];
	int rv = 0;
	
	
	//	NSEnumerator *enumerator = [array objectEnumerator];
	
	//	NSNumber* anObject;
	int element = -1;
	int index = 0;
	
	for(index = 0; index < 7; index++)
	{
		//	while (anObject = [enumerator nextObject]) {
		element = array[index];//[anObject intValue];
		if(element == 0)
		{
			/* code to act on each element as it is returned */
			if((element +1) < number)
			{
				rv++;
			}
		}
	}
	
	
	return rv;
}


inline BOOL CheckDailyRecurrence(NSDate* now, NSDate* startDate, NSDate* recEndDate, NSTimeInterval startDateInt
						  , NSTimeInterval recEndDateInt, NSInteger interval, NSInteger eventCount)
{
	 BOOL doSilent = FALSE;

	Log(CFSTR("recurrence frequency is 1"));	
	int numberOfDays = GetNumberOfDays(startDate, now);//(nowInSeconds - startDateInt + 1)/(24 * 60 * 60);
	
	if(recEndDateInt == 0 && eventCount != 0) //count based recurrence
	{
		
		Log((CFStringRef)[NSString stringWithFormat:@"in recurrence frequency is 1 and in count based daily recurrence, %d number of days"
						  , numberOfDays]);	
		
		if((numberOfDays / interval <= eventCount) && (numberOfDays % interval == 0))
		{
			doSilent = TRUE;
			Log(CFSTR("silent based on daily recurrence count"));
		}
	}
	else if((eventCount == 0 || [now compare:recEndDate] != NSOrderedDescending) && (numberOfDays % interval == 0))
	{
		Log(CFSTR("in recurrence frequency is 1 and in end time based recurrence"));	
		doSilent = TRUE;
		Log(CFSTR("silent based on date recurrence datetime"));
		
	}
	
	
	Log((CFStringRef)[NSString stringWithFormat:@"daily result %d", doSilent]);
	
	return doSilent;
}


inline BOOL CheckWeeklyRecurrence(NSString* specifier, NSInteger nowdayOfWeek, NSDate* recEndDate, NSDate* now						   
						   , NSInteger nowInt, NSDate* startDate, NSInteger startDateInt, NSInteger interval
						   , NSInteger startDayOfWeek, NSInteger eventCount, NSInteger recEndDateInt)
{
	
	
	
	
	 BOOL doSilent =FALSE;
	//get interval
	
	Log(CFSTR("weekly frequency"));
	 BOOL isTodaySilentDay = FALSE;
//	NSArray *specifierCommaSepartedItems;
	//NSInteger specifierInInt;
	
	if(specifier != NULL && [specifier compare:@""] != NSOrderedSame)
	{
		Log((CFStringRef)specifier);
		
		//specifierInInt = 
		ConvertStringWeekArrayToInt(specifier);
	}
	else
	{
		Log(CFSTR("specifier string is Null..."));
		NSMutableArray* defaultSepcifierArray = [[NSMutableArray alloc] initWithCapacity:1];
		Log(CFSTR("created specifier default array in weekly"));
		NSNumber* startDaayOfWeekNumber = [[NSNumber alloc] initWithInt:startDayOfWeek];
		
		Log(CFSTR("created default array, adding startDayOfweekNumber"));
		
		//[defaultSepcifierArray addObject:startDaayOfWeekNumber];
		weekDaysArray[startDayOfWeek-1] = 0;
		
		//specifierInInt = weekDaysArray;  //defaultSepcifierArray;
		Log(CFSTR("specifier string is Null and done adding startday of week to specifier int"));
		
		Log((CFStringRef)[NSString stringWithFormat:@"set specifierInInt array to default start day of week, value=%d",startDayOfWeek]);
		[defaultSepcifierArray release];
		[startDaayOfWeekNumber release];
	}	
	
	//if(specifierInInt != NULL)
	{
		
		int noOfEventdaysInWeek = 0;//[specifierInInt count];
		
		int index = 0;
		
		for(index = 0; index < 7; index++)
		{
			if(weekDaysArray[index] == 0)
			{
				noOfEventdaysInWeek++;
			}
			
		}
		
		Log((CFStringRef)[NSString stringWithFormat:@"specifierIn Int count= %d", noOfEventdaysInWeek]);
		
		if(noOfEventdaysInWeek != 0)
		{
			
			isTodaySilentDay = IsSilentDay(weekDaysArray, nowdayOfWeek);
			Log((CFStringRef)[NSString stringWithFormat:@"weekly silent day value: %d", isTodaySilentDay]);
			int numberOfWeeks = GetNumberOfWeeks(startDate, now);  //(nowInt - startDateInt+1)/(7*24*60*60);
			
			if(isTodaySilentDay && (numberOfWeeks % interval == 0))
			{
				Log(CFSTR("today is silent day"));
				
				
				if(recEndDateInt == 0 && eventCount != 0)//count based 
				{
					Log(CFSTR("count based weekly recurrence"));
					//occurence in between weeks except start and end weeks
					// + number of items in specifier>= start date day
					// + number of items in specified < today's day
					int eventsInMiddleWeeks = (numberOfWeeks/interval) * noOfEventdaysInWeek; //includes all events except today
					Log((CFStringRef)([NSString stringWithFormat:@"events in middle week %d", eventsInMiddleWeeks]));	
					
					NSInteger numberOFItemsBetweenStartDayOfWeekAndTodaysDayOFweekInSpecifierArray
					= GetNumberOfItemsBetweenRange(weekDaysArray, startDayOfWeek, nowdayOfWeek, 8);
					
					Log((CFStringRef)([NSString stringWithFormat:@"numberOFItemsBetweenStartDayOfWeekAndTodaysDayOFweekInSpecifierArray %d"
									   , numberOFItemsBetweenStartDayOfWeekAndTodaysDayOFweekInSpecifierArray]));
					
					//int eventsInFirstWeek = (noOfEventdaysInWeek - GetNumberOfItemsLessThanGivenNumber(specifierInInt, startDayOfWeek));
					//Log((CFStringRef)([NSString stringWithFormat:@"events in first week %d", eventsInFirstWeek]));	
					
					//int eventsInCurrentWeek = GetNumberOfItemsLessThanGivenNumber(specifierInInt, nowdayOfWeek);
					//Log((CFStringRef)([NSString stringWithFormat:@"events in current week %d", eventsInCurrentWeek]));	
					
					int occurenceAlreadyHappened = eventsInMiddleWeeks +numberOFItemsBetweenStartDayOfWeekAndTodaysDayOFweekInSpecifierArray;
					//+ eventsInFirstWeek
					//+ eventsInCurrentWeek;
					
					if(occurenceAlreadyHappened < eventCount)
					{
						Log(CFSTR("count based weekly recurrence, silent done"));
						doSilent = TRUE;
					}
				}
				else if ((eventCount == 0 || [now compare:recEndDate] != NSOrderedDescending) && (numberOfWeeks % interval == 0))
				{//date based..make it silent
					Log(CFSTR("time based weekly recurrence silent done"));
					doSilent = TRUE;
				}
			}//istodaysilentday
			
		}//specififerint	
		//}
		
	}
	
	Log((CFStringRef)[NSString stringWithFormat:@"weekly result %d", doSilent]);
	
	return doSilent;
}	



inline BOOL IsSilentDay(NSInteger specifierCommaSepartedItems[], int todaysDay)
{
	 BOOL isTodaySilentDay = FALSE;
	
	if(specifierCommaSepartedItems[todaysDay-1] == 0)
	{
		isTodaySilentDay = TRUE;
	}
	//	if(specifierCommaSepartedItems != NULL)
	//	{
	//		int arrayCount = [specifierCommaSepartedItems count];
	//		NSNumber* anObject;
	//		int element = -1; 
	
	//		NSEnumerator *enumerator = [specifierCommaSepartedItems objectEnumerator];
	
	//		while (anObject = [enumerator nextObject]) {
	//			element = [anObject intValue];
	
	//			if(todaysDay == element)
	//			{
	//				isTodaySilentDay = TRUE;
	//				break;
	//			}
	//		}
	//	}
	
	return isTodaySilentDay;
	
}



inline NSInteger ConvertMonthSpecifierToInt(NSString* specifier)
{
	Log((CFStringRef)specifier);
	
	if(specifier != NULL && [specifier length] > 2)
	{
		
		NSString* firstTwoChars = [specifier substringToIndex: 2];
		
		if([firstTwoChars caseInsensitiveCompare:@"M="] == NSOrderedSame)
		{
			specifier = [specifier substringFromIndex:2];
			
			return [specifier integerValue];
		}
	}
	
	return 0;
}

//prefix to be removed by the method D=
inline NSArray* ConvertStringWeekArrayToInt(NSString* specifier)
{
	
	if(specifier != NULL && [specifier length] > 2)
	{
		NSString* getfirstTwoChars = [specifier substringToIndex:2];
		
		if([getfirstTwoChars caseInsensitiveCompare:@"D="] == NSOrderedSame)
		{
			NSString* weekString = [specifier substringFromIndex:2];
			
			NSArray* specifierCommaSepartedItems = [weekString componentsSeparatedByString:@","];
			
			if(specifierCommaSepartedItems != NULL)
			{
				int arrayCount = [specifierCommaSepartedItems count];
				Log((CFStringRef)[NSString stringWithFormat:@"weekly specifier array, count: %d", arrayCount]);
				
				//NSMutableArray* specifierArrayInInt = [[NSMutableArray alloc] init];
				//			NSNumber *numberToAdd; 
				
				
				NSEnumerator *enumerator = [specifierCommaSepartedItems objectEnumerator];
				NSString* anObject;
				
				
				Log(CFSTR("weekly specifier, started enumeration."));
				while (anObject = [enumerator nextObject]) 
				{
					Log((CFStringRef)anObject);
					
					if([anObject length] > 2)
					{
						
						//leave last 2 chars for the day. 
						NSString* intStr = [anObject substringToIndex: [anObject length] -2];
						NSInteger nthWeek = [intStr integerValue];
						
						NSString* weekDayStr = [anObject substringFromIndex:[anObject length] -2];
						
						if([@"SU" caseInsensitiveCompare:weekDayStr] == NSOrderedSame)
						{
							Log(CFSTR("found su"));
							weekDaysArray[0] = nthWeek;
							//	numberToAdd = [[NSNumber alloc] initWithInt:1];
							//	[specifierArrayInInt addObject:numberToAdd];
							
						}					
						else if([@"MO" caseInsensitiveCompare:weekDayStr] == NSOrderedSame) {
							//	numberToAdd = [[NSNumber alloc] initWithInt:2];
							//	[specifierArrayInInt addObject:numberToAdd];
							Log(CFSTR("found mo"));
							weekDaysArray[1] = nthWeek;
						}
						else if([@"TU" caseInsensitiveCompare:weekDayStr] == NSOrderedSame) {		
							//						numberToAdd = [[NSNumber alloc] initWithInt:3];
							//						[specifierArrayInInt addObject:numberToAdd];
							Log(CFSTR("found tu"));
							weekDaysArray[2] = nthWeek;
						}					
						else if([@"WE" caseInsensitiveCompare:weekDayStr] == NSOrderedSame) {
							//						numberToAdd = [[NSNumber alloc] initWithInt:4];
							//						[specifierArrayInInt addObject:numberToAdd];
							Log(CFSTR("found we"));
							weekDaysArray[3] = nthWeek;
						}
						else if([@"TH" caseInsensitiveCompare:weekDayStr] == NSOrderedSame) {
							
							//						numberToAdd = [[NSNumber alloc] initWithInt:5];
							//						[specifierArrayInInt addObject:numberToAdd];
							Log(CFSTR("found th"));
							weekDaysArray[4] = nthWeek;
						}					
						else if([@"FR" caseInsensitiveCompare:weekDayStr] == NSOrderedSame) {
							//						numberToAdd = [[NSNumber alloc] initWithInt:6];
							//						[specifierArrayInInt addObject:numberToAdd];
							Log(CFSTR("found fr"));
							weekDaysArray[5] = nthWeek;
						}
						else if([@"SA" caseInsensitiveCompare:weekDayStr] == NSOrderedSame) {
							//						numberToAdd = [[NSNumber alloc] initWithInt:7];
							//						[specifierArrayInInt addObject:numberToAdd];
							Log(CFSTR("found sa"));
							weekDaysArray[6] = nthWeek;
						}
						
					}
				}
				
				//[specifierArrayInInt release];
				
				//		Log((CFStringRef) arrayItems);
				
				//return specifierArrayInInt;
			}
		}
	}
	
	return NULL;
	
}



