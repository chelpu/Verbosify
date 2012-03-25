//
//  InsertViewController.h
//  Verbosify
//
//  Created by Joseph Constan on 4/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VerbosifyViewController.h"


@interface InsertViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate> {
	VerbosifyViewController *delegate;
	UIPickerView *pickerView;
	
	NSArray *titles;
	NSArray *postNums;
}
@property (nonatomic, retain) VerbosifyViewController *delegate;
@property (nonatomic, retain) IBOutlet UIPickerView *pickerView;

@property (nonatomic, retain) NSArray *titles;
@property (nonatomic, retain) NSArray *postNums;

- (IBAction)insertButtonPressed;
//- (IBAction)randomButtonPressed;
- (IBAction)cancelButtonPressed;

@end
