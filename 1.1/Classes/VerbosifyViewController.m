//
//  VerbosifyViewController.m
//  Verbosify
//
//  Created by Joseph Constan on 1/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VerbosifyViewController.h"

@implementation VerbosifyViewController

@synthesize textView, topLabel, verbosify, startOver, postButton, presetWords, tts, wallPostButton, 
songLyricsButton, randomButton, commentButton, facebookPostNum, spinner;

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	[textView resignFirstResponder];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
		
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
		
	tts = [[FliteTTS alloc] init];
	parsedWords = [[NSMutableDictionary alloc] init];
	spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	textView.delegate = self;
	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"presetWords"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"dictNoMultCache"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"bigMultCache"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"bigNoMultCache"];

	//I'll have one general list, plus one for verbs, nouns, prepositions, etc for after the more complex ones have been parsed
	NSDictionary *basePresets = [[NSDictionary alloc] initWithObjectsAndKeys:
				   @"the", @"the",
				   @"of", @"of",
				   @"and", @"and",
				   @"a", @"a",
				   @"to", @"to",
				   @"in", @"in",
				   @"is", @"is",
				   @"thou", @"you",					//replace "you" with "thou"
				   @"that", @"that",
				   @"it", @"it",					//10
				   @"he", @"he",					
				   @"was", @"was",
				   @"for", @"for",
				   @"upon", @"on",
				   @"art", @"are",
				   @"as", @"as",
				   @"in the company of", @"with",
				   @"his", @"his",
				   @"they", @"they",
				   @"I", @"i",					//20
				   @"in the direction of", @"at",
				   @"be", @"be",
				   @"the aforementioned", @"this",
				   @"have", @"have",
				   @"from", @"from",
				   @"or", @"or",
				   @"an individual", @"one",
				   @"hadst", @"had",
				   @"by", @"by",
				   @"communication", @"word",									//30
				   @"nevertheless", @"but",
				   @"in no way", @"not",
				   @"what", @"what",
				   @"all", @"all",
				   @"were", @"were",
				   @"ourselves", @"we",
				   @"whence", @"when",
				   @"thine", @"your",
				   @"can", @"can",
				   @"communicated", @"said",					//40
				   @"in attendance", @"there",
				   @"utilize", @"use",
				   @"an", @"an",
				   @"each", @"each",
				   @"whichever", @"which",
				   @"she", @"she",
				   @"doth", @"do",
				   @"in what manner", @"how",
				   @"their", @"their",
				   @"with the condition that", @"if",					//50
				   @"shall", @"will",
				   @"shall", @"will.v",
				   @"heavenward", @"up",
				   @"supplementary", @"other",
				   @"about", @"about",
				   @"outward", @"out",
				   @"innumerable", @"many",
				   @"then", @"then",
				   @"them", @"them",
				   @"these", @"these",
				   @"indeed", @"so",					//60
				   @"several", @"some",
				   @"her", @"her",
				   @"would", @"would",
				   @"assemble", @"make",
				   @"equivalent to", @"like",
				   @"him", @"him",
				   @"in the direction of", @"into",
				   @"temporal length", @"time",
				   @"has", @"has",
				   @"visually examine", @"look",					//70
				   @"twosome", @"two",
				   @"additional", @"more",
				   @"compose", @"write",
				   @"proceed", @"go",
				   @"visually perceive", @"see",
				   @"mathematical", @"number",
				   @"no", @"no",
				   @"passageway", @"way",
				   @"could", @"could",
				   @"citizens", @"people",					//80
				   @"my", @"my",
				   @"compared", @"than",
				   @"primary", @"first",
				   @"liquid", @"water",
				   @"been", @"been",
				   @"communication", @"call",
				   @"who", @"who",
				   @"petroleum", @"oil.n",
				   @"lubricate", @"oil.v",
				   @"its", @"its",
				   @"momentarily", @"now",					//90
				   @"discover", @"find",
				   @"extensive", @"long",
				   @"downward", @"down",
				   @"24-hour period", @"day",
				   @"did", @"did",
				   @"acquire", @"get",
				   @"arrive", @"come",
				   @"assembled", @"made",
				   @"might possibly", @"may",
				   @"component", @"part",		//end top 100 words
				   @"feline", @"vagina",
				   @"on account of the fact that", @"because",
				   @"forsooth", @"truly",
				   @"indubitably", @"really",
				   @"forsooth", @"indeed",
				   @"whosoever", @"whoever",
				   @"without delay", @"immediately",
				   @"immediately", @"now",
				   @"me", @"me",
				   @"am", @"am",
				   @"moved with great haste", @"ran",
				   @"expedition", @"run.n",
				   @"move with great haste", @"run",
				   @"salutations", @"hi",
				   @"celestial being", @"god",
				   @"have sexual intercourse with", @"fuck",			//YAY PROFANITY
				   @"having sexual intercourse with", @"fucking",
				   @"excrement", @"shit",
				   @"excrement", @"poop",
				   @"female dog", @"bitch",
				   @"complaining whiningly", @"bitching",
				   @"rooster", @"cock",
				   @"perpetual damnation", @"hell",
				   @"condemn to hell", @"damn",
				   @"long-eared hooved mammal", @"ass",
				   @"mischievous scalawag", @"motherfucker",
				   @"mammary glands", @"tits",
				   @"mammary gland", @"tit",
				   @"mammary gland", @"breast",
				   @"mammary glands", @"breasts",
				   @"mammary gland", @"boob",
				   @"mammary glands", @"boobs",
				   @"phallus", @"dick",
				   @"phalli", @"dicks",
				   @"male reproductive organ", @"penis",
				   @"female reproductive organ", @"vagina",
				   @"female reproductive organ", @"cunt",
				   @"feline", @"pussy",
				   @"eject reproductive fluid", @"cum.v",
				   @"ejecting reproductive fluid", @"cumming",
				   @"reproductive fluid", @"cum",
				   @"balderdash", @"bullshit",
				   @"uric discharge", @"piss",
				   @"African-American", @"nigger",
				   nil];

	if ([[NSUserDefaults standardUserDefaults] objectForKey:@"presetWords"]) {
		presetWords = [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"presetWords"]];
	} else {
		presetWords = [[NSMutableDictionary alloc] initWithDictionary:basePresets];
	}
	if ([[NSUserDefaults standardUserDefaults] objectForKey:@"dictNoMultCache"]) {
		dictNoMultCache = [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"dictNoMultCache"]];
	} else {
		dictNoMultCache = [[NSMutableDictionary alloc] initWithDictionary:basePresets];
	}
	if ([[NSUserDefaults standardUserDefaults] objectForKey:@"bigMultCache"]) {
		bigMultCache = [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"bigMultCache"]];
	} else {
		bigMultCache = [[NSMutableDictionary alloc] initWithDictionary:basePresets];
	}
	if ([[NSUserDefaults standardUserDefaults] objectForKey:@"bigNoMultCache"]) {
		bigNoMultCache = [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"bigNoMultCache"]];
	} else {
		bigNoMultCache = [[NSMutableDictionary alloc] initWithDictionary:basePresets];
	}
	[basePresets release];
	
	
	VerbosifyAppDelegate *appDelegate = (VerbosifyAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSArray* permissions =  [[NSArray arrayWithObjects:
							  @"publish_stream", @"read_stream", nil] retain];
	
	[appDelegate.facebook authorize:permissions delegate:appDelegate];
}

