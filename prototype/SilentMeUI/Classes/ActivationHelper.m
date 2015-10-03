#import "ActivationHelper.h"
#import "Constants.h"

static NSString* const BuyLabel = @"Buy";

@implementation ActivationHelper

-(ActivationHelper*)initWithView:(UIView*)view controller:(UIViewController*)controller
{
	if (self = [super init])
	{
		parentView = view;
		parentController = controller;
		status = nil;
		messageToDisplay = nil;
		key = nil ;
		dataString = nil;
		model = [Model GetModel];
	}
	
	return self;
}

-(void) ActivateApp
{
	Model * modelInst = [Model GetModel];
	if (modelInst->deviceActivated == NULL || [modelInst->deviceActivated length] == 0 ) 
	{
		[self presentActivationInfo:NotActivatedStr];
	}
	
}

- (void) presentActivationInfo: (NSString *) msg
{
    UIAlertView *baseAlert = [[UIAlertView alloc]
                              initWithTitle:@"Activation Alert"
                              message:msg
                              delegate:self cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
	// [baseAlert setNumberOfRows:3];
    [baseAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSString * deviceId = [[UIDevice currentDevice] uniqueIdentifier];
	//NSString * deviceId = @"183b2b917ff7ee2ef089ce6272f965d0505c82f3";
	NSLocale *currentLocale = [NSLocale currentLocale];
	
	if (alertView == buyAlert)
	{
		switch (buttonIndex) {
			case 0:
				if (deviceId == NULL)
				{
					deviceId = @"";
				}
				NSString * finalBuyStr = [NSString stringWithFormat:BuyURLString, [currentLocale localeIdentifier], deviceId];
				NSURL * url = 
				[[NSURL alloc] initWithString:[finalBuyStr stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
				
				[[UIApplication sharedApplication] openURL:url];
				break;
			default:
				break;
		}
	}
	else
	{

		NSString * finalRequestString = [NSString stringWithFormat:URLString, [currentLocale localeIdentifier], deviceId];
		NSURLRequest *request = [[NSURLRequest alloc] initWithURL: 
								 [NSURL URLWithString:[finalRequestString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
		NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self]; 
		[self initIndicator];
		[activityIndicator startAnimating];
	}
	[alertView release];
}

-(void) initIndicator
{
	activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 20.0f, 20.0f)];
    [activityIndicator setCenter:CGPointMake(160.0f, 208.0f)];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [parentView addSubview:activityIndicator];
}

-(void)parseDataV2
{
	//dataString = @"stt=completed&msg=hiVishal&sig=aaaaaa";
	status = OurError;
	messageToDisplay = GenericActivationError;
	key = nil;
	dtString = nil;
	
	if ( dataString == nil )
	{
		return;
	}
	
	NSArray *tokens = [dataString componentsSeparatedByString:@"&"];
	
	if (tokens == nil)
	{
		return;
	}
	
	NSEnumerator *enumerator = [tokens objectEnumerator];
	NSString *item ;
	
	while (item = [enumerator nextObject])
	{
		NSRange range = [item rangeOfString:@"="];
		
		if (range.location == NSNotFound || [item length] < 5)
		{
			continue;
		}
		
		NSString * first = [item substringToIndex:3];
		if ( [@"sig" compare:first options:NSCaseInsensitiveSearch] == NSOrderedSame )
		{
			key = [item substringFromIndex:4]; 
		}
		else if ( [@"msg" compare:first options:NSCaseInsensitiveSearch] == NSOrderedSame )
		{
			messageToDisplay = [item substringFromIndex:4]; 
			if ( [messageToDisplay length] == 0 || [messageToDisplay length] > 200 )
			{
				messageToDisplay = GenericActivationError;
			} 
		}
		else if ( [@"stt" compare:first options:NSCaseInsensitiveSearch] == NSOrderedSame )
		{
			status = [item substringFromIndex:4]; 
		}
		else if ( [@"dtt" compare:first options:NSCaseInsensitiveSearch] == NSOrderedSame )
		{
			dtString = [item substringFromIndex:4];
			[[Model GetModel] SetValue:ManualId value:dtString];
			//if ( [dateString length] = 10 )
			//{
				//NSDateFormatter *df = [[NSDateFormatter alloc] init];
				//[df setDateFormat:@"yyyy-MM-dd"];
				//NSDate *myDate = [[df dateFromString: dateString] retain];

			//}
		}
	}
	
	return;
}


-(void) ShowInfoV2
{
	if ( messageToDisplay == NULL || [messageToDisplay length] == 0)
	{
		[self presentInfo:GenericActivationError];
		model->deviceActivated = NULL;
		[model WriteValues];		
		return; 
	}
	
	[self presentInfo:messageToDisplay];
	
	if( key != NULL && [key length] == 0)
		model->deviceActivated = NULL;
	else
	{
		model->deviceActivated = key;
	}
	
	if(model->deviceActivated != NULL && [model->deviceActivated length] != 0)
	{
		
		// TODO :self.navigationItem.leftBarButtonItem = refreshButton;
		//TODO: [buyButton release];
		// TODO buyButton = nil;
		
	}
	
	[model WriteValues];
	
	return;
}

- (void) presentInfo: (NSString *) msg
{
    UIAlertView *baseAlert = [[UIAlertView alloc]
                              initWithTitle:@"Activation Alert"
                              message:msg
                              delegate:nil cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
	// [baseAlert setNumberOfRows:3];
    [baseAlert show];
}

#pragma mark NSURLConnection Delegates
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	NSString * currentData = nil;
	if (dataString == nil)
		dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	else
	{
		currentData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		dataString =  [[[dataString autorelease] stringByAppendingString:currentData] retain];
		[currentData release];
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //[self presentInfo:CFSTR("FinshLaoding")];
	[self parseDataV2];
	[self ShowInfoV2];
	[self ShowBuyButton];
	[activityIndicator stopAnimating];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	
	[self presentInfo:GenericActivationError];
	[self ShowBuyButton];
	[activityIndicator stopAnimating];
}

-(void) ShowBuyButton
{
	if (model->deviceActivated == NULL || [model->deviceActivated length] == 0)
	{
		UIBarButtonItem * buyButton = [[UIBarButtonItem alloc]
				 initWithTitle:NSLocalizedString(BuyLabel,@"")
				 style:UIBarButtonItemStyleDone
				 target:self
				 action:@selector(BuyApp)];
		
		parentController.navigationItem.leftBarButtonItem = buyButton;
		[buyButton release];
	}
}

-(void)BuyApp
{
	
	buyAlert = [[UIAlertView alloc]
				initWithTitle:@""
				message:@"\n\n\n\n\n\n"
				delegate:self cancelButtonTitle:nil
				otherButtonTitles:NSLocalizedString(BuyLabel,@""),@"Cancel",nil];
	
	[buyAlert setNumberOfRows:2];
    [buyAlert show];
	CGRect frame = [buyAlert frame];
	
	frame.origin.y -= 20.0f;
	//frame.size.height +=60.0f;
	buyAlert.frame = frame;
	[buyAlert setBackgroundColor:[UIColor blackColor]];	
	UITextView * textView = [[UITextView alloc] initWithFrame:CGRectMake(20.0, 20.0, 245.0, 120.0)];
	[textView setEditable:NO];
	[textView setScrollEnabled:YES];
	[textView setIndicatorStyle:UIScrollViewIndicatorStyleBlack];
	//
	[textView setBackgroundColor:[UIColor whiteColor]];
	[textView setAlpha:1];
    //[textView setOpaque:YES];
	[textView setTextColor:[UIColor blackColor]];
	[textView setFont:[UIFont systemFontOfSize:14.0f]];
	
	//[ textView setMarginTop: 20 ];
	[ textView setText: @"The price to buy the license is 3 USD + Paypal processing charges. The purchase can be made using major credit cards through our PayPal Store or CydiaStore. The license is bound to iPhone device from where it was purchased and cannot be transferred to any other iPhone or other device owned by you or someone else. If you lose or buy/upgrade to new iPhone you will have to buy a new license. There is no way to transfer the license from one device (e.g: iPhone) to another. \n \n By downloading or buying the app you accept the following license agreement: \n	Auto Silent software is sold 'as is'. All warranties either expressed or implied are disclaimed as to the software, its quality, performance, usability, fitness for any particular purpose(s).  You, the consumer, bear the entire risk relating to the software, caused by it directly or indirectly. In no event its developers, iPhone Packers or any members of its team wil be liable for direct, indirect, incidental or consequential damages resulting from the defect or using the software.	If the software is proved to have defect, you and not iPhone Packers or its team assume the cost of any necessary service or repair. \n To buy the app from our PayPal Store, click Buy button below. To buy the app from Cydia store, open Cydia and buy it via CydiaStore. Once payment is processed, the app will try to activate automatically when opened." ];
	
	[buyAlert addSubview:textView];
}


@end
