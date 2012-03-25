//
//  LyricsViewController.h
//  Verbosify
//
//  Created by Joseph Constan on 4/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VerbosifyViewController.h"


@interface LyricsViewController : UIViewController <UITextFieldDelegate> {
	UITextField *artistTextField;
	UITextField *songTextField;
	
	VerbosifyViewController *delegate;
}
@property (nonatomic, retain) VerbosifyViewController *delegate;

@property (nonatomic, retain) IBOutlet UITextField *artistTextField;
@property (nonatomic, retain) IBOutlet UITextField *songTextField;

- (IBAction)insertButtonPressed;
- (IBAction)cancelButtonPressed;

@end
