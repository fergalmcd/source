//
//  Scale_HQ.m
//  WRUPlayer
//
//  Created by Fergal McDonnell on 22/04/2014.
//  Copyright 2014 Tailteann. All rights reserved.
//

#import "Scale_HQ.h"
#import "WRUPlayerAppDelegate.h"
#import "Constants.h"
#import "Information.h"
#import "IndividualScore.h"
#import "Injury.h"
#import "SurveysParser.h"


int kNumberOfPages = 0;
float currentScaleScore = 0.0;
float currentSubscaleScore = 0.0;
float currentScaleQuestionScore = 0.0;
NSString *scaleId;
NSString *infoScale;
NSUserDefaults *prefs;
NSString *alertMessage;


@interface Scale_HQ (PrivateMethods)

- (void)loadScrollViewWithPage:(int)centralPage;
- (void)moveToNextQuestion:(NSInteger)nextPage;
- (void)scrollViewDidScroll:(UIScrollView *)sender;
- (void)flipTransition;

- (void)executeQuestion:(NSInteger)question_num;
- (void)executeQuestionForView:(Scale_Question *)questionView ForItem:(NSInteger)item WithScore:(float)score;
- (NSString *)currentQuestionTotalAsString;
- (void)setDiagnosis;

- (void)calculateScaleTotal;
- (int)adjustScaleTotalIgnoringNulls;
- (void)adjustScaleTotals;

@end


@implementation Scale_HQ


@synthesize viewControllers;
@synthesize scrollView, progressControl, progressIndicator;

@synthesize scale_total, current_total, current_subtotal, scale_status, current_question, current_questionSubheading, numberOfRecords;
@synthesize moreInfo_button, previous_button, continue_button;

@synthesize startView;
@synthesize q1View, q2View, q3View, q4View, q5View, q6View, q7View, q8View, q9View, q10View, q11View, q12View, q13View, q14View, q15View;
@synthesize finalView;

@synthesize currentQuestionView;

@synthesize player;
@synthesize mailComposerViewController;
@synthesize savedScore, surveyController;
@synthesize survey;

UIView *controller;
UIAlertView *alert;
IndividualScore *scoreToSave;

DoctotHelper *helper;
UIBarButtonItem *modalViewButtonItem;
UIButton *modalViewButton;
UIBarButtonItem *infoPageButtonItem;
UIButton *infoPageButton;
BOOL scaleJustAccessed;

UIActionSheet *dismissScaleAlert;
UIActionSheet *scaleRecordsFullAlert;
UIActionSheet *resetScaleAlert;
UIActionSheet *saveConfirmation;

NSString *final_score_intro;
NSString *final_diagnosis_level5;
NSString *final_diagnosis_level4;
NSString *final_diagnosis_level3;
NSString *final_diagnosis_level2;
NSString *final_diagnosis_level1;
NSString *final_diagnosis_extended_level5;
NSString *final_diagnosis_extended_level4;
NSString *final_diagnosis_extended_level3;
NSString *final_diagnosis_extended_level2;
NSString *final_diagnosis_extended_level1;
float scaleUpperBoundsLevel_1 = -1.0;
float scaleUpperBoundsLevel_2 = -1.0;
float scaleUpperBoundsLevel_3 = -1.0;
float scaleUpperBoundsLevel_4 = -1.0;
UIColor *level5Colour;
UIColor *level4Colour;
UIColor *level3Colour;
UIColor *level2Colour;
UIColor *level1Colour;
NSString *colourSelected;
NSString *currentTotalAsString;
NSInteger diagnosisLevel;
BOOL reverseColourDirection = NO;
NSString *scalePercision;

int currentPage;
NSString *error_string;
NSString *curlDirection;
NSInteger primaryKey;
char *sql;
char *save_firstName,  *save_lastName,  *save_date,  *save_score;
int save_dateAsInteger;
Boolean readyForSave;
BOOL shakeEnabled = YES;
BOOL adjustNumberOfRecords = NO;
NSString *email_body_format;
NSString *email_body;
NSString *objectSentFromNotification;
NSString * const NOTIF_TotalScores = @"TotalScores";
NSString * const NOTIF_ExecuteSelectedQuestion = @"ExecuteSelectedQuestion";

BOOL lowSleepScore = NO;
BOOL lowEnergyScore = NO;
BOOL lowMoodScore = NO;
NSString *htmlOutput;
NSString *jsonOutput;
SurveyController *surveyController;


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		prefs = [NSUserDefaults standardUserDefaults];
        scaleId = [[NSString alloc] initWithFormat:@"%@", [prefs stringForKey:@"CurrentScale"]];
		
		if([scaleId isEqual:@"wruplayer"] == YES){
			self.title = NSLocalizedString(@"PageOneTitle", @"");
			kNumberOfPages = 14;
			reverseColourDirection = NO;
			scaleUpperBoundsLevel_1 = wruPlayerUpperBoundsOfLevel1;
			scaleUpperBoundsLevel_2 = wruPlayerUpperBoundsOfLevel2;
			scaleUpperBoundsLevel_3 = -1;
			scaleUpperBoundsLevel_4 = -1;
		}
		
    }
	
    return self;
}


- (void)updateSavedScoreAmount {
    int numberOfRecords_int = [savedScore returnNumberOfScoresForScale];
	prefs = [NSUserDefaults standardUserDefaults];
	NSInteger maximumScoresAllowed = [prefs integerForKey:@"maxSavesAllowed"];
	
    if(numberOfRecords_int > maximumScoresAllowed){
		numberOfRecords.textColor = [UIColor redColor];
		//numberOfRecords_int = maximumScoresAllowed;
		if(adjustNumberOfRecords){	// This adjustment compensates for when an entry is deleted to make room for the next one
			numberOfRecords_int = [savedScore returnNumberOfScoresForScale] - 1;
			adjustNumberOfRecords = NO;
		}
	}else{
		numberOfRecords.textColor = [UIColor whiteColor];
	}
	
	numberOfRecords.text = [[NSString alloc] initWithFormat:@"(%i)", numberOfRecords_int];
	
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set Up the Top Left of the Nav Bar
    UIButton* leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 43, 49)];
	[leftButton addTarget:self action:@selector(confirmPopViewController) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setImage:[UIImage imageNamed:@"icon_back.png"] forState:UIControlStateNormal];
	UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
	
	scaleId = [[NSString alloc] initWithFormat:@"%@", [prefs stringForKey:@"CurrentScale"]];
	final_score_intro = [[NSString alloc] initWithFormat:@"%@_Final_Score_Intro", [scaleId uppercaseString]];
	final_diagnosis_level5 = [[NSString alloc] initWithFormat:@"%@_Final_Diagnosis_Level5", [scaleId uppercaseString]];
	final_diagnosis_level4 = [[NSString alloc] initWithFormat:@"%@_Final_Diagnosis_Level4", [scaleId uppercaseString]];
	final_diagnosis_level3 = [[NSString alloc] initWithFormat:@"%@_Final_Diagnosis_Level3", [scaleId uppercaseString]];
	final_diagnosis_level2 = [[NSString alloc] initWithFormat:@"%@_Final_Diagnosis_Level2", [scaleId uppercaseString]];
	final_diagnosis_level1 = [[NSString alloc] initWithFormat:@"%@_Final_Diagnosis_Level1", [scaleId uppercaseString]];
	final_diagnosis_extended_level5 = [[NSString alloc] initWithFormat:@"%@_Final_Diagnosis_Extended_Level5", [scaleId uppercaseString]];
	final_diagnosis_extended_level4 = [[NSString alloc] initWithFormat:@"%@_Final_Diagnosis_Extended_Level4", [scaleId uppercaseString]];
	final_diagnosis_extended_level3 = [[NSString alloc] initWithFormat:@"%@_Final_Diagnosis_Extended_Level3", [scaleId uppercaseString]];
	final_diagnosis_extended_level2 = [[NSString alloc] initWithFormat:@"%@_Final_Diagnosis_Extended_Level2", [scaleId uppercaseString]];
	final_diagnosis_extended_level1 = [[NSString alloc] initWithFormat:@"%@_Final_Diagnosis_Extended_Level1", [scaleId uppercaseString]];
	
	[startView goFor:scaleId];
	[q1View goToQuestion:1 For:scaleId];		
	[q2View goToQuestion:2 For:scaleId];		
	[q3View goToQuestion:3 For:scaleId];		
	[q4View goToQuestion:4 For:scaleId];		
	[q5View goToQuestion:5 For:scaleId];
	[q6View goToQuestion:6 For:scaleId];
	[q7View goToQuestion:7 For:scaleId];
	[q8View goToQuestion:8 For:scaleId];
	[q9View goToQuestion:9 For:scaleId];
	[q10View goToQuestion:10 For:scaleId];
	[q11View goToQuestion:11 For:scaleId];
	[q12View goToQuestion:12 For:scaleId];
	[q13View goToQuestion:13 For:scaleId];
	[q14View goToQuestion:14 For:scaleId];
	[q15View goToQuestion:15 For:scaleId];
	[finalView go];
	
	helper = [[DoctotHelper alloc] init];
	mailComposerViewController = [[MailComposerViewController alloc] initWithNibName:@"MailComposerViewController" bundle:nil];
	player = [[Player alloc] init];
    [player initialisePlayer];
    [self initialiseWithPlayerDefaults];
    
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSavedScoreAmount) name:NOTIF_TotalScores object:nil]; 
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(executeSelectedQuestionViaNotification:) name:NOTIF_ExecuteSelectedQuestion object:nil];
	
	readyForSave = FALSE;
	scalePercision = q1View.percision;
	
	NSString *str_link = [[NSString alloc] initWithFormat:@"%@_Total", [scaleId uppercaseString]];
	NSString *str = NSLocalizedString(str_link, @"");
	str = @"";
	scale_total.text = [str	stringByAppendingString:@"0"]; 
	[str_link release];
	[str release];
	current_total.text = @"";
	current_subtotal.text = @"";
	current_question.text = q1View.question.question;
	
	scrollView.pagingEnabled = NO;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, scrollView.frame.size.height + scrollAdditionalHeightOffset);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
	scrollView.contentOffset = CGPointMake(0, scrollHeightOffset);
	scrollView.directionalLockEnabled = YES;
    scrollView.delegate = self;
	
    currentPage = 0;
	progressControl.bounds = CGRectMake(0.0, 0.0, 159.0, 19.0);
	
	infoViewController = [[Information alloc] initWithNibName:@"Information" bundle:nil];
	questionExtendedViewController = [[Scale_QuestionExtended alloc] initWithNibName:@"Scale_QuestionExtended" bundle:nil];
	savedScore = [[ScaleScore alloc] initWithNibName:@"ScaleScore" bundle:nil];
	savedScore.managedObjectContext = self.managedObjectContext;
	[self updateSavedScoreAmount];
	
	// Set Up the Top Right of the Nav Bar
	UIButton* rightButton = [[UIButton alloc] initWithFrame:CGRectMake(300, 10, 43, 49)];
	[rightButton setBackgroundImage:[UIImage imageNamed:@"icon_info.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(goToInfoScreen) forControlEvents:UIControlEventTouchUpInside];
	modalViewButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
	//self.navigationItem.rightBarButtonItem = modalViewButtonItem;
	
	infoPageButton = [[UIButton alloc] initWithFrame:CGRectMake(300, 10, 43, 49)];
	[infoPageButton setBackgroundImage:[UIImage imageNamed:@"icon_info.png"] forState:UIControlStateNormal];
	[infoPageButton addTarget:self action:@selector(goToInfoScreen) forControlEvents:UIControlEventTouchUpInside];
	infoPageButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoPageButton];
	
	[self returnToStart];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"DoctotStroke.sqlite"]];
	
	NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 
		 Typical reasons for an error here include:
		 * The persistent store is not accessible
		 * The schema for the persistent store is incompatible with current managed object model
		 Check the error message to determine what the actual problem was.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }    
	
    return persistentStoreCoordinator;
}


#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
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

- (void)confirmPopViewController {

    if( scaleJustAccessed ){
    
        [self popViewController];
        
    }else{
    
        dismissScaleAlert =
        [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Save_DismissSurvey", @"")
                                    delegate:self cancelButtonTitle:NSLocalizedString(@"Button_Cancel", @"") destructiveButtonTitle:nil
                           otherButtonTitles:NSLocalizedString(@"Button_Continue", @"") ,nil, nil, nil, nil];
        [dismissScaleAlert showInView:self.view];
        
    }
    
}

- (void)popViewController {
    [[self navigationController] popViewControllerAnimated:YES];
}

