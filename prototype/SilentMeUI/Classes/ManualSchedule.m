#import "ManualSchedule.h"
#import "Constants.h"
#import "Model.h"
#import "OnOffCell.h"
#import "BaseCell.h"
#import "Section.h"
#import "NameCell.h"
#import "Calendar.h"
#import "TextViewCell.h"

static ManualSchedule* schedule = nil;
static NSString* const EnableLabel = @"Enable";

static NSString * const calendarLabel = @"Calendars";
static NSString * const CalendarUsageHeader = @"Usage Information";

@implementation ManualSchedule

+(ManualSchedule*) Schedule
{
	if (schedule == nil)
	{
		schedule = [[ManualSchedule alloc] init];
	}
	return schedule;
}


- (ManualSchedule*) init
{
	self = [super init];
	dict = nil;
	ScheduleId = [[NSString stringWithFormat:@"%d",ManualScheduleId] retain];
	profile = [Profile ProfileWithId:[[Model GetModel] GetIntegerValue:ManualModeProfileKey]];
	return self;
}

-(NSString*)  ViewControllerClassName
{
	return @"BaseController";
}

-(NSMutableArray*) ViewDataSource
{
	//[self initViewDataSource];
	//return viewDataSource;
	return nil;
}

- (NSString*) Name
{
	//return NSLocalizedString(CalenderScheduleName,@"");
	return @"";
}

- (bool) Enabled
{
	return [[Model GetModel] GetBoolValue:ManualMode];
}

- (int) StartTime
{
	return 0;
	
}

- (int) EndTime
{
	return 0;
}

- (Profile*) Profile
{
	return profile;
}

-(NSString*) GetTimeForInt:(int)seconds;
{
	return @"";
}

-(NSString*) TimeString
{
	return @"";
}

- (NSDate*) GetDateFromInteger:(int) secondsElapsed
{
	return nil;
}

-(int) GetTimeElapsedForTheday:(NSDate*) date
{
	return 0;
}

-(void) SetBoolValue:(NSString*)key value:(BOOL)val
{
	[[Model GetModel] SetBoolValue:key value:val];
	[self PostMyNotification:key];
}

-(void) SetIntegerValue:(NSString*)key value:(int)val
{
	[[Model GetModel] SetIntegerValue:key value:val];
}

-(void) PostMyNotification:(NSString*)key
{
	[BaseDictionary PostInterProcessNotification:NotificaitonManualModeProfileChanged];
}

-(void) SetProfile:(Profile*) prof
{
	profile = prof;
	[self SetIntegerValue:ManualModeProfileKey value:[profile GetProfileId]];
	[self PostMyNotification:CalendarProfileTag];
}

@end