- (BOOL)textView:(UITextView *)aTextView shouldChangeTextInRange:(NSRange)range 
 replacementText:(NSString *)text
{
    // Any new character added is passed in as the "text" parameter
    if ([text isEqualToString:@"\n"]) {
			
		[textView resignFirstResponder];
		[self verbosifyPressed];
		
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
    // For any other character return TRUE so that the text gets added to the view
    return TRUE;
}

- (IBAction)beginTTS:(id)sender {
	if (textView.text.length > 0 && ![textView isFirstResponder]) {
		UIActivityIndicatorView *ttsWheel = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		ttsWheel.center = [sender center];
		[self.view addSubview:ttsWheel];
		[ttsWheel startAnimating];
		[NSThread detachNewThreadSelector:@selector(loadFliteInBackground:) toTarget:self withObject:ttsWheel];
	}
	[textView resignFirstResponder];
}

- (void)loadFliteInBackground:(UIActivityIndicatorView *)wheel {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	//[tts performSelectorOnMainThread:@selector(speakText:) withObject:textView.text waitUntilDone:NO];
	[tts speakText:textView.text];
	[pool release];
	[wheel stopAnimating];
	[wheel release];
}

/*- (void)parseGrammar:(NSString *)input {
	
	Dictionary    dict;
    Parse_Options opts;
    Sentence      sent;
    Linkage       linkage;
    int           i, num_linkages, numSentences;
	
	char *  input_string[[[input componentsSeparatedByString:@". "] count]];
	if ([input rangeOfString:@". "].location == NSNotFound) {
		input_string[0] = [input cStringUsingEncoding:NSUTF8StringEncoding];
		numSentences = 1;
	} else {
		for (int j = 0; j < [[input componentsSeparatedByString:@". "] count]; j++) {
			input_string[j] = [[[input componentsSeparatedByString:@". "] objectAtIndex:j] cStringUsingEncoding:NSUTF8StringEncoding];
		}
		numSentences = [[input componentsSeparatedByString:@". "] count];
	}
	[parsedWords removeAllObjects];

    opts  = parse_options_create();
    dict  = dictionary_create("4.0.dict", "4.0.knowledge", NULL, "4.0.affix");
	parse_options_set_max_sentence_length(opts, 120);
	
    for (i=0; i<numSentences; ++i) {
		sent = sentence_create(input_string[i], dict);
		NSLog(@"sent ln: %d", sent->length);
		num_linkages = sentence_parse(sent, opts);
		if (num_linkages > 0) {
			linkage = linkage_create(0, sent, opts);
			
			NSMutableArray *words = [NSMutableArray arrayWithCapacity:numWords+2];
			for (int k = 0; k < linkage->num_words; k++) {
				NSString *currentWord = [NSString stringWithCString:linkage_get_words(linkage)[k] encoding:NSUTF8StringEncoding];
				if (![currentWord isEqualToString:@"LEFT-WALL"] && ![currentWord isEqualToString:@"RIGHT-WALL"]) {
					[words addObject:currentWord];
				}
			}
			
			for (int j = 0; j < [words count]; j++) {
				NSString *currentWord = [words objectAtIndex:j];
				NSString *pos= @"";
				if ([currentWord characterAtIndex:currentWord.length-2] == '.') {
					switch ([currentWord characterAtIndex:currentWord.length-1]) {
						case 'v':
							pos = @"verb";
							break;
						case 'n':
							pos = @"noun";
							break;
						case 'a':
							pos = @"adjective";
							break;
						case 'e':
							pos = @"adverb";
							break;
						default:
							break;
					}
				}
				if ([currentWord rangeOfString:@"[?]"].location != NSNotFound) {
					currentWord = [currentWord stringByReplacingOccurrencesOfString:@"[?]" withString:@""];
				}
				if ([currentWord rangeOfString:@"[!]"].location != NSNotFound) {
					currentWord = [currentWord stringByReplacingOccurrencesOfString:@"[!]" withString:@""];
				}
				[parsedWords setValue:currentWord forKey:[NSString stringWithFormat:@"word%d", j]];
				[parsedWords setValue:pos forKey:[NSString stringWithFormat:@"pos%d", j]];
			}
			//string_delete(diagram);
			linkage_delete(linkage);
		}
		sentence_delete(sent);
    }	
	
    dictionary_delete(dict);
    parse_options_delete(opts);
}*/

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
    
	[self dismissModalViewControllerAnimated:YES];
}

