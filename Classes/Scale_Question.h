//
//  Scale_Question.h
//  WRUPlayer
//
//  Created by Fergal McDonnell on 22/04/2014.
//  Copyright 2014 Tailteann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "Question.h"
#import "AlertPrompt.h"
#import "Swiper.h"
#import "PowerBar.h"


@interface Scale_Question : UIView <UITextViewDelegate> {

    UIImageView *content;
    Swiper *theSwiper;
    PowerBar *sleepPowerBar;
    PowerBar *energyPowerBar;
    PowerBar *moodPowerBar;
    
	UIButton *option1;
	UIButton *option2;
	UIButton *option3;
	UIButton *option4;
	UIButton *option5;
	UIButton *option6;
	UIButton *option7;
	UIButton *optionUntestable;
	
	UILabel *questionLabel;
	UILabel *questionSubheadingLabel;
	UILabel *questionHintLabel;
	UILabel *option1Label;
	UILabel *option2Label;
	UILabel *option3Label;
	UILabel *option4Label;
	UILabel *option5Label;
	UILabel *option6Label;
	UILabel *option7Label;
	UILabel *optionUntestableLabel;
	
	UILabel *option1Score;
	UILabel *option2Score;
	UILabel *option3Score;
	UILabel *option4Score;
	UILabel *option5Score;
	UILabel *option6Score;
	UILabel *option7Score;
	UILabel *optionUntestableScore;
    
    UIDatePicker *sleepTime;
    UIDatePicker *wakeupTime;
    UITextView *comment;
	
	UILabel *explainUntestableLabel;
	
	NSInteger scaleQuestionNumber;
	
	UILabel *slideInstruction;
	UISlider *clearSelectionSlider;
	UIImageView *clearSelectionTrack;
	
	UIImage *answer_off;
	UIImage *answer_clicked;
	UIImage *answer_confirmed;
	
	UILabel *total;	
	//NSInteger score;
	float score;
	NSInteger item;
	NSString *percision;
	NSString *selectedItemText;
	
	UIImageView *background;
	Question *question;
	
	NSTimer *clockTimer;
	UILabel *clockTimeSpentLabel;
	UIButton *clockStatusButton;
	NSInteger clockCounter;
	BOOL allowClockToBeReset;
}

@property (nonatomic, retain) IBOutlet UIImageView *content;
@property (nonatomic, retain) IBOutlet Swiper *theSwiper;
@property (nonatomic, retain) IBOutlet PowerBar *sleepPowerBar;
@property (nonatomic, retain) IBOutlet PowerBar *energyPowerBar;
@property (nonatomic, retain) IBOutlet PowerBar *moodPowerBar;

@property (nonatomic, retain) IBOutlet UIButton *option1;
@property (nonatomic, retain) IBOutlet UIButton *option2;
@property (nonatomic, retain) IBOutlet UIButton *option3;
@property (nonatomic, retain) IBOutlet UIButton *option4;
@property (nonatomic, retain) IBOutlet UIButton *option5;
@property (nonatomic, retain) IBOutlet UIButton *option6;	// OPS & RANKIN Only
@property (nonatomic, retain) IBOutlet UIButton *option7;	// RANKIN Only
@property (nonatomic, retain) IBOutlet UIButton *optionUntestable;	// NIHSS Only

@property (nonatomic, retain) IBOutlet UILabel *questionLabel;
@property (nonatomic, retain) IBOutlet UILabel *questionSubheadingLabel;
@property (nonatomic, retain) IBOutlet UILabel *questionHintLabel;
@property (nonatomic, retain) IBOutlet UILabel *option1Label;
@property (nonatomic, retain) IBOutlet UILabel *option2Label;
@property (nonatomic, retain) IBOutlet UILabel *option3Label;
@property (nonatomic, retain) IBOutlet UILabel *option4Label;
@property (nonatomic, retain) IBOutlet UILabel *option5Label;
@property (nonatomic, retain) IBOutlet UILabel *option6Label;	// OPS & RANKIN Only
@property (nonatomic, retain) IBOutlet UILabel *option7Label;	// RANKIN Only
@property (nonatomic, retain) IBOutlet UILabel *optionUntestableLabel;	// NIHSS Only

