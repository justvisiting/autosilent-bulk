#import "BaseCell.h"

@interface StatusCell : BaseCell
{
	UITableViewCell * cell;
}

- (StatusCell*) init;
- (NSString*) GetStatusIconPath;
- (void) ObserveStatusChangeNotification:(NSNotification*)notification;
-(void) RefreshStatus;
-(void) SetTitle;
@end