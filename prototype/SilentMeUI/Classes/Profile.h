#import <Foundation/Foundation.h>
#import "BaseDictionary.h"

@class BaseCell;

@interface Profile : BaseDictionary {
	
@private
	NSString* ringtone;
	NSString* calendarAlertTone;
	int profileId;
	NSMutableArray* viewDataSource;
	BaseCell * profileCell;
	bool isNotCommited;
}

+ (Profile*) ProfileWithId:(int) profileId;
+(void) InitProfileArray;
+(NSMutableArray*) GetProfileArray;
+(NSString*) GetCurrentProfileName;
+(Profile*)CreateNewProfile;
+(void) SaveProfile:(Profile*)profile;
+(void) DeleteProfile:(Profile*)profile;
+ (NSMutableArray*) GetProfileDataSource;
+(bool) IsNameDuplicate:(NSString*)name;
+(bool) IsProfileNameDuplicate:(Profile*)profile;
+ (void) DeleteProfileDataSource;
+(Profile*) GetDefaultProfile;
+(Profile*) GetCurrentProfile;

- (Profile*) initFromId: (int) profileIdentifier;
- (NSString*) RingTone;
- (NSString*) CalendarAlertTone;
- (int) GetProfileId;
- (NSString*) Name;
-(void) PersistData;
-(void) initViewDataSource;
-(NSMutableArray*) ViewDataSource;
-(BaseCell*) getProfileCell;
-(bool) IsNotCommited;
-(void) SetNonPersistBoolValue:(NSString*) key value:(bool) val;
-(bool) CanBeDeleted;

@end