// WRU Initialisation
- (void)initialiseWithPlayerDefaults {
    
    q1View.theSwiper.score = player.weight;
    [q1View.theSwiper jumpToScore:player.weight];
    q1View.option1Score.text = [NSString stringWithFormat:@"%.1f", player.weight];
    q1View.option1Label.text = player.weightUnits;
    
    NSDate * now = [[NSDate alloc] init];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents * comps = [cal components:NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:now];
    
    if( !player.sleepAMPMIndicator ){
        //player.sleepTimeHours += 12;
    }
    [comps setHour:player.sleepTimeHours];
    [comps setMinute:player.sleepTimeMinutes];
    NSDate *sleepDate = [cal dateFromComponents:comps];
    [q2View.sleepTime setDate:sleepDate animated:YES];
    
    if( !player.wakeupAMPMIndicator ){
        //player.wakeupTimeHours += 12;
    }
    [comps setHour:player.wakeupTimeHours];
    [comps setMinute:player.wakeupTimeMinutes];
    NSDate *wakeUpDate = [cal dateFromComponents:comps];
    [q3View.wakeupTime setDate:wakeUpDate animated:YES];
    
    q5View.option1Score.text = @"-";
    q5View.option2Score.text = @"-";
    q5View.option3Score.text = @"-";
    
    // TEMPORARY
    q9View.item = 5;
    q10View.item = 5;
    //q11View.item = 5;
    //q12View.item = 5;
    //q13View.item = 5;
    
}

