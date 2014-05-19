//
//  MainViewController.m
//  WRUPlayer
//
//  Created by Fergal McDonnell on 22/04/2014.
//  Copyright Tailteann 2014. All rights reserved.
//
// Abstract:   The application's main view controller (front page).
//


#import "MainViewController.h"

#import "Scale_HQ.h"
#import "DoctotHelper.h"
#import "DocTOT_Info.h"
#import "Constants.h"


@implementation MainViewController

@synthesize welcome_label;
@synthesize wru_player, about, settings;
@synthesize targetViewController;

NSUserDefaults *prefs;

- (void)awakeFromNib
{
	// make the title of this page the same as the title of this app
	//self.title = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];	
	self.title = NSLocalizedString(@"DocTOTHomeTitle", @"");
	overviewController = [[DocTOT_Info alloc] initWithNibName:@"DocTOT_Info" bundle:nil];
	NSArray *ver = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    if ([[ver objectAtIndex:0] intValue] >= 7) {
        self.navigationController.navigationBar.barTintColor = [[UIColor alloc] initWithRed:headerColour_Red green:headerColour_Green blue:headerColour_Blue alpha:headerColour_Alpha];
        self.navigationController.navigationBar.translucent = NO;
    }else {
        self.navigationController.navigationBar.tintColor = [[UIColor alloc] initWithRed:headerColour_Red green:headerColour_Green blue:headerColour_Blue alpha:headerColour_Alpha];
    }
	
	// Set Up the Top Left of the Nav Bar
	UIButton* leftButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 43, 49)];
	[leftButton setBackgroundImage:[UIImage imageNamed:@"icon_settings.png"] forState:UIControlStateNormal];
	[leftButton addTarget:self action:@selector(goToSettings:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
	self.navigationItem.leftBarButtonItem = leftButtonItem;
	
	// Set Up the Top Right of the Nav Bar
	UIButton* rightButton = [[UIButton alloc] initWithFrame:CGRectMake(300, 10, 43, 49)];
	[rightButton setBackgroundImage:[UIImage imageNamed:@"icon_info.png"] forState:UIControlStateNormal];
	[rightButton addTarget:self action:@selector(goToInfo:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
	self.navigationItem.rightBarButtonItem = rightButtonItem;
	
	// Set Up the Navigation Buttons	 
	[wru_player setTitle:[[NSString alloc] initWithFormat:@"%@", NSLocalizedString(@"PageOneTitle", @"")] forState:UIControlStateNormal];
	[about setTitle:[[NSString alloc] initWithFormat:@"%@", NSLocalizedString(@"DocTOTAboutTitle", @"")] forState:UIControlStateNormal];
	[about addTarget:self action:@selector(goToInfo:) forControlEvents:UIControlEventTouchUpInside];
	[settings setTitle:[[NSString alloc] initWithFormat:@"%@", NSLocalizedString(@"DocTOTSettingsTitle", @"")] forState:UIControlStateNormal];
	[settings addTarget:self action:@selector(goToSettings:) forControlEvents:UIControlEventTouchUpInside];
    
    // Initialising the Settings Screen
    [self goToSettings:settings];
    [[overviewController navigationController] popViewControllerAnimated:NO];
    
}

- (IBAction)goToInfo:(id)sender
{
	[[self navigationController] pushViewController:overviewController animated:YES];
	[overviewController goToInfo];
}

- (IBAction)goToSettings:(id)sender
{
	[[self navigationController] pushViewController:overviewController animated:YES];
	[overviewController goToSettings];
}

- (IBAction)goToScale:(id)sender
{	
	prefs = [NSUserDefaults standardUserDefaults];
	
	if (sender == wru_player){
		[prefs setObject:scale1Id forKey:@"CurrentScale"];
		targetViewController = [[Scale_HQ alloc] initWithNibName:@"WRUPlayer_HQ" bundle:nil];
	} 
	
	[[self navigationController] pushViewController:targetViewController animated:YES];
}

#pragma mark UIViewController delegates

- (void)viewWillAppear:(BOOL)animated{}

- (void)viewDidAppear:(BOOL)animated{
	// Welcome Message
	prefs = [NSUserDefaults standardUserDefaults];
	welcome_label.text = [[NSString alloc] initWithFormat:@"%@ %@", NSLocalizedString(@"Simple_Welcome", @""), [prefs stringForKey:@"FirstName"] ];
}

- (void)dealloc
{
	[overviewController release];
	[targetViewController release];
	[prefs release];
	[welcome_label release];
	[about release];	[settings release];
	
	[super dealloc];
}


@end

