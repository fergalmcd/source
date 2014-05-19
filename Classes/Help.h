//
//  Help.h
//  WRUPlayer
//
//  Created by Fergal McDonnell on 22/04/2014.
//  Copyright 2014 Tailteann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HelpView.h"
#import "Constants.h"


@interface Help : UIViewController {
	UIScrollView *scrollView;
	
	UIButton *previous;
	UIButton *next;
	
	HelpView *questionOverviewView;
	HelpView *questionAnsweredView;
	HelpView *shakeToResetView;
	HelpView *savedScoresView;
	HelpView *settingsView;
	HelpView *stopwatchView;
	
	UILabel *heading;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIButton *previous;
@property (nonatomic, retain) IBOutlet UIButton *next;
@property (nonatomic, retain) IBOutlet HelpView *questionOverviewView;
@property (nonatomic, retain) IBOutlet HelpView *questionAnsweredView;
@property (nonatomic, retain) IBOutlet HelpView *shakeToResetView;
@property (nonatomic, retain) IBOutlet HelpView *savedScoresView;
@property (nonatomic, retain) IBOutlet HelpView *settingsView;
@property (nonatomic, retain) IBOutlet HelpView *stopwatchView;
@property (nonatomic, retain) IBOutlet UILabel *heading;

- (IBAction)goToSpecificHelpPage:(int)newPage;
- (IBAction)goToPreviousHelpPage;
- (IBAction)goToNextHelpPage;
- (void)goToHelpPage;


@end
