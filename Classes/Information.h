//
//  Information.h
//  WRUPlayer
//
//  Created by Fergal McDonnell on 22/04/2014.
//  Copyright Tailteann 2014. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoItem.h"
#import "HelpContents.h"
#import "Help.h"


@interface Information : UIViewController {
	
	UITableView *groupedTable;
	
	UILabel *heading;
	UILabel *subHeading;
	UILabel *reference;
	UILabel *infoitem1_label;
	UILabel *infoitem1;
	UILabel *infoitem2_label;
	UILabel *infoitem2;
	UILabel *infoitem3_label;
	UILabel *infoitem3;
	UILabel *infoitem4_label;
	UILabel *infoitem4;
	/*
	UIButton *overview;
	UIButton *mainPurpose;
	UIButton *commentary;
	UIButton *additionalReferences;
	UIButton *address;
	UIButton *scoring;
	UIButton *versions;
	UIButton *help;
	*/
	UIBarButtonItem *backButtonItem;
	UIButton *backButton;
	
	UILabel *currentLabelText;
	InfoItem *infoItem;
	HelpContents *helpContentsViewController;
	Help *helpViewController;
}

@property (nonatomic, retain) IBOutlet UITableView *groupedTable;
/*
@property (nonatomic, retain) IBOutlet UIButton *overview;
@property (nonatomic, retain) IBOutlet UIButton *mainPurpose;
@property (nonatomic, retain) IBOutlet UIButton *commentary;
@property (nonatomic, retain) IBOutlet UIButton *additionalReferences;
@property (nonatomic, retain) IBOutlet UIButton *address;
@property (nonatomic, retain) IBOutlet UIButton *scoring;
@property (nonatomic, retain) IBOutlet UIButton *versions;
@property (nonatomic, retain) IBOutlet UIButton *help;
*/
@property (nonatomic, retain) IBOutlet UILabel *heading;
@property (nonatomic, retain) IBOutlet UILabel *subHeading;
@property (nonatomic, retain) IBOutlet UILabel *reference;
@property (nonatomic, retain) IBOutlet UILabel *infoitem1_label;
@property (nonatomic, retain) IBOutlet UILabel *infoitem1;
@property (nonatomic, retain) IBOutlet UILabel *infoitem2_label;
@property (nonatomic, retain) IBOutlet UILabel *infoitem2;
@property (nonatomic, retain) IBOutlet UILabel *infoitem3_label;
@property (nonatomic, retain) IBOutlet UILabel *infoitem3;
@property (nonatomic, retain) IBOutlet UILabel *infoitem4_label;
@property (nonatomic, retain) IBOutlet UILabel *infoitem4;

@property (nonatomic, retain) IBOutlet UILabel *currentLabelText;

@property (nonatomic, retain) InfoItem *infoItem;
@property (nonatomic, retain) HelpContents *helpContentsViewController;
@property (nonatomic, retain) Help *helpViewController;
@property (nonatomic, retain) UIBarButtonItem *backButtonItem;
@property (nonatomic, retain) UIButton *backButton;

- (IBAction)setTextForOverview;
- (IBAction)setTextForMainPurpose;
- (IBAction)setTextForCommentary;
- (IBAction)setTextForScoring;
- (IBAction)setTextForVersion;
- (IBAction)setTextForAdditionalReferences;
- (IBAction)setTextForAddress;
- (void)transitionToInfoItem;
- (IBAction)goToHelpSection;
- (void)flipTransition;

- (void)setInfoFor:(NSString *)scale;

@end
