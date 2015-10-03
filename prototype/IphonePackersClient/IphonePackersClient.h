#import <Foundation/Foundation.h>

@interface IphonePackersClient: NSObject
{	
}
+ (int)GetPurchaseStatus:(NSString*)applicationId appVersion:(int)version;
+ (NSString*) GetBuyLink:(NSString*)applicationId appVersion:(int) version;
@end