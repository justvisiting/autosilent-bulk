//
//  SliderCell.m
//  SilentMe
//
//  Created by god on 2/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SliderCell.h"

#ifdef IS_IPHONE
#import <Celestial/AVSystemController.h>
#endif

@implementation SliderCell


- (SliderCell*) initWithIntTag:(NSString *) tag  dict:(BaseDictionary*) dict
{
	self = [super init];
	
    if ( self ) {
        title = @"";
		cellIdentifier = @"SliderCell";
		nextViewControllerClassName =  nil ;
		nextDataSource = nil;
		intTag = tag;
		boolTag = nil;
		basedict = dict;
    }
    return self;
}

- (UITableViewCell *) getTableViewCell:(UITableView *) tableView
{
	cell = nil;//[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	UISlider *slider= NULL;
	
	if (!cell) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:cellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		slider = [[UISlider alloc] initWithFrame: CGRectMake(100.0f, 10.0f, 200.0f, 28.0f)];
        [slider setTag:999];
		slider.backgroundColor = [UIColor clearColor];
		slider.minimumValue = 0.0f;
		slider.maximumValue = 100.0f;
		slider.continuous = NO;
		//slider.value = 25.0f;
        [cell addSubview:slider];
        [slider release];
	}
	cell.text = title;
	
	// recover switchView from the cell
    slider = (UISlider*)[cell viewWithTag:999];
    [slider addTarget:self action:@selector(updateValue:) forControlEvents:UIControlEventValueChanged];
	
    // Set up the cell
    NSNumber* value = (NSNumber*)[basedict GetValue:intTag];
	
    slider.value = [value floatValue] * 100.0f;
	
	[self setTitle:slider];
	
	if(nextViewControllerClassName != nil)
	{
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.hidesAccessoryWhenEditing = YES;
	}
	return cell;	
}

- (void) updateValue: (UIControl *) sender
{
    //UITableViewCell *cell = (UITableViewCell *)[sender superview];
	UISlider * slider = (UISlider*)sender;
	float value = slider.value / 100.0f;
	[basedict SetValue:intTag value:[NSNumber numberWithFloat:value]];
		[self setTitle:slider];
#ifdef IS_IPHONE
	//[[UIApplication sharedApplication] setSystemVolumeHUDEnabled:NO];

	if ( basedict == [Profile GetCurrentProfile])
	{
	AVSystemController *avs = [AVSystemController sharedAVSystemController];
		
	[avs setActiveCategoryVolumeTo:value];	
	}
	

#endif
}

-(void) setTitle :(UISlider*) slider
{
	int value = (int) slider.value;
	title = [[NSString stringWithFormat:@"%d%%",value] retain];
	cell.text = title;
}

@end
