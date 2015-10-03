#import <Foundation/Foundation.h>
#import "Profile.h"
#include "BaseDictionary.h"

@interface Schedule : BaseDictionary {
	//NSMutableDictionary* dict;
	NSString* ScheduleId;
	Profile * profile;
	NSMutableArray * viewDataSource;
	bool isNotComitted;
}

+ (Schedule*) ScheduleWithId:(NSString*) scheduleId;
+(void) SaveNewSchedule:(Schedule*) newSchedule;
+(void) DeleteSchedule:(Schedule*) deleteSchedule;
+ (NSMutableArray*) AllSchedules;
+(NSMutableArray*) CellsForSchedule;
+(void)InitScheduleArray;
+(void)InitScheduleCells;
+(int) GetTimeElapsedForTheday:(NSDate*) date;


+(Schedule*) CreateNewSchedule;
+(void)PostScheduleChangedNotification;

- (Schedule*) initFromId: (NSString*) scheduleId;
-(NSString*)  ViewControllerClassName;
-(NSMutableArray*) ViewDataSource;
- (NSString*) Name;
- (bool) Enabled;
- (int) StartTime;
- (int) EndTime;
- (NSString*) RepeatString;
- (Profile*) Profile;
-(NSString*) GetTimeForInt:(int)seconds;
-(NSString*) TimeString;
- (NSDate*) GetDateFromInteger:(int) secondsElapsed;
-(void) initViewDataSource;
-(void) PersistData;
-(void) SetProfile:(Profile*) prof;
-(NSArray*) GetRepeatArray;
-(void) SetRepeatArray:(NSArray*) array;
-(bool) IsDayApplicable:(NSInteger) day;
-(bool)IsNotCommited;
-(NSMutableArray*) GetStartTimeDataSource;
-(NSMutableArray*) GetEndTimeDataSource;
-(bool) IsActive;
@end
