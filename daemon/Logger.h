//
//  Logger.h
//  Util
//
//  Created by god on 5/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Logger : NSObject {
	
}
+ (void) Log:(NSString*) message;
+ (BOOL) WriteListToFile:(CFStringRef) url dtWrite:(CFPropertyListRef) dataToWrite;
@end