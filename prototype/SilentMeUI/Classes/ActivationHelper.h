#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Model.h"

@interface ActivationHelper: NSObject
{
	UIActivityIndicatorView* activityIndicator;
	UIView * parentView;
	UIViewController * parentController;
	NSString* status;
	NSString* messageToDisplay;
	NSString* key ;
	NSString* dataString;
	NSString* dtString;
	
	Model * model;
	
	UIAlertView * buyAlert;
	
}

-(void) ActivateApp;
-(ActivationHelper*)initWithView:(UIView*)view controller:(UIViewController*)controller;

- (void) presentActivationInfo: (NSString *) msg;
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
-(void) initIndicator;
-(void)parseDataV2;
-(void) ShowInfoV2;
- (void) presentInfo: (NSString *) msg;
-(void) ShowBuyButton;
-(void)BuyApp;

#pragma mark NSURLConnection Delegates
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
@end