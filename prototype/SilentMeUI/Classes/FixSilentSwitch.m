#import "FixSilentSwitch.h"
#import "Model.h"
#import "Constants.h"

static NSString * const FixSilentSwitchLabel = @"Disable/Bypass Silent Switch";
static NSString * const UnFixSilentSwitch = @"Enable iPhone Silent Switch";
static NSString * const FixMessage = @"FixMessage";
static NSString * const UnFixMessage = @"UnfixMessage";
static NSString * const SilentSwitchIcon = @"/Applications/SilentMe.app/SilentSwitch.png";

@implementation FixSilentSwitch
- (FixSilentSwitch*) init
{
	self = [super init];
	
    if ( self ) {
        title = nil;
		cellIdentifier = @"FixSilentSwitch";
		nextViewControllerClassName =  nil ;
		nextDataSource = nil;
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ObserveStatusChangeNotification:) name:NotificationFixSilentSwitchDone object:nil];

    }
	
    return self;
}

- (UITableViewCell *) getTableViewCell:(UITableView *) tableView
{
	cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero] autorelease];
	[self SetTitle];
	//cell.image = [UIImage imageWithContentsOfFile:SilentSwitchIcon];
	return cell;
}

- (void)cellSelected:(UITableViewController *) currentController
{
	UIAlertView * fixAlert = [[UIAlertView alloc]
				initWithTitle:@""
				message:NSLocalizedString([self GetMessageBody],@"")
				delegate:self cancelButtonTitle:nil
				otherButtonTitles:@"Ok",@"Cancel",nil];
	[fixAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	switch (buttonIndex) {
		case 0:
			[BaseDictionary PostInterProcessNotification:[self GetPostNotification]];
			break;
		default:
			break;
	}
	[alertView release];
}


-(void) SetTitle
{
	[[Model GetModel] RefreshDaemonDictionary];
	BOOL silentSwitchFixed = [[Model GetModel]  GetBoolValueFromDaemon:SilentSwitchFixDone];
	if ( silentSwitchFixed )
	{
		cell.text = NSLocalizedString(UnFixSilentSwitch,@"");
	}
	else
	{
		cell.text = NSLocalizedString(FixSilentSwitchLabel,@"");
	}
}

- (NSString*) GetMessageBody
{
	BOOL silentSwitchFixed = [[Model GetModel]  GetBoolValueFromDaemon:SilentSwitchFixDone];
	if (silentSwitchFixed)
		return UnFixMessage;
	else
		return FixMessage;
}

- (NSString*) GetPostNotification
{
	BOOL silentSwitchFixed = [[Model GetModel]  GetBoolValueFromDaemon:SilentSwitchFixDone];
	if (silentSwitchFixed)
		return NotificationUnFixSilentSwitch;
	else
		return NotificationFixSilentSwitch;
}

- (void) ObserveStatusChangeNotification:(NSNotification*)notification
{
	[self SetTitle];
	//TODO fix doesnt show up immediately
}


@end