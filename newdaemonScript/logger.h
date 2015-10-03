//
//  logger.h
//  newdaemon
//
//  Created by god on 10/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "constants.h"

@interface logger : NSObject {
	NSMutableDictionary* dict;
}
+ (void) initLogger:(NSString*) source;
+ (void) Log: (NSString*) message level: (LogLevelType) level;
+ (void) Log: (NSString*) message;

@end

