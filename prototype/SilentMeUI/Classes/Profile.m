#import "Profile.h"
#import "Section.h"
#import "OnOffCell.h"
#import "Constants.h"
#import "Model.h"
#import "ProfileNameCell.h"
#import "CalenderSchedule.h"
#import "ManualSchedule.h"

static NSMutableDictionary* MasterProfileDict = nil;
static NSString * const NameTag = @"Name";
static NSMutableArray* ProfileArray = nil;
static NSString * const NoneProfileName = @"None";
static NSString * const ProfileSettingsSuffix = @"Profile Settings";
static NSString * const CustomVolumeLabel = @"Customize Volume";
static NSMutableArray * ProfileDataSource = nil;
static Profile * DefaultProfile =  nil;

@implementation Profile

+ (NSMutableArray*) GetProfileDataSource
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

+ (void) DeleteProfileDataSource
{
	[ProfileDataSource release];
	ProfileDataSource = nil;
}

+ (Profile*) ProfileWithId:(int) profileId
{
	if (profileId == DefaultProfileId)
	{
		return [self GetDefaultProfile];
	}
	if ( MasterProfileDict == nil)
	{
		MasterProfileDict = [[NSMutableDictionary dictionaryWithContentsOfFile:ProfilesFilePath] retain];
	}
	
	[Profile InitProfileArray];
	int i;
	for (i=0; i< [ProfileArray count]; i++) {
		Profile * profile = [ProfileArray objectAtIndex:i];
		if ([profile GetProfileId] == profileId)
			return profile;
	}
	return nil;
	
}

+(Profile*) GetDefaultProfile
{
	if (DefaultProfile == nil)
	{
		DefaultProfile = [[Profile alloc] initFromId:DefaultProfileId];
	}
	return DefaultProfile;
}

+(Profile*) GetCurrentProfile
{
	NSNumber* num = [[Model GetModel] GetValueFromDaemon:CurrentProfileKey];
	int currProfileId = DefaultProfileId;
	if (num != nil)
	{
		currProfileId = [num intValue];
	}
	
	
	Profile * profile = [Profile ProfileWithId:currProfileId];
	
	return profile;
}


+(NSString*) GetCurrentProfileName
{
	NSNumber* num = [[Model GetModel] GetValueFromDaemon:CurrentProfileKey];
	int currProfileId = DefaultProfileId;
	if (num != nil)
	{
		currProfileId = [num intValue];
	}
	
	if (currProfileId == DefaultProfileId)
	{
		return NSLocalizedString(NoneProfileName,@"");
	}
	
	Profile * profile = [Profile ProfileWithId:currProfileId];
	
	if ( profile != nil)
	{
		return [profile Name];
	}
	else
	{
		return NSLocalizedString(NoneProfileName,@"");
	}
}


+(void) InitProfileArray
{
	if ( MasterProfileDict == nil)
	{
		MasterProfileDict = [[NSMutableDictionary dictionaryWithContentsOfFile:ProfilesFilePath] retain];
	}
	
	if(ProfileArray == nil)
	{
		ProfileArray = [[NSMutableArray alloc] init];
		NSArray *keys;
		int i, count;
		NSString* key ;
		
		keys = [MasterProfileDict allKeys];
		count = [keys count];
		for (i = 0; i < count; i++)
		{
			key = (NSString*)[keys objectAtIndex: i];
			Profile * prof = [[Profile alloc] initFromId:[key intValue]];
			[ProfileArray addObject:prof];
		}
	}
	
}

+(NSMutableArray*) GetProfileArray
{
	[Profile InitProfileArray];
	return ProfileArray;
}

