#import "BaseCell.h"

@interface CheckmarkCell : BaseCell
{
	UITableViewCell * cell;
}

- (CheckmarkCell*) initWithTitle: (NSString *) t boolTag:(NSString*)tag dict:(BaseDictionary*) dict;

- (CheckmarkCell*) initWithTitle: (NSString *) t nextControllerName: (NSString*)controllerClassName
				  nextDataSource:(NSMutableArray*)nextDs boolTag:(NSString *) tag  dict:(BaseDictionary*) dict;

- (void) switchMe;
- (void) updateCheckmark;
@end
