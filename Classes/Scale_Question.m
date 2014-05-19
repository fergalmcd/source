//
//  Scale_Question.m
//  WRUPlayer
//
//  Created by Fergal McDonnell on 22/04/2014.
//  Copyright 2014 Tailteann. All rights reserved.
//

#import "Scale_Question.h"
#import "WRUPlayerAppDelegate.h"
#import "MainViewController.h"
#import "Scale_HQ.h"
#import "Player.h"

@implementation Scale_Question

@synthesize content, theSwiper, sleepPowerBar, energyPowerBar, moodPowerBar;
@synthesize option1, option2, option3, option4, option5, option6, option7, optionUntestable;
@synthesize questionLabel, questionSubheadingLabel, questionHintLabel;
@synthesize option1Label, option2Label, option3Label, option4Label, option5Label, option6Label, option7Label, optionUntestableLabel;
@synthesize option1Score, option2Score, option3Score, option4Score, option5Score, option6Score, option7Score, optionUntestableScore;
@synthesize sleepTime, wakeupTime, comment;
@synthesize explainUntestableLabel;
@synthesize scaleQuestionNumber;

@synthesize slideInstruction;
@synthesize clearSelectionSlider, clearSelectionTrack;

@synthesize total;
@synthesize item, score;
@synthesize percision;
@synthesize selectedItemText;

@synthesize answer_off, answer_clicked, answer_confirmed;
@synthesize background;
@synthesize question;

@synthesize clockTimer;
@synthesize clockTimeSpentLabel, clockStatusButton, clockCounter, allowClockToBeReset;
NSString *clockStatus = @"off";

UIColor *deselectedTextColour;
UIColor *selectedTextColour;
UIColor *confirmedTextColour;
NSString *scaleType;
NSString *scaleCapitalised;

UIAlertView *alert;
AlertPrompt *untestableExplanationPrompt;
NSString *untestableExplanationString;
NSString *questionFormat;
NSString *questionExtendedFormat;
NSString *adjustQuestionScoreText;

UILabel *clockTitleLabel;

WRUPlayerAppDelegate *appDelegate;
MainViewController *theMainViewController;
Scale_HQ *currentViewController;
Scale_Question *currentScaleQuestion;
Player *thisPlayer;

NSUserDefaults *prefs;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)goToQuestion:(NSInteger)question_num For:(NSString *)scale{
	
    appDelegate = (WRUPlayerAppDelegate *)[[UIApplication sharedApplication] delegate];
    theMainViewController = (MainViewController *)appDelegate.mainViewController;
    currentViewController = (Scale_HQ *)theMainViewController.targetViewController;
    thisPlayer = (Player *)currentViewController.player;
    prefs = [NSUserDefaults standardUserDefaults];
    
	scaleType = scale;
	scaleCapitalised = [scale uppercaseString];
	scaleQuestionNumber = question_num;
	question = [[Question alloc] init];
	[background setImage:[UIImage imageNamed:questionBackground]];
	
	slideInstruction.text = NSLocalizedString(@"SlideInstruction", @"");
	[clearSelectionSlider setThumbImage:[UIImage imageNamed:resetSliderThumb] forState:UIControlStateNormal];
	[clearSelectionSlider setThumbImage:[UIImage imageNamed:resetSliderThumb] forState:UIControlStateHighlighted];
	[clearSelectionSlider setMinimumTrackImage:[UIImage imageNamed:emptyImage] forState:UIControlStateNormal];
	[clearSelectionSlider setMinimumTrackImage:[UIImage imageNamed:emptyImage] forState:UIControlStateHighlighted];
	[clearSelectionSlider setMaximumTrackImage:[UIImage imageNamed:emptyImage] forState:UIControlStateNormal];
	[clearSelectionSlider setMaximumTrackImage:[UIImage imageNamed:emptyImage] forState:UIControlStateHighlighted];
	clearSelectionSlider.bounds = CGRectMake(0.0, 0.0, 300.0, 50.0);
	[clearSelectionTrack setImage:[UIImage imageNamed:resetSliderTrack]];
	
	answer_off =		[UIImage imageNamed:answerOffButton];
	answer_clicked =	[UIImage imageNamed:answerClickButton];
	answer_confirmed =	[UIImage imageNamed:answerConfirmButton];
	deselectedTextColour = [UIColor whiteColor];
	selectedTextColour = [UIColor blackColor];
	confirmedTextColour = [UIColor blackColor];
	
	[self setScalePercisionForQuestion:question_num OfScale:scale];
	
	total = [[UILabel alloc] init];
	total.text = [[NSString alloc] initWithFormat:percision, score];
	
	[question setupQuestion:question_num ForScale:scaleCapitalised];
	
	option1Label.text = question.item0.description;
	option2Label.text = question.item1.description;
	option3Label.text = question.item2.description;
	option4Label.text = question.item3.description;
	option5Label.text = question.item4.description;
	option6Label.text = question.item5.description;
	option7Label.text = question.item6.description;
	option1Score.text = [NSString stringWithFormat:percision, question.item0.score];
	option2Score.text = [NSString stringWithFormat:percision, question.item1.score];
	option3Score.text = [NSString stringWithFormat:percision, question.item2.score];
	option4Score.text = [NSString stringWithFormat:percision, question.item3.score];
	option5Score.text = [NSString stringWithFormat:percision, question.item4.score];
	option6Score.text = [NSString stringWithFormat:percision, question.item5.score];
	option7Score.text = [NSString stringWithFormat:percision, question.item6.score];
	questionHintLabel.text = [NSString stringWithFormat:@"%@", question.questionHint];
	
	optionUntestableLabel.text = question.itemUntestable.description;
	optionUntestableScore.text = NSLocalizedString(@"NIHSS_Untestable", @"");;
	untestableExplanationString = @"";
	explainUntestableLabel.text = @"";
	
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"NL"];
    [sleepTime setLocale:locale];
    [wakeupTime setLocale:locale];
    
	[self adjustAwkwardScaleForQuestion:question_num OfScale:scale];

	allowClockToBeReset = YES;
	[self initialiseClock];
	
	[self clearAllButtons];
	[self resetClockStatus:NO];

}

