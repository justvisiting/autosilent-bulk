#import "IphonePackersClient.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//static NSString * const URLString = @"http://iphonepackers.info/app/VerifyApp?v=3&code=";
static NSString * const URLString = @"http://iphonepackers.info/cydiaiPhone/VerifyApp?code=1&appId=2&version=1";
static NSString * const BuyAppFmtString = @"http://iphonepackers.info/cydiaiPhone/BuyApp?c=%@&aId=%@&aV=1&v=2";

@implementation IphonePackersClient

+ (int)GetPurchaseStatus:(NSString*)applicationId appVersion:(int)version
{
	
	NSError *error;
    NSData *activationData;
	NSURLResponse *response;
	
	NSString * deviceId = [[UIDevice currentDevice] uniqueIdentifier];
	//NSString * finalRequestString = [(NSString *)URLString stringByAppendingString:deviceId];
	NSString * finalRequestString = URLString;
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL: [NSURL URLWithString: finalRequestString  ]];
	activationData = [ NSURLConnection sendSynchronousRequest:request 
											returningResponse:&response error:&error];
	if (response == nil)
	{
		return 503;
	}
	
	if ([(NSHTTPURLResponse*)response statusCode] != 200 )
	{
		return [(NSHTTPURLResponse*)response statusCode];
	}
	if ( activationData == nil || [activationData length] == 0)
	{
		return 500;
	}
	
	NSString * activateString = [[NSString alloc] initWithData:activationData encoding:NSUTF8StringEncoding];
	NSArray *tokens = [activateString componentsSeparatedByString:@"="];
	
	if (tokens == nil || [tokens count] < 2)
	{
		return 500;
	}
	
	NSString * retValue = (NSString *)[tokens objectAtIndex:1];
	
    [activateString release];
	return [retValue intValue];
}

+(NSString*) GetBuyLink:(NSString*)applicationId appVersion:(int) version
{
	NSString * deviceId = [[UIDevice currentDevice] uniqueIdentifier];
	return [NSString stringWithFormat:BuyAppFmtString,deviceId,applicationId];
}

@end