- (void)dealloc {
	[scrollView release];
    [progressControl release];
	[viewControllers release];
	
	[scaleId release];
	[scale_total release];
	[current_total release];
	[current_subtotal release];
	[scale_status release];
	[controller release];
	[currentQuestionView release];
	[scoreToSave release];
	[numberOfRecords release];
	[moreInfo_button release];
	[previous_button release];
	[continue_button release];
	
	[scaleRecordsFullAlert release];
	[resetScaleAlert release];
	
	[final_score_intro release];
	[final_diagnosis_level5 release];			[final_diagnosis_level4 release];			[final_diagnosis_level3 release];			[final_diagnosis_level2 release];			[final_diagnosis_level1 release];
	[final_diagnosis_extended_level5 release];	[final_diagnosis_extended_level4 release];	[final_diagnosis_extended_level3 release];	[final_diagnosis_extended_level2 release];	[final_diagnosis_extended_level1 release];
	[level5Colour release];						[level4Colour release];						[level3Colour release];						[level2Colour release];						[level1Colour release];
	[colourSelected release];
	
	[startView release];
	[q1View release];	[q2View release];	[q3View release];	[q4View release];	[q5View release];
	[q6View release];	[q7View release];	[q8View release];	[q9View release];	[q10View release];
	[q11View release];	[q12View release];	[q13View release];	[q14View release];	[q15View release];
	[finalView release];
	
	[prefs release];
	[alertMessage release];
	[error_string release];
	[email_body_format release];
	[email_body release];
	[savedScore release];
	[currentTotalAsString release];
	[scalePercision release];
	[managedObjectModel release];
    [managedObjectContext release];	    
    [persistentStoreCoordinator release];
	
	[alert release];
	[helper release];
	[infoPageButtonItem release];
	[infoPageButton release];
	[modalViewButtonItem release];
	[modalViewButton release];
	
    [super dealloc];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Scale Score Calculation Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


- (IBAction)clearCurrentQuestionSelectedOption{
	
	if(currentQuestionView == q1View){	[q1View clearAllButtons];		[q1View calculateQuestionTotal];	}
	if(currentQuestionView == q2View){	[q2View clearAllButtons];		[q2View calculateQuestionTotal];	}
	if(currentQuestionView == q3View){	[q3View clearAllButtons];		[q3View calculateQuestionTotal];	}
	if(currentQuestionView == q4View){	[q4View clearAllButtons];		[q4View calculateQuestionTotal];	}
	if(currentQuestionView == q5View){	[q5View clearAllButtons];		[q5View calculateQuestionTotal];	}
	if(currentQuestionView == q6View){	[q6View clearAllButtons];		[q6View calculateQuestionTotal];	}
	if(currentQuestionView == q7View){	[q7View clearAllButtons];		[q7View calculateQuestionTotal];	}
	
	[self calculateScaleTotal];
}

- (IBAction)executeSelectedQuestion:(id)sender{
	
	if(sender == q1View.optionUntestable){	[self executeQuestionForView:q1View ForItem:q1View.question.itemUntestable.item_no WithScore:q1View.question.itemUntestable.score];	}
	if(sender == q1View.option1){			[self executeQuestionForView:q1View ForItem:q1View.question.item0.item_no WithScore:q1View.question.item0.score];	}
	if(sender == q1View.option2){			[self executeQuestionForView:q1View ForItem:q1View.question.item1.item_no WithScore:q1View.question.item1.score];	}
	if(sender == q1View.option3){			[self executeQuestionForView:q1View ForItem:q1View.question.item2.item_no WithScore:q1View.question.item2.score];	}
	if(sender == q1View.option4){			[self executeQuestionForView:q1View ForItem:q1View.question.item3.item_no WithScore:q1View.question.item3.score];	}
	if(sender == q1View.option5){			[self executeQuestionForView:q1View ForItem:q1View.question.item4.item_no WithScore:q1View.question.item4.score];	}
	if(sender == q1View.option6){			[self executeQuestionForView:q1View ForItem:q1View.question.item5.item_no WithScore:q1View.question.item5.score];	}
	if(sender == q1View.option7){			[self executeQuestionForView:q1View ForItem:q1View.question.item6.item_no WithScore:q1View.question.item6.score];	}
	
	if(sender == q2View.optionUntestable){	[self executeQuestionForView:q2View ForItem:q2View.question.itemUntestable.item_no WithScore:q2View.question.itemUntestable.score];	}
	if(sender == q2View.option1){			[self executeQuestionForView:q2View ForItem:q2View.question.item0.item_no WithScore:q2View.question.item0.score];	}
	if(sender == q2View.option2){			[self executeQuestionForView:q2View ForItem:q2View.question.item1.item_no WithScore:q2View.question.item1.score];	}
	if(sender == q2View.option3){			[self executeQuestionForView:q2View ForItem:q2View.question.item2.item_no WithScore:q2View.question.item2.score];	}
	if(sender == q2View.option4){			[self executeQuestionForView:q2View ForItem:q2View.question.item3.item_no WithScore:q2View.question.item3.score];	}
	if(sender == q2View.option5){			[self executeQuestionForView:q2View ForItem:q2View.question.item4.item_no WithScore:q2View.question.item4.score];	}
	if(sender == q2View.option6){			[self executeQuestionForView:q2View ForItem:q2View.question.item5.item_no WithScore:q2View.question.item5.score];	}
	if(sender == q2View.option7){			[self executeQuestionForView:q2View ForItem:q2View.question.item6.item_no WithScore:q2View.question.item6.score];	}
	
	if(sender == q3View.optionUntestable){	[self executeQuestionForView:q3View ForItem:q3View.question.itemUntestable.item_no WithScore:q3View.question.itemUntestable.score];	}
	if(sender == q3View.option1){			[self executeQuestionForView:q3View ForItem:q3View.question.item0.item_no WithScore:q3View.question.item0.score];	}
	if(sender == q3View.option2){			[self executeQuestionForView:q3View ForItem:q3View.question.item1.item_no WithScore:q3View.question.item1.score];	}
	if(sender == q3View.option3){			[self executeQuestionForView:q3View ForItem:q3View.question.item2.item_no WithScore:q3View.question.item2.score];	}
	if(sender == q3View.option4){			[self executeQuestionForView:q3View ForItem:q3View.question.item3.item_no WithScore:q3View.question.item3.score];	}
	if(sender == q3View.option5){			[self executeQuestionForView:q3View ForItem:q3View.question.item4.item_no WithScore:q3View.question.item4.score];	}
	if(sender == q3View.option6){			[self executeQuestionForView:q3View ForItem:q3View.question.item5.item_no WithScore:q3View.question.item5.score];	}
	
	if(sender == q4View.optionUntestable){	[self executeQuestionForView:q4View ForItem:q4View.question.itemUntestable.item_no WithScore:q4View.question.itemUntestable.score];	}
	if(sender == q4View.option1){			[self executeQuestionForView:q4View ForItem:q4View.question.item0.item_no WithScore:q4View.question.item0.score];	}
	if(sender == q4View.option2){			[self executeQuestionForView:q4View ForItem:q4View.question.item1.item_no WithScore:q4View.question.item1.score];	}
	if(sender == q4View.option3){			[self executeQuestionForView:q4View ForItem:q4View.question.item2.item_no WithScore:q4View.question.item2.score];	}
	if(sender == q4View.option4){			[self executeQuestionForView:q4View ForItem:q4View.question.item3.item_no WithScore:q4View.question.item3.score];	}
	if(sender == q4View.option5){			[self executeQuestionForView:q4View ForItem:q4View.question.item4.item_no WithScore:q4View.question.item4.score];	}
	if(sender == q4View.option6){			[self executeQuestionForView:q4View ForItem:q4View.question.item5.item_no WithScore:q4View.question.item5.score];	}
	if(sender == q4View.option7){			[self executeQuestionForView:q4View ForItem:q4View.question.item6.item_no WithScore:q4View.question.item6.score];	}
	
	if(sender == q5View.optionUntestable){	[self executeQuestionForView:q5View ForItem:q5View.question.itemUntestable.item_no WithScore:q5View.question.itemUntestable.score];	}
	if(sender == q5View.option1){			[self executeQuestionForView:q5View ForItem:q5View.question.item0.item_no WithScore:q5View.question.item0.score];	}
	if(sender == q5View.option2){			[self executeQuestionForView:q5View ForItem:q5View.question.item1.item_no WithScore:q5View.question.item1.score];	}
	if(sender == q5View.option3){			[self executeQuestionForView:q5View ForItem:q5View.question.item2.item_no WithScore:q5View.question.item2.score];	}
	if(sender == q5View.option4){			[self executeQuestionForView:q5View ForItem:q5View.question.item3.item_no WithScore:q5View.question.item3.score];	}
	if(sender == q5View.option5){			[self executeQuestionForView:q5View ForItem:q5View.question.item4.item_no WithScore:q5View.question.item4.score];	}
	if(sender == q5View.option6){			[self executeQuestionForView:q5View ForItem:q5View.question.item5.item_no WithScore:q5View.question.item5.score];	}
	if(sender == q5View.option7){			[self executeQuestionForView:q5View ForItem:q5View.question.item6.item_no WithScore:q5View.question.item6.score];	}
	
    if(sender == q6View.optionUntestable){	[self executeQuestionForView:q6View ForItem:q6View.question.itemUntestable.item_no WithScore:q6View.question.itemUntestable.score];	}
	if(sender == q6View.option1){			[self executeQuestionForView:q6View ForItem:q6View.question.item0.item_no WithScore:q6View.question.item0.score];	}
	if(sender == q6View.option2){			[self executeQuestionForView:q6View ForItem:q6View.question.item1.item_no WithScore:q6View.question.item1.score];	}
	if(sender == q6View.option3){			[self executeQuestionForView:q6View ForItem:q6View.question.item2.item_no WithScore:q6View.question.item2.score];	}
	if(sender == q6View.option4){			[self executeQuestionForView:q6View ForItem:q6View.question.item3.item_no WithScore:q6View.question.item3.score];	}
	if(sender == q6View.option5){			[self executeQuestionForView:q6View ForItem:q6View.question.item4.item_no WithScore:q6View.question.item4.score];	}
	if(sender == q6View.option6){			[self executeQuestionForView:q6View ForItem:q6View.question.item5.item_no WithScore:q6View.question.item5.score];	}
	if(sender == q6View.option7){			[self executeQuestionForView:q6View ForItem:q6View.question.item6.item_no WithScore:q6View.question.item6.score];	}
	
    if(sender == q7View.optionUntestable){	[self executeQuestionForView:q7View ForItem:q7View.question.itemUntestable.item_no WithScore:q7View.question.itemUntestable.score];	}
	if(sender == q7View.option1){			[self executeQuestionForView:q7View ForItem:q7View.question.item0.item_no WithScore:q7View.question.item0.score];	}
	if(sender == q7View.option2){			[self executeQuestionForView:q7View ForItem:q7View.question.item1.item_no WithScore:q7View.question.item1.score];	}
	if(sender == q7View.option3){			[self executeQuestionForView:q7View ForItem:q7View.question.item2.item_no WithScore:q7View.question.item2.score];	}
	if(sender == q7View.option4){			[self executeQuestionForView:q7View ForItem:q7View.question.item3.item_no WithScore:q7View.question.item3.score];	}
	if(sender == q7View.option5){			[self executeQuestionForView:q7View ForItem:q7View.question.item4.item_no WithScore:q7View.question.item4.score];	}
	if(sender == q7View.option6){			[self executeQuestionForView:q7View ForItem:q7View.question.item5.item_no WithScore:q7View.question.item5.score];	}
	if(sender == q7View.option7){			[self executeQuestionForView:q7View ForItem:q7View.question.item6.item_no WithScore:q7View.question.item6.score];	}
    
	if(sender == q8View.optionUntestable){	[self executeQuestionForView:q8View ForItem:q8View.question.itemUntestable.item_no WithScore:q8View.question.itemUntestable.score];	}
	if(sender == q8View.option1){			[self executeQuestionForView:q8View ForItem:q8View.question.item0.item_no WithScore:q8View.question.item0.score];	}
	if(sender == q8View.option2){			[self executeQuestionForView:q8View ForItem:q8View.question.item1.item_no WithScore:q8View.question.item1.score];	}
	if(sender == q8View.option3){			[self executeQuestionForView:q8View ForItem:q8View.question.item2.item_no WithScore:q8View.question.item2.score];	}
	if(sender == q8View.option4){			[self executeQuestionForView:q8View ForItem:q8View.question.item3.item_no WithScore:q8View.question.item3.score];	}
	if(sender == q8View.option5){			[self executeQuestionForView:q8View ForItem:q8View.question.item4.item_no WithScore:q8View.question.item4.score];	}
	if(sender == q8View.option6){			[self executeQuestionForView:q8View ForItem:q8View.question.item5.item_no WithScore:q8View.question.item5.score];	}
	if(sender == q8View.option7){			[self executeQuestionForView:q8View ForItem:q8View.question.item6.item_no WithScore:q8View.question.item6.score];	}
    
	if(sender == q9View.optionUntestable){	[self executeQuestionForView:q9View ForItem:q9View.question.itemUntestable.item_no WithScore:q9View.question.itemUntestable.score];	}
	if(sender == q9View.option1){			[self executeQuestionForView:q9View ForItem:q9View.question.item0.item_no WithScore:q9View.question.item0.score];	}
	if(sender == q9View.option2){			[self executeQuestionForView:q9View ForItem:q9View.question.item1.item_no WithScore:q9View.question.item1.score];	}
	if(sender == q9View.option3){			[self executeQuestionForView:q9View ForItem:q9View.question.item2.item_no WithScore:q9View.question.item2.score];	}
	if(sender == q9View.option4){			[self executeQuestionForView:q9View ForItem:q9View.question.item3.item_no WithScore:q9View.question.item3.score];	}
	if(sender == q9View.option5){			[self executeQuestionForView:q9View ForItem:q9View.question.item4.item_no WithScore:q9View.question.item4.score];	}
	if(sender == q9View.option6){			[self executeQuestionForView:q9View ForItem:q9View.question.item5.item_no WithScore:q9View.question.item5.score];	}
	if(sender == q9View.option7){			[self executeQuestionForView:q9View ForItem:q9View.question.item6.item_no WithScore:q9View.question.item6.score];	}
    
	if(sender == q10View.optionUntestable){	[self executeQuestionForView:q10View ForItem:q10View.question.itemUntestable.item_no WithScore:q10View.question.itemUntestable.score];	}
	if(sender == q10View.option1){			[self executeQuestionForView:q10View ForItem:q10View.question.item0.item_no WithScore:q10View.question.item0.score];	}
	if(sender == q10View.option2){			[self executeQuestionForView:q10View ForItem:q10View.question.item1.item_no WithScore:q10View.question.item1.score];	}
	if(sender == q10View.option3){			[self executeQuestionForView:q10View ForItem:q10View.question.item2.item_no WithScore:q10View.question.item2.score];	}
	if(sender == q10View.option4){			[self executeQuestionForView:q10View ForItem:q10View.question.item3.item_no WithScore:q10View.question.item3.score];	}
	if(sender == q10View.option5){			[self executeQuestionForView:q10View ForItem:q10View.question.item4.item_no WithScore:q10View.question.item4.score];	}
	if(sender == q10View.option6){			[self executeQuestionForView:q10View ForItem:q10View.question.item5.item_no WithScore:q10View.question.item5.score];	}
	if(sender == q10View.option7){			[self executeQuestionForView:q10View ForItem:q10View.question.item6.item_no WithScore:q10View.question.item6.score];	}
    
	if(sender == q11View.optionUntestable){	[self executeQuestionForView:q11View ForItem:q11View.question.itemUntestable.item_no WithScore:q11View.question.itemUntestable.score];	}
	if(sender == q11View.option1){			[self executeQuestionForView:q11View ForItem:q11View.question.item0.item_no WithScore:q11View.question.item0.score];	}
	if(sender == q11View.option2){			[self executeQuestionForView:q11View ForItem:q11View.question.item1.item_no WithScore:q11View.question.item1.score];	}
	if(sender == q11View.option3){			[self executeQuestionForView:q11View ForItem:q11View.question.item2.item_no WithScore:q11View.question.item2.score];	}
	if(sender == q11View.option4){			[self executeQuestionForView:q11View ForItem:q11View.question.item3.item_no WithScore:q11View.question.item3.score];	}
	if(sender == q11View.option5){			[self executeQuestionForView:q11View ForItem:q11View.question.item4.item_no WithScore:q11View.question.item4.score];	}
	if(sender == q11View.option6){			[self executeQuestionForView:q11View ForItem:q11View.question.item5.item_no WithScore:q11View.question.item5.score];	}
	if(sender == q11View.option7){			[self executeQuestionForView:q11View ForItem:q11View.question.item6.item_no WithScore:q11View.question.item6.score];	}
    
	if(sender == q12View.optionUntestable){	[self executeQuestionForView:q12View ForItem:q12View.question.itemUntestable.item_no WithScore:q12View.question.itemUntestable.score];	}
	if(sender == q12View.option1){			[self executeQuestionForView:q12View ForItem:q12View.question.item0.item_no WithScore:q12View.question.item0.score];	}
	if(sender == q12View.option2){			[self executeQuestionForView:q12View ForItem:q12View.question.item1.item_no WithScore:q12View.question.item1.score];	}
	if(sender == q12View.option3){			[self executeQuestionForView:q12View ForItem:q12View.question.item2.item_no WithScore:q12View.question.item2.score];	}
	if(sender == q12View.option4){			[self executeQuestionForView:q12View ForItem:q12View.question.item3.item_no WithScore:q12View.question.item3.score];	}
	if(sender == q12View.option5){			[self executeQuestionForView:q12View ForItem:q12View.question.item4.item_no WithScore:q12View.question.item4.score];	}
	if(sender == q12View.option6){			[self executeQuestionForView:q12View ForItem:q12View.question.item5.item_no WithScore:q12View.question.item5.score];	}
	if(sender == q12View.option7){			[self executeQuestionForView:q12View ForItem:q12View.question.item6.item_no WithScore:q12View.question.item6.score];	}
    
	if(sender == q13View.optionUntestable){	[self executeQuestionForView:q13View ForItem:q13View.question.itemUntestable.item_no WithScore:q13View.question.itemUntestable.score];	}
	if(sender == q13View.option1){			[self executeQuestionForView:q13View ForItem:q13View.question.item0.item_no WithScore:q13View.question.item0.score];	}
	if(sender == q13View.option2){			[self executeQuestionForView:q13View ForItem:q13View.question.item1.item_no WithScore:q13View.question.item1.score];	}
	if(sender == q13View.option3){			[self executeQuestionForView:q13View ForItem:q13View.question.item2.item_no WithScore:q13View.question.item2.score];	}
	if(sender == q13View.option4){			[self executeQuestionForView:q13View ForItem:q13View.question.item3.item_no WithScore:q13View.question.item3.score];	}
	if(sender == q13View.option5){			[self executeQuestionForView:q13View ForItem:q13View.question.item4.item_no WithScore:q13View.question.item4.score];	}
	if(sender == q13View.option6){			[self executeQuestionForView:q13View ForItem:q13View.question.item5.item_no WithScore:q13View.question.item5.score];	}
	if(sender == q13View.option7){			[self executeQuestionForView:q13View ForItem:q13View.question.item6.item_no WithScore:q13View.question.item6.score];	}
    
	if(sender == q14View.optionUntestable){	[self executeQuestionForView:q14View ForItem:q14View.question.itemUntestable.item_no WithScore:q14View.question.itemUntestable.score];	}
	if(sender == q14View.option1){			[self executeQuestionForView:q14View ForItem:q14View.question.item0.item_no WithScore:q14View.question.item0.score];	}
	if(sender == q14View.option2){			[self executeQuestionForView:q14View ForItem:q14View.question.item1.item_no WithScore:q14View.question.item1.score];	}
	if(sender == q14View.option3){			[self executeQuestionForView:q14View ForItem:q14View.question.item2.item_no WithScore:q14View.question.item2.score];	}
	if(sender == q14View.option4){			[self executeQuestionForView:q14View ForItem:q14View.question.item3.item_no WithScore:q14View.question.item3.score];	}
	if(sender == q14View.option5){			[self executeQuestionForView:q14View ForItem:q14View.question.item4.item_no WithScore:q14View.question.item4.score];	}
	if(sender == q14View.option6){			[self executeQuestionForView:q14View ForItem:q14View.question.item5.item_no WithScore:q14View.question.item5.score];	}
	if(sender == q14View.option7){			[self executeQuestionForView:q14View ForItem:q14View.question.item6.item_no WithScore:q14View.question.item6.score];	}
    
	if(sender == q15View.optionUntestable){	[self executeQuestionForView:q15View ForItem:q15View.question.itemUntestable.item_no WithScore:q15View.question.itemUntestable.score];	}
	if(sender == q15View.option1){			[self executeQuestionForView:q15View ForItem:q15View.question.item0.item_no WithScore:q15View.question.item0.score];	}
	if(sender == q15View.option2){			[self executeQuestionForView:q15View ForItem:q15View.question.item1.item_no WithScore:q15View.question.item1.score];	}
	if(sender == q15View.option3){			[self executeQuestionForView:q15View ForItem:q15View.question.item2.item_no WithScore:q15View.question.item2.score];	}
	if(sender == q15View.option4){			[self executeQuestionForView:q15View ForItem:q15View.question.item3.item_no WithScore:q15View.question.item3.score];	}
	if(sender == q15View.option5){			[self executeQuestionForView:q15View ForItem:q15View.question.item4.item_no WithScore:q15View.question.item4.score];	}
	if(sender == q15View.option6){			[self executeQuestionForView:q15View ForItem:q15View.question.item5.item_no WithScore:q15View.question.item5.score];	}
	if(sender == q15View.option7){			[self executeQuestionForView:q15View ForItem:q15View.question.item6.item_no WithScore:q15View.question.item6.score];	}
    
	[self calculateScaleTotal];
	
}

// Generic Question Method  ////////////////////////////////////////////

- (void)executeQuestionForView:(Scale_Question *)questionView ForItem:(NSInteger)item WithScore:(float)score{
	
	if(questionView.item == item){
		[questionView confirmButtonsForOption:item];
		[self moveToNextQuestion];
	}else{
		[questionView setButtonsForOption:item];
	}
	
	questionView.score = score;
	[questionView setSelectedItemTextFor:item];
	[questionView calculateQuestionTotal];
    
    // WRU View Specifics
    NSString *aReference;

    // q6View: Low Sleep Score
    if( questionView == q6View ){
        aReference = [NSString stringWithFormat:@"WRUPLAYER_Q6_Item%.0f", q6View.score];
        player.sleepScoreLow = NSLocalizedString(aReference, @"");
    }
    
    // q7View: Low Energy Score
    if( questionView == q7View ){
        aReference = [NSString stringWithFormat:@"WRUPLAYER_Q7_Item%.0f", q7View.score];
        player.energyScoreLow = NSLocalizedString(aReference, @"");
    }
    
    // q8View: Low Mood Score
    if( questionView == q8View ){
        aReference = [NSString stringWithFormat:@"WRUPLAYER_Q8_Item%.0f", q8View.score];
        player.moodScoreLow = NSLocalizedString(aReference, @"");
    }
    
    // q11View: Illnesses
    if( questionView == q11View ){
        aReference = [NSString stringWithFormat:@"WRUPLAYER_Q11_Item%.0f", q11View.score];
        player.illness = NSLocalizedString(aReference, @"");
    }
    
    // q12View: Contact Required
    if( questionView == q12View ){
        aReference = [NSString stringWithFormat:@"WRUPLAYER_Q12_Item%.0f", q12View.score];
        player.commentRecipient = NSLocalizedString(aReference, @"");
        aReference = [aReference stringByAppendingString:@"_Email"];
        player.commentRecipientEmail = NSLocalizedString(aReference, @"");
    }
    
    // q13View: Contact Content
    if( questionView == q13View ){
        player.comments = q13View.comment.text;
        //[mailComposerViewController setBasicEmailWithRecipient:player.commentRecipientEmail andSubject:player.commentRecipient andText:player.comments];
        //[[self navigationController] pushViewController:mailComposerViewController animated:YES];
    }
    
}

// Recalculate Scale Score ////////////////////////////////////////////

- (void)calculateScaleTotal{
	
	current_total.text = [self currentQuestionTotalAsString];
	
	currentScaleScore = q1View.score + q2View.score + q3View.score + q4View.score + q5View.score + q6View.score + q7View.score;
		
	// Adjustments	NNB: DO NOT DELETE. This is still needed for normal scales
	[self adjustScaleTotals];
	
	[self setDiagnosis];
}

- (int)adjustScaleTotalIgnoringNulls{
	
	if(currentScaleScore <= 0){
		return 0;
	}else{	
		// Calculate the number of Questions answered
		float currentScaleScoreFLOAT = 0.0;
		int questions_answered = 0;
		if(q1View != NULL)	if(q1View.item > -1)	questions_answered = questions_answered + 1;
		if(q2View != NULL)	if(q2View.item > -1)	questions_answered = questions_answered + 1;
		if(q3View != NULL)	if(q3View.item > -1)	questions_answered = questions_answered + 1;
		if(q4View != NULL)	if(q4View.item > -1)	questions_answered = questions_answered + 1;
		if(q5View != NULL)	if(q5View.item > -1)	questions_answered = questions_answered + 1;
		if(q6View != NULL)	if(q6View.item > -1)	questions_answered = questions_answered + 1;
		if(q7View != NULL)	if(q7View.item > -1)	questions_answered = questions_answered + 1;
		if(q8View != NULL)	if(q8View.item > -1)	questions_answered = questions_answered + 1;
		if(q9View != NULL)	if(q9View.item > -1)	questions_answered = questions_answered + 1;
		if(q10View != NULL)	if(q10View.item > -1)	questions_answered = questions_answered + 1;
		if(q11View != NULL)	if(q11View.item > -1)	questions_answered = questions_answered + 1;
		if(q12View != NULL)	if(q12View.item > -1)	questions_answered = questions_answered + 1;
		if(q13View != NULL)	if(q13View.item > -1)	questions_answered = questions_answered + 1;
		if(q14View != NULL)	if(q14View.item > -1)	questions_answered = questions_answered + 1;
		if(q15View != NULL)	if(q15View.item > -1)	questions_answered = questions_answered + 1;
		
		currentScaleScoreFLOAT = (kNumberOfPages - 1) * ( (float)(currentScaleScore) / (float)(questions_answered) );
	
		return round(currentScaleScoreFLOAT);
	}
}

- (void)adjustScaleTotals{

	scale_total.text = [[NSString alloc] initWithFormat:scalePercision, currentScaleScore];

}

// Clear ALL options selected

- (IBAction)clearAllSelectedOptions{
	
	if(currentQuestionView.clearSelectionSlider.value > resetSliderDistanceToExit ){
		[self clearAllSelectedOptionsBasic];
	}
	
}

- (IBAction)clearAllSelectedOptionsBasic{
	
	currentScaleScore = 0.0;
	currentScaleQuestionScore = 0.0;
	scrollView.contentOffset = CGPointMake(0, scrollHeightOffset);
	scale_total.text = @"0";
	finalView.first_name.text = @"";
	finalView.last_name.text = @"";
	
	[q1View clearAllButtons];
	[q2View clearAllButtons];
	[q3View clearAllButtons];
	[q4View clearAllButtons];
	[q5View clearAllButtons];
	[q6View clearAllButtons];
	[q7View clearAllButtons];
	[q8View clearAllButtons];
	[q9View clearAllButtons];
	[q10View clearAllButtons];
	[q11View clearAllButtons];
	[q12View clearAllButtons];
	[q13View clearAllButtons];
	[q14View clearAllButtons];
	[q15View clearAllButtons];
	
	[q1View resetClockCounterOnly]; 
	[q2View resetClockCounterOnly];
	[q3View resetClockCounterOnly];
	[q4View resetClockCounterOnly];
	[q5View resetClockCounterOnly];
	[q6View resetClockCounterOnly];
	[q7View resetClockCounterOnly];
	[q8View resetClockCounterOnly];
	[q9View resetClockCounterOnly];
	[q10View resetClockCounterOnly];
	[q11View resetClockCounterOnly];
	[q12View resetClockCounterOnly];
	[q13View resetClockCounterOnly];
	[q14View resetClockCounterOnly];
	[q15View resetClockCounterOnly];
	
	[self calculateScaleTotal];
	[self returnToStart];
	
}

- (IBAction)sliderSpringsBack{
	
	if(currentQuestionView.clearSelectionSlider.value <= resetSliderDistanceToExit ){
		currentQuestionView.clearSelectionSlider.value = 0.0;
	}
	
}


// WRU Interactions

- (IBAction)sliderUpdatesScore{
    
    currentQuestionView.item = 5;
    currentScaleQuestionScore = currentQuestionView.score;
    [self calculateScaleTotal];
    
    if( currentQuestionView == q1View ){
    
        player.weight = q1View.theSwiper.score;
        //NSString *newWeight = [NSString stringWithFormat:@"%f", player.weight];
        //[prefs setObject:newWeight forKey:@"Weight"];
        
    }
    
}

- (IBAction)updateDatePicker:(UIDatePicker *)theDatePicker {
    
    NSDate *theTime = theDatePicker.date;
    NSDateComponents *theTimeComponents = [[NSCalendar currentCalendar] components:NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit fromDate:theTime];
    
    if( theDatePicker == q2View.sleepTime ){
        q2View.item = 5;
        player.sleepTimeHours = [theTimeComponents hour];
        player.sleepTimeMinutes = [theTimeComponents minute];
    }
    
    if( theDatePicker == q3View.wakeupTime ){
        q3View.item = 5;
        player.wakeupTimeHours = [theTimeComponents hour];
        player.wakeupTimeMinutes = [theTimeComponents minute];
    }
    
}

- (IBAction)executeSelectedQuestionViaNotification:(id)sender{
	
	int score = 0;
	int item = -1;
	objectSentFromNotification = [sender object];
	
	if([objectSentFromNotification isEqualToString:@"option1"]){	item = currentQuestionView.question.item0.item_no;	score = currentQuestionView.question.item0.score;	}
	if([objectSentFromNotification isEqualToString:@"option2"]){	item = currentQuestionView.question.item1.item_no;	score = currentQuestionView.question.item1.score;	}
	if([objectSentFromNotification isEqualToString:@"option3"]){	item = currentQuestionView.question.item2.item_no;	score = currentQuestionView.question.item2.score;	}
	if([objectSentFromNotification isEqualToString:@"option4"]){	item = currentQuestionView.question.item3.item_no;	score = currentQuestionView.question.item3.score;	}
	if([objectSentFromNotification isEqualToString:@"option5"]){	item = currentQuestionView.question.item4.item_no;	score = currentQuestionView.question.item4.score;	}
	
	currentQuestionView.allowClockToBeReset = NO;
	[currentQuestionView setButtonsForOption:item];
	currentQuestionView.allowClockToBeReset = YES;
	
	currentQuestionView.score = score;
	[currentQuestionView calculateQuestionTotal];
	[self calculateScaleTotal];
	
}

////////////////////////////////////////////////////////////////////////////////
// Save Score Methods
////////////////////////////////////////////////////////////////////////////////

- (IBAction)saveScore{
    
    [self displayOptionAlertWithMessage:NSLocalizedString(@"Final_Save_Confirm", @"") ];
    
    /*
	// Check that the Patient's name has been entered
    if ( ([finalView.first_name.text length] == 0) || ([finalView.last_name.text length] == 0) ) {
		
		[self displayAlertWithMessage:NSLocalizedString(@"Final_Save_No_Name_Entered", @"") ];
		
	}else{
		
		if ( ([finalView.final_score.text isEqualToString:@"-"]) || ([finalView.final_score.text length] == 0) ){
			[self displayAlertWithMessage:NSLocalizedString(@"Final_Save_No_Score_Entered", @"") ];
		}else{
		
            [finalView.first_name resignFirstResponder];
            [finalView.last_name resignFirstResponder];
            [self checkIfTableIsFull];
            
		}
	}
     */
}

- (void)checkIfTableIsFull{
	readyForSave = TRUE;
	// Check that the Save Limit has not been exceeded
	int recordsSavedInTable = 0;
	recordsSavedInTable = [savedScore returnNumberOfScoresForScale];
	
	prefs = [NSUserDefaults standardUserDefaults];
	NSInteger maximumScoresAllowed = [prefs integerForKey:@"maxSavesAllowed"];
	
	if(recordsSavedInTable >= maximumScoresAllowed){
		
		scaleRecordsFullAlert =
		[[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Save_TableFull", @"") 
									delegate:self cancelButtonTitle:NSLocalizedString(@"Button_Cancel", @"") destructiveButtonTitle:nil
						   otherButtonTitles:NSLocalizedString(@"Button_Continue", @"") ,nil, nil, nil, nil];
		
		[scaleRecordsFullAlert showInView:self.view];
		
	}else{
		[self saveScoreToDatabase];
	}
	
}

- (void)saveScoreToDatabase{
	
	//////////////// INSERT Score INTO Database ////////////////
	
	extern float currentScaleScore;

	scoreToSave = [[IndividualScore alloc] init];
	scoreToSave.firstName = (NSString *)finalView.first_name.text;
	scoreToSave.lastName = (NSString *)finalView.last_name.text;
	scoreToSave.score = currentScaleScore;
	scoreToSave.scoreAsString = [[NSString alloc] initWithFormat:@"%@", finalView.final_score.text];
	scoreToSave.diagnosis = (NSString *)finalView.diagnosis.text;
	scoreToSave.diagnosisExtended = finalView.diagnosis_extended;
	scoreToSave.diagnosisLevel = diagnosisLevel;
	scoreToSave.diagnosisColour = colourSelected;
	
	if(q1View != NULL){         if(q1View.item == -1){	scoreToSave.q1 = -1;	}else{	if(q1View.item == 0){	scoreToSave.q1 = -2;	}else{	scoreToSave.q1 = q1View.score;	}}}
	if(q2View != NULL){         if(q2View.item == -1){	scoreToSave.q2 = -1;	}else{	if(q2View.item == 0){	scoreToSave.q2 = -2;	}else{	scoreToSave.q2 = q2View.score;	}}}
	if(q3View != NULL){         if(q3View.item == -1){	scoreToSave.q3 = -1;	}else{	if(q3View.item == 0){	scoreToSave.q3 = -2;	}else{	scoreToSave.q3 = q3View.score;	}}}
	if(q4View != NULL){         if(q4View.item == -1){	scoreToSave.q4 = -1;	}else{	if(q4View.item == 0){	scoreToSave.q4 = -2;	}else{	scoreToSave.q4 = q4View.score;	}}}
	if(q5View != NULL){         if(q5View.item == -1){	scoreToSave.q5 = -1;	}else{	if(q5View.item == 0){	scoreToSave.q5 = -2;	}else{	scoreToSave.q5 = q5View.score;	}}}
	if(q6View != NULL){         if(q6View.item == -1){	scoreToSave.q6 = -1;	}else{	if(q6View.item == 0){	scoreToSave.q6 = -2;	}else{	scoreToSave.q6 = q6View.score;	}}}
	if(q7View != NULL){         if(q7View.item == -1){	scoreToSave.q7 = -1;	}else{	if(q7View.item == 0){	scoreToSave.q7 = -2;	}else{	scoreToSave.q7 = q7View.score;	}}}
	if(q8View != NULL){         if(q8View.item == -1){	scoreToSave.q8 = -1;	}else{	if(q8View.item == 0){	scoreToSave.q8 = -2;	}else{	scoreToSave.q8 = q8View.score;	}}}
	if(q9View != NULL){         if(q9View.item == -1){	scoreToSave.q9 = -1;	}else{	if(q9View.item == 0){	scoreToSave.q9 = -2;	}else{	scoreToSave.q9 = q9View.score;	}}}
	if(q10View != NULL){		if(q10View.item == -1){	scoreToSave.q10 = -1;	}else{	if(q10View.item == 0){	scoreToSave.q10 = -2;	}else{	scoreToSave.q10 = q10View.score;	}}}
	if(q11View != NULL){		if(q11View.item == -1){	scoreToSave.q11 = -1;	}else{	if(q11View.item == 0){	scoreToSave.q11 = -2;	}else{	scoreToSave.q11 = q11View.score;	}}}
	if(q12View != NULL){		if(q12View.item == -1){	scoreToSave.q12 = -1;	}else{	if(q12View.item == 0){	scoreToSave.q12 = -2;	}else{	scoreToSave.q12 = q12View.score;	}}}
	if(q13View != NULL){		if(q13View.item == -1){	scoreToSave.q13 = -1;	}else{	if(q13View.item == 0){	scoreToSave.q13 = -2;	}else{	scoreToSave.q13 = q13View.score;	}}}
	if(q14View != NULL){		if(q14View.item == -1){	scoreToSave.q14 = -1;	}else{	if(q14View.item == 0){	scoreToSave.q14 = -2;	}else{	scoreToSave.q14 = q14View.score;	}}}
	if(q15View != NULL){		if(q15View.item == -1){	scoreToSave.q15 = -1;	}else{	if(q15View.item == 0){	scoreToSave.q15 = -2;	}else{	scoreToSave.q15 = q15View.score;	}}}
	
	/////////////////// Set up extended text results for each item selected /////////////////////	
	if( [scaleId isEqualToString:@"wruplayer"] ){
        q1View.selectedItemText = [NSString stringWithFormat:@"%.1f", q1View.theSwiper.score];
    }
    
    scoreToSave.q1Extended = q1View.selectedItemText;	scoreToSave.q2Extended = q2View.selectedItemText;	scoreToSave.q3Extended = q3View.selectedItemText;
	scoreToSave.q4Extended = q4View.selectedItemText;	scoreToSave.q5Extended = q5View.selectedItemText;	scoreToSave.q6Extended = q6View.selectedItemText;
    scoreToSave.q7Extended = q7View.selectedItemText;   scoreToSave.q8Extended = q8View.selectedItemText;   scoreToSave.q9Extended = q9View.selectedItemText;
	scoreToSave.q10Extended = q10View.selectedItemText;  scoreToSave.q11Extended = q11View.selectedItemText;  scoreToSave.q12Extended = q12View.selectedItemText;
	scoreToSave.q13Extended = q13View.selectedItemText;  scoreToSave.q14Extended = q14View.selectedItemText;  scoreToSave.q15Extended = q15View.selectedItemText;
	
	if( !( [q1View.explainUntestableLabel.text isEqual:@"(null)"] || ([q1View.explainUntestableLabel.text length] <= 0) ) )	scoreToSave.q1Extended = [[NSString alloc] initWithFormat:@"%@ \n%@", scoreToSave.q1Extended, q1View.explainUntestableLabel.text];
	if( !( [q2View.explainUntestableLabel.text isEqual:@"(null)"] || ([q2View.explainUntestableLabel.text length] <= 0) ) )	scoreToSave.q2Extended = [[NSString alloc] initWithFormat:@"%@ \n%@", scoreToSave.q2Extended, q2View.explainUntestableLabel.text];
	if( !( [q3View.explainUntestableLabel.text isEqual:@"(null)"] || ([q3View.explainUntestableLabel.text length] <= 0) ) )	scoreToSave.q3Extended = [[NSString alloc] initWithFormat:@"%@ \n%@", scoreToSave.q3Extended, q3View.explainUntestableLabel.text];
	if( !( [q4View.explainUntestableLabel.text isEqual:@"(null)"] || ([q4View.explainUntestableLabel.text length] <= 0) ) )	scoreToSave.q4Extended = [[NSString alloc] initWithFormat:@"%@ \n%@", scoreToSave.q4Extended, q4View.explainUntestableLabel.text];
	if( !( [q5View.explainUntestableLabel.text isEqual:@"(null)"] || ([q5View.explainUntestableLabel.text length] <= 0) ) )	scoreToSave.q5Extended = [[NSString alloc] initWithFormat:@"%@ \n%@", scoreToSave.q5Extended, q5View.explainUntestableLabel.text];
	if( !( [q6View.explainUntestableLabel.text isEqual:@"(null)"] || ([q6View.explainUntestableLabel.text length] <= 0) ) )	scoreToSave.q6Extended = [[NSString alloc] initWithFormat:@"%@ \n%@", scoreToSave.q6Extended, q6View.explainUntestableLabel.text];
	if( !( [q7View.explainUntestableLabel.text isEqual:@"(null)"] || ([q7View.explainUntestableLabel.text length] <= 0) ) )	scoreToSave.q7Extended = [[NSString alloc] initWithFormat:@"%@ \n%@", scoreToSave.q7Extended, q7View.explainUntestableLabel.text];
	if( !( [q8View.explainUntestableLabel.text isEqual:@"(null)"] || ([q8View.explainUntestableLabel.text length] <= 0) ) )	scoreToSave.q8Extended = [[NSString alloc] initWithFormat:@"%@ \n%@", scoreToSave.q8Extended, q8View.explainUntestableLabel.text];
	if( !( [q9View.explainUntestableLabel.text isEqual:@"(null)"] || ([q9View.explainUntestableLabel.text length] <= 0) ) )	scoreToSave.q9Extended = [[NSString alloc] initWithFormat:@"%@ \n%@", scoreToSave.q9Extended, q9View.explainUntestableLabel.text];
	if( !( [q10View.explainUntestableLabel.text isEqual:@"(null)"] || ([q10View.explainUntestableLabel.text length] <= 0) ) )	scoreToSave.q10Extended = [[NSString alloc] initWithFormat:@"%@ \n%@", scoreToSave.q10Extended, q10View.explainUntestableLabel.text];
	if( !( [q11View.explainUntestableLabel.text isEqual:@"(null)"] || ([q11View.explainUntestableLabel.text length] <= 0) ) )	scoreToSave.q11Extended = [[NSString alloc] initWithFormat:@"%@ \n%@", scoreToSave.q11Extended, q11View.explainUntestableLabel.text];
	if( !( [q12View.explainUntestableLabel.text isEqual:@"(null)"] || ([q12View.explainUntestableLabel.text length] <= 0) ) )	scoreToSave.q12Extended = [[NSString alloc] initWithFormat:@"%@ \n%@", scoreToSave.q12Extended, q12View.explainUntestableLabel.text];
	if( !( [q13View.explainUntestableLabel.text isEqual:@"(null)"] || ([q13View.explainUntestableLabel.text length] <= 0) ) )	scoreToSave.q13Extended = [[NSString alloc] initWithFormat:@"%@ \n%@", scoreToSave.q13Extended, q13View.explainUntestableLabel.text];
    if( !( [q13View.explainUntestableLabel.text isEqual:@"(null)"] || ([q13View.explainUntestableLabel.text length] <= 0) ) )	scoreToSave.q13Extended = [[NSString alloc] initWithFormat:@"%@ \n%@", scoreToSave.q13Extended, q13View.explainUntestableLabel.text];
    if( !( [q13View.explainUntestableLabel.text isEqual:@"(null)"] || ([q13View.explainUntestableLabel.text length] <= 0) ) )	scoreToSave.q13Extended = [[NSString alloc] initWithFormat:@"%@ \n%@", scoreToSave.q13Extended, q13View.explainUntestableLabel.text];
    
	[self readjustForAwkwardScales];
	
	[savedScore insertNewObject:scoreToSave];
	
	/////////////////// Inform user of successful score save /////////////////////	
	
	error_string = [[NSString alloc] initWithString:(NSString *)NSLocalizedString(@"Final_Save_Complete", @"")];
	error_string = [error_string stringByAppendingString:@" "];
	error_string = [error_string stringByAppendingString:finalView.first_name.text];
	error_string = [error_string stringByAppendingString:@" "];
	error_string = [error_string stringByAppendingString:finalView.last_name.text];
	
	[self displayAlertWithMessage:error_string];
	
	NSLog(@"O/P: %@", error_string); 
	
	[self updateSavedScoreAmount];
	
	/////////////////// Reset score & return to start page /////////////////////
	
	BOOL emailResult = [prefs boolForKey:@"AutomaticEmail"];
	if( emailResult ){
				
		email_body_format = @"%@: %@ %@\n%@: %@\n\n";
		
		email_body = [[NSString alloc] initWithFormat:email_body_format, 
					  NSLocalizedString(@"Save_FullName", @""), 
					  finalView.first_name.text, finalView.last_name.text, 
					  NSLocalizedString(@"Save_Score", @""), finalView.final_score.text
					  ];

		if([finalView.diagnosis.text length] > 0)	
			email_body = [email_body stringByAppendingFormat:@"%@: %@\n", NSLocalizedString(@"Save_Diagnosis", @""), scoreToSave.diagnosis];
		
		if([finalView.diagnosis_extended length] > 0)
			email_body = [email_body stringByAppendingFormat:@"%@: %@\n\n", NSLocalizedString(@"Save_DiagnosisExtended", @""), scoreToSave.diagnosisExtended];
		else
			email_body = [email_body stringByAppendingFormat:@"\n"];
		
		if(kNumberOfPages > 1){
			email_body = [email_body stringByAppendingFormat:@"- %@: %@", q1View.question.question, q1View.total.text];
			if([q1View.selectedItemText length] > 0)	email_body = [email_body stringByAppendingFormat:@" (%@)\n", q1View.selectedItemText];	else	email_body = [email_body stringByAppendingFormat:@"\n"];
		}
		if(kNumberOfPages > 2){
			email_body = [email_body stringByAppendingFormat:@"- %@: %@", q2View.question.question, q2View.total.text];
			if([q2View.selectedItemText length] > 0)	email_body = [email_body stringByAppendingFormat:@" (%@)\n", q2View.selectedItemText];	else	email_body = [email_body stringByAppendingFormat:@"\n"];
		}
		if(kNumberOfPages > 3){
			email_body = [email_body stringByAppendingFormat:@"- %@: %@", q3View.question.question, q3View.total.text];
			if([q3View.selectedItemText length] > 0)	email_body = [email_body stringByAppendingFormat:@" (%@)\n", q3View.selectedItemText];	else	email_body = [email_body stringByAppendingFormat:@"\n"];
		}
		if(kNumberOfPages > 4){
			email_body = [email_body stringByAppendingFormat:@"- %@: %@", q4View.question.question, q4View.total.text];
			if([q4View.selectedItemText length] > 0)	email_body = [email_body stringByAppendingFormat:@" (%@)\n", q4View.selectedItemText];	else	email_body = [email_body stringByAppendingFormat:@"\n"];
		}
		if(kNumberOfPages > 5){
			email_body = [email_body stringByAppendingFormat:@"- %@: %@", q5View.question.question, q5View.total.text];
			if([q5View.selectedItemText length] > 0)	email_body = [email_body stringByAppendingFormat:@" (%@)\n", q5View.selectedItemText];	else	email_body = [email_body stringByAppendingFormat:@"\n"];
		}
        if(kNumberOfPages > 6){
			email_body = [email_body stringByAppendingFormat:@"- %@: %@", q6View.question.question, q6View.total.text];
			if([q6View.selectedItemText length] > 0)	email_body = [email_body stringByAppendingFormat:@" (%@)\n", q6View.selectedItemText];	else	email_body = [email_body stringByAppendingFormat:@"\n"];
		}
        if(kNumberOfPages > 7){
			email_body = [email_body stringByAppendingFormat:@"- %@: %@", q7View.question.question, q7View.total.text];
			if([q7View.selectedItemText length] > 0)	email_body = [email_body stringByAppendingFormat:@" (%@)\n", q7View.selectedItemText];	else	email_body = [email_body stringByAppendingFormat:@"\n"];
		}
        if(kNumberOfPages > 8){
			email_body = [email_body stringByAppendingFormat:@"- %@: %@", q8View.question.question, q8View.total.text];
			if([q8View.selectedItemText length] > 0)	email_body = [email_body stringByAppendingFormat:@" (%@)\n", q8View.selectedItemText];	else	email_body = [email_body stringByAppendingFormat:@"\n"];
		}
        if(kNumberOfPages > 9){
			email_body = [email_body stringByAppendingFormat:@"- %@: %@", q9View.question.question, q9View.total.text];
			if([q9View.selectedItemText length] > 0)	email_body = [email_body stringByAppendingFormat:@" (%@)\n", q9View.selectedItemText];	else	email_body = [email_body stringByAppendingFormat:@"\n"];
		}
        if(kNumberOfPages > 10){
			email_body = [email_body stringByAppendingFormat:@"- %@: %@", q10View.question.question, q10View.total.text];
			if([q10View.selectedItemText length] > 0)	email_body = [email_body stringByAppendingFormat:@" (%@)\n", q10View.selectedItemText];	else	email_body = [email_body stringByAppendingFormat:@"\n"];
		}
        if(kNumberOfPages > 11){
			email_body = [email_body stringByAppendingFormat:@"- %@: %@", q11View.question.question, q11View.total.text];
			if([q11View.selectedItemText length] > 0)	email_body = [email_body stringByAppendingFormat:@" (%@)\n", q11View.selectedItemText];	else	email_body = [email_body stringByAppendingFormat:@"\n"];
		}
        if(kNumberOfPages > 12){
			email_body = [email_body stringByAppendingFormat:@"- %@: %@", q12View.question.question, q12View.total.text];
			if([q12View.selectedItemText length] > 0)	email_body = [email_body stringByAppendingFormat:@" (%@)\n", q12View.selectedItemText];	else	email_body = [email_body stringByAppendingFormat:@"\n"];
		}
        if(kNumberOfPages > 13){
			email_body = [email_body stringByAppendingFormat:@"- %@: %@", q13View.question.question, q13View.total.text];
			if([q13View.selectedItemText length] > 0)	email_body = [email_body stringByAppendingFormat:@" (%@)\n", q13View.selectedItemText];	else	email_body = [email_body stringByAppendingFormat:@"\n"];
		}
        if(kNumberOfPages > 14){
			email_body = [email_body stringByAppendingFormat:@"- %@: %@", q13View.question.question, q14View.total.text];
			if([q14View.selectedItemText length] > 0)	email_body = [email_body stringByAppendingFormat:@" (%@)\n", q14View.selectedItemText];	else	email_body = [email_body stringByAppendingFormat:@"\n"];
		}
        if(kNumberOfPages > 15){
			email_body = [email_body stringByAppendingFormat:@"- %@: %@", q13View.question.question, q15View.total.text];
			if([q15View.selectedItemText length] > 0)	email_body = [email_body stringByAppendingFormat:@" (%@)\n", q15View.selectedItemText];	else	email_body = [email_body stringByAppendingFormat:@"\n"];
		}
        
		[mailComposerViewController setEmailDataForScale:[scaleId uppercaseString] WithText:email_body];
		[[self navigationController] pushViewController:mailComposerViewController animated:YES];
	}
	
	[self clearAllSelectedOptionsBasic];
	
}

- (void)readjustForAwkwardScales{}


- (void)actionSheet:(UIActionSheet *)modalView clickedButtonAtIndex:(NSInteger)buttonIndex{
	
	shakeEnabled = YES;
	
	switch (buttonIndex)
	{
		case 0:{
			
            // Logic For modalView = dismissScaleAlert
			if(modalView == dismissScaleAlert){
				[self popViewController];
			}
            
			// Logic For modalView = resetScaleAlert
			if(modalView == resetScaleAlert){
				[self clearAllSelectedOptionsBasic];
				[currentQuestionView resetClockStatus:YES];
			}
			
			// Logic For modalView = scaleRecordsFullAlert
			if(modalView == scaleRecordsFullAlert){
				if ( readyForSave ) {
					adjustNumberOfRecords = YES;
					[self saveScoreToDatabase];
					[savedScore deleteFirstRecordFromTable:scaleId];
				}
			}
            
            // Logic For modalView = saveConfirmation
			if(modalView == saveConfirmation){
                
                [self submitSurveyOperations:YES];
                
			}
            
            
			break;
		}
		case 1:{
			break;
		}
	}
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{}
- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{}
- (void)actionSheetCancel:(UIActionSheet *)actionSheet{}
- (void)didPresentActionSheet:(UIActionSheet *)actionSheet{}
- (void)willPresentActionSheet:(UIActionSheet *)actionSheet{}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Navigation Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)loadScrollViewWithPage:(int)centralPage{
    int page = centralPage;
	progressControl.progress = ( (float)page + 1 ) / ( (float)kNumberOfPages - 1 );
    
    // Moving the progress indicator Image
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake( ((progressControl.progress * 150) - 82), 0, progressIndicator.frame.size.width, progressIndicator.frame.size.height)];
    img.image = [UIImage imageNamed:@"prog_bar_both.png"];
    for(UIImageView *subImage in [progressIndicator subviews]){
        [subImage removeFromSuperview];
    }
    [progressIndicator addSubview:img];
	
	scale_status.text = [NSString stringWithFormat:@"%@ %i %@ %i", NSLocalizedString(@"Question", @""), page+1, NSLocalizedString(@"Of", @""), kNumberOfPages-1];
	scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, scrollView.frame.size.height + scrollAdditionalHeightOffset);
	[moreInfo_button setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
	
	if (page < 0) return;
    if (page >= kNumberOfPages) return;
	
    controller = [viewControllers objectAtIndex:page];
	
	if (page == 0) {	
		currentQuestionView = q1View;
	}
	if (page == 1)  {
		currentQuestionView = q2View;
	}
	if (page == 2)  {
		currentQuestionView = q3View;
	}
	if (page == 3)  {
		currentQuestionView = q4View;
	}
	if (page == 4)  {
		currentQuestionView = q5View;
	}
	if (page == 5)  {
		currentQuestionView = q6View;
	}
	if (page == 6)  {
		currentQuestionView = q7View;
	}
	if (page == 7)  {
		currentQuestionView = q8View;
	}
	if (page == 8)  {
		currentQuestionView = q9View;
	}
	if (page == 9)  {
		currentQuestionView = q10View;
	}
	if (page == 10)  {
		currentQuestionView = q11View;
	}
	if (page == 11)  {
		currentQuestionView = q12View;
	}
	if (page == 12)  {
		currentQuestionView = q13View;
	}
	if (page == 13)  {
		currentQuestionView = q14View;
	}
	if (page == 14)  {
		currentQuestionView = q15View;
	}

	if(page == (kNumberOfPages - 1) ){
		scale_status.text = @"";
		finalView.final_score.text = scale_total.text;
		current_question.text = NSLocalizedString(final_score_intro, @"");
		current_questionSubheading.text = NSLocalizedString(@"Final_Save_Explanation", @"");
		current_total.text = @"-";
		current_subtotal.text = @"";
		
		[self setDiagnosis];
		
		if([finalView.diagnosis_extended length] > 0)
			[finalView.diagnosis_button setImage:[UIImage imageNamed:moreInfoButton] forState:UIControlStateNormal];
		
        [self configureSurveyOutput];
        
		controller = finalView;
		
	}else{
		controller = currentQuestionView;
		current_question.text = currentQuestionView.question.question;
		current_questionSubheading.text = currentQuestionView.question.questionSubheading;
		currentScaleQuestionScore = currentQuestionView.score;
		current_total.text = [self currentQuestionTotalAsString];
		[self adjustScaleTotals];
	}
	
	scrollView.contentSize = CGSizeMake(controller.frame.size.width, controller.frame.size.height);
	scrollView.contentOffset = CGPointMake(0, scrollHeightOffset);
	
	[self becomeFirstResponder];
	
	// Determines if the More Info Button should be displayed
	[self displayMoreInfoButton];
	
	// add the controller's view to the scroll view
	for(int i = 0; i < [[scrollView subviews] count]; i++){
		[[[scrollView subviews] objectAtIndex:i] removeFromSuperview];
	}
	
	[DoctotHelper slideInFor:scrollView For:curlDirection];
	[scrollView addSubview:controller];
	
}

- (NSString *)currentQuestionTotalAsString{
	
	if((currentQuestionView.item == -1) || (controller == finalView)){
		currentTotalAsString = @"-";
	}else{
		if(currentQuestionView.item == 0)
			currentTotalAsString = NSLocalizedString(@"NIHSS_UntestableShortened", @"");
		else
			currentTotalAsString = [NSString stringWithFormat:scalePercision, currentScaleQuestionScore];
	}
	
	return currentTotalAsString;
}

- (void)setDiagnosis{
	
	if(scaleUpperBoundsLevel_1 >= 0){
		if(reverseColourDirection){
			level2Colour = [UIColor whiteColor];
			level1Colour = [UIColor redColor];
		}else{
			level2Colour = [UIColor redColor];
			level1Colour = [UIColor whiteColor];
		}
	}
	if(scaleUpperBoundsLevel_2 >= 0){
		if(reverseColourDirection){
			level3Colour = [UIColor whiteColor];
			level2Colour = [UIColor yellowColor];
			level1Colour = [UIColor redColor];
		}else{
			level3Colour = [UIColor redColor];
			level2Colour = [UIColor yellowColor];
			level1Colour = [UIColor whiteColor];
		}
	}
	if(scaleUpperBoundsLevel_3 >= 0){
		if(reverseColourDirection){
			level4Colour = [UIColor whiteColor];
			level3Colour = [UIColor blueColor];
			level2Colour = [UIColor yellowColor];
			level1Colour = [UIColor redColor];
		}else{
			level4Colour = [UIColor redColor];
			level3Colour = [UIColor yellowColor];
			level2Colour = [UIColor blueColor];
			level1Colour = [UIColor whiteColor];
		}
	}
	if(scaleUpperBoundsLevel_4 >= 0){
		if(reverseColourDirection){
			level5Colour = [UIColor redColor];
			level4Colour = [UIColor orangeColor];
			level3Colour = [UIColor yellowColor];
			level2Colour = [UIColor blueColor];
			level1Colour = [UIColor whiteColor];
		}else{
			level5Colour = [UIColor whiteColor];
			level4Colour = [UIColor blueColor];
			level3Colour = [UIColor yellowColor];
			level2Colour = [UIColor orangeColor];
			level1Colour = [UIColor redColor];
		}
	}
	
	
	if( (currentScaleScore > scaleUpperBoundsLevel_4) && (scaleUpperBoundsLevel_4 >= 0) ){
		diagnosisLevel = 5;
		scale_total.textColor = level5Colour;
		finalView.score_intro.textColor = level5Colour;
		finalView.diagnosis.textColor = level5Colour;
		finalView.diagnosis.text = NSLocalizedString(final_diagnosis_level5, @"");
		finalView.diagnosis_extended = NSLocalizedString(final_diagnosis_extended_level5, @"");
	}else{
		if( (currentScaleScore > scaleUpperBoundsLevel_3) && (scaleUpperBoundsLevel_3 >= 0) ){
			diagnosisLevel = 4;
			scale_total.textColor = level4Colour;
			finalView.score_intro.textColor = level4Colour;
			finalView.diagnosis.textColor = level4Colour;
			finalView.diagnosis.text = NSLocalizedString(final_diagnosis_level4, @"");
			finalView.diagnosis_extended = NSLocalizedString(final_diagnosis_extended_level4, @"");
		}else{
			if( (currentScaleScore > scaleUpperBoundsLevel_2) && (scaleUpperBoundsLevel_2 >= 0) ){
				diagnosisLevel = 3;
				scale_total.textColor = level3Colour;
				finalView.score_intro.textColor = level3Colour;
				finalView.diagnosis.textColor = level3Colour;
				finalView.diagnosis.text = NSLocalizedString(final_diagnosis_level3, @"");
				finalView.diagnosis_extended = NSLocalizedString(final_diagnosis_extended_level3, @"");
			}else{
				if( (currentScaleScore > scaleUpperBoundsLevel_1) && (scaleUpperBoundsLevel_1 >= 0) ){
					diagnosisLevel = 2;
					scale_total.textColor = level2Colour;
					finalView.score_intro.textColor = level2Colour;
					finalView.diagnosis.textColor = level2Colour;
					finalView.diagnosis.text = NSLocalizedString(final_diagnosis_level2, @"");
					finalView.diagnosis_extended = NSLocalizedString(final_diagnosis_extended_level2, @"");
				}else{
					diagnosisLevel = 1;
					scale_total.textColor = level1Colour;
					finalView.score_intro.textColor = level1Colour;
					finalView.diagnosis.textColor = level1Colour;
					finalView.diagnosis.text = NSLocalizedString(final_diagnosis_level1, @"");
					finalView.diagnosis_extended = NSLocalizedString(final_diagnosis_extended_level1, @"");
				}
			}
		}
	}
	
	if( [finalView.final_score.text isEqualToString:@"-"] )	finalView.diagnosis.text = @"";
	
	// Diagnosis Colour reading for DB
	if(scale_total.textColor == [UIColor redColor])		colourSelected = @"red";
	if(scale_total.textColor == [UIColor orangeColor])	colourSelected = @"orange";
	if(scale_total.textColor == [UIColor yellowColor])	colourSelected = @"yellow";
	if(scale_total.textColor == [UIColor blueColor])	colourSelected = @"blue";
	if(scale_total.textColor == [UIColor whiteColor])	colourSelected = @"white";
	
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)submitSurveyOperations:(BOOL)dailyOperationsRequired {
    
    // Send the JSON string
    player.successfullySubmitted = [self submitSurveyToServer];
    
    if( dailyOperationsRequired ){
        
        // Alert the user
        if( player.successfullySubmitted ){
            [self displayAlertWithMessage:NSLocalizedString(@"Final_Save_Complete", @"")];
        }else{
            [self displayAlertWithMessage:NSLocalizedString(@"Final_Save_Fail", @"")];
        }
        
        // XML STORAGE: Update the local save
        survey = (Survey *)[SurveysParser loadSurvey];
        [survey.entries addObject:player];
        [SurveysParser saveSurvey:survey];
        
        // Adjust the weight
        NSString *newWeight = [NSString stringWithFormat:@"%f", player.weight];
        [prefs setObject:newWeight forKey:@"Weight"];
        
        // Set the Submit Date as today so as to block the user entering more than one survey
        [prefs setObject:[DoctotHelper returnTodaysDateAsString] forKey:@"LastSurveyDate"];
        
    }
    
    [self popViewController];
    
}

- (void)configureSurveyOutput {
    
    // FINAL SCREEN OUTPUT
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *theBaseURL = [NSURL fileURLWithPath:path];
    
    player.surveyDate = [NSDate date];
    NSDateFormatter *surveyDateFormat = [[NSDateFormatter alloc] init];
    [surveyDateFormat setDateFormat:@"dd-MM-yyyy"];
    NSString *surveyDateString = [surveyDateFormat stringFromDate:player.surveyDate];
    player.dateAsString = surveyDateString;
    
    NSString *htmlFormatMedium = @"<p style='font: 24pt Helvetica;color:#000000;'>";
    NSString *htmlFormatLarge = @"<p style='font: 36pt Helvetica;color:#000000;'>";
    
    htmlOutput = [NSString stringWithFormat:@"<CENTER>%@These are the values entered for %@ Morning Monitoring:</CENTER>", htmlFormatLarge, surveyDateString];
    htmlOutput = [htmlOutput stringByAppendingFormat:@"%@", htmlFormatMedium];
    htmlOutput = [htmlOutput stringByAppendingFormat:@"%@: %.1f %@<BR>", NSLocalizedString(@"WRUPLAYER_Q1", @""), player.weight, player.weightUnits];
    if( ![player.weightStatus isEqualToString:NSLocalizedString(@"WRUPLAYER_WeightNormal", @"")] ){
        htmlOutput = [htmlOutput stringByAppendingFormat:@"WEIGHT ALERT: %@<BR>", player.weightStatus];
    }
    htmlOutput = [htmlOutput stringByAppendingFormat:@"%@: %i:%i<BR>", NSLocalizedString(@"WRUPLAYER_Q2", @""), player.sleepTimeHours, player.sleepTimeMinutes];
    htmlOutput = [htmlOutput stringByAppendingFormat:@"%@: %i:%i<BR>", NSLocalizedString(@"WRUPLAYER_Q3", @""), player.wakeupTimeHours, player.wakeupTimeMinutes];
    htmlOutput = [htmlOutput stringByAppendingFormat:@"%@: %@<BR>", NSLocalizedString(@"WRUPLAYER_Q4", @""), player.medicationTaken];
    
    htmlOutput = [htmlOutput stringByAppendingFormat:@"%@:<UL>", NSLocalizedString(@"WRUPLAYER_Q5", @"")];
    htmlOutput = [htmlOutput stringByAppendingFormat:@"<LI>%@%@: %.1f", htmlFormatMedium, NSLocalizedString(@"WRUPLAYER_Q5_Item0", @""), player.sleepScore];
    if( lowSleepScore ){
        htmlOutput = [htmlOutput stringByAppendingFormat:@" (%@)", player.sleepScoreLow];
    }
    htmlOutput = [htmlOutput stringByAppendingFormat:@"<LI>%@%@: %.1f", htmlFormatMedium, NSLocalizedString(@"WRUPLAYER_Q5_Item1", @""), player.energyScore];
    if( lowEnergyScore ){
        htmlOutput = [htmlOutput stringByAppendingFormat:@" (%@)", player.energyScoreLow];
    }
    htmlOutput = [htmlOutput stringByAppendingFormat:@"<LI>%@%@: %.1f", htmlFormatMedium, NSLocalizedString(@"WRUPLAYER_Q5_Item2", @""), player.moodScore];
    if( lowMoodScore ){
        htmlOutput = [htmlOutput stringByAppendingFormat:@" (%@)", player.moodScoreLow];
    }
    htmlOutput = [htmlOutput stringByAppendingString:@"</UL>"];
    
    htmlOutput = [htmlOutput stringByAppendingFormat:@"%@%@:<UL>", htmlFormatMedium, NSLocalizedString(@"WRUPLAYER_Q9", @"")];
    Injury *thisInjury;
    for(int i = 0; i < [player.injuries count]; i++){
        thisInjury = [[Injury alloc] init];
        thisInjury = (Injury *)[player.injuries objectAtIndex:i];
        htmlOutput = [htmlOutput stringByAppendingFormat:@"<LI>%@%@ (%i)", htmlFormatMedium, thisInjury.area, thisInjury.severity];
    }
    htmlOutput = [htmlOutput stringByAppendingString:@"</UL>"];
    if( [player.injuries count] == 0 ){
        htmlOutput = [htmlOutput stringByAppendingFormat:@"%@", htmlFormatMedium];
        htmlOutput = [htmlOutput stringByAppendingString:@"None<BR>"];
    }
    
    htmlOutput = [htmlOutput stringByAppendingFormat:@"%@%@:<UL>", htmlFormatMedium, NSLocalizedString(@"WRUPLAYER_Q10", @"")];
    Injury *thisStiffness;
    for(int i = 0; i < [player.stiffnesses count]; i++){
        thisStiffness = [[Injury alloc] init];
        thisStiffness = (Injury *)[player.stiffnesses objectAtIndex:i];
        htmlOutput = [htmlOutput stringByAppendingFormat:@"<LI>%@%@ (%i)", htmlFormatMedium, thisStiffness.area, thisStiffness.severity];
    }
    htmlOutput = [htmlOutput stringByAppendingString:@"</UL>"];
    if( [player.stiffnesses count] == 0 ){
        htmlOutput = [htmlOutput stringByAppendingFormat:@"%@", htmlFormatMedium];
        htmlOutput = [htmlOutput stringByAppendingString:@"None<BR>"];
    }
    
    htmlOutput = [htmlOutput stringByAppendingFormat:@"%@", htmlFormatMedium];
    htmlOutput = [htmlOutput stringByAppendingFormat:@"%@: %@<BR>", NSLocalizedString(@"WRUPLAYER_Q11", @""), player.illness];
    htmlOutput = [htmlOutput stringByAppendingFormat:@"%@: %@<BR>", NSLocalizedString(@"WRUPLAYER_Q12", @""), player.commentRecipient];
    
    [finalView.surveyReview loadHTMLString:htmlOutput baseURL:theBaseURL];
    
    // JSON STRING CONSTRUCTION
    
    /* Testing ///////
    Injury *inj1 = [[Injury alloc] init];   inj1.type = @"INJURY";  inj1.area = @"Left ankle";   inj1.severity = 4;  [player.injuries addObject:inj1];
    Injury *inj2 = [[Injury alloc] init];   inj2.type = @"INJURY";  inj2.area = @"Right wrist";   inj2.severity = 2;  [player.injuries addObject:inj2];
    Injury *stiff1 = [[Injury alloc] init];   stiff1.type = @"STIFFNESS";  stiff1.area = @"Neck";   stiff1.severity = 3;  [player.stiffnesses addObject:stiff1];
    Injury *stiff2 = [[Injury alloc] init];   stiff2.type = @"STIFFNESS";  stiff2.area = @"Left hamstring";   stiff2.severity = 2;  [player.stiffnesses addObject:stiff2];
    */////////////////
    
    if( [player.username length] > 0 ) {
        jsonOutput = [NSString stringWithFormat:@"{ \"userName\": \"%@\", ", player.username];
    }
    jsonOutput = [NSString stringWithFormat:@"{ \"wruId\": %i, ", player.wruID];
    if( [player.firstName length] > 0 ) {
        jsonOutput = [jsonOutput stringByAppendingFormat:@"\"firstName\": \"%@\", ", player.firstName];
    }
    if( [player.lastName length] > 0 ) {
        jsonOutput = [jsonOutput stringByAppendingFormat:@"\"lastName\": \"%@\", ", player.lastName];
    }
    jsonOutput = [jsonOutput stringByAppendingFormat:@"\"weight\": %.1f, ", player.weight];
    jsonOutput = [jsonOutput stringByAppendingFormat:@"\"weightStatus\": %@, ", player.weightStatus];
    jsonOutput = [jsonOutput stringByAppendingFormat:@"\"sleepTimeHour\": %i, ", player.sleepTimeHours];
    jsonOutput = [jsonOutput stringByAppendingFormat:@"\"SleepTimeMinute\": %i, ", player.sleepTimeMinutes];
    //jsonOutput = [jsonOutput stringByAppendingFormat:@"\"sleepTimeUnit\": \"%@\", ", player.sleepTimeUnits];
    jsonOutput = [jsonOutput stringByAppendingFormat:@"\"wakeupTimeHour\": %i, ", player.wakeupTimeHours];
    jsonOutput = [jsonOutput stringByAppendingFormat:@"\"wakeupTimeMinute\": %i, ", player.wakeupTimeMinutes];
    //jsonOutput = [jsonOutput stringByAppendingFormat:@"\"wakeupTimeUnit\": \"%@\", ", player.wakeupTimeUnits];
    jsonOutput = [jsonOutput stringByAppendingFormat:@"\"medicationTaken\": \"%@\", ", player.medicationTaken];
    jsonOutput = [jsonOutput stringByAppendingFormat:@"\"sleepScore\": %.1f, ", player.sleepScore];
    jsonOutput = [jsonOutput stringByAppendingFormat:@"\"energyScore\": %.1f, ", player.energyScore];
    jsonOutput = [jsonOutput stringByAppendingFormat:@"\"moodScore\": %.1f, ", player.moodScore];
    if( [player.sleepScoreLow length] > 0 ) {
        jsonOutput = [jsonOutput stringByAppendingFormat:@"\"sleepScoreLow\": \"%@\", ", player.sleepScoreLow];
    }
    if( [player.energyScoreLow length] > 0 ) {
        jsonOutput = [jsonOutput stringByAppendingFormat:@"\"energyScoreLow\": \"%@\", ", player.energyScoreLow];
    }
    if( [player.moodScoreLow length] > 0 ) {
        jsonOutput = [jsonOutput stringByAppendingFormat:@"\"moodScoreLow\": \"%@\", ", player.moodScoreLow];
    }
    jsonOutput = [jsonOutput stringByAppendingFormat:@"\"illness\": \"%@\", ", player.illness];
    jsonOutput = [jsonOutput stringByAppendingFormat:@"\"commentRecipient\": \"%@\", ", player.commentRecipient];
    
    if( ([player.injuries count] == 0) && ([player.stiffnesses count] == 0) ){
        
        jsonOutput = [jsonOutput stringByAppendingString:@""];
    
    }else{
    
        Injury *anInjury;
        jsonOutput = [jsonOutput stringByAppendingString:@"\"injuries\": ["];
        for(int i = 0; i < [player.injuries count]; i++) {
            anInjury = (Injury *)[player.injuries objectAtIndex:i];
            if( i > 0 ){
                jsonOutput = [jsonOutput stringByAppendingString:@", "];
            }
            jsonOutput = [jsonOutput stringByAppendingString:@"{ "];
            jsonOutput = [jsonOutput stringByAppendingFormat:@"\"id\": %i, ", i + 1];
            jsonOutput = [jsonOutput stringByAppendingFormat:@"\"type\": \"%@\", ", anInjury.type];
            jsonOutput = [jsonOutput stringByAppendingFormat:@"\"area\": \"%@\", ", anInjury.area];
            jsonOutput = [jsonOutput stringByAppendingFormat:@"\"severity\": %i ", anInjury.severity];
            jsonOutput = [jsonOutput stringByAppendingString:@"}"];
        }
        Injury *aStiffness;
        for(int i = 0; i < [player.stiffnesses count]; i++) {
            aStiffness = (Injury *)[player.stiffnesses objectAtIndex:i];
            if( (i == 0) && ([player.injuries count] > 0) ){
                jsonOutput = [jsonOutput stringByAppendingString:@", "];
            }
            if( i > 0 ){
                jsonOutput = [jsonOutput stringByAppendingString:@", "];
            }
            jsonOutput = [jsonOutput stringByAppendingString:@"{ "];
            jsonOutput = [jsonOutput stringByAppendingFormat:@"\"id\": %i, ", i + 1];
            jsonOutput = [jsonOutput stringByAppendingFormat:@"\"type\": \"%@\", ", aStiffness.type];
            jsonOutput = [jsonOutput stringByAppendingFormat:@"\"area\": \"%@\", ", aStiffness.area];
            jsonOutput = [jsonOutput stringByAppendingFormat:@"\"severity\": %i ", aStiffness.severity];
            jsonOutput = [jsonOutput stringByAppendingString:@"}"];
        }
        jsonOutput = [jsonOutput stringByAppendingString:@"], "];
        
    }
    
    jsonOutput = [jsonOutput stringByAppendingFormat:@"\"date\": \"%@\"", player.dateAsString];
    
    jsonOutput = [jsonOutput stringByAppendingString:@" }"];
    
    //NSLog(@"jsonOutput: %@", jsonOutput);
    
}

- (BOOL)submitSurveyToServer {
    
    BOOL connectionEstablished = YES;
    
    //NSString *url_string = [[NSString alloc] initWithFormat:@"%@=%@", uploadLocation, htmlOutput];
    NSString *url_string = @"http://www.yahoo.com";
	NSURL *urlToSend = [[NSURL alloc] initWithString:url_string];
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:urlToSend cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
	
	NSData *urlData;
	NSURLResponse *response;
	NSError *error = [[NSError alloc] init];
    urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
	
	long error_code = [error code];
	
	if(error_code == 0){
		connectionEstablished = YES;
	}else{
		connectionEstablished = NO;
	}
    
    return connectionEstablished;
    
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Code to reset a question after User Shake
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)viewDidAppear:(BOOL)animated {
    scaleJustAccessed = YES;
    [self becomeFirstResponder];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if ( event.subtype == UIEventSubtypeMotionShake )
    {
		BOOL shakeResult = [prefs boolForKey:@"ShakeReset"];
		
		if(shakeResult){
			if( (currentQuestionView.item == -1) && (currentQuestionView.clockCounter == 0)){
				if(shakeEnabled){
					shakeEnabled = NO;
					resetScaleAlert = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Reset_ScaleShake", @"") 
									delegate:self cancelButtonTitle:NSLocalizedString(@"Button_Cancel", @"") 
									destructiveButtonTitle:nil
									otherButtonTitles:NSLocalizedString(@"Button_Continue", @"") ,nil, nil, nil, nil];
					[resetScaleAlert showInView:self.view];
				}
			}else{
				[currentQuestionView clearAllButtons];
				[self calculateScaleTotal];
				[currentQuestionView resetClockStatus:YES];
			}
		}
		
    }
	
    if ( [super respondsToSelector:@selector(motionEnded:withEvent:)] )
        [super motionEnded:motion withEvent:event];
}

