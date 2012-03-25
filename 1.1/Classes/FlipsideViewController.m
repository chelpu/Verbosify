//
//  FlipsideViewController.m
//  Untitled
//
//  Created by Joseph Constan on 1/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FlipsideViewController.h"


@implementation FlipsideViewController

@synthesize delegate, parseSwitch, phraseSwitch, fontSwitch, thesaurusSwitch, voicePicker, voiceLabel, fbButton;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];  
		
	fbButton = [[FBLoginButton alloc] initWithFrame:CGRectMake(20, 249, 90, 31)];
	fbButton.center = CGPointMake(self.view.center.x, fbButton.center.y);
	fbButton.hidden = NO;
	VerbosifyAppDelegate *appDelegate = (VerbosifyAppDelegate *)[[UIApplication sharedApplication] delegate];
	fbButton.isLoggedIn = [appDelegate.facebook isSessionValid];
	[fbButton updateImage];
	[self.view addSubview:fbButton];
	[fbButton addTarget:fbButton action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
	
	if([[[NSUserDefaults standardUserDefaults] stringForKey:@"VoiceLabelText"] length] > 0)
		voiceLabel.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"VoiceLabelText"];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[fbButton updateImage];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

	//[parseSwitch setOn:![defaults boolForKey:@"DontParseGrammar"] animated:NO];
	[phraseSwitch setOn:![defaults boolForKey:@"NoPhrasesAllowed"] animated:NO];
	[fontSwitch setOn:[defaults boolForKey:@"UseFonts"] animated:NO];
	thesaurusSwitch.selectedSegmentIndex = ([defaults boolForKey:@"UseAltThesaurus"] == YES) ? 1 : 0;
	[self pickerView:voicePicker didSelectRow:[defaults integerForKey:@"Voice"] inComponent:0];
}

- (IBAction)done:(id)sender {
	[self.delegate flipsideViewControllerDidFinish:self];	
}

- (IBAction)switchFlipped:(id)sender {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

	/*if ([sender tag] == 10) {
		[defaults setBool:!parseSwitch.on forKey:@"DontParseGrammar"];
		NSLog(@"parseSwitch Flipped %d", ![defaults boolForKey:@"DontParseGrammar"]);
	} else */if ([sender tag] == 20) {
		[defaults setBool:!phraseSwitch.on forKey:@"NoPhrasesAllowed"];
		NSLog(@"phraseSwitch Flipped %d", ![defaults boolForKey:@"NoPhrasesAllowed"]);
	} else if ([sender tag] == 30) {
		[defaults setBool:([thesaurusSwitch selectedSegmentIndex] == 1) forKey:@"UseAltThesaurus"];
		NSLog(@"thesaurusSwitch Flipped %d", [defaults boolForKey:@"UseAltThesaurus"]);
	} else if ([sender tag] == 40) {
		[defaults setBool:fontSwitch.on forKey:@"UseFonts"];
	} 
	[defaults synchronize];
}

- (IBAction)linkPressed:(id)sender {
	if ([[[sender titleLabel] text] isEqualToString:@"Big Huge Thesaurus"]) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://words.bighugelabs.com"]];
	} else if ([[[sender titleLabel] text] isEqualToString:@"Codevs.com"]) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.codevs.com"]];
	} else if ([[[sender titleLabel] text] isEqualToString:@"Dictionary.com"]) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.dictionary.com"]];
	} else if ([[[sender titleLabel] text] isEqualToString:@"Contact The Dev"]) {
		if ([MFMailComposeViewController canSendMail]) {
			MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
			[mailViewController setToRecipients:[NSArray arrayWithObject:@"jcon5294@gmail.com"]];
			[mailViewController setSubject:@"Verbosify!"];
			mailViewController.mailComposeDelegate = self;
			[self presentModalViewController:mailViewController animated:YES];
		}
	}
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[self dismissModalViewControllerAnimated:YES];
	[controller release];
}

- (IBAction)changePressed {
	maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 480, 256)];
	maskView.backgroundColor = self.view.backgroundColor;
	maskView.alpha = 0;
	[self.view addSubview:maskView];
	[self.view bringSubviewToFront:voicePicker];
	
	[UIView beginAnimations:@"showVoicePicker" context:nil];
	[UIView setAnimationDuration:1];

	maskView.alpha = 1;
	voicePicker.alpha = 1;
	voicePicker.hidden = NO;
	
	[UIView commitAnimations];
}

#pragma mark -
#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return 4;
}

#pragma mark -
#pragma mark UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	switch (row) {
		case 0:
			return @"Awb (Scottish Male)";
			break;
		case 1:
			return @"Kal (American Male)";
			break;
		case 2:
			return @"Rms (American Male)";
			break;
		case 3:
			return @"Slt (American Female)";
			break;
		default:
			return @"";
			break;
	}
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	int r = arc4random() % 4;
	[[NSUserDefaults standardUserDefaults] setInteger:row forKey:@"Voice"];
	switch (row) {
		case 0:
			[[delegate tts] setVoice:@"cmu_us_awb"];
			if (r >= 1) {
				voiceLabel.text = @"Current Thesaurus Rex Voice: Awb";
			} else {
				voiceLabel.text = @"The Dinosaur is now Scottish!";
			}
			break;
		case 1:
			[[delegate tts] setVoice:@"cmu_us_kal"];
			voiceLabel.text = @"Current Thesaurus Rex Voice: Kal";
			break;
		case 2:
			[[delegate tts] setVoice:@"cmu_us_rms"];
			voiceLabel.text = @"Current Thesaurus Rex Voice: Rms";
			break;
		case 3:
			[[delegate tts] setVoice:@"cmu_us_slt"];
			if (r >= 1) {
				voiceLabel.text = @"Current Thesaurus Rex Voice: Slt";
			} else {
				voiceLabel.text = @"The Dinosaur is now a lovely lady. Be gentle.";
			}
			break;
		default:
			break;
	}
	[UIView beginAnimations:@"hideVoicePicker" context:nil];
	[UIView setAnimationDuration:1];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(hideVoicePicker)];
	
	maskView.alpha = 0;
	voicePicker.alpha = 0;
	
	[UIView commitAnimations];
	
	[[NSUserDefaults standardUserDefaults] setObject:voiceLabel forKey:@"VoiceLabelText"];
}
												  
- (void)hideVoicePicker {
	[maskView release];
	voicePicker.hidden = YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
			interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}



- (void)dealloc {
	[fbButton release];
    [super dealloc];
}


@end
