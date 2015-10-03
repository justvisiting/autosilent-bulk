#import "MultipleTimeCell.h"
#import "Model.h"
#import "BaseController.h"
#import "ScheduleViewController.h"

static const int rowOffset = 10;
static const int rowHeight = 15;
static const int centerWidth = 220;
static const int lastWidth = 220;
static const int firstWidth = 60;
static NSString * const ScheduleOnIcon = @"/Applications/SilentMe.app/ScheduleOn.png";
static NSString * const ScheduleOffIcon = @"/Applications/SilentMe.app/ScheduleOff.png";
static NSString * const ScheduleActiveIcon = @"/Applications/SilentMe.app/ScheduleActive.png";
@implementation MultipleTimeCell

- (MultipleTimeCell*) initWithSchedule:(Schedule *) sch
{
	self = [super init];
	
    if ( self ) {
        schedule = sch;
		cellIdentifier = @"MultipleTimeCell";
		nextViewControllerClassName =  [schedule ViewControllerClassName] ;
		nextDataSource = [schedule ViewDataSource] ;
    }
	
    return self;
}

- (void)cellSelected:(UITableViewController *) currentController
{
	if ( [nextViewControllerClassName caseInsensitiveCompare:@"BaseController"] == NSOrderedSame)
	{
	BaseController* baseContrl = (BaseController*)[NSClassFromString(nextViewControllerClassName) alloc];
	baseContrl = [baseContrl initWithDataSource:nextDataSource title:[schedule Name]];
	
	if (nextViewControllerClassName)
	{
		[[currentController navigationController] pushViewController:baseContrl animated:YES];
	}
	}
	else
	{
		ScheduleViewController * baseContrller = [[ScheduleViewController alloc] initWithSchedule:schedule];
		[[currentController navigationController] pushViewController:baseContrller animated:YES];
	}
}

- (UITableViewCell *) getTableViewCell:(UITableView *) tableView
{
	UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	
	if (!cell) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:cellIdentifier] autorelease];
		//cell.selectionStyle = UITableViewCellSelectionStyleGray;

		[self addLabelAtRow:0 col:1 tableCell:cell];
		[self addLabelAtRow:1 col:1 tableCell:cell];
		//[self addLabelAtRow:1 col:2 tableCell:cell];
		[self addLabelAtRow:2 col:1 tableCell:cell];

	}
	
	[self updateLabelWithRow:0 col:1 tableCell:cell];
	[self updateLabelWithRow:1 col:1 tableCell:cell];
	//[self updateLabelWithRow:1 col:2 tableCell:cell];
	[self updateLabelWithRow:2 col:1 tableCell:cell];
	cell.image = [UIImage imageWithContentsOfFile:[self GetOnOffImagePath]];
	if(nextViewControllerClassName != nil)
	{
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.hidesAccessoryWhenEditing = YES;
	}
	return cell;	
}

-(NSString*) GetStringAtRow:(int)row Col:(int)col
{

	switch (col) {
		case 1:
			switch (row) {
				case 0:
					return [schedule Name];
					break;
				case 1:
					return [[NSString stringWithFormat:@"%@ %@",[schedule RepeatString],[self getTimeString]] retain];
					break;
				case 2:
					return [[NSString stringWithFormat:@"%@ %@",[[schedule Profile] Name],NSLocalizedString(@"Profile", @"")] retain];
					break;
			}
			break;
		case 2:
			switch (row) {
				case 1:
					return [[schedule Profile] Name];
					break;
			}
			break;
	}
	
	return @"";
}


-(NSString*) GetBoolValue
{
	if ( [schedule Enabled] )
		  return @"On";
	else
		return @"Off";
}

-(NSString*) getTimeString
{
	return [schedule TimeString];
}

-(CGFloat) getHeight
{
	return 65.0f;
}

-(void) addLabelAtRow:(int)row col:(int)col tableCell:(UITableViewCell*) cell
{

	NSString * text = [self GetStringAtRow:row Col:col];
	CGRect rect = [self getRectForRow:row col:col];
	int tag = rect.origin.x + rect.origin.y;
	
	UILabel * label;
	BOOL bold = NO;
	float fontSize = 11.0f;
	UIColor *primaryColor = [UIColor darkGrayColor];
	if (row == 0 )
	{
		fontSize = 14.0f;
		bold = YES;
		primaryColor = [UIColor blackColor];
	}
	
	label =	[self newLabelWithPrimaryColor:primaryColor selectedColor:[UIColor whiteColor] fontSize:fontSize bold:bold frame:rect];
	
	[label setTag:tag];
	[label setText:text];
	//label.textAlignment = UITextAlignmentCenter;
	
	[cell addSubview:label];

	[label release];
}

- (UILabel *)newLabelWithPrimaryColor:(UIColor *)primaryColor selectedColor:(UIColor *)selectedColor fontSize:(CGFloat)fontSize bold:(BOOL)bold frame:(CGRect)rect
{
	UIFont *font;
	if (bold) {
		font = [UIFont boldSystemFontOfSize:fontSize];
	} else {
		font = [UIFont systemFontOfSize:fontSize];
	}
	
	UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	newLabel.backgroundColor = [UIColor clearColor];
	newLabel.opaque = NO;
	newLabel.textColor = primaryColor;
	newLabel.highlightedTextColor = selectedColor;
	newLabel.font = font;
	[newLabel setFrame:rect];
	
	return newLabel;
}

-(CGRect) getRectForRow:(int)row col:(int)col
{
	CGRect rect = CGRectZero;
	switch (col) {
		case 0:
			rect.origin.x = 0;
			rect.size.width = firstWidth;
			break;
		case 1:
			rect.origin.x = 0 + firstWidth;
			rect.size.width = centerWidth;
			break;
		case 2:
			rect.origin.x = 0 + firstWidth + centerWidth;
			rect.size.width = lastWidth;
			break;
	}
	
	rect.origin.y = (row * rowHeight) + rowOffset;
	rect.size.height = rowHeight;
	
	return rect;
}

-(UILabel*) retrieveLabelWithRow:(int)row col:(int)col tableCell:(UITableViewCell *)cell
{
	CGRect rect = [self getRectForRow:row col:col];
	int tag = rect.origin.x + rect.origin.y;
	
	return (UILabel*)[cell viewWithTag:tag];
}

-(void) updateLabelWithRow:(int)row col:(int)col tableCell:(UITableViewCell *)cell
{
	CGRect rect = [self getRectForRow:row col:col];
	int tag = rect.origin.x + rect.origin.y;
	
	UILabel* label = (UILabel*)[cell viewWithTag:tag];
	label.text = [self GetStringAtRow:row Col:col];
}

-(NSString*) GetOnOffImagePath
{
	NSString * path ;
	if ([schedule Enabled])
	{
		path = ScheduleOnIcon;
	}
	else {
		path = ScheduleOffIcon;
	}

	if ([schedule IsActive])
	{
		path = ScheduleActiveIcon;
	}
	return path;
}
@end