+(Profile*) CreateNewProfile
{
	int MaxId = 0;
	
	int i;
	
	for (i =0; i< [[self GetProfileArray] count]; i++) {
		Profile * currProfile = (Profile*)[[self GetProfileArray] objectAtIndex:i];
		if ( [currProfile GetProfileId] > MaxId)
		{
			MaxId = [currProfile GetProfileId];
		}
	}
	MaxId = MaxId +1;
	
	Profile * newProfile = [[Profile alloc] initFromId:SilentProfileId];
	newProfile->profileId = MaxId;
	newProfile->isNotCommited = YES;
	
	NSMutableArray* stringArray = [[NSMutableArray alloc] init];
	
	[stringArray addObject:PhoneEnabled];
	[stringArray addObject:VibrateEnabled];
	[stringArray addObject:VoiceMailEnabled];
	[stringArray addObject:NewMailEnabled];
	[stringArray addObject:CalAlertEnabled];
	[stringArray addObject:SmsAlertEnabled];
	[stringArray addObject:LockUnlockEnabled];
	[stringArray addObject:KeyboardSoundEnabled];
	
	[stringArray addObject:RingToneLabel];
	[stringArray addObject:VibrateLabel];
	[stringArray addObject:VoiceMailLabel];
	[stringArray addObject:NewMailLabel];
	[stringArray addObject:CalenderLabel];
	[stringArray addObject:NewTextLabel];
	[stringArray addObject:LockSoundsLabel];
	[stringArray addObject:KeyboardSoundLabel];
	
	for ( i = 0;  i < 9; i++) {
		NSString* str = (NSString*)[stringArray objectAtIndex:i];
		[newProfile SetNonPersistBoolValue:str value:NO];
	}

	[newProfile SetValue:NameTag value:@""];
	
	return newProfile;
}

+(void) SaveProfile:(Profile*)profile
{
	[[self GetProfileArray] addObject:profile];
	[profile PersistData];
	profile->isNotCommited = NO;
	Section * sec = (Section*) [ProfileDataSource objectAtIndex:0];
	[sec addCell:[profile getProfileCell]];
	
}

+(void) DeleteProfile:(Profile*)profile
{
	[[self GetProfileArray] removeObject:profile];
	Section * sec = (Section*) [ProfileDataSource objectAtIndex:0];
	[sec removeCell:[profile getProfileCell]];
	[profile->dict release];
	profile->dict = nil;
	[profile PersistData];
	[profile->profileCell release];
	[profile release];
}

+(bool) IsProfileNameDuplicate:(Profile*)profile
{
	NSString * name = [profile Name];
	int i;
	for (i=0; i<[[self GetProfileArray] count]; i++) {
		Profile * currProfile = [[self GetProfileArray] objectAtIndex:i];
		
		if (profile != currProfile)
		{
			if ([name caseInsensitiveCompare:[currProfile Name]] == NSOrderedSame)
			{
				return YES;
			}
		}
	}
	
	return NO;
}

+(bool) IsNameDuplicate:(NSString*)name
{
	int i;
	for (i=0; i<[[self GetProfileArray] count]; i++) {
		Profile * currProfile = [[self GetProfileArray] objectAtIndex:i];

			if ([name caseInsensitiveCompare:[currProfile Name]] == NSOrderedSame)
			{
				return YES;
			}
	}
	
	return NO;
}

- (Profile*) initFromId: (int) profileIdentifier
{
	self = [super init];
	
	if (profileIdentifier == DefaultProfileId)
	{
		dict = nil;
		profileId = profileIdentifier;
		isNotCommited = NO;
		return self;
	}
	
	if ( MasterProfileDict == nil)
	{
		MasterProfileDict = [[NSMutableDictionary dictionaryWithContentsOfFile:ProfilesFilePath] retain];
	}
	dict = [[NSMutableDictionary dictionaryWithDictionary: (NSDictionary*)[MasterProfileDict objectForKey:[NSString stringWithFormat:@"%d",profileIdentifier]]] retain];
	profileId = profileIdentifier;
	//TODO handle dict = nil case
	//[self initViewDataSource];
	isNotCommited = NO;
	return self;
	
}

- (NSString*) RingTone
{
	return ringtone;
}

- (NSString*) CalendarAlertTone;
{
	return calendarAlertTone;
}

- (int) GetProfileId
{
	return profileId;
}

- (NSString*) Name
{
	if (profileId == DefaultProfileId)
	{
		return DefaultProfileName;
	}
	
	if (dict != nil)
		return [self GetStringValue:NameTag]; 
		
	return @"";
}

- (void) SetBoolValue:(NSString*) key value:(bool) val
{

	[super SetBoolValue:key value:val];
	
	
	if (![self IsNotCommited])
	{
		[self PersistData];
	
		[self  PostMyNotification:key];
	}
}

-(void) SetNonPersistBoolValue:(NSString*) key value:(bool) val
{
		[super SetBoolValue:key value:val];
}

-(void) PersistData
{
	[MasterProfileDict setValue:dict forKey:[NSString stringWithFormat:@"%d",profileId]];
	[MasterProfileDict writeToFile:ProfilesFilePath atomically:YES];
}

