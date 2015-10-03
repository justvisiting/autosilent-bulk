#import "BaseCell.h"
#import "Schedule.h"

@interface MultipleTimeCell : BaseCell
{
	Schedule * schedule;
}

- (MultipleTimeCell*) initWithSchedule:(Schedule *) sch;
-(NSString*) GetBoolValue;
-(CGRect) getRectForRow:(int)row col:(int)col;
- (UILabel *)newLabelWithPrimaryColor:(UIColor *)primaryColor selectedColor:(UIColor *)selectedColor fontSize:(CGFloat)fontSize bold:(BOOL)bold frame:(CGRect)rect;
-(UILabel*) retrieveLabelWithRow:(int)row col:(int)col tableCell:(UITableViewCell *)cell;
-(void) updateLabelWithRow:(int)row col:(int)col tableCell:(UITableViewCell *)cell;
-(void) addLabelAtRow:(int)row col:(int)col tableCell:(UITableViewCell*) cell;
//-(NSString*) GetTimeForTag:(NSString*)tag;
-(NSString*) getTimeString;
-(NSString*) GetOnOffImagePath;
@end