- (void)setupLayout{
    
    // Won't work in older iOS versions
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 5) {
        [content setImage:[[UIImage imageNamed:questionContainer] stretchableImageWithLeftCapWidth:5 topCapHeight:5]];
    }else{
        [content setImage:[[UIImage imageNamed:questionContainer] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)]];
    }
    
}

- (void)dealloc {
	
	[scaleType release];
	[scaleCapitalised release];
	[percision release];
	[questionLabel release];	
	[questionSubheadingLabel release];
	[questionHintLabel release];
	[option1 release];		[option2 release];		[option3 release];		[option4 release];		[option5 release];		[option6 release];		[option7 release];		[optionUntestable release];
    [option1Label release];	[option2Label release];	[option3Label release];	[option4Label release];	[option5Label release];	[option6Label release];	[option7Label release];	[optionUntestableLabel release];
	[option1Score release];	[option2Score release];	[option3Score release]; [option4Score release]; [option5Score release];	[option6Score release];	[option7Score release];	[optionUntestableScore release];
	[explainUntestableLabel release];
	[selectedItemText release];
	
	[slideInstruction release];
	[clearSelectionSlider release];
	[clearSelectionTrack release];
	[total release];
	[question release];		
	[background release];
	[alert release];
	[untestableExplanationPrompt release];
	[untestableExplanationString release];
	[questionFormat release];
	[questionExtendedFormat release];
	[adjustQuestionScoreText release];
	
	[answer_off release];			[answer_clicked release];		[answer_confirmed release];
	[deselectedTextColour release];	[selectedTextColour release];	[confirmedTextColour release];
	
	[clockTimeSpentLabel release];	[clockStatusButton release];	[clockTimer release];	[clockStatus release];
	
    [super dealloc];
}


