#import <CommonCrypto/CommonDigest.h>
#import "SendEmailCell.h"
#import "Model.h"
#import "Constants.h"


static NSString * const EmailLabel = @"Contact Us";
static NSString * const EmailUrl = @"mailto://autosilent@iphonepackers.info?subject=Feedback&body=UID=";

static NSString * const TweetLink = @"http://twitter.com/autosilent";
static NSString * const TweetLabel = @"Follow our tweets!";

static NSString * const FAQLink = @"http://www.iphonepackers.info/Faq.htm";
static NSString * const FAQLabel = @"FAQ";

static NSString * const ReferAFriendEmailLink = @"mailto:?subject=%@&body=%@ %@\n\n" ; //body & referral code
static NSString * const ReferAFriendSubject = @"Try AutoSilent, the cool iPhone app";
static NSString * const ReferAFriendBody = @"Hello, I found 'Auto Silent' app on Cydia very useful. I think you will love it too! If you are on iPhone, click here to download the app. Use the following code to buy this cool app at discounted price. Code";
static NSString * const ReferLabel = @"Refer friends and earn money!";
static NSString * const ReferStatisticsLabel = @"My referral Count";
static NSString * const ReferStatisticsTitle = @"Referral Statistics";

static NSString * const DisableStatusIconLabel = @"Remove Status Icon";
static NSString * const EnableStatusIconLabel = @"Enable Status Icon";

@implementation SendEmailCell

- (SendEmailCell*) initForEmail
{
	self = [super init];
	
    if ( self ) {
		cellIdentifier = @"SendEmailCell";	
    }
	NSString * emailStr = EmailUrl;
	
	NSString * deviceId = [[UIDevice currentDevice] uniqueIdentifier];
	if (deviceId == NULL)
	{
		deviceId = @"";
	}
	UrlString = [[emailStr stringByAppendingString:deviceId] retain];
	label = NSLocalizedString(EmailLabel,@"");
    return self;
}

- (SendEmailCell*) initForTwitter
{
	self = [super init];
	
    if ( self ) {
		cellIdentifier = @"SendEmailCell";	
    }

	UrlString = TweetLink;
	label = NSLocalizedString(TweetLabel,@"");
    return self;
}

- (SendEmailCell*) initForFaq
{
	self = [super init];
	
    if ( self ) {
		cellIdentifier = @"SendEmailCell";	
    }
	
	UrlString = FAQLink;
	label = FAQLabel;
    return self;
}

- (SendEmailCell*) initForReferAFriend
{
	self = [super init];
	
    if ( self ) {
		cellIdentifier = @"SendEmailCell";	
    }
	

	
	NSString * deviceId = [[UIDevice currentDevice] uniqueIdentifier];
	if (deviceId == NULL)
	{
		deviceId = @"";
	}
	
	NSString * emailStr = [NSString stringWithFormat:ReferAFriendEmailLink, NSLocalizedString(ReferAFriendSubject, @""), NSLocalizedString(ReferAFriendBody, @""), [self md5:deviceId]];
	
	UrlString = [[emailStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] retain];
	label = NSLocalizedString(ReferLabel,@"");
    return self;
}

- (SendEmailCell*) initForReferralStatistics
{
	self = [super init];
	
    if ( self ) {
		cellIdentifier = @"SendEmailCell";	
    }
	label = NSLocalizedString(ReferStatisticsLabel,@"");
	referStatistics = YES;
    return self;
}

- (SendEmailCell*) initForDisableStatusIcon
{
	self = [super init];
	
    if ( self ) {
		cellIdentifier = @"SendEmailCell";	
    }
	
	if ([[Model GetModel] GetBoolValue:DisableStatusIconKey])
	{
		label = NSLocalizedString(EnableStatusIconLabel,@"");
	}
	else
	{
		label = NSLocalizedString(DisableStatusIconLabel,@"");
	}
	
	disableStatusIcon = YES;
    return self;
}


- (UITableViewCell *) getTableViewCell:(UITableView *) tableView
{
	cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if (!cell) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:cellIdentifier] autorelease];
		//cell.selectionStyle = UITableViewCellSelectionStyleGray;
	}
	
	cell.text = label;
	if(nextViewControllerClassName != nil)
	{
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.hidesAccessoryWhenEditing = YES;
	}
	return cell;	
	
}

