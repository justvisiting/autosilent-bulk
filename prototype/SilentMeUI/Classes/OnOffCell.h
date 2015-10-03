#import "BaseCell.h"

@interface OnOffCell : BaseCell
{
	UITableView * myTableView;
}

- (OnOffCell*) initWithTitle: (NSString *) t ;
- (OnOffCell*) initWithTitle: (NSString *) t boolTag:(NSString*)tag dict:(BaseDictionary*) dict;
- (OnOffCell*) initWithTitle: (NSString *) t nextControllerName: (NSString*)controllerClassName
nextDataSource:(NSMutableArray*)nextDs boolTag:(NSString *) tag  dict:(BaseDictionary*) dict;


@end