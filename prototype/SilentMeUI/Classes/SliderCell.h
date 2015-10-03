//
//  SliderCell.h
//  SilentMe
//
//  Created by god on 2/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BaseCell.h"

@interface SliderCell : BaseCell
{
	UITableView * myTableView;
	UITableViewCell * cell;
}

- (SliderCell*) initWithIntTag:(NSString *) tag  dict:(BaseDictionary*) dict;
-(void) setTitle :(UISlider*) slider;

@end