- (void)showAlertForQuestion:(NSInteger)question_picked ForScale:(NSString *)scale
{  
	questionFormat = [[NSString alloc] initWithFormat:@"%@_Q%i", [scale uppercaseString], question_picked];
	questionExtendedFormat = [[NSString alloc] initWithFormat:@"%@_Subheading_Extended", questionFormat];
	
	alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(questionFormat, @"") message:NSLocalizedString(questionExtendedFormat, @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Button_OK", @"") otherButtonTitles:nil,nil];
	((UILabel*)[[alert subviews] objectAtIndex:1]).textAlignment = NSTextAlignmentLeft;
	
	[alert dismissWithClickedButtonIndex:0 animated:TRUE];
	[alert show];	
} 

- (void)showInterQuestionAlertWithHeading:(NSString *)alertHeading AndMessage:(NSString *)alertMessage
{  
	alert = [[UIAlertView alloc] initWithTitle:alertHeading message:alertMessage delegate:self cancelButtonTitle:NSLocalizedString(@"Button_OK", @"") otherButtonTitles:nil,nil];
	[alert dismissWithClickedButtonIndex:0 animated:TRUE];
	[alert show];	
} 


////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Clock Methods

- (void)initialiseClock {
	
	clockCounter = 0;
	[clockStatusButton setBackgroundImage:[UIImage imageNamed:stopwatchStart] forState:UIControlStateNormal];
	clockTimeSpentLabel.text = [[NSString alloc] initWithFormat:@"%i", clockCounter];
	
}

- (void)positionClock {
	clockTitleLabel = [clockStatusButton titleLabel];
	CGRect fr = [clockTitleLabel frame];
	fr.origin.x = 40; 
	fr.origin.y = 10;
	[[clockStatusButton titleLabel] setFrame:fr];
	[clockStatusButton titleLabel].textColor = [UIColor redColor];
}

- (IBAction)changeClockStatus {
	
	if([clockStatus isEqualToString:@"off"]){
		clockStatus = @"on";
		[clockStatusButton setBackgroundImage:[UIImage imageNamed:stopwatchStop] forState:UIControlStateNormal];
		clockTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(moveClockOn) userInfo:nil repeats:YES];
	}else{
		if([clockStatus isEqualToString:@"on"]){
			clockStatus = @"off";
			[clockStatusButton setBackgroundImage:[UIImage imageNamed:stopwatchStart] forState:UIControlStateNormal];
			[clockTimer invalidate];
		}
	}

}

- (void)moveClockOn {
	if(clockCounter < 999)
		clockCounter = clockCounter + 1;
	else
		clockCounter = 0;
	
	clockTimeSpentLabel.text = [[NSString alloc] initWithFormat:@"%i", clockCounter];
	
}

- (void)resetClockStatus:(BOOL)includingCounter {
	if(clockCounter > 0){
		if(includingCounter){
			clockCounter = 0;
			[self resetClockCounterOnly];
		}
		if([clockStatus isEqualToString:@"on"]){
			clockStatus = @"off";
			[clockStatusButton setBackgroundImage:[UIImage imageNamed:stopwatchStart] forState:UIControlStateNormal];
			[clockTimer invalidate];
		}
	}
}

- (void)resetClockCounterOnly {
	clockCounter = 0;
	clockTimeSpentLabel.text = [[NSString alloc] initWithFormat:@"%i", clockCounter];
	[clockStatusButton setBackgroundImage:[UIImage imageNamed:stopwatchStart] forState:UIControlStateNormal];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)calculateQuestionTotal{
	extern float currentScaleQuestionScore;
	currentScaleQuestionScore = score;
	if(item == -1){
		total.text = [[NSString alloc] initWithString:@"-"];
	}else{
		if(item == 0){
			total.text = [[NSString alloc] initWithString:NSLocalizedString(@"NIHSS_UntestableShortened", @"")];
		}else{
			total.text = [[NSString alloc] initWithFormat:percision, score];
		}
	}
	[self adjustAnswerForAwkwardScale];
}

- (void)setSelectedItemTextFor:(int)selectedItem{

	if(selectedItem == 0)	selectedItemText = question.itemUntestable.description;
	if(selectedItem == 1)	selectedItemText = question.item0.description;
	if(selectedItem == 2)	selectedItemText = question.item1.description;
	if(selectedItem == 3)	selectedItemText = question.item2.description;
	if(selectedItem == 4)	selectedItemText = question.item3.description;
	if(selectedItem == 5)	selectedItemText = question.item4.description;
	if(selectedItem == 6)	selectedItemText = question.item5.description;
	if(selectedItem == 7)	selectedItemText = question.item6.description;

	if( (selectedItem > 7) || (selectedItem < 0) )	selectedItemText = @"";
	
}