- (BOOL)canBecomeFirstResponder{ 
	return YES; 
}

//////////////////////////////////////////////

- (void)displayMoreInfoButton{}

- (IBAction)showAlertForCurrentQuestion{}

// WRU Navigation
- (IBAction)navigateBetweenQuestions {

    BOOL reroute = NO;
    
    // Weight
    if( currentPage == 0 ){
        
        q1View.score = player.weight;
        if( player.weight > (player.previousWeight + MAX_WEIGHT_INCREASE) ){
            player.weightStatus = NSLocalizedString(@"WRUPLAYER_WeightOver", @"");
        }else{
            if( player.weight < (player.previousWeight - MAX_WEIGHT_DECREASE) ){
                player.weightStatus = NSLocalizedString(@"WRUPLAYER_WeightUnder", @"");
            }else{
                player.weightStatus = NSLocalizedString(@"WRUPLAYER_WeightNormal", @"");
            }
        }
        /*
        if( [player.weightStatus isEqualToString:NSLocalizedString(@"WRUPLAYER_WeightUnder", @"")] ){
            [self displayAlertWithMessage:NSLocalizedString(@"WRUPLAYER_WeightOsmo", @"")];
        }
        
        if( [player.weightStatus isEqualToString:NSLocalizedString(@"WRUPLAYER_WeightOver", @"")] ){
            [self displayAlertWithMessage:NSLocalizedString(@"WRUPLAYER_WeightGainMessage", @"")];
        }
        */
    }
    
    // Sleep Time
    if( currentPage == 1 ){
        NSDate *theSleepTime = q2View.sleepTime.date;
        NSDateComponents *theSleepTimeComponents = [[NSCalendar currentCalendar] components:NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit fromDate:theSleepTime];
        player.sleepTimeHours = [theSleepTimeComponents hour];
        player.sleepTimeMinutes = [theSleepTimeComponents minute];

        if( player.sleepTimeHours < 12 ){
            player.sleepAMPMIndicator = YES;
        }else{
            player.sleepAMPMIndicator = NO;
        }
    
    }
    
    // Wake Up Time
    if( currentPage == 2 ){
        NSDate *theWakeUpTime = q3View.wakeupTime.date;
        NSDateComponents *theWakeUpTimeComponents = [[NSCalendar currentCalendar] components:NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit fromDate:theWakeUpTime];
        player.wakeupTimeHours = [theWakeUpTimeComponents hour];
        player.wakeupTimeMinutes = [theWakeUpTimeComponents minute];
        
        if( player.wakeupTimeHours < 12 ){
            player.wakeupAMPMIndicator = YES;
        }else{
            player.wakeupAMPMIndicator = NO;
        }
        
    }
    
    // Medication
    if( currentPage == 3 ){
        
        if( q4View.score == 0 ){
            player.medicationTaken = @"No";
        }
        if( q4View.score == 1 ){
            player.medicationTaken = @"Yes";
        }
        
    }
    
    
    // SEM & related questions
    lowSleepScore = NO;
    lowEnergyScore = NO;
    lowMoodScore = NO;
    player.sleepScore = q5View.sleepPowerBar.score;
    player.energyScore = q5View.energyPowerBar.score;
    player.moodScore = q5View.moodPowerBar.score;
    if ( player.sleepScore < 3 ) {     lowSleepScore = YES;    }
    if ( player.energyScore < 3 ) {    lowEnergyScore = YES;    }
    if ( player.moodScore < 3 ) {      lowMoodScore = YES;    }
    
    
    // q7View: Low Energy Score
    if( currentPage == 6 ){
        if( !lowMoodScore ){
            currentPage = currentPage + 1;
        }
    }
    
    // q6View: Low Sleep Score
    if( currentPage == 5 ){
        if( !lowEnergyScore && !lowMoodScore ){
            currentPage = currentPage + 2;
            reroute = lowEnergyScore;
        }else{
            if( lowEnergyScore ){
                currentPage = currentPage + 0;
            }else{
                if( lowMoodScore ){
                    currentPage = currentPage + 1;
                }
            }
        }
    }
    
    // Sleep Energy Mood
    if( currentPage == 4 ){
        
        if( lowSleepScore ){
            currentPage = currentPage + 1;
            reroute = lowSleepScore;
        }else{
            if( lowEnergyScore ){
                currentPage = currentPage + 2;
                reroute = lowEnergyScore;
            }else{
                if( lowMoodScore ){
                    currentPage = currentPage + 3;
                    reroute = lowMoodScore;
                }else{
                    currentPage = currentPage + 3;
                }
            }
        }
        
        [q6View clearAllButtons];
        [q7View clearAllButtons];
        [q8View clearAllButtons];
        
    }
    
    if( currentPage == 11 ){
        /*if( q12View.score == 0 ){
            currentPage = currentPage + 2;
            reroute = YES;
        }*/
        currentPage = currentPage + 2;
        reroute = YES;
    }
  
    if( !reroute ){
        currentPage = currentPage + 1;
    }
    
}