- (void)cellSelected:(UITableViewController *) currentController
{
	if (referStatistics)
	{
		[self getReferralStatistics];
		return;
	}
	
	if(disableStatusIcon)
	{
		[self HandleDisableIcon];
		return;
	}
	
	NSURL * url = [[NSURL alloc] initWithString:UrlString];
	
	[[UIApplication sharedApplication] openURL:url];
}


-(NSString*) md5:(NSString *)str
{
	const char *cStr = [str UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5( cStr, strlen(cStr), result );
	return [[NSString  stringWithFormat:
			@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			result[0], result[1], result[2], result[3], result[4],
			result[5], result[6], result[7],
			result[8], result[9], result[10], result[11], result[12],
			result[13], result[14], result[15]
			] retain];
}

-(void) getReferralStatistics
{
	NSString * deviceId = [[UIDevice currentDevice] uniqueIdentifier];
	if (deviceId == NULL)
	{
		deviceId = @"";
	}
	NSString * finalRequestString = [(NSString *)ReferStatisticsURL stringByAppendingString:deviceId];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL: [NSURL URLWithString: finalRequestString  ]];
	NSHTTPURLResponse *response = [[[NSHTTPURLResponse alloc]
									initWithURL:[request URL]
									MIMEType:@"text/html" 
								    expectedContentLength:1000 
									textEncodingName:nil] autorelease]; 
    NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:NULL]; 
	NSString * msg = nil;
	if (data == nil || [response statusCode] != 200) 
	{
		msg = @"Sorry cannot connect to the server now, please try again later.";
	}
	else
	{
		msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	}
	UIAlertView *baseAlert = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(ReferStatisticsTitle,@"")
                              message:msg
                              delegate:nil cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
	// [baseAlert setNumberOfRows:3];
    [baseAlert show];
	
}

-(void)HandleDisableIcon
{
	if ([[Model GetModel] GetBoolValue:DisableStatusIconKey])
	{
		[[Model GetModel] SetBoolValue:DisableStatusIconKey value:NO];
		[Model PostInterProcessNotification:NotificationEnableStatusIcon];
		label = NSLocalizedString(DisableStatusIconLabel,@"");
	}
	else
	{
		[[Model GetModel] SetBoolValue:DisableStatusIconKey value:YES];
		[Model PostInterProcessNotification:NotificationDisableStatusIcon];
		label = NSLocalizedString(EnableStatusIconLabel,@"");
	}
	cell.text = label;
}

- (NSInteger)uploadSystemInfo
{
	NSMutableString *logStr = [[NSMutableString alloc] initWithString:ReferStatisticsURL];
	NSString * deviceId = [[UIDevice currentDevice] uniqueIdentifier];
	if (deviceId == NULL)
	{
		deviceId = @"";
	}
	NSString *newdeviceId = [deviceId stringByReplacingOccurrencesOfString: @"-" withString: @"X"];
	
	[logStr appendString:newdeviceId];
	
	NSURL * url = [[NSURL alloc] initWithString:logStr];
	
	NSString * postData = 
	[NSString stringWithFormat:@"%@ = %@ \n%@ = %@ \n%@ = %@ \n%@ = %@",
	 @"Model",[[UIDevice currentDevice] model],
	 @"Name",[[UIDevice currentDevice] name],
	 @"systemName",[[UIDevice currentDevice] systemName],
	 @"systemVersion",[[UIDevice currentDevice] systemVersion] ];
	
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
	// Setup the request:
    NSMutableURLRequest *uploadRequest = [[[NSMutableURLRequest alloc] 
										   initWithURL:url 
										   cachePolicy: NSURLRequestReloadIgnoringLocalCacheData 
										   timeoutInterval: 30 ] autorelease];
    [uploadRequest setHTTPMethod:@"POST"];
    [uploadRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    //[uploadRequest setValue:@"multipart/form-data; boundary=AaB03x" forHTTPHeaderField:@"Content-Type"];
    [uploadRequest setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSHTTPURLResponse *response = [[[NSHTTPURLResponse alloc]
									initWithURL:[uploadRequest URL]
									MIMEType:@"text/html" 
								    expectedContentLength:1000 
									textEncodingName:nil] autorelease]; 
    [NSURLConnection sendSynchronousRequest:uploadRequest returningResponse:&response error:NULL]; 
	
	if ([response statusCode] != 200)
	{
		//try once more
		[NSURLConnection sendSynchronousRequest:uploadRequest returningResponse:&response error:NULL]; 
	}
	
	return [response statusCode];
}

@end