#import "SingletonDataSources.h"
#import "Constants.h"
#import "OnOffCell.h"
#import "MultipleTimeCell.h"
#import "ScheduleTimeCell.h"
#import "StatusCell.h"
#import "FixSilentSwitch.h"
#import "UploadLogsCell.h"
#import "SendEmailCell.h"
#import "Schedule.h"
#import "Model.h"
#import "Profile.h"
#import "ManualProfileCell.h"
#import "TextViewCell.h"

static NSMutableArray* MainTableDataSource = nil;
static NSMutableArray* ManualTimeSetterDataSource = nil;
static NSMutableArray* MiscDataSource = nil;
static NSMutableArray* ProfileDataSource = nil;
static NSMutableArray* CreditsDataSource = nil;
//static NSMutableArray* WeekendNightEnabled = nil;

static ManualTimeCell* manualTimeCell = nil;
static NSString* const Enable = @"Enable";
static NSString* const Starts = @"Starts";
static NSString* const Ends = @"Ends";

static NSString* const MiscItemsLabel = @"More";
static NSString* const ManualEndsLabel = @"Ends";

static NSString* const ManualModeLabel = @"Manual Mode";
static NSString* const AutomaticModeLabel = @"Automatic Mode";
static NSString* const CreateScheduleLabel = @"Create New Schedule";
static NSString* const CreditsTitle = @"Without your help, this app would not be possible.Thank You!";
static NSString* const CreditsCellTitle = @"Credits";
static NSString* const CreditsFile = @"/Applications/SilentMe.app/configs/credits.plist";
/*
NSMutableArray* GetWeekdayTableDataSource()
{
	NSMutableArray* weekdaySchedule = [[NSMutableArray alloc] init];
	Section* firstSec =  [[Section alloc] initWithHeader:@""];

	
	OnOffCell * cell = [[OnOffCell alloc] initWithTitle:NSLocalizedString(Enable, @"") boolTag:NightEnabled];
	[firstSec addCell:cell];
	ScheduleTimeCell * startTimeCell = (ScheduleTimeCell *) [[ScheduleTimeCell alloc] initWithTitle:NSLocalizedString(Starts, @"")
										nextControllerName:nil nextDataSource:nil intTag:weekdayStart];
	[firstSec addCell:startTimeCell];
	
	ScheduleTimeCell * endTimeCell = (ScheduleTimeCell *)[[ScheduleTimeCell alloc] initWithTitle:NSLocalizedString(Ends, @"")
								 nextControllerName:nil nextDataSource:nil intTag:weekdayEnd];
     
		[firstSec addCell:endTimeCell];
	
	[weekdaySchedule addObject:firstSec];
	
	return weekdaySchedule;
}

NSMutableArray* GetWeekendTableDataSource()
{
	NSMutableArray* weekdaySchedule = [[NSMutableArray alloc] init];
	Section* firstSec =  [[Section alloc] initWithHeader:@""];
	OnOffCell * cell = [[OnOffCell alloc] initWithTitle:NSLocalizedString(Enable, @"") boolTag:WeekendNightEnabled];
	[firstSec addCell:cell];
	ScheduleTimeCell * startTimeCell = (ScheduleTimeCell *) [[ScheduleTimeCell alloc] initWithTitle:NSLocalizedString(Starts, @"")
										nextControllerName:nil nextDataSource:nil intTag:weekendStart];
	[firstSec addCell:startTimeCell];
	
	ScheduleTimeCell * endTimeCell = (ScheduleTimeCell *)[[ScheduleTimeCell alloc] initWithTitle:NSLocalizedString(Ends, @"")
									  nextControllerName:nil nextDataSource:nil  intTag:weekendEnd];
	
	[firstSec addCell:endTimeCell];
	
	[weekdaySchedule addObject:firstSec];
	
	return weekdaySchedule;
}


NSMutableArray* GetCalendarSyncDataSource()
{
	NSMutableArray* weekdaySchedule = [[NSMutableArray alloc] init];
	Section* firstSec =  [[Section alloc] initWithHeader:@""];
	OnOffCell * cell = [[OnOffCell alloc] initWithTitle:NSLocalizedString(@"Sync With Calender",@"") boolTag:CalSyncEnabled];
	[firstSec addCell:cell];
	
	[weekdaySchedule addObject:firstSec];
	
	return weekdaySchedule;
}
*/