- (void)setScalePercisionForQuestion:(NSInteger)question_num OfScale:(NSString *)scale{
	percision = @"%.0f";
}

- (void)adjustAwkwardScaleForQuestion:(NSInteger)question_num OfScale:(NSString *)scale{

    if([scale isEqualToString:@"wruplayer"]){
        
        if( question_num == 1 ){
            [theSwiper setupSwiperOfType:@"weight" andStartValue:50 andEndValue:150 withDefaultScore:thisPlayer.previousWeight];
        }
        if( question_num == 4 ){
            answer_off =		[UIImage imageNamed:answerOffButton];
            answer_clicked =	[UIImage imageNamed:answerClickButton];
            answer_confirmed =	[UIImage imageNamed:answerConfirmButton];
        }
        if( question_num == 5 ){
            [sleepPowerBar setupPowerBarStartingAt:-1 andEndingAt:52 forIdentifier:@"sleep"];
            [energyPowerBar setupPowerBarStartingAt:0 andEndingAt:50 forIdentifier:@"energy"];
            [moodPowerBar setupPowerBarStartingAt:0 andEndingAt:50 forIdentifier:@"mood"];
        }
    
    }
    
}

- (void)adjustAnswerForAwkwardScale{}

//////////////////////////////////////////////////////////////////////////////////////
// For Untestable Explanations
- (void)showUntestableExplanationAlert{
	untestableExplanationPrompt = [AlertPrompt alloc];
	untestableExplanationPrompt = [untestableExplanationPrompt initWithTitle:NSLocalizedString(@"NIHSS_UntestableExplain", @"") message:@"Please type" delegate:self cancelButtonTitle:NSLocalizedString(@"Button_Cancel", @"") okButtonTitle:NSLocalizedString(@"Button_OK", @"")];
	[untestableExplanationPrompt show];
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if( (buttonIndex != [alertView cancelButtonIndex]) && (alertView == untestableExplanationPrompt) ){
		untestableExplanationString = [(AlertPrompt *)alertView enteredText];
		explainUntestableLabel.text = untestableExplanationString;
	}
	[untestableExplanationPrompt.textField resignFirstResponder];
}
//////////////////////////////////////////////////////////////////////////////////////

- (void)updateFromSwiper{
    
    if( [scaleType isEqualToString:@"wruplayer"] ){
        
        if( scaleQuestionNumber == 1 ){
            
        }
        
    }
    
    total.text = [NSString stringWithFormat:@"%.0f", score];
}

//////////////////////////////////////////////////////////////////////////////////////

- (void)setPowerBarScore:(float)theScore forIdentifier:(NSString *)theIdentifier {
    
    if( (sleepPowerBar.score < 0) || (energyPowerBar.score < 0) || (moodPowerBar.score < 0) ){
        item = -1;
    }else{
        item = 5;
    }
    
    if( [theIdentifier isEqualToString:@"sleep"] ){
        option1Score.text = [NSString stringWithFormat:@"%.1f", theScore];
    }
    if( [theIdentifier isEqualToString:@"energy"] ){
        option2Score.text = [NSString stringWithFormat:@"%.1f", theScore];
    }
    if( [theIdentifier isEqualToString:@"mood"] ){
        option3Score.text = [NSString stringWithFormat:@"%.1f", theScore];
    }
    
    [self calculateQuestionTotal];
    
}

//////////////////////////////////////////////////////////////////////////////////////

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

//////////////////////////////////////////////////////////////////////////////////////

