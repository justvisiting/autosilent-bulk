#include "BaseDictionary.h"

@implementation BaseDictionary

+ (void) PostInterProcessNotification:(NSString*) name
{
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter() //center
										 , (CFStringRef)name
										 , NULL
										 , NULL
										 , TRUE);
	
}

- (BaseDictionary*) initDict
{
	dict = [[NSMutableDictionary alloc] init];
	return self;
}

-(BOOL) GetBoolValue:(NSString*) key
{
	NSNumber * val =  [dict valueForKey:key];
	
	if(val == NULL)
	{
		return FALSE;
	}
	
	
	BOOL rv = [val boolValue];
	
	return rv;
}

-(void) SetBoolValue:(NSString*)key value:(BOOL)val
{
	
	if(val)
	{
		[dict setValue:[NSNumber numberWithBool:val] forKey:key];
	}
	else
	{
		[dict setValue:[NSNumber numberWithBool:val]  forKey:key];
	}
	
	//[self WriteValues];
}

-(int) GetIntegerValue:(NSString*)key
{
	NSNumber* val = [dict valueForKey:key];
	
	int rv = 0;
	
	if(val != NULL)
	{
		rv = [val intValue];
		
		
		//CFRelease(val);
	}
	return rv;
}

-(void) SetIntegerValue:(NSString*)key value:(int)val
{
	
	NSNumber * num = [NSNumber numberWithInt:val];
	
	if(num != NULL)
	{
		[dict setValue:num forKey:key];
		//CFRelease(num);
	}
	//[self WriteValues];
}

-(void) SetValue:(NSString*)key value:(id)val
{
	[dict setValue:val forKey:key];
}

-(id) GetValue:(NSString*)key
{
	return [dict valueForKey:key];
}



-(NSString*) GetStringValue:(NSString*)key
{
	NSString* str = (NSString *)[dict objectForKey:key];
	
	if(str == nil)
		return @"";
	else
		return str;
}

-(NSArray*) GetArray:(NSString*)key
{
	NSArray* str = (NSArray *)[dict valueForKey:key];
	
		return str;
}

-(void) PostMyNotification:(NSString*)key
{
}
@end