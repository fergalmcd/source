//
//  FavouriteDetail.m
//  IPHA
//
//  Created by Fergal McDonnell on 24/02/2014.
//
//

#import "SurveyDetail.h"
#import "Scale_HQ.h"
#import "SurveysParser.h"
#import "WRUPlayerAppDelegate.h"
#import "MainViewController.h"
#import "Scale_HQ.h"
#import "SurveyController.h"

@interface SurveyDetail ()

@end

@implementation SurveyDetail

@synthesize detailsView, detailsInfo, detailsContent;
@synthesize detailPlayer, resubmitButton, location, survey;

UIButton *detailsBackButton;
UIBarButtonItem *detailsBackButtonItem;
UIButton *detailsEditButton;
UIBarButtonItem *detailsEditButtonItem;
NSString *theHTMLContent;
Scale_HQ *resubmission;

WRUPlayerAppDelegate *appDelegate;
MainViewController *theMainViewController;
Scale_HQ *currentViewController;
SurveyController *theSurveyController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Set the Title
    self.title = detailPlayer.dateAsString;
    
    // Set Up the Top Left of the Nav Bar
	detailsBackButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 43, 49)];
    [detailsBackButton setBackgroundImage:[UIImage imageNamed:@"icon_back.png"] forState:UIControlStateNormal];
    [detailsBackButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
	detailsBackButtonItem = [[UIBarButtonItem alloc] initWithCustomView:detailsBackButton];
	self.navigationItem.leftBarButtonItem = detailsBackButtonItem;
    
    [resubmitButton setTitle:NSLocalizedString(@"Screen_Resubmit", @"") forState:UIControlStateNormal];
    
    theHTMLContent = [NSString stringWithFormat:@"%@%@ - %.1f <BR>", NSLocalizedString(@"Screen_Font", @""), NSLocalizedString(@"WRUPLAYER_Q1", @""), detailPlayer.weight];
    theHTMLContent = [theHTMLContent stringByAppendingFormat:@"%@ - %i:%i<BR>", NSLocalizedString(@"WRUPLAYER_Q2", @""), detailPlayer.sleepTimeHours, detailPlayer.sleepTimeMinutes];
    theHTMLContent = [theHTMLContent stringByAppendingFormat:@"%@ - %i:%i<BR>", NSLocalizedString(@"WRUPLAYER_Q3", @""), detailPlayer.wakeupTimeHours, detailPlayer.wakeupTimeMinutes];
    theHTMLContent = [theHTMLContent stringByAppendingFormat:@"%@ - %@<BR>", NSLocalizedString(@"WRUPLAYER_Q4", @""), detailPlayer.medicationTaken];
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *theBaseURL = [NSURL fileURLWithPath:path];
    [detailsContent loadHTMLString:theHTMLContent baseURL:theBaseURL];
    
    if( detailPlayer.successfullySubmitted ){
        resubmitButton.hidden = YES;
    }
    
    appDelegate = (WRUPlayerAppDelegate *)[[UIApplication sharedApplication] delegate];
    theMainViewController = (MainViewController *)appDelegate.mainViewController;
    currentViewController = (Scale_HQ *)theMainViewController.targetViewController;
    theSurveyController = (SurveyController *)currentViewController.surveyController;
    
}

- (void)viewDidAppear:(BOOL)animated {

    
    
}

- (void)setup:(Player *)selectedPlayer atLocation:(int)theLocation {
    
    detailPlayer = selectedPlayer;
    location = theLocation;
  
}

- (IBAction)resubmitPlayer {
    
    resubmission = [[Scale_HQ alloc] init];
    resubmission.player = detailPlayer;
    [resubmission submitSurveyOperations:NO];
    detailPlayer = resubmission.player;
    
    // Update the XML
    if( detailPlayer.successfullySubmitted ){
        survey = (Survey *)[SurveysParser loadSurvey];
        [survey.entries removeObjectAtIndex:location];
        [survey.entries addObject:detailPlayer];
        [SurveysParser saveSurvey:survey];
    }
    
    [self popViewController];
    [theSurveyController.surveyTable reloadData];
    
}

- (void)popViewController{
    
    [[self navigationController] popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
