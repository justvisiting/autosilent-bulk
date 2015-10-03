#import "Schedule.h"
#import "MultipleTimeCell.h"
#import "Section.h"
#import "OnOffCell.h"
#import "ScheduleTimeCell.h"
#import "CalenderSchedule.h"
#import "Constants.h"
#import "TextFieldCell.h"
#import "NameCell.h"
#import "SceduleRepeatStringCell.h"
#import "ScheduleNameCell.h"
#import "Model.h"

static NSMutableDictionary* MasterScheduleDict = nil;
static NSMutableArray* ScheduleArray = nil;
static NSMutableArray* ScheduleCells = nil;
static NSString * const profileTag = @"Profile";
static NSString * const NameTag = @"Name";
static NSString * const EnabledTag = @"Enabled";
static NSString * const StartTimeTag = @"StartTime";
static NSString * const EndTimeTag = @"EndTime";
static NSString * const RepeatInfoTag = @"RepeatInfo";

static NSString* const Enable = @"Enable";
static NSString* const Starts = @"Starts";
static NSString* const Ends = @"Ends";
static NSString* const AllDays = @"Everyday";

//static  NSArray *dayList = [NSArray arrayWithObjects: @"sun",
//						  @"mon", 
//						  @"tue", 
//						  @"wed",
//						  @"thu",
//						  @"fri",
//						  @"sat", nil] ;
//static  NSArray *dayList = nil;

@implementation Schedule

+ (Schedule*) ScheduleWithId:(NSString*) scheduleId
{
	if (MasterScheduleDict == nil)
	{
		MasterScheduleDict = [[NSMutableDictionary dictionaryWithContentsOfFile:ScheduleFilePath] retain];
	}
	
	return (Schedule*) [[Schedule alloc] initFromId:scheduleId];
}

+ (NSMutableArray*) AllSchedules
{
	if (ScheduleArray == nil)
	{
		[Schedule InitScheduleArray];
	}
	
	return ScheduleArray;
}

+(NSMutableArray*) CellsForSchedule
{
	[Schedule InitScheduleCells];
	return ScheduleCells;
}


+(void)InitScheduleArray
{
	if (ScheduleArray != nil)
		return;
	
	if (MasterScheduleDict == nil)
	{
		MasterScheduleDict = [[NSMutableDictionary dictionaryWithContentsOfFile:ScheduleFilePath] retain];
	}
	
	ScheduleArray = [[NSMutableArray alloc] init];
	NSArray *keys;
	int i, count;
	NSString* key ;
	
	keys = [MasterScheduleDict allKeys];
	count = [keys count];
	for (i = 0; i < count; i++)
	{
		key = (NSString*)[keys objectAtIndex: i];
		[ScheduleArray addObject:[Schedule ScheduleWithId:key]];
	}
}

+(void)InitScheduleCells
{
	if (ScheduleCells != nil)
		return;
	
	[Schedule InitScheduleArray];
	
	int i;
	
	ScheduleCells = [[NSMutableArray alloc] init];
	for (i =0; i < [ScheduleArray count]; i++) {
		MultipleTimeCell * cell = [[MultipleTimeCell alloc] initWithSchedule:(Schedule*)[ScheduleArray objectAtIndex:i]];
		[ScheduleCells addObject:cell];
	}
	[ScheduleCells addObject:[[MultipleTimeCell alloc] initWithSchedule:[CalenderSchedule Schedule]]];
	
	//TODO add calender  schedule
}

+(Schedule*) CreateNewSchedule
{
	int i;
	NSMutableArray * repeatArray = [ [NSMutableArray alloc] initWithCapacity:7];
	for ( i = 0 ; i < 7 ; i++ )
	{
		[repeatArray addObject:[NSNumber numberWithInt:i+1]];
	}
	BaseDictionary * schedDict = [[BaseDictionary alloc] initDict];
	
	[schedDict SetBoolValue:EnabledTag value:NO];
	[schedDict SetIntegerValue:StartTimeTag value:[ Schedule GetTimeElapsedForTheday:[NSDate date]]];
	[schedDict SetIntegerValue:EndTimeTag value:[self GetTimeElapsedForTheday:[NSDate date]]];
	[schedDict SetValue:NameTag value:@""];
	[schedDict SetIntegerValue:profileTag value:SilentProfileId];
	[schedDict SetValue:RepeatInfoTag value:repeatArray];
	Schedule * newSchedule = [Schedule alloc];
	newSchedule->dict = [[NSMutableDictionary alloc]  initWithDictionary:schedDict->dict];
	//[newSchedule->dict initWithDictionary:schedDict->dict];
	newSchedule->ScheduleId = [[NSString stringWithFormat:@"%d", [ScheduleArray count] + 1] retain];
	newSchedule->profile = [Profile ProfileWithId:SilentProfileId];
	
	[newSchedule initViewDataSource];
	newSchedule->isNotComitted = YES;
	return newSchedule;
}

