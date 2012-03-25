//
//  FlipsideViewController.h
//  Untitled
//
//  Created by Joseph Constan on 1/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "FBConnect.h"
#import "VerbosifyAppDelegate.h"
#import "VerbosifyViewController.h"
#import "FBLoginButton.h"

@class VerbosifyViewController;

@interface FlipsideViewController : UIViewController <MFMailComposeViewControllerDelegate> {
	VerbosifyViewController *delegate;
	UISwitch *parseSwitch;
	UISwitch *phraseSwitch;
	UISwitch *fontSwitch;
	UIPickerView *voicePicker;
	UISegmentedControl *thesaurusSwitch;
	UILabel *voiceLabel;
	
	UIView *maskView;
	FBLoginButton *fbButton;
	//FBSession *fbSession;
}
	
@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) IBOutlet UISwitch *parseSwitch;
@property (nonatomic, retain) IBOutlet UISwitch *phraseSwitch;
@property (nonatomic, retain) IBOutlet UISwitch *fontSwitch;
@property (nonatomic, retain) IBOutlet UISegmentedControl *thesaurusSwitch;
@property (nonatomic, retain) IBOutlet UIPickerView *voicePicker;
@property (nonatomic, retain) IBOutlet UILabel *voiceLabel;
@property (nonatomic, retain) FBLoginButton *fbButton;
//@property (nonatomic, assign) FBSession *fbSession;

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
- (void)hideVoicePicker;
- (IBAction)done:(id)sender;
- (IBAction)linkPressed:(id)sender;
- (IBAction)switchFlipped:(id)sender;
- (IBAction)changePressed;
@end


@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