- (IBAction)reverseNavigateQuestions {
    
    if( (currentPage != 6) && (currentPage != 7) && (currentPage != 8) && (currentPage != 13) ){
        currentPage = currentPage - 1;
        return;
    }

    // q7View: Low Energy Score
    if( currentPage == 6 ){
        if( (q6View.item != -1) ){
            currentPage = currentPage - 1;
        }else{
            currentPage = currentPage - 2;
        }
    }
    
    // q8View: Low Mood Score
    if( currentPage == 7 ){
        if( (q7View.item != -1) ){
            currentPage = currentPage - 1;
        }else{
            if( (q6View.item != -1) ){
                currentPage = currentPage - 2;
            }else{
                currentPage = currentPage - 3;
            }
        }
    }
    
    // q9View: Injuries
    if( currentPage == 8 ){
        if( (q8View.item != -1) ){
            currentPage = currentPage - 1;
        }else{
            if( (q7View.item != -1) ){
                currentPage = currentPage - 2;
            }else{
                if( (q6View.item != -1) ){
                    currentPage = currentPage - 3;
                }else{
                    currentPage = currentPage - 4;
                }
            }
        }
    }
    
    // Final View
    if( currentPage == 13 ){
        /*if( q12View.score == 0 ){
            currentPage = currentPage - 2;
        }else{
            currentPage = currentPage - 1;
        }
        */
        currentPage = currentPage - 2;
    }
    
}

