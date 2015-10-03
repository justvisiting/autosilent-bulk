//not tracking what's here
#include <stdio.h>
#include <notify.h>
#include <unistd.h>
#include <stdarg.h>
#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>

/*
U _CalendarModelCalendarsChangedNotification
U _CalendarModelDateToShowResultsFromKey
U _CalendarModelDidChangeExternallyKey
U _CalendarModelDisplayedOccurrencesChangedNotification
U _CalendarModelDisplayedOccurrencesWillChangeNotification
U _CalendarModelFilterChangedNotification
U _CalendarModelFoundDateToScrollToNotification
U _CalendarModelInvitationCountsChangedNotification
U _CalendarModelInvitationsChangedNotification
U _CalendarModelMoreSearchResultsAvailableNotification
U _CalendarModelPreviouslySelectedOccurrenceKey
U _CalendarModelSelectedDateChangedNotification
U _CalendarModelSelectedDateReaffirmedNotification
U _CalendarModelSelectedOccurrenceChangedNotification
*/

static void callback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    printf("notification intercepted");
	if(name != NULL)
	fprintf(stderr, "Notification intercepted: %s\n", [name UTF8String]);
    //if (userInfo) CFShow(userInfo);
    return;
}

static void signalHandler(int sigraised)
{
    printf("\nInterrupted.\n");
    _exit(0);
}

void usage(char *appname)
{
    printf("%s : options \n", appname);
    printf("-s     listen to standard notifications\n");
    printf("-t     listen to core telephony notifications\n");
}

int Notifications()
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
//    if (argc < 2) {usage(argv[0]); exit(0);}
	
    NSString *readNotifications = @"com.apple.springboard.ringerstateBOUNDARYcom.apple.springboard.showingAlertItem";
    NSArray *notifications = [readNotifications componentsSeparatedByString:@"BOUNDARY"];
	
    opterr = 0;
    int c;
    id results;
    BOOL isTelephony = NO;
    BOOL isStandard = YES;
	
	/*
    while ((c = getopt (argc, argv, "ts")) != -1)
		switch (c)
	{
        case 's': 
            isStandard = YES;
			break;
        case 't': 
            isTelephony = YES;
            break;
        case '?':
			if (isprint (optopt))
				fprintf (stderr, "Unknown option `-%c'.\n", optopt);
			else
				fprintf (stderr,
						 "Unknown option character `\\x%x'.\n",
						 optopt);
			return 1;
        default:
			return 0;
	}*/
	
    if ((!isStandard) && (!isTelephony))
    {
        printf("Listen either to standard (-s), telephony (-t) notifications or both\n");
        printf("No notification type selected. Exiting.\n");
        exit(-1);
    }
	
    if (isStandard)
    {
		
		/*
		 void CFNotificationCenterPostNotification (
		 CFNotificationCenterRef center,
		 CFStringRef name,
		 const void *object,
		 CFDictionaryRef userInfo,
		 Boolean deliverImmediately
		 );
		 */
		
		CFMutableDictionaryRef stockInfoDict = CFDictionaryCreateMutable(NULL, 1,
																		 &kCFCopyStringDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
		
		//CFBooleanRef boolVal = 
		CFDictionaryAddValue(stockInfoDict, CFSTR("ringerstate"), kCFBooleanFalse);
		
		
        printf("Watching for Standard Notifications (%d notifications)\n", [notifications count]);
		
        for (id *notification in notifications)
        {
            CFNotificationCenterAddObserver(
											CFNotificationCenterGetDarwinNotifyCenter(), //center
											NULL, // observer
											callback, // callback
											notification, // name
											NULL, // object
											CFNotificationSuspensionBehaviorHold
											); 
        }
    }
	
    if (isTelephony)
    {
        printf("Watching for Core Telephony notifications\n");
        id ct = CTTelephonyCenterGetDefault();
        CTTelephonyCenterAddObserver(
									 ct, 
									 NULL, 
									 callback,
									 NULL,
									 NULL,
									 CFNotificationSuspensionBehaviorHold);
    }
	
	
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter() //center
										 , CFSTR("com.apple.springboard.ringerstate")
										 , NULL
										 , NULL
										 , TRUE);
	
    // Set up a signal handler so we can clean up when we're interrupted from the command line
    sig_t oldHandler = signal(SIGINT, signalHandler);
    if (oldHandler == SIG_ERR) {
        printf("Could not establish new signal handler");
        exit(1);
    }
	
    // Start the run loop. Now we'll receive notifications.
    printf("Starting Notification Scan. ^C to quit.\n");
    CFRunLoopRun();
	
    printf("Unexpectedly back from CFRunLoopRun()!\n");
}