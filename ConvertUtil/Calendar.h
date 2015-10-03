//
//  Calendar.h
//  ConvertUtil
//
//  Created by god on 11/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Calendar : NSObject {
	int calenderId;
	NSString * displayName;
	NSString * identifier;
	bool enabled;
	NSMutableDictionary * dict;
}

+(NSMutableArray*)CalendarList;
+(NSMutableDictionary*) MasterCalendarDict;
- (Calendar*) initWithIdentifier:(NSString*)ident calenderId:(int)calId;
-(void) SetBoolValue:(NSString*)key value:(BOOL)val;

+(void)InitCalenderList;
@end
