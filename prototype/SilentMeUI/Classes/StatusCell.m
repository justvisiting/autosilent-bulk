#import "StatusCell.h"
#import "Model.h"
#import "Profile.h"
#import "Constants.h"

static NSString * const AppDisabled = @"Currently Disabled";
static NSString * const EnabledNotSilent = @"Phone not Silent";
static NSString * const PhoneSilent = @"Phone in Silent Mode";
static NSString * const CurrentProfileLabel = @"Active Profile :";

@implementation StatusCell
- (StatusCell*) init
{
	self = [super init];
	
    if ( self ) {
        title = nil;
		cellIdentifier = @"StatusCell";
		nextViewControllerClassName =  nil ;
		nextDataSource = nil;
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ObserveStatusChangeNotification:) name:StatusChangedNotification object:nil];
		
    }
	
    return self;
}

- (UITableViewCell *) getTableViewCell:(UITableView *) tableView
{
	cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (!cell) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:cellIdentifier] autorelease];
	}
	[self SetTitle];
	
	if(nextViewControllerClassName != nil)
	{
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.hidesAccessoryWhenEditing = YES;
	}
	return cell;
}

- (void)cellSelected:(UITableViewController *) currentController
{
	[self SetTitle];
}

-(void) RefreshStatus
{
	cell.image = [UIImage imageWithContentsOfFile:[self GetStatusIconPath]];
}


-(NSString*) GetStatusIconPath
{
	[[Model GetModel] RefreshDaemonDictionary];
	BOOL silentModeOn = [[Model GetModel]  GetBoolValueFromDaemon:SilentModeOn];
	Model * model = [Model GetModel] ;
    // Swap the art when the state changes
	if (!( [model GetBoolValue:CalSyncEnabled] || [model GetBoolValue:AutomaticEnabledKey] || [model GetBoolValue:ManualMode]))
	{
		cell.text = NSLocalizedString(AppDisabled,@"");
		return SettingsDisabledIcon;
	}		
	else if (silentModeOn)
	{
		cell.text = NSLocalizedString(PhoneSilent,@"");
		return OnIcon;
	}
	else
	{
		cell.text = NSLocalizedString(EnabledNotSilent,@"");
		return OffIcon;
	}
}

-(void) SetTitle
{
	[[Model GetModel] RefreshDaemonDictionary];
	cell.text = [NSString stringWithFormat:@"%@ %@",
				  NSLocalizedString(CurrentProfileLabel,@""), [Profile GetCurrentProfileName]];
}


- (void) ObserveStatusChangeNotification:(NSNotification*)notification
{
	[self SetTitle];
	//[(UITableView*)[cell superview] reloadData];
}

@end