- (void)setButtonsForOption:(NSInteger)choice{

	[self clearAllButtons];
	item = choice;

	switch (choice)
	{
		case 0: // Untestable
		{
			[self drawButtons:@"clicked" ForLabel:optionUntestableLabel];
			optionUntestableLabel.textColor = selectedTextColour;
			optionUntestableScore.textColor = selectedTextColour;
			[self showUntestableExplanationAlert];
			break;
		}
		case 1:
		{
			[self drawButtons:@"clicked" ForLabel:option1Label];
			option1Label.textColor = selectedTextColour;
			option1Score.textColor = selectedTextColour;
			break;
		}
		case 2:
		{
			[self drawButtons:@"clicked" ForLabel:option2Label];
			option2Label.textColor = selectedTextColour;
			option2Score.textColor = selectedTextColour;
			break;
		}
		case 3:
		{
			[self drawButtons:@"clicked" ForLabel:option3Label];
			option3Label.textColor = selectedTextColour;
			option3Score.textColor = selectedTextColour;
			break;
		}		
		case 4:
		{
			[self drawButtons:@"clicked" ForLabel:option4Label];
			option4Label.textColor = selectedTextColour;
			option4Score.textColor = selectedTextColour;
			break;
		}		
		case 5:
		{
			[self drawButtons:@"clicked" ForLabel:option5Label];
			option5Label.textColor = selectedTextColour;
			option5Score.textColor = selectedTextColour;
			break;
		}
		case 6:
		{
			[self drawButtons:@"clicked" ForLabel:option6Label];
			option6Label.textColor = selectedTextColour;
			option6Score.textColor = selectedTextColour;
			break;
		}case 7:
		{
			[self drawButtons:@"clicked" ForLabel:option7Label];
			option7Label.textColor = selectedTextColour;
			option7Score.textColor = selectedTextColour;
			break;
		}
			
		default:
		{
			[self clearAllButtons];
			break;
		}
	}

}

- (void)confirmButtonsForOption:(NSInteger)choice{
	
	switch (choice)
	{
		case 0:
		{
			[self drawButtons:@"confirmed" ForLabel:optionUntestableLabel];
			optionUntestableLabel.textColor = confirmedTextColour;
			optionUntestableLabel.textColor = confirmedTextColour;
			break;
		}
		case 1:
		{
            [self drawButtons:@"confirmed" ForLabel:option1Label];
			option1Label.textColor = confirmedTextColour;
			option1Score.textColor = confirmedTextColour;
			break;
		}
		case 2:
		{
			[self drawButtons:@"confirmed" ForLabel:option2Label];
			option2Label.textColor = confirmedTextColour;
			option2Score.textColor = confirmedTextColour;
			break;
		}
		case 3:
		{
			[self drawButtons:@"confirmed" ForLabel:option3Label];
			option3Label.textColor = confirmedTextColour;
			option3Score.textColor = confirmedTextColour;
			break;
		}		
		case 4:
		{
			[self drawButtons:@"confirmed" ForLabel:option4Label];
			option4Label.textColor = confirmedTextColour;
			option4Score.textColor = confirmedTextColour;
			break;
		}		
		case 5:
		{
			[self drawButtons:@"confirmed" ForLabel:option5Label];
			option5Label.textColor = confirmedTextColour;
			option5Score.textColor = confirmedTextColour;
			break;
		}
		case 6:
		{
			[self drawButtons:@"confirmed" ForLabel:option6Label];
			option6Label.textColor = confirmedTextColour;
			option6Score.textColor = confirmedTextColour;
			break;
		}
		case 7:
		{
			[self drawButtons:@"confirmed" ForLabel:option7Label];
			option7Label.textColor = confirmedTextColour;
			option7Score.textColor = confirmedTextColour;
			break;
		}
			
		default:
		{
			[self clearAllButtons];
			[self resetClockStatus:NO];
			break;
		}
	}
	
}

- (void)clearAllButtons{
	clearSelectionSlider.value = 0.0;
	score = 0.0;
	item = -1;
	selectedItemText = @"";
	explainUntestableLabel.text = @"";
	[self calculateQuestionTotal];
			
	[self drawButtons:@"off" ForLabel:option1Label];
	[self drawButtons:@"off" ForLabel:option2Label];
	[self drawButtons:@"off" ForLabel:option3Label];
	[self drawButtons:@"off" ForLabel:option4Label];
	[self drawButtons:@"off" ForLabel:option5Label];
	[self drawButtons:@"off" ForLabel:option6Label];
	[self drawButtons:@"off" ForLabel:option7Label];
	[self drawButtons:@"off" ForLabel:optionUntestableLabel];
	
	option1Label.textColor = deselectedTextColour;			option1Score.textColor = deselectedTextColour;
	option2Label.textColor = deselectedTextColour;			option2Score.textColor = deselectedTextColour;
	option3Label.textColor = deselectedTextColour;			option3Score.textColor = deselectedTextColour;
	option4Label.textColor = deselectedTextColour;			option4Score.textColor = deselectedTextColour;
	option5Label.textColor = deselectedTextColour;			option5Score.textColor = deselectedTextColour;
	option6Label.textColor = deselectedTextColour;			option6Score.textColor = deselectedTextColour;
	option7Label.textColor = deselectedTextColour;			option7Score.textColor = deselectedTextColour;
	optionUntestableLabel.textColor = deselectedTextColour;	optionUntestableScore.textColor = deselectedTextColour;
    
    // Q1 Reset
    if( scaleQuestionNumber == 1 ){
        float resetWeight = [[prefs stringForKey:@"Weight"] floatValue];
        [theSwiper jumpToScore:resetWeight];
        option1Score.text = @"-";
    }
    
}