- (void)cacheNewWord:(NSString *)newWord forKey:(NSString *)oldWord {
	BOOL phrasesAllowed = ![[NSUserDefaults standardUserDefaults] boolForKey:@"NoPhrasesAllowed"];
	if (useAltThesaurus && phrasesAllowed)
		[bigMultCache setObject:newWord forKey:oldWord];
	else if (useAltThesaurus && !phrasesAllowed)
		[bigNoMultCache setObject:newWord forKey:oldWord];
	else if (!useAltThesaurus && !phrasesAllowed)
		[dictNoMultCache setObject:newWord forKey:oldWord];
	else
		[presetWords setObject:newWord forKey:oldWord];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:presetWords forKey:@"presetWords"];
	[defaults setObject:dictNoMultCache forKey:@"dictNoMultCache"];
	[defaults setObject:bigMultCache forKey:@"bigMultCache"];
	[defaults setObject:bigNoMultCache forKey:@"bigNoMultCache"];
	[defaults synchronize];
}

- (NSString *)cachedWordForKey:(NSString *)oldWord {
	BOOL phrasesAllowed = ![[NSUserDefaults standardUserDefaults] boolForKey:@"NoPhrasesAllowed"];
	if (useAltThesaurus && phrasesAllowed) {
		if ([bigMultCache objectForKey:oldWord])
			return [bigMultCache objectForKey:oldWord];
		else
			return nil;
	} else if (useAltThesaurus && !phrasesAllowed) {
		if ([bigNoMultCache objectForKey:oldWord])
			return [bigNoMultCache objectForKey:oldWord];
		else
			return nil;
	} else if (!useAltThesaurus && !phrasesAllowed) {
		if ([dictNoMultCache objectForKey:oldWord])
			return [dictNoMultCache objectForKey:oldWord];
		else
			return nil;
	} else {
		if ([presetWords objectForKey:oldWord])
			return [presetWords objectForKey:oldWord];
		else
			return nil;
	}
}

