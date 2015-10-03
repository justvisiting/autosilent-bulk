//
//  Calendar.h
//  SilentMe
//
//  Created by god on 11/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BaseDictionary.h"

@class CheckmarkCell;

@interface Calendar : BaseDictionary
{
	int calenderId;
	NSString * displayName;
	NSString * identifier;
	bool enabled;
}

+(NSMutableArray*)CalendarList;
+(void)InitCalenderList;
+(NSMutableDictionary*) MasterCalendarDict;
- (Calendar*) initWithIdentifier:(NSString*)ident calenderId:(int)calId title:(NSString*)title;
/*
-(int)CalenderId;
-(NSString*) DisplayName;
-(NSString*) Identifier;
-(bool) Enabled;
-(void)SetEnabled:(bool)val;
-(NSMutableDictionary*) dictionary;
 */
-(CheckmarkCell*)GetCell;
@end