+(void) SaveNewSchedule:(Schedule*) newSchedule
{
	[ScheduleArray addObject:newSchedule];
	MultipleTimeCell * cell = [[MultipleTimeCell alloc] initWithSchedule:newSchedule];
	[ScheduleCells addObject:cell];
	//[MasterScheduleDict setObject:newSchedule->dict forKey:newSchedule->ScheduleId];
	[newSchedule PersistData];
	[newSchedule PostMyNotification:nil];
	newSchedule->isNotComitted = NO;
}

+(void) DeleteSchedule:(Schedule*) deleteSchedule
{
	[ScheduleArray removeObject:deleteSchedule];
	[deleteSchedule->dict release];
	deleteSchedule->dict = nil;
	
	int i;
	for (i=0; i< [ScheduleArray count] ; i++) {
		Schedule * sched = [ScheduleArray objectAtIndex:i];
		sched->ScheduleId = [[NSString stringWithFormat:@"%d",i+1] retain];
		[sched PersistData];
	}
	deleteSchedule->ScheduleId = [[NSString stringWithFormat:@"%d",i+1] retain];
	[deleteSchedule PersistData];
	
	for (i=0; i< [ScheduleCells count] ; i++) {
		MultipleTimeCell * sched = [ScheduleCells objectAtIndex:i];
		[sched release];
	}
	[ScheduleCells removeAllObjects];
	[ScheduleCells release];
	ScheduleCells = nil;
	[self InitScheduleCells];
	[deleteSchedule release];
	[self PostScheduleChangedNotification];
	
}

+(void)PostScheduleChangedNotification
{
		[BaseDictionary PostInterProcessNotification:NotificaitonScheduleChanged];
}

- (Schedule*) initFromId: (NSString*) scheduleId
{
	self = [super init];
	
	if ( MasterScheduleDict == nil)
	{
		MasterScheduleDict = [[NSMutableDictionary dictionaryWithContentsOfFile:ScheduleFilePath] retain];
	}
	dict = [[NSMutableDictionary dictionaryWithDictionary:(NSMutableDictionary*) [MasterScheduleDict objectForKey:scheduleId]] retain];
	ScheduleId = scheduleId;
	profile = [Profile ProfileWithId:[self GetIntegerValue:profileTag]];
	//TODO handle dict = nil case
	[self initViewDataSource];
	isNotComitted = NO;
	return self;
	
}

