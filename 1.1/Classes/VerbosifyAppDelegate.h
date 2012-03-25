//
//  VerbosifyAppDelegate.h
//  Verbosify
//
//  Created by Joseph Constan on 1/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Facebook.h"

@class VerbosifyViewController, FlipsideViewController;

@interface VerbosifyAppDelegate : NSObject <UIApplicationDelegate, FBSessionDelegate> {
    UIWindow *window;
    VerbosifyViewController *viewController;
	FlipsideViewController *flipsideViewController;
	Facebook *facebook;
}

@property (nonatomic, retain) Facebook *facebook;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet VerbosifyViewController *viewController;
@property (nonatomic, retain) FlipsideViewController *flipsideViewController;

@end

