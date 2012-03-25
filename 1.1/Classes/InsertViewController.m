//
//  InsertViewController.m
//  Verbosify
//
//  Created by Joseph Constan on 4/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InsertViewController.h"


@implementation InsertViewController

@synthesize delegate, pickerView, titles, postNums;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
		titles = [[NSMutableArray alloc] initWithCapacity:20];
    }
    return self;
}*/


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
	
	delegate.textView.text = [titles objectAtIndex:[pickerView selectedRowInComponent:0]];
	delegate.facebookPostNum = [postNums objectAtIndex:[pickerView selectedRowInComponent:0]];
	
	[delegate.spinner stopAnimating];
	[delegate.spinner release];
	[delegate dismissModalViewControllerAnimated:YES];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)aPickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)aPickerView numberOfRowsInComponent:(NSInteger)component {
	return [titles count];
}

- (NSString *)pickerView:(UIPickerView *)aPickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [titles objectAtIndex:row];
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
	
	[titles release];
	[postNums release];
    [super dealloc];
}


@end
