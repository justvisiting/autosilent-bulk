//
//  TextFieldController.h
//  SilentMe
//
//  Created by god on 11/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BaseController.h"

@class TextFieldCell;

@interface TextFieldController : BaseController {
	TextFieldCell* textField;
}
- (TextFieldController *) initWithDataSource:(NSMutableArray*)ds title:(NSString*) scheduleName textField:(TextFieldCell*) textCell;
@end
