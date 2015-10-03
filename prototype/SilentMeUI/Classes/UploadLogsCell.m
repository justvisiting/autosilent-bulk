#import "UploadLogsCell.h"
#import "Model.h"
#import "Constants.h"

static NSString * const UploadLogsLabel = @"Send Debug Logs";
static NSString * const UploadMessage = @"UploadMessage";
static NSString * const UploadLogStatusTitle =   @"Log Upload Status";
static NSString * const SuccessLogUploadMessage = @"Logs sent successfully.";
static NSString * const UploadErrorMsg = @"There was an issue connecting to the remote server. Please try again later.";

@implementation UploadLogsCell
- (UploadLogsCell*) init
{
	self = [super init];
	
    if ( self ) {
		cellIdentifier = @"UploadLogsCell";	
    }
	
    return self;
}

- (UITableViewCell *) getTableViewCell:(UITableView *) tableView
{
	UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	
	if (!cell) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:cellIdentifier] autorelease];
		//cell.selectionStyle = UITableViewCellSelectionStyleGray;
	}
	
	cell.text = NSLocalizedString(UploadLogsLabel,@"");
	if(nextViewControllerClassName != nil)
	{
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.hidesAccessoryWhenEditing = YES;
	}
	return cell;	
	
}

- (void)cellSelected:(UITableViewController *) currentController
{
	controller = currentController;
	UIAlertView * uploadAlert = [[UIAlertView alloc]
							  initWithTitle:@""
							  message:NSLocalizedString(UploadMessage,@"")
							  delegate:self cancelButtonTitle:nil
							  otherButtonTitles:@"Ok",@"Cancel",nil];
	[uploadAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	switch (buttonIndex) {
		case 0:
			[self UploadLogs];
			break;
		default:
			break;
	}
	[alertView release];
}

-(void) UploadLogs
{
	NSArray * fileList = [[NSFileManager defaultManager] directoryContentsAtPath:logPath];
	NSInteger finalstatus = 200;
	NSInteger currStatus = 200;
	int cnt =[fileList count];
	
	int i =0;
	
	UIActivityIndicatorView * activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 20.0f, 20.0f)];
    [activityIndicator setCenter:CGPointMake(160.0f, 208.0f)];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
	if (controller != nil)
	{
		[controller.tableView addSubview:activityIndicator];
	}

	[activityIndicator startAnimating];
	
	for ( i= 0; i< cnt; i++) {
		NSString * currentFile = [fileList objectAtIndex:i];
		
		if ([currentFile hasSuffix:@".plist"])
		{
			currStatus = [self uploadFile:currentFile WithPath:logPath];
			if (currStatus != 200 )
				finalstatus = currStatus;
		}
		
	}
	currStatus = [self uploadFile:@"settings.plist" WithPath:appPath];
	if (currStatus != 200 )
		finalstatus = currStatus;	
	
	currStatus = [self uploadFile:@"daemonsettings.plist" WithPath:appPath];
	if (currStatus != 200 )
		finalstatus = currStatus;

	currStatus = [self uploadFile:@"schedule.plist" WithPath:configsPath];
	if (currStatus != 200 )
		finalstatus = currStatus;	
	
	currStatus = [self uploadFile:@"profiles.plist" WithPath:configsPath];
	if (currStatus != 200 )
		finalstatus = currStatus;
	
	
	currStatus = [self uploadFile:@"calendars.plist" WithPath:configsPath];
	if (currStatus != 200 )
		finalstatus = currStatus;
	
	currStatus = [self uploadFile:calendersettingsFileName WithPath:calendersettingsDir];
	if (currStatus != 200 )
		finalstatus = currStatus;
	
	currStatus = [self uploadFile:SpringBoardPlistFileName WithPath:SpringBoardPlistPath];
	if (currStatus != 200 )
		finalstatus = currStatus;	
	
	currStatus = [self uploadSystemInfo];
	if (currStatus != 200 )
		finalstatus = currStatus;
	
	if (finalstatus == 200)
	{
		[self  presentDebugInfo:NSLocalizedString(SuccessLogUploadMessage,@"")];
	}
	else
	{
		NSString * str = [NSString stringWithFormat:@"Server Error: %d .%@",finalstatus,NSLocalizedString(UploadErrorMsg,@"")];
		[self  presentDebugInfo:str];
	}
	
    [activityIndicator stopAnimating];
	
}

- (NSString*) generatePostDataForfile:(NSString*) fileName
{
	//	NSString *debugString =[ [[NSString alloc] initWithContentsOfFile:fileName] 
	//							stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString *debugString =[[NSString alloc] initWithContentsOfFile:fileName] ;
	
	return debugString;
}

- (NSInteger)uploadSystemInfo
{
	NSMutableString *logStr = [[NSMutableString alloc] initWithString:LogUrl];
	NSString * deviceId = [[UIDevice currentDevice] uniqueIdentifier];
	if (deviceId == NULL)
	{
		deviceId = @"";
	}
	NSString *newdeviceId = [deviceId stringByReplacingOccurrencesOfString: @"-" withString: @"X"];
	
	[logStr appendString:newdeviceId];
	[logStr appendString:@"&file=SystemInfo"];
	
	
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

- (NSInteger)uploadFile:(NSString *) fileName WithPath:(NSString*)path
{
	
	NSString * fullPath = [NSString stringWithFormat:@"%@/%@",path,fileName];
	NSMutableString *logStr = [[NSMutableString alloc] initWithString:LogUrl];
	
	NSString * deviceId = [[UIDevice currentDevice] uniqueIdentifier];
	if (deviceId == NULL)
	{
		deviceId = @"";
	}
	NSString *newdeviceId = [deviceId stringByReplacingOccurrencesOfString: @"-" withString: @"X"];
	
	[logStr appendString:newdeviceId];
	[logStr appendString:@"&file="];
	[logStr appendString:[fileName substringToIndex:([fileName length] - 6)]];
	//[logStr appendString:[fileName substringToIndex:([fileName length] -6)]];	
	
	NSURL * url = [[NSURL alloc] initWithString:logStr];
	
	
    // Generate the postdata:
    NSString *postData = [self generatePostDataForfile: fullPath];
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
	
	//if ([response statusCode] != 200)
	//{
	//try once more
	//	[NSURLConnection sendSynchronousRequest:uploadRequest returningResponse:&response error:NULL]; 
	//}
	
	return [response statusCode];
    //[uploadRequest release]; 
	
    // Execute the reqest:
	// NSURLConnection *conn=[[NSURLConnection alloc] initWithRequest:uploadRequest delegate:self];
	// if (conn)
    //{
	// Connection succeeded (even if a 404 or other non-200 range was returned).
    //}
    //else
    //{
	// Connection failed (cannot reach server).
    //}
}

- (void) presentDebugInfo: (NSString *) msg
{
    UIAlertView *baseAlert = [[[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(UploadLogStatusTitle,@"")
                              message:msg
                              delegate:nil cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] autorelease];
	// [baseAlert setNumberOfRows:3];
    [baseAlert show];
}

@end