NSMutableArray* GetSilentSettingsDataSource()
{
	NSMutableArray* silentSettings = [[NSMutableArray alloc] init];
	Section* firstSec =  [[Section alloc] initWithHeader:@""];
	[silentSettings addObject:firstSec];
	
	NSMutableArray* stringArray = [[NSMutableArray alloc] init];
	
	[stringArray addObject:PhoneEnabled];
	[stringArray addObject:VibrateEnabled];
	[stringArray addObject:VoiceMailEnabled];
	[stringArray addObject:NewMailEnabled];
	[stringArray addObject:CalAlertEnabled];
	[stringArray addObject:SmsAlertEnabled];
	[stringArray addObject:LockUnlockEnabled];
	[stringArray addObject:KeyboardSoundEnabled];
	[stringArray addObject:SentMailEnabled];
	
	[stringArray addObject:RingToneLabel];
	[stringArray addObject:VibrateLabel];
	[stringArray addObject:VoiceMailLabel];
	[stringArray addObject:NewMailLabel];
	[stringArray addObject:CalenderLabel];
	[stringArray addObject:NewTextLabel];
	[stringArray addObject:LockSoundsLabel];
	[stringArray addObject:KeyboardSoundLabel];

	
	int i;
	for ( i = 0;  i < 9; i++) {
		NSString* str = (NSString*)[stringArray objectAtIndex:i];
		NSString* label = NSLocalizedString( (NSString*)[stringArray objectAtIndex:i+9], @"");  
		OnOffCell * cell = (OnOffCell*)[[OnOffCell alloc] initWithTitle:label boolTag:str dict:[Model GetModel]];
		[firstSec addCell:cell];
	}

	[stringArray release];
	
	return silentSettings;
}

NSMutableArray* GetProfileDataSource()
{
	if (ProfileDataSource == nil)
	{
				ProfileDataSource = [[NSMutableArray alloc] init];
		Section * settingsSection = [[Section alloc] initWithHeader:@""];
		//BaseCell * settingsCell = [[BaseCell alloc] initWithTitle:NSLocalizedString(@"SilentProfile Settings", @"") nextControllerName:@"BaseController" nextDataSource:GetSilentSettingsDataSource()];
		NSMutableArray * profiles = [Profile GetProfileArray];
		int i;
		
		for (i=0; i < [profiles count]; i++) {
			[settingsSection addCell:(BaseCell*)[(Profile*)[profiles objectAtIndex:i] getProfileCell]];
		}
		
		[ProfileDataSource addObject:settingsSection];
	}
	return ProfileDataSource;	
}

