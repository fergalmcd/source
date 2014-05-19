//
//  DocTOT_Info.h
//  WRUPlayer
//
//  Created by Fergal McDonnell on 22/04/2014.
//  Copyright Tailteann 2014. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "Settings.h"

@interface DocTOT_Info : UIViewController < UINavigationBarDelegate >
{
	IBOutlet UILabel *welcomeLabel;
	IBOutlet UILabel *appName;
	IBOutlet UILabel *copyright;
	IBOutlet UIWebView *spielLabel;
	IBOutlet UILabel *sponsorLabel;
	IBOutlet UILabel *sponsorAddInfoLabel;
	IBOutlet UILabel *sponsorURL;
	IBOutlet UIButton *sponsorButton;
	
	IBOutlet Settings *settings;
}

@property (nonatomic, retain) UILabel *welcomeLabel;
@property (nonatomic, retain) UILabel *appName;
@property (nonatomic, retain) UILabel *copyright;
@property (nonatomic, retain) UIWebView *spielLabel;
@property (nonatomic, retain) UILabel *sponsorLabel;
@property (nonatomic, retain) UILabel *sponsorAddInfoLabel;
@property (nonatomic, retain) UILabel *sponsorURL;
@property (nonatomic, retain) UIButton *sponsorButton;

@property (nonatomic, retain) Settings *settings;

- (IBAction)goToInfo;
- (IBAction)goToSettings;
- (IBAction)goToSponsorSite;


@end