-(void) initViewDataSource
{
	viewDataSource = [[NSMutableArray alloc] init];
	Section* nameSec = [[Section alloc] initWithHeader:@""];
	//TextFieldCell * nameCell = [[TextFieldCell alloc] initWithTitle:[self Name] Schedule:self];
	ScheduleNameCell * nameCell = [[ScheduleNameCell alloc]  initWithSchedule:self nextControllerName:nil nextDataSource:nil];
	[nameSec addCell:nameCell];
	Section* firstSec =  [[Section alloc] initWithHeader:@""];
	OnOffCell * cell = [[OnOffCell alloc] initWithTitle:NSLocalizedString(Enable, @"") boolTag:EnabledTag dict:self];
	[firstSec addCell:cell];
	
		Section* secondSec =  [[Section alloc] initWithHeader:@""];
	ScheduleTimeCell * startTimeCell = (ScheduleTimeCell *) [[ScheduleTimeCell alloc] initWithTitle:NSLocalizedString(Starts, @"") nextControllerName:@"ScheduleTimeViewController" nextDataSource:[self GetStartTimeDataSource ]		intTag:StartTimeTag dict:self];
	
	[secondSec addCell:startTimeCell];
	
	ScheduleTimeCell * endTimeCell = (ScheduleTimeCell *)[[ScheduleTimeCell alloc] initWithTitle:NSLocalizedString(Ends, @"") nextControllerName:@"ScheduleTimeViewController" nextDataSource:[self GetEndTimeDataSource] intTag:EndTimeTag dict:self];
	
	[secondSec addCell:endTimeCell];
	
	
	Section * ProfileSection = [[Section alloc] initWithHeader:@""];
	NameCell * profileCell = [[NameCell alloc] initWithSchedule:self nextControllerName:nil nextDataSource:nil];
	[ProfileSection addCell:profileCell];
	
	Section * RepeatSec = [[Section alloc] initWithHeader:@""];
	SceduleRepeatStringCell * repeatCell = (SceduleRepeatStringCell * )[[SceduleRepeatStringCell alloc] initWithSchedule:self nextControllerName:nil nextDataSource:nil];
	[RepeatSec addCell:repeatCell];
	
	
	[viewDataSource addObject:nameSec];
	[viewDataSource addObject:firstSec];
	[viewDataSource addObject:secondSec];
	[viewDataSource addObject:ProfileSection];
	[viewDataSource addObject:RepeatSec];
	

	
}

-(NSMutableArray*) GetStartTimeDataSource
{
	NSMutableArray * startDataSource = [[NSMutableArray alloc] init];
		Section* firstSec =  [[Section alloc] initWithHeader:@""];
	ScheduleTimeCell * startTimeCell = (ScheduleTimeCell *) [[ScheduleTimeCell alloc] initWithTitle:NSLocalizedString(Starts, @"")		 nextControllerName:nil nextDataSource:nil  intTag:StartTimeTag dict:self];
		[firstSec addCell:startTimeCell];
	[startDataSource addObject:firstSec];
	
	return startDataSource;
}

-(NSMutableArray*) GetEndTimeDataSource
{
	NSMutableArray * startDataSource = [[NSMutableArray alloc] init];
	Section* firstSec =  [[Section alloc] initWithHeader:@""];
	ScheduleTimeCell * endTimeCell = (ScheduleTimeCell *)[[ScheduleTimeCell alloc] initWithTitle:NSLocalizedString(Ends, @"")
																			  nextControllerName:nil nextDataSource:nil
																						  intTag:EndTimeTag dict:self];
	
	[firstSec addCell:endTimeCell];
	
	[startDataSource addObject:firstSec];
	
	return startDataSource;
}

-(NSString*)  ViewControllerClassName
{
	return @"ScheduleViewController";
}

-(NSMutableArray*) ViewDataSource
{
	return viewDataSource;
}

- (NSString*) Name
{
	return [self GetStringValue:NameTag];
}

- (bool) Enabled
{
	//return (bool)[(NSNumber*)[dict valueForKey:EnabledTag] boolValue];
	return [self GetBoolValue:EnabledTag];
}

- (int) StartTime
{
	//return [(NSNumber*)[dict valueForKey:StartTimeTag] intValue];
	return [self GetIntegerValue:StartTimeTag];
}

- (int) EndTime
{
	//return [(NSNumber*)[dict valueForKey:EndTimeTag] intValue];
	return [self GetIntegerValue:EndTimeTag];
}

- (NSString*) RepeatString
{
	//TODO many issus
	NSArray *dayList = [NSArray arrayWithObjects: NSLocalizedString(@"Sun",@""),
							  NSLocalizedString(@"Mon",@""), 
							  NSLocalizedString(@"Tue",@""), 
							  NSLocalizedString(@"Wed",@""),
							  NSLocalizedString(@"Thu",@""),
							  NSLocalizedString(@"Fri",@""),
							  NSLocalizedString(@"Sat",@""), nil] ;
	
	NSArray * repeatDays =[self GetArray:RepeatInfoTag];
	NSMutableString * finalString = [[[NSMutableString alloc] initWithString:@""] autorelease];
	if ( [repeatDays count] == 0)
	{
		[finalString appendString:@"None"];
		return finalString;
	}
	
	if ( [repeatDays count] == 7)
	{
		[finalString appendString:NSLocalizedString(AllDays,@"")];
		return finalString;
	}
	
	int i;
	
	for (i=0; i< [repeatDays count]; i++) {
		if ( i != 0)
			[finalString appendString:@","];
		int index = [(NSNumber*)[repeatDays objectAtIndex:i] intValue] - 1;
		if (index >= 0 && index < 7)
		[finalString appendString:(NSString*)[dayList objectAtIndex:index]];
	}
	
	return finalString;
}

