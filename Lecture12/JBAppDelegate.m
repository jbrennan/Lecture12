//
//  JBAppDelegate.m
//  Lecture12
//
//  Created by Jason Brennan on 12-03-08.
//  Copyright (c) 2012 Jason Brennan. All rights reserved.
//

#import "JBAppDelegate.h"

#import "JBMasterViewController.h"
#import "JBServicesBrowserTableViewController.h"
#import "JBIMClient.h"



@implementation JBAppDelegate {
	UIBackgroundTaskIdentifier _bgTask;
}

@synthesize window = _window;
@synthesize navigationController = _navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.

//	JBMasterViewController *masterViewController = [[JBMasterViewController alloc] initWithNibName:@"JBMasterViewController" bundle:nil];
	
	JBServicesBrowserTableViewController *services = [[JBServicesBrowserTableViewController alloc] initWithStyle:UITableViewStylePlain];
	
	self.navigationController = [[UINavigationController alloc] initWithRootViewController:services];
	self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
	
	_bgTask = UIBackgroundTaskInvalid;
	
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	_bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
		[application endBackgroundTask:_bgTask];
		_bgTask = UIBackgroundTaskInvalid;
	}];
	
	
	// Send the logout message and disconnect asynchronously
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^() {
		// post the notification object, which will be on this q's thread
		// this happens synchronously on this q
		[[NSNotificationCenter defaultCenter] postNotificationName:JBIMClientApplicationClosingNotification object:nil];
		
		dispatch_sync(dispatch_get_main_queue(),^() {
			// Main Queue code
			// we're done
			[application endBackgroundTask:_bgTask];
			_bgTask = UIBackgroundTaskInvalid;
		});
		
	});
	
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