-(void) initViewDataSource
{

	if (viewDataSource == nil)
	{
		viewDataSource = [[NSMutableArray alloc] init];
		Section* nameSec = [[Section alloc] initWithHeader:@""];
		ProfileNameCell * nameCell = [[ProfileNameCell alloc]  initWithProfile:self nextControllerName:nil nextDataSource:nil];
		[nameSec addCell:nameCell];
		[viewDataSource addObject:nameSec];
		
		Section* firstSec =  [[Section alloc] initWithHeader:@""];
		[viewDataSource addObject:firstSec];
		
		NSMutableArray* stringArray = [[NSMutableArray alloc] init];
		
		[stringArray addObject:PhoneEnabled];
		[stringArray addObject:VibrateEnabled];
		[stringArray addObject:VoiceMailEnabled];
		[stringArray addObject:NewMailEnabled];
		[stringArray addObject:CalAlertEnabled];
		[stringArray addObject:SmsAlertEnabled];
		[stringArray addObject:LockUnlockEnabled];
		[stringArray addObject:KeyboardSoundEnabled];
		[stringArray addObject:PushNotificationEnabled];
		[stringArray addObject:SentMailEnabled]; 
		
		[stringArray addObject:RingToneLabel];
		[stringArray addObject:VibrateLabel];
		[stringArray addObject:VoiceMailLabel];
		[stringArray addObject:NewMailLabel];
		[stringArray addObject:CalenderLabel];
		[stringArray addObject:NewTextLabel];
		[stringArray addObject:LockSoundsLabel];
		[stringArray addObject:KeyboardSoundLabel];
		[stringArray addObject:PushNotificationLabel];
		[stringArray addObject:SentMailLabel];
		
		int i;
		for ( i = 0;  i < 10; i++) {
			NSString* str = (NSString*)[stringArray objectAtIndex:i];
			NSString* label = NSLocalizedString( (NSString*)[stringArray objectAtIndex:i+10], @"");  
			OnOffCell * cell = (OnOffCell*)[[OnOffCell alloc] initWithTitle:label boolTag:str dict:self];
			[firstSec addCell:cell];
		}
		
		[stringArray release];
		
	}
		
}

-(NSMutableArray*) ViewDataSource
{
	[self initViewDataSource];
	return viewDataSource;
}

-(void) SetValue:(NSString*)key value:(id)val
{
	[super SetValue:key value:val];
	if (![self IsNotCommited])
	{
		[self PersistData];
	}
}
-(BaseCell*)getProfileCell
{
	if ( profileCell == nil)
	{
		//profileCell = [[BaseCell alloc] initWithTitle:[[NSString stringWithFormat:@"%@ %@",[self Name], NSLocalizedString(ProfileSettingsSuffix,@"")] retain]
		//						nextControllerName:@"BaseController" 
	//							nextDataSource:[self ViewDataSource]];
		
		profileCell = [[BaseCell alloc] initWithTitle:[[self Name] retain] Profile:self];
	}
	else
	{
		[profileCell release];
		profileCell = [[BaseCell alloc] initWithTitle:[[self Name] retain] Profile:self];
	}
	
	return profileCell;
}

-(void) PostMyNotification:(NSString*)key
{
	[BaseDictionary PostInterProcessNotification:NotificaitonProfileChanged];
	
	if ([key caseInsensitiveCompare:PhoneEnabled] == NSOrderedSame)
	{
		if ([self GetBoolValue:PhoneEnabled])
		{
			[BaseDictionary PostInterProcessNotification:NotificaitonRingerOn];
		}
		else
		{
			[BaseDictionary PostInterProcessNotification:NotificaitonRingerOff];
		}
	}

	if ([key caseInsensitiveCompare:VibrateEnabled] == NSOrderedSame)
	{
		if ([self GetBoolValue:VibrateEnabled])
		{
			[BaseDictionary PostInterProcessNotification:NotificaitonVibrateOn];
		}
		else
		{
			[BaseDictionary PostInterProcessNotification:NotificaitonVibrateOff];
		}
	}
}

-(bool) IsNotCommited
{
	return isNotCommited;
}


-(bool) CanBeDeleted
{
	int i = 0;
	bool canBeDeleted = YES;
	for (i=0; i < [[Schedule AllSchedules] count] ; i++) {
		if ([(Schedule*)[[Schedule AllSchedules] objectAtIndex:i] Profile] == self)
		{
			canBeDeleted = NO;
		}
	}
	
	if ([[CalenderSchedule Schedule] Profile] == self)
	{
		canBeDeleted = NO;
	}
	
	if ([[ManualSchedule Schedule] Profile] == self)
	{
		canBeDeleted = NO;
	}
	return canBeDeleted;
}


@end
