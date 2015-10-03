//
//  SilentMeAppDelegate.m
//  SilentMe
//
//  Created by iphonePacker on 9/13/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "SilentMeAppDelegate.h"
#import "MainTableController.h"
#import "SingletonDataSources.h"

@implementation SilentMeAppDelegate

//@synthesize window;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    

    // Override point for customization after application launch
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[MainTableController alloc] initWithDataSource:GetMainTableDataSource()]];
	[window addSubview:nav.view];
    [window makeKeyAndVisible];
}

- (void)applicationWillTerminate:(UIApplication *)application  {
	// handle any final state matters here
}

- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