- (void)beginVerbosifying:(NSString *)string {

	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSMutableArray *words;
	//create array from words in textView separated by spaces
	words = ([string rangeOfString:@" "].location == NSNotFound)
	? [NSMutableArray arrayWithObject:string]
	: (NSMutableArray *)[string componentsSeparatedByString:@" "];
	numWords = [words count];
	
	//BOOL shouldParse = ![[NSUserDefaults standardUserDefaults] boolForKey:@"DontParseGrammar"];
	BOOL shouldParse = NO;
	if (shouldParse) {
		[self parseGrammar:textView.text];
		//pull the punctuation from the words and add them to the dictionary
		for (int i = 0; i < [words count]; i++) {
			[parsedWords setValue:[[words objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet letterCharacterSet]] 
						   forKey:[NSString stringWithFormat:@"punct%d", i]];
		}
		NSLog(@"parsedWords: %@", parsedWords);
		textView.text = [self verbosifiedDictionary:parsedWords];
		//if (textView.text.length > 1)
		//	textView.text = [textView.text substringToIndex:textView.text.length-1];
	} else {
		NSString *newText = [self verbosifiedArray:words];
		[textView performSelectorOnMainThread:@selector(setText:) withObject:newText waitUntilDone:NO];
	}
	
	[spinner stopAnimating];
	[spinner release];
	[pool release];
}

