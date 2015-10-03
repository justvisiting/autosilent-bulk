#import "BaseCell.h"

@interface Section: NSObject
{
	NSString * sectionHeader;
	NSMutableArray * cellArray;
}

- (Section *) initWithHeader: (NSString*) title;
- (void) addCell:(id)cell;
- (int) cellCount;
- (NSString*) header;
- (BaseCell*) cellAtIndex: (int) index;
-(void)removeObjectsInArray: (NSMutableArray*)array;
- (void) removeCell:(id)cell;
@end