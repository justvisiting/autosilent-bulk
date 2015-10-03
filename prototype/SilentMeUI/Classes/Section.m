#import "Section.h"

@implementation  Section

- (Section *) initWithHeader: (NSString*) title;
{
	self = [super init];
	
    if ( self ) {
        sectionHeader = title;
		cellArray = [[NSMutableArray alloc] init];
    }
	
    return self;
}

- (void) addCell:(id)cell
{
	[cellArray addObject:cell];
}

- (void) removeCell:(id)cell
{
	[cellArray removeObject:cell];
}
- (int) cellCount
{
	return [cellArray count];
}

- (NSString*) header
{
	return sectionHeader;
}

- (BaseCell*) cellAtIndex: (int) index
{
	return (BaseCell*) [cellArray objectAtIndex:index];
}

-(void)removeObjectsInArray: (NSMutableArray*)array
{
	[cellArray removeObjectsInArray:array];
}

// Clean up
-(void) dealloc
{
    [cellArray release];
    [super dealloc];
}
@end