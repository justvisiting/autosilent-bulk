#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CGGeometry.h>

@interface BaseController : UITableViewController
{
	NSMutableArray * dataSource;
}
- (BaseController *) init;
- (BaseController *) initWithDataSource:(NSMutableArray*)ds title:(NSString*) scheduleName;
@end