NSMutableArray* GetMainTableDataSource()
{
	if ( MainTableDataSource == nil )
	{
		MainTableDataSource = [[NSMutableArray alloc] init];
		
		Section * statusSection = [[Section alloc] initWithHeader:@""];
		[statusSection addCell:[[StatusCell alloc] init]];
		
		Section * manualSection = [[Section alloc] initWithHeader:NSLocalizedString(ManualModeLabel, @"")];

		OnOffCell * cell = [[OnOffCell alloc] initWithTitle:NSLocalizedString(@"Silent Now", @"") boolTag:ManualMode dict:[Model GetModel]];
		[manualSection addCell:cell];
		ManualTimeCell * timerCell = [[ManualTimeCell alloc] initWithTitle:NSLocalizedString(ManualEndsLabel, @"")
														nextControllerName:@"ManualTimeSetterController" 
														nextDataSource:GetManualTimeSetterDataSource() dateTag:ManualEndTime dict:[Model GetModel]];
		[manualSection addCell:timerCell];
		ManualProfileCell * manualProfile = [[ManualProfileCell alloc] init];
		[manualSection addCell:manualProfile];
		
		Section * autoSection = [[Section alloc] initWithHeader:NSLocalizedString(AutomaticModeLabel,@"")];
		OnOffCell * enabledCell = [[OnOffCell alloc] initWithTitle:NSLocalizedString(Enable, @"") boolTag:AutomaticEnabledKey dict:[Model GetModel]];
		[autoSection addCell:enabledCell];
		
		BaseCell * addSchedule = [[BaseCell alloc] initWithTitle:NSLocalizedString(CreateScheduleLabel,@"") nextControllerName:@"ScheduleViewController" nextDataSource:nil CreateSchedule:YES];
		[autoSection addCell:addSchedule];
		int i;
		
		for (i=0; i< [[Schedule CellsForSchedule] count]; i++) {
			MultipleTimeCell * cell = (MultipleTimeCell*) [[Schedule CellsForSchedule] objectAtIndex:i];
			[autoSection addCell:cell];
		}
		
		//MultipleTimeCell * calendarCell = (MultipleTimeCell*)[[MultipleTimeCell alloc] initWithTitle:NSLocalizedString(@"Calender Sync", @"") nextControllerName:@"BaseController" nextDataSource:GetCalendarSyncDataSource() boolTag:CalSyncEnabled];
		//calendarCell->profileString = NSLocalizedString(@"SilentProfile", @"");
		//calendarCell->scheduleDays = NSLocalizedString(@"Schedule based on Calender Events", @"");
		
		//[autoSection addCell:calendarCell];
		
		//OnOffCell * weekendNightsCell = [[OnOffCell alloc] initWithTitle:@"Weekend Nights" boolTag:WeekendNightEnabled];
		//[autoSection addCell:weekendNightsCell];
		
		Section * settingsSection = [[Section alloc] initWithHeader:@""];
		BaseCell * profileCell = [[BaseCell alloc] initWithTitle:NSLocalizedString(@"Profiles",@"") nextControllerName:@"ProfileAddController" nextDataSource:[Profile GetProfileDataSource]];
		
		[settingsSection addCell:profileCell];
	
			//Section * fixSection = [[Section alloc] initWithHeader:@""];
			//FixSilentSwitch * fixCell = [[FixSilentSwitch alloc] init];
			//[fixSection addCell:fixCell];
		
		
		Section * miscSection = [[Section alloc] initWithHeader:@""];
		BaseCell * MiscCell = [[BaseCell alloc] initWithTitle:NSLocalizedString(MiscItemsLabel,@"") nextControllerName:@"BaseController" nextDataSource:GetMiscDataSource()];
		[miscSection addCell:MiscCell];
		
		[MainTableDataSource addObject:statusSection];
		[MainTableDataSource addObject:manualSection];
		[MainTableDataSource addObject:autoSection];
		[MainTableDataSource addObject:settingsSection];
			//[MainTableDataSource addObject:fixSection];
		[MainTableDataSource addObject:miscSection];
	}
	
	return MainTableDataSource;
}


NSMutableArray* GetManualTimeSetterDataSource()
{
	if ( ManualTimeSetterDataSource == nil)
	{
		ManualTimeSetterDataSource = [[NSMutableArray alloc] init];
		
		Section * manualSection = [[Section alloc] initWithHeader:@""];
		manualTimeCell = [[ManualTimeCell alloc] initWithTitle:NSLocalizedString(ManualEndsLabel, @"") dateTag:ManualEndTime dict:[Model GetModel]];
		[manualSection addCell:manualTimeCell];

		[ManualTimeSetterDataSource addObject:manualSection];
	}
	
	return ManualTimeSetterDataSource;
}

ManualTimeCell * ManualTimeCell()
{
	return manualTimeCell;
}

NSString * GetManualTimeString()
{
	return [ManualTimeCell() getTimeString];
}