@property (nonatomic, retain) IBOutlet UILabel *option1Score;
@property (nonatomic, retain) IBOutlet UILabel *option2Score;
@property (nonatomic, retain) IBOutlet UILabel *option3Score;
@property (nonatomic, retain) IBOutlet UILabel *option4Score;
@property (nonatomic, retain) IBOutlet UILabel *option5Score;
@property (nonatomic, retain) IBOutlet UILabel *option6Score;	// OPS & RANKIN Only
@property (nonatomic, retain) IBOutlet UILabel *option7Score;	// RANKIN Only
@property (nonatomic, retain) IBOutlet UILabel *optionUntestableScore;	// NIHSS Only

@property (nonatomic, retain) IBOutlet UIDatePicker *sleepTime;
@property (nonatomic, retain) IBOutlet UIDatePicker *wakeupTime;
@property (nonatomic, retain) IBOutlet UITextView *comment;

@property (nonatomic, retain) IBOutlet UILabel *explainUntestableLabel;	// NIHSS Only

@property (nonatomic) NSInteger scaleQuestionNumber;

@property (nonatomic, retain) IBOutlet UILabel *slideInstruction;
@property (nonatomic, retain) IBOutlet UISlider *clearSelectionSlider;
@property (nonatomic, retain) IBOutlet UIImageView *clearSelectionTrack;

@property (nonatomic, retain) IBOutlet UIImage *answer_off;
@property (nonatomic, retain) IBOutlet UIImage *answer_clicked;
@property (nonatomic, retain) IBOutlet UIImage *answer_confirmed;

@property (nonatomic, retain) IBOutlet UILabel *total;
//@property (nonatomic) NSInteger score;
@property (nonatomic) float score;
@property (nonatomic) NSInteger item;
@property (nonatomic, retain) IBOutlet NSString *percision;
@property (nonatomic, retain) IBOutlet NSString *selectedItemText;

@property (nonatomic, retain) IBOutlet UIImageView *background;
@property (nonatomic, retain) IBOutlet Question *question;

@property (nonatomic, retain) IBOutlet NSTimer *clockTimer;
@property (nonatomic, retain) IBOutlet UILabel *clockTimeSpentLabel;
@property (nonatomic) NSInteger clockCounter;
@property (nonatomic, retain) IBOutlet UIButton *clockStatusButton;
@property (nonatomic) BOOL allowClockToBeReset;


- (void)goToQuestion:(NSInteger)question_num For:(NSString *)scale;
- (void)calculateQuestionTotal;
- (void)setSelectedItemTextFor:(int)selectedItem;
- (void)setScalePercisionForQuestion:(NSInteger)question OfScale:(NSString *)scale;
- (void)adjustAwkwardScaleForQuestion:(NSInteger)question_num OfScale:(NSString *)scale;
- (void)adjustAnswerForAwkwardScale;
- (void)setButtonsForOption:(NSInteger)choice;
- (void)updateFromSwiper;
- (void)confirmButtonsForOption:(NSInteger)choice;
- (void)clearAllButtons;
- (void)drawButtons:(NSString *)status ForLabel:(UILabel *)text_label;
- (void)showAlertForQuestion:(NSInteger)question  ForScale:(NSString *)scale;
- (void)showUntestableExplanationAlert;
- (void)showInterQuestionAlertWithHeading:(NSString *)alertHeading AndMessage:(NSString *)alertMessage;
- (void)updateDatePicker:(UIDatePicker *)theDatePicker;
- (void)setPowerBarScore:(float)theScore forIdentifier:(NSString *)theIdentifier;

- (void)initialiseClock;
- (void)positionClock;
- (IBAction)changeClockStatus;
- (void)moveClockOn;
- (IBAction)resetClockStatus:(BOOL)includingCounter;
- (void)resetClockCounterOnly;


@end
