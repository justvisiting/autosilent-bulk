#import "BaseCell.h"

@interface SendEmailCell : BaseCell
{
	NSString * UrlString;
	NSString * label;
	bool referStatistics;
	bool disableStatusIcon;
	UITableViewCell * cell ;
}

- (SendEmailCell*) initForEmail;
- (SendEmailCell*) initForTwitter;
- (SendEmailCell*) initForFaq;
-(NSString*) md5:(NSString *)str;
- (SendEmailCell*) initForReferAFriend;
- (SendEmailCell*) initForReferralStatistics;
- (SendEmailCell*) initForDisableStatusIcon;
-(void) getReferralStatistics;
-(void)HandleDisableIcon;
@end