NSMutableArray* GetMiscDataSource()
{
	if ( MiscDataSource == nil)
	{
		MiscDataSource = [[NSMutableArray alloc] init];
		
		Section * ContactUsSection = [[Section alloc] initWithHeader:NSLocalizedString(@"",@"")];
		SendEmailCell * emailCell = [[SendEmailCell alloc] initForEmail];
		[ContactUsSection addCell:emailCell];
		
		Section * debugSection = [[Section alloc] initWithHeader:@""];
		UploadLogsCell * uploadCell = [[UploadLogsCell alloc] init];
		[debugSection addCell:uploadCell];
		
		Section * TwitterSection = [[Section alloc] initWithHeader:@""];
		SendEmailCell * tweetCell = [[SendEmailCell alloc] initForTwitter];
		[TwitterSection addCell:tweetCell];
		
		Section * ReferSection = [[Section alloc] initWithHeader:@""];
		SendEmailCell * referCell = [[SendEmailCell alloc] initForReferAFriend];
		[ReferSection addCell:referCell];
		
		Section * ReferStatsSection = [[Section alloc] initWithHeader:@""];
		SendEmailCell * referStatsCell = [[SendEmailCell alloc] initForReferralStatistics];
		[ReferStatsSection addCell:referStatsCell];
		
		Section * FaqSection = [[Section alloc] initWithHeader:@""];
		SendEmailCell * faqCell = [[SendEmailCell alloc] initForFaq];
		[FaqSection addCell:faqCell];
		
		Section * CreditSec = [[Section alloc] initWithHeader:@""];
		BaseCell * creditCell = [[BaseCell alloc] initWithTitle:NSLocalizedString(CreditsCellTitle,@"") nextControllerName:@"BaseController" nextDataSource:GetCreditsDataSource()];
		[CreditSec addCell:creditCell];
		
		Section * DisableStatusSec = [[Section alloc] initWithHeader:@""];
		SendEmailCell * disableCell = [[SendEmailCell alloc] initForDisableStatusIcon];
		[DisableStatusSec addCell:disableCell];
		
		[MiscDataSource addObject:FaqSection];
		[MiscDataSource addObject:ReferSection];
		[MiscDataSource addObject:ReferStatsSection];
		[MiscDataSource addObject:CreditSec];
		[MiscDataSource addObject:TwitterSection];
		[MiscDataSource addObject:ContactUsSection];
			//		[MiscDataSource addObject:DisableStatusSec];
		[MiscDataSource addObject:debugSection];
	}
	
	return MiscDataSource;
}

NSMutableArray* GetCreditsDataSource()
{
	if (CreditsDataSource == nil)
	{
		CreditsDataSource = [[NSMutableArray alloc] init];
		Section * CreditsSection = [[Section alloc] initWithHeader:NSLocalizedString( CreditsTitle, @"")];
		
		NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithContentsOfFile:CreditsFile];
		[CreditsDataSource addObject:CreditsSection];
		

		NSArray * credList = [dict allValues];
		/*NSArray *credList = [NSArray arrayWithObjects: NSLocalizedString(@"Frederik Meyer.\nfrederik@gmail.om \nGerman Translation",@""),
							NSLocalizedString(@"Ma Lin for Chinese translation",@""), 
							NSLocalizedString(@"Yasaka for Japanese translation",@""), 
							NSLocalizedString(@"Italio for Spanish translation",@""),
							NSLocalizedString(@"Leo for helping out with bugs",@""),
							NSLocalizedString(@"Chris for his great feature suggestion",@""),
							NSLocalizedString(@"Wael bin khaled for nothing",@""), nil] ;*/

		
		int i;
		for (i=0; i < [credList count] ; i++) {
			//BaseCell * cell = [[TextViewCell alloc] initForCredit:(NSString*)[credList objectAtIndex:i]];
			//BaseCell * cell = [[BaseCell alloc] initSmallFontWithTitle:(NSString*)[credList objectAtIndex:i]];
			//[CreditsSection addCell:cell];
			Section * credSection = [[Section alloc] initWithHeader:[[(NSString*)[credList objectAtIndex:i] stringByReplacingOccurrencesOfString:@"@@" withString:@"\n"] retain]];
			[CreditsDataSource addObject:credSection];
		}
		
		//[CreditsDataSource addObject:CreditsSection];
		
	}
	
	return CreditsDataSource;
}