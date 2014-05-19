//
//  Scale_HQ.h
//  WRUPlayer
//
//  Created by Fergal McDonnell on 22/04/2014.
//  Copyright 2014 Tailteann. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DoctotHelper.h"
#import "MailComposerViewController.h"
#import "ProgressViewColoured.h"
#import "Question.h"
#import "QuestionItem.h"
#import "Player.h"

#import "Scale_Start.h"
#import "Scale_Question.h"
#import "Scale_QuestionExtended.h"
#import "Scale_Final.h"
#import "ScaleScore.h"
#import "Survey.h"
#import "SurveyController.h"


@class Information;

@interface Scale_HQ : UIViewController <UIScrollViewDelegate, UIActionSheetDelegate> {
	
	IBOutlet UIScrollView *scrollView;
	IBOutlet ProgressViewColoured *progressControl;
    IBOutlet UIImageView *progressIndicator;
	NSMutableArray *viewControllers;
	
	IBOutlet Scale_Start *startView;
	IBOutlet Scale_Question *q1View;
	IBOutlet Scale_Question *q2View;
	IBOutlet Scale_Question *q3View;
	IBOutlet Scale_Question *q4View;
	IBOutlet Scale_Question *q5View;
	IBOutlet Scale_Question *q6View;
	IBOutlet Scale_Question *q7View;
	IBOutlet Scale_Question *q8View;
	IBOutlet Scale_Question *q9View;
	IBOutlet Scale_Question *q10View;
	IBOutlet Scale_Question *q11View;
	IBOutlet Scale_Question *q12View;
	IBOutlet Scale_Question *q13View;
	IBOutlet Scale_Question *q14View;
	IBOutlet Scale_Question *q15View;
	IBOutlet Scale_Final *finalView;
    
    IBOutlet Scale_Question *currentQuestionView;
	
	UILabel *scale_total;
	UILabel *current_total;
	UILabel *current_subtotal;
	UILabel *scale_status;
	UILabel *current_question;
	UILabel *current_questionSubheading;
	UILabel *numberOfRecords;
	UIButton *moreInfo_button;
	UIButton *previous_button;
	UIButton *continue_button;
	
	BOOL pageControlUsed;
	
    Player *player;
	Scale_QuestionExtended *questionExtendedViewController;
	Information	*infoViewController;
	MailComposerViewController *mailComposerViewController;
	ScaleScore *savedScore;
    SurveyController *surveyController;
    
    Survey *survey;
	
	NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
}

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) ProgressViewColoured *progressControl;
@property (nonatomic, retain) UIImageView *progressIndicator;
@property (nonatomic, retain) NSMutableArray *viewControllers;

@property (nonatomic, retain) Scale_Start *startView;
@property (nonatomic, retain) Scale_Question *q1View;
@property (nonatomic, retain) Scale_Question *q2View;
@property (nonatomic, retain) Scale_Question *q3View;
@property (nonatomic, retain) Scale_Question *q4View;
@property (nonatomic, retain) Scale_Question *q5View;
@property (nonatomic, retain) Scale_Question *q6View;
@property (nonatomic, retain) Scale_Question *q7View;
@property (nonatomic, retain) Scale_Question *q8View;
@property (nonatomic, retain) Scale_Question *q9View;
@property (nonatomic, retain) Scale_Question *q10View;
@property (nonatomic, retain) Scale_Question *q11View;
@property (nonatomic, retain) Scale_Question *q12View;
@property (nonatomic, retain) Scale_Question *q13View;
@property (nonatomic, retain) Scale_Question *q14View;
@property (nonatomic, retain) Scale_Question *q15View;
@property (nonatomic, retain) Scale_Final *finalView;

@property (nonatomic, retain) Scale_Question *currentQuestionView;

@property (nonatomic, retain) IBOutlet UILabel *scale_total;
@property (nonatomic, retain) IBOutlet UILabel *current_total;
@property (nonatomic, retain) IBOutlet UILabel *current_subtotal;
@property (nonatomic, retain) IBOutlet UILabel *scale_status;
@property (nonatomic, retain) IBOutlet UILabel *current_question;
@property (nonatomic, retain) IBOutlet UILabel *current_questionSubheading;
@property (nonatomic, retain) IBOutlet UILabel *numberOfRecords;

@property (nonatomic, retain) Player *player;
@property (nonatomic, retain) IBOutlet MailComposerViewController *mailComposerViewController;
@property (nonatomic, retain) IBOutlet ScaleScore *savedScore;
@property (nonatomic, retain) SurveyController *surveyController;

@property (nonatomic, retain) Survey *survey;

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, retain) IBOutlet UIButton *moreInfo_button;
@property (nonatomic, retain) IBOutlet UIButton *previous_button;
@property (nonatomic, retain) IBOutlet UIButton *continue_button;

- (IBAction)startTest:(id)sender;
- (IBAction)returnToStart;
- (IBAction)goToInfoScreen;
- (IBAction)goToSavedScores;
- (IBAction)goToSurveys:(id)sender;
- (void)updateSavedScoreAmount;
- (void)saveScoreToDatabase;
- (void)checkIfTableIsFull;
- (IBAction)saveScore;
- (void)confirmPopViewController;
- (void)readjustForAwkwardScales;
- (void)displayAlertWithMessage:(NSString *)message;
- (void)displayOptionAlertWithMessage:(NSString *)message;
- (void)displayMoreInfoButton;
- (IBAction)showAlertForCurrentQuestion;
- (IBAction)navigateBetweenQuestions;
- (IBAction)reverseNavigateQuestions;
- (IBAction)moveToNextQuestion;
- (IBAction)moveToPreviousQuestion;

- (IBAction)sliderSpringsBack;
- (IBAction)sliderUpdatesScore;
- (IBAction)updateDatePicker:(UIDatePicker *)theDatePicker;
- (IBAction)clearAllSelectedOptions;
- (IBAction)clearAllSelectedOptionsBasic;
- (IBAction)clearCurrentQuestionSelectedOption;
- (IBAction)executeSelectedQuestion:(id)sender;
- (IBAction)executeSelectedQuestionViaNotification:(id)sender;
- (void)submitSurveyOperations:(BOOL)dailyOperationsRequired;
- (void)configureSurveyOutput;
- (BOOL)submitSurveyToServer;


// NIHSS specific
- (void)goToQuestionExtended:(NSString *)imageString;

- (void)goToQuestionExtended:(NSString *)imageString;

- (NSString *)applicationDocumentsDirectory;

@end
