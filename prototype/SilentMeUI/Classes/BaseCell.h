#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BaseDictionary.h"
#import "Profile.h"

@interface BaseCell: NSObject
{
	NSString * cellIdentifier;
	NSString * title;

	NSString * intTag;
	NSString * boolTag;
	NSString * dateTag;
	NSMutableArray * nextDataSource;
	bool CreateSchedule;
	Profile* profile;
	bool smallfont;
@public
		BaseDictionary * basedict;
		NSString * nextViewControllerClassName;
}

- (BaseCell*) initWithTitle: (NSString *) t;
- (BaseCell*) initSmallFontWithTitle: (NSString *) t;
- (BaseCell*) initWithTitle: (NSString *) t nextControllerName: (NSString*)controllerClassName nextDataSource:(NSMutableArray*)nextDs;
- (BaseCell*) initWithTitle: (NSString *) t nextControllerName: (NSString*)controllerClassName nextDataSource:(NSMutableArray*)nextDs CreateSchedule:(bool)ScheduleCreate;

- (BaseCell*) initWithTitle:(NSString *)t Profile:(Profile*)prof;

- (UITableViewCell *) getTableViewCell: (UITableView*) tableView;
- (void) accessoryButtonTapped:(UITableViewController *) currentController;
- (void) setAuxString:(NSString*) auxString;
- (NSDate *) getTime;
- (int) getTimeInSeconds;
-(void) setTime:(UIDatePicker*)datePicker cell:(UITableViewCell*)uicell;
- (void)cellSelected:(UITableViewController *) currentController;
-(int) getIntValue;
-(bool) getBoolValue;
- (void) switchMe: (UIControl *) sender;
-(CGFloat) getHeight;
@end