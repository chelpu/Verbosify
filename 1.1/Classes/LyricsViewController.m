//
//  LyricsViewController.m
//  Verbosify
//
//  Created by Joseph Constan on 4/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LyricsViewController.h"


@implementation LyricsViewController

@synthesize artistTextField, songTextField, delegate;

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	[artistTextField resignFirstResponder];
	[songTextField resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // Any new character added is passed in as the "text" parameter
    if ([string isEqualToString:@"\n"]) {
		
		[textField resignFirstResponder];
		[self insertButtonPressed];
		
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
    // For any other character return TRUE so that the text gets added to the view
    return TRUE;
}

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

- (IBAction)cancelButtonPressed {
	
	[delegate.spinner stopAnimating];
	[delegate.spinner release];
	[delegate dismissModalViewControllerAnimated:YES];
	delegate.commentButton.hidden = YES;
}

- (IBAction)insertButtonPressed {
	
	if ([songTextField.text length] <= 0) {
		UIAlertView *sentView = [[UIAlertView alloc] initWithTitle:@"You need to enter a song title!" message:nil delegate:nil
												 cancelButtonTitle:@"OK" otherButtonTitles:nil];
		
		[sentView show];
		[sentView release];
		return;
	}
	
	NSMutableString *lyricsURL = [NSMutableString stringWithFormat:@"http://lyrics.wikia.com/api.php?song=%@&fmt=text", 
								  [songTextField.text stringByReplacingOccurrencesOfString:@" " withString:@"_"]];
	if ([artistTextField.text length] > 0) {
		[lyricsURL appendFormat:@"&artist=%@", [artistTextField.text stringByReplacingOccurrencesOfString:@" " withString:@"_"]];
	}
	NSError *error = [[NSError alloc] init];
	NSString *lyrics = [NSString stringWithContentsOfURL:[NSURL URLWithString:lyricsURL] encoding:NSUTF8StringEncoding error:&error];
	
	if (lyrics) {
		if ([lyrics isEqualToString:@"Not found"]) {
			UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Unable to find song \"%@\"", songTextField.text] 
															   message:@"Try checking you spelling"
															  delegate:nil
													 cancelButtonTitle:@"OK" otherButtonTitles:nil];
			
			[errorView show];
			[errorView release];
			return;
		} else {
			delegate.textView.text = lyrics;
		}
	} else {
		UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Couldn't connect to Lyrics.Wikia.com" 
														   message:[NSString stringWithFormat:@"Check your connection\nError: %@", [error localizedDescription]]
														  delegate:nil
												 cancelButtonTitle:@"OK" otherButtonTitles:nil];
		
		[errorView show];
		[errorView release];
		return;
	}

	[delegate.spinner stopAnimating];
	[delegate.spinner release];
	[delegate dismissModalViewControllerAnimated:YES];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
			interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
