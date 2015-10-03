#import "BaseController.h"
#import "Schedule.h"

@interface ScheduleTimeViewController : BaseController
{
	UIDatePicker* pickerView;
	UITableView* tableViewImp;
	Schedule * schedule;
}
- (ScheduleTimeViewController *) init;
- (ScheduleTimeViewController *) initWithDataSource:(NSMutableArray*)ds title:(NSString*) scheduleName;

@end