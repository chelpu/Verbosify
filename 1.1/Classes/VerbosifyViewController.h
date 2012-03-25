//
//  VerbosifyViewController.h
//  Verbosify
//
//  Created by Joseph Constan on 1/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlipsideViewController.h"
#import "VerbosifyAppDelegate.h"
#import "FliteTTS.h"
#import "Reachability.h"
#import "InsertViewController.h"
#import "LyricsViewController.h"

@class FlipsideViewController;

@interface VerbosifyViewController : UIViewController 
<NSXMLParserDelegate, FBRequestDelegate, UITextViewDelegate> {

	UITextView *textView;
	UIButton *verbosify;
	UIButton *startOver;	
	UIButton *postButton;	
	UILabel *topLabel;
	UIButton *wallPostButton;
	UIButton *songLyricsButton;
	UIButton *randomButton;
	UIButton *commentButton;
	
	FliteTTS *tts;
	
	NSMutableDictionary *parsedWords;
	NSMutableDictionary *presetWords;	//default, dictionary.com with multiple words allowed
	NSMutableDictionary *dictNoMultCache;
	NSMutableDictionary *bigMultCache;
	NSMutableDictionary *bigNoMultCache;
	
	NSString *facebookPostNum;
	NSMutableString *synonyms;
	UIActivityIndicatorView *spinner;
	
	NSUInteger numWords;
	BOOL useAltThesaurus;
	BOOL isPosting;
	
	//parser data
	BOOL inPOS;
	BOOL inItem;
	BOOL inSynonyms;
	NSString *parserPOS;
}
@property (nonatomic, retain) IBOutlet UITextView *textView;
@property (nonatomic, retain) IBOutlet UIButton *verbosify;
@property (nonatomic, retain) IBOutlet UIButton *startOver;
@property (nonatomic, retain) IBOutlet UIButton *postButton;	
@property (nonatomic, retain) IBOutlet UILabel *topLabel;

@property (nonatomic, retain) IBOutlet UIButton *wallPostButton;
@property (nonatomic, retain) IBOutlet UIButton *songLyricsButton;
@property (nonatomic, retain) IBOutlet UIButton *randomButton;
@property (nonatomic, retain) IBOutlet UIButton *commentButton;

@property (nonatomic, retain) NSString *facebookPostNum;
@property (nonatomic, retain) UIActivityIndicatorView *spinner;

@property (nonatomic, retain) NSMutableDictionary *presetWords;
@property (nonatomic, retain) FliteTTS *tts;

- (IBAction) verbosifyPressed;
- (IBAction) startOverPressed;
- (IBAction)randomButtonPressed;
- (IBAction)wallPostButtonPressed;
- (IBAction)songButtonPressed;
- (IBAction)postAsComment;
- (IBAction) postToFacebook;
- (IBAction) showInfo:(id)sender; 
- (IBAction)beginTTS:(id)sender;
//- (IBAction)startSpinning:(id)sender;
- (void)cacheNewWord:(NSString *)newWord forKey:(NSString *)oldWord;
- (NSString *)cachedWordForKey:(NSString *)oldWord;

//- (void)parseGrammar:(NSString *)input;
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
- (void)keyboardDidShow:(NSNotification *)notif;
- (void)keyboardDidHide:(NSNotification *)notif;
- (NSString *)verbosifiedArray:(NSMutableArray *)words;
- (NSString *)verbosifiedDictionary:(NSMutableDictionary *)words;
- (BOOL)conditionsMet:(NSArray *)currentLine POS:(NSString *)pos LSL:(NSUInteger)longestSynLen;

@end

