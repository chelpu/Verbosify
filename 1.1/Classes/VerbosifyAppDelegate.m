//
//  VerbosifyAppDelegate.m
//  Verbosify
//
//  Created by Joseph Constan on 1/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VerbosifyAppDelegate.h"
#import "VerbosifyViewController.h"

#define kFacebookAppId @"129134327153308"

@implementation VerbosifyAppDelegate

@synthesize window;
@synthesize viewController, facebook, flipsideViewController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.

    // Add the view controller's view to the window and display.
    [self.window addSubview:viewController.view];
    [self.window makeKeyAndVisible];
	
	facebook = [[Facebook alloc] initWithAppId:kFacebookAppId];

    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
	
    return [facebook handleOpenURL:url]; 
}

- (void)fbDidLogin {
	flipsideViewController.fbButton.isLoggedIn = YES;
	[flipsideViewController.fbButton updateImage];
}

- (void)fbDidLogout {
	UIAlertView *logoutAlert = [[UIAlertView alloc] initWithTitle:@"Logged Out of Facebook" 
														  message:@"Clearly so you can log back into your second and third accounts to further spread the word about this app, right?" 
														 delegate:nil 
												cancelButtonTitle:@"Okay" 
												otherButtonTitles:nil];
	[logoutAlert show];
	[logoutAlert release];
	flipsideViewController.fbButton.isLoggedIn = NO;
	[flipsideViewController.fbButton updateImage];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
	//cache previous "translations"
	[[NSUserDefaults standardUserDefaults] setObject:viewController.presetWords forKey:@"presetWords"];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
	[flipsideViewController.fbButton updateImage];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
	[flipsideViewController.fbButton updateImage];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}

#pragma mark -
#pragma mark Facebook Support
/*
- (void)session:(FBSession *)session didLogin:(FBUID)uid {
}

-(void)status:(MOFBStatus*)aMofbStatus DidFailWithError:(NSError*)error {
}

-(void)statusDidUpdate:(id)sender {
}*/

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
