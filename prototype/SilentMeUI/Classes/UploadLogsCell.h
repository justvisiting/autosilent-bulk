#import "BaseCell.h"

@interface UploadLogsCell : BaseCell
{
	UITableViewController * controller;
}

- (UploadLogsCell*) init;
- (void) presentDebugInfo: (NSString *) msg;
- (NSInteger)uploadFile:(NSString *) fileName WithPath:(NSString*)path;
- (NSInteger)uploadSystemInfo;
- (NSString*) generatePostDataForfile:(NSString*) fileName;
-(void) UploadLogs;
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
@end