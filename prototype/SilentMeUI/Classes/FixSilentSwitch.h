#import "BaseCell.h"

@interface FixSilentSwitch : BaseCell
{
	UITableViewCell * cell;
}

- (FixSilentSwitch*) init;
- (void) ObserveStatusChangeNotification:(NSNotification*)notification;
-(void) SetTitle;
- (NSString*) GetPostNotification;
- (NSString*) GetMessageBody;
@end