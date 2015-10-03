#import "Schedule.h"
///User/Library/Preferences/com.apple.accountsettings.plist to get user name
//query sqlite store to get calendar list. 
@interface CalenderSchedule : Schedule
{
}
+(CalenderSchedule*) Schedule;
- (CalenderSchedule*) init;
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
-(int) GetTimeElapsedForTheday:(NSDate*) date;
-(void) initViewDataSource;

@end