- (Profile*) Profile
{
	return profile;
}

-(NSString*) TimeString
{
	return [NSString stringWithFormat:@"(%@ - %@)", [self GetTimeForInt:[self StartTime]], [self GetTimeForInt:[self EndTime]]];
}


-(NSString*) GetTimeForInt:(int)seconds
{	
	//if (![[Model GetModel] GetBoolValue:boolTag])
	//{
	//	return @"Off";
	//}
	
	return [[[self GetDateFromInteger:seconds] descriptionWithCalendarFormat:
			 @"%I:%M %p" timeZone:nil locale:nil] description];
}

- (NSDate*) GetDateFromInteger:(int) secondsElapsed
{
	NSDate * date = [NSDate date];
	int nowSeconds = [Schedule GetTimeElapsedForTheday:date];
	secondsElapsed = secondsElapsed - nowSeconds;
	NSDate *returnDate = [[NSDate alloc] initWithTimeInterval:secondsElapsed sinceDate:date];
	return returnDate;
	
}

+(int) GetTimeElapsedForTheday:(NSDate*) date
{
	NSCalendar *gregorian = [[NSCalendar alloc]
							 initWithCalendarIdentifier:NSGregorianCalendar];
	
	NSUInteger unitFlags = NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
	
	NSDateComponents *components = [gregorian components:unitFlags 
												fromDate:date];
	
	int rv =	([components hour] * 60 + [components minute]) * 60 + [components second];
	
	
	[gregorian release];
	return rv;
	
}

-(void) SetBoolValue:(NSString*)key value:(BOOL)val
{
	[super SetBoolValue:key value:val];
	if (![self IsNotCommited])
	{
	[self PersistData];
	[self PostMyNotification:key];
	}
}

-(void) SetIntegerValue:(NSString*)key value:(int)val
{
	[super SetIntegerValue:key value:val];
	if (![self IsNotCommited])
	{
	[self PersistData];
	[self PostMyNotification:key];
	}
}

-(void) SetValue:(NSString*)key value:(id)val
{
	[super SetValue:key value:val];
	if (![self IsNotCommited])
	{
		[self PersistData];
	}
}
-(void) PersistData
{
	[MasterScheduleDict setValue:dict forKey:ScheduleId];
	[MasterScheduleDict writeToFile:ScheduleFilePath atomically:YES];
}

-(void) PostMyNotification:(NSString*)key
{
	[BaseDictionary PostInterProcessNotification:NotificaitonScheduleChanged];
}

-(void) SetProfile:(Profile*) prof
{
	profile = prof;
	[self SetIntegerValue:profileTag value:[profile GetProfileId]];
}
-(NSArray*) GetRepeatArray
{
	return [self GetArray:RepeatInfoTag];
}
-(void) SetRepeatArray:(NSArray*) array
{
	[self SetValue:RepeatInfoTag value:array];
	if(![self IsNotCommited])
	{
		[self PersistData];
		[self PostMyNotification:RepeatInfoTag];
	}
}

-(bool) IsDayApplicable:(NSInteger) day
{
	NSArray * repeatDays =[self GetArray:RepeatInfoTag];

	int i;
	
	for (i=0; i< [repeatDays count]; i++) {

		if (day == [(NSNumber*)[repeatDays objectAtIndex:i] intValue] )
			return YES;

	}
	
	return NO;
	
}

-(bool)IsNotCommited
{
	return isNotComitted;
}

-(bool) IsActive
{
	[[Model GetModel] RefreshDaemonDictionary];
	NSNumber* num = [[Model GetModel] GetValueFromDaemon:CurrentScheduleKey];
	int currProfileId = DefaultScheduleIdWhenNoScheduleIsApplicable;
	if (num != nil)
	{
		currProfileId = [num intValue];
	}
	
	if (currProfileId == [ ScheduleId intValue] )
	{
		return YES;
	}
	else
	{
		return NO;
	}
	
}

@end


