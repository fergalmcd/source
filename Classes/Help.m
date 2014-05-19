//
//  Help.m
//  WRUPlayer
//
//  Created by Fergal McDonnell on 22/04/2014.
//  Copyright 2014 Tailteann. All rights reserved.
//

#import "Help.h"


@implementation Help


@synthesize scrollView;
@synthesize previous, next;
@synthesize questionOverviewView, questionAnsweredView, shakeToResetView, savedScoresView, settingsView, stopwatchView;
@synthesize heading;

HelpView *currentHelpView;

int currentHelpPage = 1;
int maxHelpPage = 6;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	heading.textColor = [[UIColor alloc] initWithRed:help_headingColour_Red green:help_headingColour_Green blue:help_headingColour_Blue alpha:1.0];
    
    // Set Up the Top Left of the Nav Bar
    UIButton* leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 43, 49)];
	[leftButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setImage:[UIImage imageNamed:@"icon_back.png"] forState:UIControlStateNormal];
	UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
	currentHelpView = [[HelpView alloc] init];
	[questionOverviewView setUpView:1];
	[questionAnsweredView setUpView:2];
	[shakeToResetView setUpView:3];
	[savedScoresView setUpView:4];
	[settingsView setUpView:5];
	[stopwatchView setUpView:6];
	
	[self goToHelpPage];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (IBAction)goToSpecificHelpPage:(int)newPage {
	currentHelpPage = newPage;
	[self goToHelpPage];
}

- (IBAction)goToPreviousHelpPage {
	currentHelpPage = currentHelpPage - 1;
	if(currentHelpPage == 0){
		currentHelpPage = maxHelpPage;
	}
	[self goToHelpPage];
}

- (IBAction)goToNextHelpPage {
	currentHelpPage = currentHelpPage + 1;
	if(currentHelpPage > maxHelpPage){
		currentHelpPage = 1;
	}
	[self goToHelpPage];
}

- (void)goToHelpPage {
	
	[currentHelpView removeFromSuperview];
	
	if(currentHelpPage == 1)	currentHelpView = questionOverviewView;
	if(currentHelpPage == 2)	currentHelpView = questionAnsweredView;
	if(currentHelpPage == 3)	currentHelpView = shakeToResetView;
	if(currentHelpPage == 4)	currentHelpView = savedScoresView;
	if(currentHelpPage == 5)	currentHelpView = settingsView;
	if(currentHelpPage == 6)	currentHelpView = stopwatchView;
	
	scrollView.contentSize = CGSizeMake( currentHelpView.frame.size.width , currentHelpView.frame.size.height );
	
	heading.text = currentHelpView.heading.text;
	self.navigationItem.title = currentHelpView.heading.text;
	
	[scrollView addSubview:currentHelpView];
	scrollView.contentOffset = CGPointMake(0 ,0);
}

- (void)popViewController {
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)dealloc {
	[scrollView release];
	[previous release];
	[next release];
	
	[currentHelpView release];
	[questionOverviewView release];
	[questionAnsweredView release];
	[shakeToResetView release];
	[savedScoresView release];
	[settingsView release];
	[stopwatchView release];
	
	[heading release];
	
    [super dealloc];
}


@end