- (void)goToQuestionExtended:(NSString *)imageString {
	[[self navigationController] pushViewController:questionExtendedViewController animated:NO];
	[questionExtendedViewController presentButton:imageString];
	[DoctotHelper flipTransition:[[[self navigationController] view] superview] From:@"left"];
}

///////////////////////////

- (void)moveToNextQuestion:(NSInteger)nextPage{
	
	currentPage = nextPage;
	curlDirection = @"Up";
	
	if(currentPage == 0){
		mailComposerViewController = [[MailComposerViewController alloc] initWithNibName:@"MailComposerViewController" bundle:nil];
		currentScaleScore = 0;
	}
	
	[self loadScrollViewWithPage:nextPage ];
	
}

- (IBAction)moveToNextQuestion{
	if(currentPage < (kNumberOfPages-1) ){
        if( currentQuestionView.item != -1 ){
            [self navigateBetweenQuestions];
            curlDirection = @"Up";
            [currentQuestionView confirmButtonsForOption:currentQuestionView.item];
            [self loadScrollViewWithPage:currentPage];
        }
	}
}

- (IBAction)moveToPreviousQuestion{
	if(currentPage > 0){
        [self reverseNavigateQuestions];
		curlDirection = @"Down";
		[currentQuestionView confirmButtonsForOption:currentQuestionView.item];
		[self loadScrollViewWithPage:currentPage];
	}
}

