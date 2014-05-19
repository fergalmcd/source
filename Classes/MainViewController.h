//
//  MainViewController.h
//  WRUPlayer
//
//  Created by Fergal McDonnell on 22/04/2014.
//  Copyright Tailteann 2014. All rights reserved.
//
// Abstract:   The application's main view controller (front page).
//

#import <UIKit/UIKit.h>

@class DocTOT_Info;

@interface MainViewController : UIViewController < UINavigationBarDelegate >
{
	IBOutlet UILabel *welcome_label;
	
	IBOutlet UIButton *wru_player;
	IBOutlet UIButton *about;
	IBOutlet UIButton *settings;
	
	DocTOT_Info	*overviewController;
    UIViewController *targetViewController;
}

@property (nonatomic, retain) UILabel *welcome_label;
@property (nonatomic, retain) UIButton *wru_player;
@property (nonatomic, retain) UIButton *about;
@property (nonatomic, retain) UIButton *settings;
@property (nonatomic, retain) IBOutlet UIViewController *targetViewController;

- (IBAction)goToScale:(id)sender;


@end