- (NSString *)verbosifiedArray:(NSMutableArray *)words {
	NSLog(@"VerbosifiedArray");
	useAltThesaurus = [[NSUserDefaults standardUserDefaults] boolForKey:@"UseAltThesaurus"];
	for (int i = 0; i < [words count]; i++) {
		NSString *oldWord = [[words objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
		
		NSLog(@"useAltThesaurus: %d, noPhrasesAllowed: %d", useAltThesaurus, [[NSUserDefaults standardUserDefaults] boolForKey:@"NoPhrasesAllowed"]);
		
		//if a preset exists, use it
		if ([self cachedWordForKey:oldWord]) {
			NSString *punctuation = [[words objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet letterCharacterSet]];
			[words replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%@%@", [self cachedWordForKey:oldWord], punctuation]];
		} 
		else {
			NSUInteger longestSynLen = 0;
			NSUInteger longestSynNum = 0;
			synonyms = [NSMutableString string];
			NSURL *synonymsUrl = [NSURL URLWithString:[NSString stringWithFormat:
													   @"http://words.bighugelabs.com/api/2/870b0600076360cfaa590e78fc3ff827/%@/", oldWord]];
			NSString *siteResponse = [NSString stringWithContentsOfURL:synonymsUrl encoding:NSUTF8StringEncoding error:NULL];
			useAltThesaurus = [[NSUserDefaults standardUserDefaults] boolForKey:@"UseAltThesaurus"];
			
			if (useAltThesaurus) {	//BIG HUGE LABS THESAURUS
				if (siteResponse == nil)
					synonyms = nil;
				else
					[synonyms setString:siteResponse];
			}
			else {	//DICTIONARY.COM
				NSURL *synonymsUrl = [NSURL URLWithString:[NSString stringWithFormat:
				@"http://api-pub.dictionary.com/v001?vid=bqpj1hk7kp2obuezc51g132sneswxof8f5rgmbo71q&q=%@&type=define&site=thesaurus", oldWord]];
				siteResponse = [NSString stringWithContentsOfURL:synonymsUrl encoding:NSUTF8StringEncoding error:NULL];
				if (siteResponse == nil)
					synonyms = nil;
				else {
					[synonyms setString:siteResponse];
					//begin fixing thesaurus.com's broken api
					[synonyms replaceOccurrencesOfString:@"&lt;" withString:@"<" options:0 range:NSMakeRange(0, [synonyms length])];
					[synonyms replaceOccurrencesOfString:@"&quot;" withString:@"\"" options:0 range:NSMakeRange(0, [synonyms length])];
					[synonyms replaceOccurrencesOfString:@"&gt;" withString:@">" options:0 range:NSMakeRange(0, [synonyms length])];
					[synonyms replaceOccurrencesOfString:@"&apos;" withString:@"'" options:0 range:NSMakeRange(0, [synonyms length])];
				
					NSLog(@"%@", synonyms);
					
					NSXMLParser *synParser = [[NSXMLParser alloc] initWithData:[synonyms dataUsingEncoding:NSUTF8StringEncoding]];
					synParser.delegate = self;
					parserPOS = [[NSString alloc] init];
					[synonyms setString:@""];
					[synParser parse];
					[parserPOS release];
				}
			}
			
			if (synonyms != nil) {
				NSArray *synList = [synonyms componentsSeparatedByString:@"\n"];
				for (int k = 0; k < [synList count]; k++) {
					if ([[synList objectAtIndex:k] rangeOfString:@"|"].location != NSNotFound) {				//if line is valid and
						NSArray *currentLine = [[synList objectAtIndex:k] componentsSeparatedByString:@"|"];
						if ([self conditionsMet:currentLine POS:nil LSL:longestSynLen]) {						//synonym is longest

							longestSynLen = [[[[synList objectAtIndex:k] componentsSeparatedByString:@"|"] objectAtIndex:2] length];
							longestSynNum = k;
						}
					}
				}
				NSString *newWord = [[[[synList objectAtIndex:longestSynNum] componentsSeparatedByString:@"|"] objectAtIndex:2] 
									 stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
				
				//temporarily cache words already requested to minimize server requests
				[self cacheNewWord:newWord forKey:oldWord];
				//and, finally, replace the old word with the new one(s)
				NSString *punctuation = [[words objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet letterCharacterSet]];
				[words replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%@%@", newWord, punctuation]];
			} 
		}
	}
	NSMutableString *ret = [NSMutableString stringWithString:@""];
	for (int j = 0; j < [words count]; j++) {
		if (j == [words count]-1)
			[ret appendString:[words objectAtIndex:j]];
		else
			[ret appendFormat:@"%@ ", [words objectAtIndex:j]];
	}
	return (NSString *)ret;
}

- (NSString *)verbosifiedDictionary:(NSMutableDictionary *)words {
	/*NSLog(@"VerbosifiedDictionary");
	for (int i = 0; i < [words count]/3; i ++) {
		NSString *oldWord = [words objectForKey:[NSString stringWithFormat:@"word%d", i]];
		NSString *punctuation = [words objectForKey:[NSString stringWithFormat:@"punct%d", i]];
		NSString *pos = [words objectForKey:[NSString stringWithFormat:@"pos%d", i]];
		//remove the .v, .n, .a, or .e suffix if it exists
		NSString *trimmedWord = ([oldWord characterAtIndex:oldWord.length-2] == '.')
		? [oldWord substringToIndex:oldWord.length-2]
		: oldWord;		
		
		//if a preset exists, use it
		if ([presetWords objectForKey:oldWord]) {
			[words setValue:[NSString stringWithFormat:@"%@%@", [presetWords objectForKey:oldWord], punctuation]
					 forKey:[NSString stringWithFormat:@"word%d", i]];
		} else if ([presetWords objectForKey:trimmedWord]) {
			[words setValue:[NSString stringWithFormat:@"%@%@", [presetWords objectForKey:trimmedWord], punctuation]
					 forKey:[NSString stringWithFormat:@"word%d", i]];
		}
		else {					
			NSUInteger longestSynLen = 0;
			NSUInteger longestSynNum = 0;
			NSURL *synonymsUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://words.bighugelabs.com/api/2/870b0600076360cfaa590e78fc3ff827/%@/", trimmedWord]];
			synonyms = [NSMutableString string];
			NSString *siteResponse = [NSString stringWithContentsOfURL:synonymsUrl encoding:NSUTF8StringEncoding error:NULL];
			useAltThesaurus = [[NSUserDefaults standardUserDefaults] boolForKey:@"UseAltThesaurus"];
			
			if (useAltThesaurus) {	//BIG HUGE LABS THESAURUS
				if (siteResponse == nil)
					synonyms = nil;
				else
					[synonyms setString:siteResponse];
			}
			else {	//DICTIONARY.COM
				NSURL *synonymsUrl = [NSURL URLWithString:[NSString stringWithFormat:
					@"http://api-pub.dictionary.com/v001?vid=bqpj1hk7kp2obuezc51g132sneswxof8f5rgmbo71q&q=%@&type=define&site=thesaurus", trimmedWord]];
				siteResponse = [NSString stringWithContentsOfURL:synonymsUrl encoding:NSUTF8StringEncoding error:NULL];
				if (siteResponse == nil)
					synonyms = nil;
				else {
					[synonyms setString:siteResponse ];
					//begin fixing thesaurus.com's broken api
					[synonyms replaceOccurrencesOfString:@"&lt;" withString:@"<" options:0 range:NSMakeRange(0, [synonyms length])];
					[synonyms replaceOccurrencesOfString:@"&quot;" withString:@"\"" options:0 range:NSMakeRange(0, [synonyms length])];
					[synonyms replaceOccurrencesOfString:@"&gt;" withString:@">" options:0 range:NSMakeRange(0, [synonyms length])];
					[synonyms replaceOccurrencesOfString:@"&apos;" withString:@"'" options:0 range:NSMakeRange(0, [synonyms length])];
				
					NSLog(@"%@", synonyms);
					
					NSXMLParser *synParser = [[NSXMLParser alloc] initWithData:[synonyms dataUsingEncoding:NSUTF8StringEncoding]];
					synParser.delegate = self;
					parserPOS = [[NSString alloc] init];
					[synonyms setString:@""];
					[synParser parse];
					[parserPOS release];
				}
			}
			
			
			if (synonyms != nil) {
				NSArray *synList = [synonyms componentsSeparatedByString:@"\n"];
				for (NSUInteger k = 0; k < [synList count]; k++) {
					if ([[synList objectAtIndex:k] rangeOfString:@"|"].location != NSNotFound) {				// if line is valid
						NSArray *currentLine = [[synList objectAtIndex:k] componentsSeparatedByString:@"|"];
						if ([self conditionsMet:currentLine POS:pos LSL:longestSynLen]) {															
								longestSynLen = [[currentLine objectAtIndex:2] length];
								longestSynNum = k;
						}
					}
					NSLog(@"%d", k);
					NSLog(@"%d", longestSynNum);
				}
				NSLog(@"%@", synList);
				NSString *newWord = [[[[synList objectAtIndex:longestSynNum] componentsSeparatedByString:@"|"] objectAtIndex:2] 
									 stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
				
				//temporarily cache words already requested to minimize server requests
				if (![presetWords objectForKey:oldWord]) {
					[presetWords setObject:newWord forKey:oldWord];
				}
				//and, finally, replace the old word with the new one(s)
				[words setValue:[NSString stringWithFormat:@"%@%@", [presetWords objectForKey:oldWord], punctuation]
						 forKey:[NSString stringWithFormat:@"word%d", i]];			
			} 
			else {
				//no synonyms found :(
				[words setValue:[NSString stringWithFormat:@"%@%@", trimmedWord, punctuation]
						 forKey:[NSString stringWithFormat:@"word%d", i]];	
			}
		}
	}
	NSMutableString *ret = [NSMutableString stringWithString:@""];
	for (int j = 0; j < [words count]/3; j++) {
		[ret appendFormat:@"%@ ", [words objectForKey:[NSString stringWithFormat:@"word%d", j]]];
	}
	return ret;
	*/
	return nil;
}

- (BOOL)conditionsMet:(NSArray *)currentLine POS:(NSString *)pos LSL:(NSUInteger)longestSynLen {

	BOOL phrasesAllowed = ![[NSUserDefaults standardUserDefaults] boolForKey:@"NoPhrasesAllowed"];
	if (pos == nil || [pos isEqualToString:@""]) {												//if pos isnt tagged, dont try to match it
		if ([[currentLine objectAtIndex:2] length] > longestSynLen &&							// synonym is longest
			[[currentLine objectAtIndex:1] isEqualToString:@"syn"] &&							// is syn (non antonym)
			([[currentLine objectAtIndex:2] rangeOfString:@" "].location == NSNotFound ||		// either no spaces found
			 phrasesAllowed)) {																	//or phrases are allowed
				
			return YES;
		} else {
			return NO;
		}
	} else {																					//otherwise, match pos
		if ([[currentLine objectAtIndex:2] length] > longestSynLen &&							// synonym is longest
			[[currentLine objectAtIndex:1] isEqualToString:@"syn"] &&							// is syn (non antonym)
			[[currentLine objectAtIndex:0] isEqualToString:pos] &&								// pos matches
			([[currentLine objectAtIndex:2] rangeOfString:@" "].location == NSNotFound ||		// either no spaces found
			 phrasesAllowed)) {																	//or phrases are allowed	
			
			return YES;
		}	
		else {
			return NO;
		}
	}
}

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

#pragma mark -
#pragma mark Button Presses

- (IBAction)showInfo:(id)sender {    
	
	VerbosifyAppDelegate *appDelegate = (VerbosifyAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
	controller.delegate = self;
	appDelegate.flipsideViewController = controller;
	//controller.fbSession = fbSession;
	
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
	
	[controller release];
}

- (IBAction)startOverPressed
{
	[UIView beginAnimations:@"slideButtonsBack" context:nil];
	[UIView setAnimationDuration:0.5];
	startOver.alpha = 0;
	startOver.center = CGPointMake(startOver.center.x + 110, startOver.center.y);
	postButton.center = CGPointMake(postButton.center.x - 110, postButton.center.y);
	[UIView commitAnimations];
	postButton.hidden = YES;
	commentButton.hidden = YES;
	
	[verbosify setTitle:@"Verbosify!" forState:UIControlStateNormal];
	textView.font = [UIFont systemFontOfSize:17.0];
	topLabel.text = @"Insert Boring Text Here:";
	verbosify.titleLabel.text = @"Verbosify!";
	textView.text = @"";
}

- (IBAction)verbosifyPressed
{
	if ([textView.text length] <= 0) {
		return;
	}
	Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
	NetworkStatus internetStatus = [r currentReachabilityStatus];
	
	if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))	//if internet is not connected
	{
		UIAlertView *sendingView = [[UIAlertView alloc] initWithTitle:@"No Internet Connection" message:@"You need an internet connection \
									via WiFi or cellular network to access the online thesaurus." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		
		[sendingView show];
		[sendingView release];
		return;
	}
	//display the spinner wheel while the text is loading (doesn't work quickly enough for some reason)
	spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	spinner.center = textView.center;
	[self.view addSubview:spinner];
	spinner.hidden = NO;
	[spinner startAnimating];
	
	
	//Random crazy font
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"UseFonts"]) {
		int r = arc4random() % 3;
		NSArray *fontArray = [NSArray arrayWithObjects:@"Freebooter Script", @"ChopinScript", @"Olde English", nil]; 
		textView.font = [UIFont fontWithName:[fontArray objectAtIndex:r] size:[UIFont systemFontSize]+8.0];
	}
	
	if ([verbosify.titleLabel.text isEqualToString:@"Verbosify!"]) {
		topLabel.text = @"Illustrious Prolix Chronicle!";
		[verbosify setTitle:@"Keep Going!" forState:UIControlStateNormal];
		
		[UIView beginAnimations:@"slideButtons" context:nil];
		[UIView setAnimationDuration:0.5];
		startOver.hidden = NO;
		startOver.alpha = 1;
		startOver.center = CGPointMake(startOver.center.x - 110, startOver.center.y);
		postButton.hidden = NO;
		postButton.center = CGPointMake(postButton.center.x + 110, postButton.center.y);
		[UIView commitAnimations];
		
	} else if ([verbosify.titleLabel.text isEqualToString:@"Keep Going!"]) {
		
		//topLabel.text = @"Probably Pure Nonsense By Now:";
	}
	
	//make text lowercase
	textView.text = [textView.text lowercaseString];
	
	[NSThread detachNewThreadSelector:@selector(beginVerbosifying:) toTarget:self withObject:textView.text];
}

- (IBAction)randomButtonPressed {
	if (wallPostButton.hidden) {
		wallPostButton.alpha = 0.0;
		wallPostButton.hidden = NO;
		songLyricsButton.alpha = 0.0;
		songLyricsButton.hidden = NO;
		
		[UIView beginAnimations:@"fadeIn" context:nil];
		[UIView setAnimationDuration:0.5];
		
		textView.alpha = 0.0;
		wallPostButton.alpha = 1.0;
		songLyricsButton.alpha = 1.0;
		
		[UIView commitAnimations];

		textView.hidden = YES;
	} else {
		textView.hidden = NO;

		[UIView beginAnimations:@"fadeOut" context:nil];
		[UIView setAnimationDuration:0.5];
		
		textView.alpha = 1.0;
		wallPostButton.alpha = 0.0;
		songLyricsButton.alpha = 0.0;
		
		[UIView commitAnimations];
		
		wallPostButton.hidden = YES;
		songLyricsButton.hidden = YES;
	}
	[randomButton setTitle:(([randomButton.titleLabel.text isEqualToString:@"Cancel"]) ? @"Insert..." : @"Cancel")
				  forState:UIControlStateNormal];
}

- (IBAction)wallPostButtonPressed {
	[self randomButtonPressed];
	
	VerbosifyAppDelegate *appDelegate = (VerbosifyAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if ([appDelegate.facebook isSessionValid]) {
		[appDelegate.facebook requestWithGraphPath:@"me/home" andDelegate:self];  
		
		spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		spinner.center = textView.center;
		[self.view addSubview:spinner];
		[spinner startAnimating];
	} else {
		NSArray* permissions =  [[NSArray arrayWithObjects:
								  @"publish_stream", @"read_stream", nil] retain];
		
		[appDelegate.facebook authorize:permissions delegate:appDelegate];
	}
}

- (IBAction)songButtonPressed {
	[self randomButtonPressed];
	
	LyricsViewController *lvc = [[LyricsViewController alloc] initWithNibName:@"LyricsViewController" bundle:nil];
	
	lvc.delegate = self;
	[self presentModalViewController:lvc animated:YES];
	[lvc release];
	
	spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	spinner.center = textView.center;
	[self.view addSubview:spinner];
	[spinner startAnimating];
}

#pragma mark -
#pragma mark Facebook support

- (IBAction)postAsComment {
	if ([textView.text length] <= 0) {
		return;
	}
	commentButton.hidden = YES;
	VerbosifyAppDelegate *appDelegate = (VerbosifyAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate.facebook requestWithGraphPath:[NSString stringWithFormat:@"%@/comments", facebookPostNum]
									andParams:[NSMutableDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@\n-Verbosify for iOS", textView.text]
																				 forKey:@"message"]
								andHttpMethod:@"POST"
								  andDelegate:self];		
}

- (IBAction)postToFacebook {
	isPosting = YES;
	VerbosifyAppDelegate *appDelegate = (VerbosifyAppDelegate *)[[UIApplication sharedApplication] delegate];
	if ([appDelegate.facebook isSessionValid]) {
		[appDelegate.facebook requestWithGraphPath:@"me/feed" 
										 andParams:[NSMutableDictionary dictionaryWithObject:textView.text forKey:@"message"]
									 andHttpMethod:@"POST"
									   andDelegate:self];
		
	} else {
		NSArray* permissions =  [[NSArray arrayWithObjects:
								  @"publish_stream", @"read_stream", nil] retain];
		
		[appDelegate.facebook authorize:permissions delegate:appDelegate];
	}
}

- (void)request:(FBRequest *)request didLoad:(id)result {
	if (result) {
		if ([request.httpMethod isEqualToString:@"POST"]) {
			UIAlertView *sentView = [[UIAlertView alloc] initWithTitle:@"Sent to Facebook!" message:nil delegate:nil
													 cancelButtonTitle:@"OK" otherButtonTitles:nil];
			
			[sentView show];
			[sentView release];
		} else {
			InsertViewController *ivc = [[InsertViewController alloc] initWithNibName:@"InsertViewController" bundle:nil];
			
			NSArray *data = [result objectForKey:@"data"];
			NSMutableArray *array = [[NSMutableArray alloc] init];
			NSMutableArray *numsArray = [[NSMutableArray alloc] init];
			NSUInteger count = 0;
			//gather 20 status messages, format them into titles for the picker view in the form "Author Name - Message"
			for (NSDictionary *post in data) {
				if ([[post objectForKey:@"type"] isEqualToString:@"status"] && count <= 20) {
					[array addObject:[NSString stringWithFormat:@"%@ - %@", 
									  [[post objectForKey:@"from"] objectForKey:@"name"], 
									  [post objectForKey:@"message"]]];
					[numsArray addObject:[post objectForKey:@"id"]];
					count++;
				}
			}
			ivc.titles = [(NSArray *)array copy];
			ivc.postNums = [(NSArray *)numsArray copy];
			ivc.delegate = self;
			[array release];
			[numsArray release];
			[self presentModalViewController:ivc animated:YES];
			[ivc release];
			
			commentButton.hidden = NO;
		}
	}
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
	UIAlertView *sentView = [[UIAlertView alloc] initWithTitle:@"Facebook Request Failed"
													   message:[NSString stringWithFormat:@"error: %@", [error localizedDescription]] 
													  delegate:nil
											 cancelButtonTitle:@"OK" otherButtonTitles:nil];
	
	[sentView show];
	[sentView release];
}

#pragma mark -
#pragma mark Keyboard Show / Hide

- (void)keyboardDidShow:(NSNotification *)notif {
	textView.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textView.frame.size.width, 110);
}

- (void)keyboardDidHide:(NSNotification *)notif {
	textView.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textView.frame.size.width, 157);
}

#pragma mark -
#pragma mark XML Parser

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName		  attributes:(NSDictionary *)attributeDict {
	
	if ([elementName isEqualToString:@"thesaurus"] && [[attributeDict objectForKey:@"totalresults"] isEqualToString:@"0"]) { //no results
		synonyms = nil;
		[parser abortParsing];
	} else if ([elementName isEqualToString:@"partofspeech"]) {
		inPOS = YES;
	} else if ([elementName isEqualToString:@"item"]) {
		inItem = YES;
	}  else if ([elementName isEqualToString:@"synonyms"]) {
		inSynonyms = YES;
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if ([elementName isEqualToString:@"partofspeech"]) {
		inPOS = NO;
	} else if ([elementName isEqualToString:@"item"]) {
		inItem = NO;
	} else if ([elementName isEqualToString:@"synonyms"]) {
		inSynonyms = NO;
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if (inPOS) {
		[parserPOS release];
		parserPOS = [string retain];
	}
	if (inItem && [string rangeOfString:@"*"].location == NSNotFound) {	//The second half makes sure the word is not slang
		[synonyms appendFormat:@"%@|syn|%@\n", parserPOS, string];
	} if (inSynonyms && !inItem && string.length > 3) {	//in one of the messed up results, still salvage the synonyms
		if ([string rangeOfString:@", "].location != NSNotFound) {
			NSArray *syns = [string componentsSeparatedByString:@", "];
			for (int i = 0; i < [syns count]; i++) {
				if ([[syns objectAtIndex:i] length] > 2) {
					[synonyms appendFormat:@"%@|syn|%@\n", parserPOS, [syns objectAtIndex:i]];
				}
			}
		} else {
			[synonyms appendFormat:@"%@|syn|%@\n", parserPOS, string];
		}
	}
}

#pragma mark -
#pragma mark Rotation (Landscape)

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

#pragma mark -
#pragma mark Memory Management

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[textView release];
	[verbosify release];
	[startOver release];	
	[postButton release];	
	[topLabel release];
	[spinner release];
	
	[presetWords release];
	[dictNoMultCache release];
	[bigMultCache release];
	[bigNoMultCache release];
	[parsedWords release];
	
	//[fbSession release];
	[tts release];
    [super dealloc];
}

@end
