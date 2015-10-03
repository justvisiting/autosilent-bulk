#import <Foundation/Foundation.h>

@interface BaseDictionary : NSObject {
	NSMutableDictionary* dict;
}

- (BaseDictionary*) initDict;

+ (void) PostInterProcessNotification:(NSString*) name;

-(BOOL) GetBoolValue:(NSString*) key;

-(void) SetBoolValue:(NSString*)key value:(BOOL)val;

-(int) GetIntegerValue:(NSString*)key;

-(void) SetIntegerValue:(NSString*)key value:(int)val;

-(NSString*) GetStringValue:(NSString*)key;

-(NSArray*) GetArray:(NSString*)key;

-(id) GetValue:(NSString*)key;

-(void) SetValue:(NSString*)key value:(id)val;

-(void) PostMyNotification:(NSString*)key;
@end