// user clicked the "i" button
- (IBAction)goToInfoScreen {
    return;
	infoScale = scaleId;
	[[self navigationController] pushViewController:infoViewController animated:NO];
	[DoctotHelper flipTransition:[[[self navigationController] view] superview] From:@"left"];
}


- (IBAction)startTest:(id)sender
{
    NSString *lastSurveyDate = [prefs objectForKey:@"LastSurveyDate"];
    if( [lastSurveyDate isEqualToString:[DoctotHelper returnTodaysDateAsString]] ){
        [self displayAlertWithMessage:NSLocalizedString(@"Save_Conflict", @"")];
    }else{
        scaleJustAccessed = NO;
        [startView removeFromSuperview];
        [self moveToNextQuestion:0];
    }
}

- (IBAction)returnToStart {
	[self.view addSubview:startView];
}

- (IBAction)goToSavedScores {
	[[self navigationController] pushViewController:savedScore animated:NO];
	[DoctotHelper flipTransition:[[[self navigationController] view] superview] From:@"left"];
	[savedScore.tableView reloadData];
}

- (IBAction)goToSurveys:(id)sender
{
    surveyController = [[SurveyController alloc] initWithNibName:@"SurveyController" bundle:nil];
	[[self navigationController] pushViewController:surveyController animated:YES];
    [surveyController setup];
    [surveyController release];
}

- (void)displayAlertWithMessage:(NSString *)message {
	
	readyForSave = FALSE;
	
	UIActionSheet *styleAlert =
	[[UIActionSheet alloc] initWithTitle:message 
								delegate:self
					   cancelButtonTitle:NSLocalizedString(@"Button_OK", @"")
				  destructiveButtonTitle:nil
					   otherButtonTitles: nil, nil, nil, nil, nil];
	[styleAlert showInView:self.view];
	[styleAlert release];
	
}

- (void)displayOptionAlertWithMessage:(NSString *)message {
	
	readyForSave = FALSE;
	
	saveConfirmation =
	[[UIActionSheet alloc] initWithTitle:message
								delegate:self
					   cancelButtonTitle:NSLocalizedString(@"Button_Cancel", @"")
				  destructiveButtonTitle:nil
					   otherButtonTitles:NSLocalizedString(@"Button_Continue", @""), nil, nil, nil, nil];
	[saveConfirmation showInView:self.view];
	[saveConfirmation release];
	
}


@end
