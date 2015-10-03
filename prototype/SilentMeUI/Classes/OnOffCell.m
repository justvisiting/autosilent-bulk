#import "OnOffCell.h"
#import "Model.h"

@implementation OnOffCell
- (OnOffCell*) initWithTitle: (NSString *) t
{
	return (OnOffCell*)[self initWithTitle:t nextControllerName:nil nextDataSource:nil];
}

- (OnOffCell*) initWithTitle: (NSString *) t boolTag:(NSString *) tag  dict:(BaseDictionary*) dict
{
	return (OnOffCell*)[self initWithTitle:t nextControllerName:nil nextDataSource:nil boolTag:tag dict:dict];
}


- (OnOffCell*) initWithTitle: (NSString *) t nextControllerName: (NSString*)controllerClassName
			  nextDataSource:(NSMutableArray*)nextDs boolTag:(NSString *) tag  dict:(BaseDictionary*) dict
{
	self = [super init];
	
    if ( self ) {
        title = t;
		cellIdentifier = @"OnOffCell";
		nextViewControllerClassName =  controllerClassName ;
		nextDataSource = nextDs;
		intTag = nil;
		boolTag = tag;
		basedict = dict;
    }
    return self;
}

- (UITableViewCell *) getTableViewCell:(UITableView *) tableView
{
	UITableViewCell * cell = nil;//[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	UISwitch *switchView = NULL;
	
	if (!cell) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:cellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		switchView = [[UISwitch alloc] initWithFrame: CGRectMake(200.0f, 10.0f, 100.0f, 28.0f)];
        [switchView setTag:999];
        [cell addSubview:switchView];
        [switchView release];
	}
	cell.text = title;
	
	// recover switchView from the cell
    switchView = (UISwitch*)[cell viewWithTag:999];
    [switchView addTarget:self action:@selector(switchMe:) forControlEvents:UIControlEventValueChanged];
	
    // Set up the cell
    bool value = [basedict GetBoolValue:boolTag];

    [switchView setOn:value animated:NO];
	
	
	if(nextViewControllerClassName != nil)
	{
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.hidesAccessoryWhenEditing = YES;
	}
	return cell;	
}

- (void) switchMe: (UIControl *) sender
{
    //UITableViewCell *cell = (UITableViewCell *)[sender superview];
	UISwitch * sw = (UISwitch*)sender;
	[basedict SetBoolValue:boolTag value:[sw isOn]];
	
}

@end