- (void)drawButtons:(NSString *)status ForLabel:(UILabel *)text_label{
	
	NSString *imageToShow;
	NSString *nextImageToShow;
	
	////////////////////////////////////////////////////////////////////////
	// OFF
	
	if([status isEqualToString:@"off"]){
		if(text_label.frame.size.height <= labelHeightMAXLine2){
			imageToShow = answerOffButton;
			nextImageToShow = answerClickButton;
		}else{
			if(text_label.frame.size.height <= labelHeightMAXLine3){
				imageToShow = answerOffButton3;
				nextImageToShow = answerClickButton3;
			}else{
				if(text_label.frame.size.height <= labelHeightMAXLine4){
					imageToShow = answerOffButton4;
					nextImageToShow = answerClickButton4;
				}
				else{
					imageToShow = answerOffButton5;
					nextImageToShow = answerClickButton5;
				}
			}			
		}
		
		// Adjust for YES\NO
		if( [text_label.text isEqualToString:NSLocalizedString(@"WRUPLAYER_Item0", @"")] ){
			imageToShow = answerOffNo;
			nextImageToShow = answerOffNo;
		}
		if( [text_label.text isEqualToString:NSLocalizedString(@"WRUPLAYER_Item1", @"")] ){
			imageToShow = answerOffYes;
			nextImageToShow = answerOffYes;
		}
        
        /* Adjust for MALE/FEMALE
		if( [text_label.text isEqualToString:NSLocalizedString(@"WRUPLAYER_Q7_Item0", @"")] ){
			imageToShow = answerOffMale;
			nextImageToShow = answerOffMale;
		}
		if( [text_label.text isEqualToString:NSLocalizedString(@"WRUPLAYER_Q7_Item1", @"")] ){
			imageToShow = answerOffFemale;
			nextImageToShow = answerOffFemale;
		}*/
		
	}
	
	////////////////////////////////////////////////////////////////////////
	
	////////////////////////////////////////////////////////////////////////
	// CLICKED
	
	if([status isEqualToString:@"clicked"]){
		if(text_label.frame.size.height <= labelHeightMAXLine2){
			imageToShow = answerClickButton;
			nextImageToShow = answerConfirmButton;
		}else{
			if(text_label.frame.size.height <= labelHeightMAXLine3){
				imageToShow = answerClickButton3;
				nextImageToShow = answerConfirmButton3;
			}else{
				if(text_label.frame.size.height <= labelHeightMAXLine4){
					imageToShow = answerClickButton4;
					nextImageToShow = answerConfirmButton4;
				}
				else{
					imageToShow = answerClickButton5;
					nextImageToShow = answerConfirmButton5;
				}
			}			
		}
		
		// Adjust for YES\NO
		if( [text_label.text isEqualToString:NSLocalizedString(@"WRUPLAYER_Item0", @"")] ){
			imageToShow = answerClickNo;
			nextImageToShow = answerClickNo;
		}
		if( [text_label.text isEqualToString:NSLocalizedString(@"WRUPLAYER_Item1", @"")] ){
			imageToShow = answerClickYes;
			nextImageToShow = answerClickYes;
		}
        
        /* Adjust for MALE/FEMALE
		if( [text_label.text isEqualToString:NSLocalizedString(@"WRUPLAYER_Q7_Item0", @"")] ){
			imageToShow = answerClickMale;
			nextImageToShow = answerClickMale;
		}
		if( [text_label.text isEqualToString:NSLocalizedString(@"WRUPLAYER_Q7_Item1", @"")] ){
			imageToShow = answerClickFemale;
			nextImageToShow = answerClickFemale;
		}*/
		
	}
	
	////////////////////////////////////////////////////////////////////////
	
	////////////////////////////////////////////////////////////////////////
	// CONFIRMED
	
	if([status isEqualToString:@"confirmed"]){
		if(text_label.frame.size.height <= labelHeightMAXLine2){
			imageToShow = answerConfirmButton;
			nextImageToShow = answerConfirmButton;
		}else{
			if(text_label.frame.size.height <= labelHeightMAXLine3){
				imageToShow = answerConfirmButton3;
				nextImageToShow = answerConfirmButton3;
			}else{
				if(text_label.frame.size.height <= labelHeightMAXLine4){
					imageToShow = answerConfirmButton4;
					nextImageToShow = answerOffButton4;
				}
				else{
					imageToShow = answerConfirmButton5;
					nextImageToShow = answerConfirmButton5;
				}
			}			
		}
		
		// Adjust for YES\NO
        if( [text_label.text isEqualToString:NSLocalizedString(@"WRUPLAYER_Item0", @"")] ){
			imageToShow = answerConfirmNo;
			nextImageToShow = answerConfirmNo;
		}
		if( [text_label.text isEqualToString:NSLocalizedString(@"WRUPLAYER_Item1", @"")] ){
			imageToShow = answerConfirmYes;
			nextImageToShow = answerConfirmYes;
		}
        
        /* Adjust for MALE/FEMALE
		if( [text_label.text isEqualToString:NSLocalizedString(@"WRUPLAYER_Q7_Item0", @"")] ){
			imageToShow = answerConfirmMale;
			nextImageToShow = answerConfirmMale;
		}
		if( [text_label.text isEqualToString:NSLocalizedString(@"WRUPLAYER_Q7_Item1", @"")] ){
			imageToShow = answerConfirmFemale;
			nextImageToShow = answerConfirmFemale;
		}*/
		
	}
	
	////////////////////////////////////////////////////////////////////////
	
	if(text_label == optionUntestableLabel){	[optionUntestable setBackgroundImage:[UIImage imageNamed:imageToShow] forState:UIControlStateNormal];	[optionUntestable setBackgroundImage:[UIImage imageNamed:nextImageToShow] forState:UIControlStateHighlighted];	}
	
	if(text_label == option1Label){	[option1 setBackgroundImage:[UIImage imageNamed:imageToShow] forState:UIControlStateNormal];	[option1 setBackgroundImage:[UIImage imageNamed:nextImageToShow] forState:UIControlStateHighlighted];	}
	if(text_label == option2Label){	[option2 setBackgroundImage:[UIImage imageNamed:imageToShow] forState:UIControlStateNormal];	[option2 setBackgroundImage:[UIImage imageNamed:nextImageToShow] forState:UIControlStateHighlighted];	}
	if(text_label == option3Label){	[option3 setBackgroundImage:[UIImage imageNamed:imageToShow] forState:UIControlStateNormal];	[option3 setBackgroundImage:[UIImage imageNamed:nextImageToShow] forState:UIControlStateHighlighted];	}
	if(text_label == option4Label){	[option4 setBackgroundImage:[UIImage imageNamed:imageToShow] forState:UIControlStateNormal];	[option4 setBackgroundImage:[UIImage imageNamed:nextImageToShow] forState:UIControlStateHighlighted];	}
	if(text_label == option5Label){	[option5 setBackgroundImage:[UIImage imageNamed:imageToShow] forState:UIControlStateNormal];	[option5 setBackgroundImage:[UIImage imageNamed:nextImageToShow] forState:UIControlStateHighlighted];	}
	if(text_label == option6Label){	[option6 setBackgroundImage:[UIImage imageNamed:imageToShow] forState:UIControlStateNormal];	[option6 setBackgroundImage:[UIImage imageNamed:nextImageToShow] forState:UIControlStateHighlighted];	}
	if(text_label == option7Label){	[option7 setBackgroundImage:[UIImage imageNamed:imageToShow] forState:UIControlStateNormal];	[option7 setBackgroundImage:[UIImage imageNamed:nextImageToShow] forState:UIControlStateHighlighted];	}
	
	if(allowClockToBeReset)
		[self resetClockStatus:NO];
		
}


@end
