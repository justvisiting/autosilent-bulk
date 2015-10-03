#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CGGeometry.h>

@interface MainTableController : UITableViewController
{
	NSMutableArray * dataSource;
}
- (MainTableController *) initWithDataSource:(NSMutableArray *) ds;
- (void) ObserveAutomaticValueChangeNotification:(NSNotification*)notification;
-(void)ObserveActiveScheduleChanged:(NSNotification*)notification;
-(void) AddSchedules;
-(void) RemoveSchedules;
@end