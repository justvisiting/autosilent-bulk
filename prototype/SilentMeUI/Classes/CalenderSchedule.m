#import "CalenderSchedule.h"
#import "Constants.h"
#import "Model.h"
#import "OnOffCell.h"
#import "BaseCell.h"
#import "Section.h"
#import "NameCell.h"
#import "Calendar.h"
#import "TextViewCell.h"

static NSString* const CalenderScheduleName = @"iPhone Calender";
static CalenderSchedule* schedule = nil;
static NSString* const CalenderScheduleDescription = @"Syncs with your Calendar";
static NSString* const EnableLabel = @"Enable";

static NSString * const calendarLabel = @"Calendars";
static NSString * const CalendarUsageHeader = @"Usage Information";

@implementation CalenderSchedule

+(CalenderSchedule*) Schedule
{
	if (schedule == nil)
	{
		schedule = [[CalenderSchedule alloc] init];
	}
	return schedule;
}


- (CalenderSchedule*) init
{
	self = [super init];
	dict = nil;
	ScheduleId = [[NSString stringWithFormat:@"%d",CalenderScheduleId] retain];
	profile = [Profile ProfileWithId:[[Model GetModel] GetIntegerValue:CalendarProfileTag]];
	//TODO handle dict = nil case
	[self initViewDataSource];
	return self;
}

-(NSString*)  ViewControllerClassName
{
	return @"BaseController";
}

-(NSMutableArray*) ViewDataSource
{
	[self initViewDataSource];
	return viewDataSource;
}

- (NSString*) Name
{
	return NSLocalizedString(CalenderScheduleName,@"");
}

- (bool) Enabled
{
	return [[Model GetModel] GetBoolValue:CalSyncEnabled];
}

- (int) StartTime
{
	return 0;
	
}

- (int) EndTime
{
	return 0;
}

- (NSString*) RepeatString
{
	return NSLocalizedString(CalenderScheduleDescription,@"");
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

-(void) initViewDataSource
{
	if (viewDataSource == nil)
	{
	viewDataSource = [[NSMutableArray alloc] init];
	Section* firstSec =  [[Section alloc] initWithHeader:@""];
	OnOffCell * cell = [[OnOffCell alloc] initWithTitle:NSLocalizedString(EnableLabel, @"") 
												boolTag:CalSyncEnabled dict:[Model GetModel]];
	[firstSec addCell:cell];
	
	Section * ProfileSection = [[Section alloc] initWithHeader:@""];
	NameCell * profileCell = [[NameCell alloc] initWithSchedule:self nextControllerName:nil nextDataSource:nil];
	[ProfileSection addCell:profileCell];
	
	Section * CalendarSection = [[Section alloc] initWithHeader:NSLocalizedString(calendarLabel,@"")];

	int i = 0;
	
	for (i=0; i< [[Calendar CalendarList] count]; i++) {
		
		[CalendarSection addCell:[(Calendar*)[[Calendar CalendarList] objectAtIndex:i] GetCell]];
	}
	

	Section * NotesSection = [[Section alloc] initWithHeader:NSLocalizedString(CalendarUsageHeader,@"")];
		TextViewCell * textcell = [[TextViewCell alloc] initWithTitle:@""];
		[NotesSection addCell:textcell];

	[viewDataSource addObject:firstSec];
	[viewDataSource addObject:ProfileSection];
	[viewDataSource addObject:CalendarSection];
		[viewDataSource addObject:NotesSection];
	}
	
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
	[BaseDictionary PostInterProcessNotification:NotificaitonScheduleChanged];
}

-(void) SetProfile:(Profile*) prof
{
	profile = prof;
	[self SetIntegerValue:CalendarProfileTag value:[profile GetProfileId]];
	[self PostMyNotification:CalendarProfileTag];
}

@end
