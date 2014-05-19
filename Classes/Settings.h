//
//  Settings.h
//  WRUPlayer
//
//  Created by Fergal McDonnell on 22/04/2014.
//  Copyright Tailteann 2014. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DoctotHelper.h"
#import "Password.h"
#import "SettingsExtended.h"


@interface Settings : UIView {
	
    UIScrollView *scrollView;
    UITableView *groupedTable;
	
    UILabel *owner_details_label;
    UILabel *password_label;
    UILabel *automaticEmail_label;
    UILabel *weightUnits_label;
    UILabel *shakeReset_label;
	
    UISwitch *passwordSwitch;
    UISwitch *automaticEmailSwitch;
    UISwitch *shakeResetSwitch;
    UISwitch *weightUnitsSwitch;
    Password *changePassword;
	
    UIButton *maxSavesUpdateButton;
    UIButton *ownerDetailsUpdateButton;

    UIButton *dailyNotificationUpdateButton;
    UIButton *sleepTimeUpdateButton;
    UIButton *wakeUpTimeUpdateButton;
    
    SettingsExtended *dailyNotificationUpdate;
    SettingsExtended *sleepTimeUpdate;
    SettingsExtended *wakeUpTimeUpdate;
    SettingsExtended *userDetailUpdate;
    SettingsExtended *maxSavesUpdate;
	
    UIView *owner_details_view;    

}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UITableView *groupedTable;

@property (nonatomic, retain) IBOutlet UILabel *owner_details_label;
@property (nonatomic, retain) IBOutlet UILabel *password_label;
@property (nonatomic, retain) IBOutlet UILabel *automaticEmail_label;
@property (nonatomic, retain) IBOutlet UILabel *weightUnits_label;
@property (nonatomic, retain) IBOutlet UILabel *shakeReset_label;

@property (nonatomic, retain) IBOutlet UISwitch *passwordSwitch;
@property (nonatomic, retain) IBOutlet UISwitch *automaticEmailSwitch;
@property (nonatomic, retain) IBOutlet UISwitch *shakeResetSwitch;
@property (nonatomic, retain) IBOutlet UISwitch *weightUnitsSwitch;
@property (nonatomic, retain) IBOutlet Password *changePassword;

@property (nonatomic, retain) IBOutlet UIButton *maxSavesUpdateButton;
@property (nonatomic, retain) IBOutlet UIButton *ownerDetailsUpdateButton;
@property (nonatomic, retain) IBOutlet UIButton *dailyNotificationUpdateButton;
@property (nonatomic, retain) IBOutlet UIButton *sleepTimeUpdateButton;
@property (nonatomic, retain) IBOutlet UIButton *wakeUpTimeUpdateButton;

@property (nonatomic, retain) IBOutlet SettingsExtended *dailyNotificationUpdate;
@property (nonatomic, retain) IBOutlet SettingsExtended *sleepTimeUpdate;
@property (nonatomic, retain) IBOutlet SettingsExtended *wakeUpTimeUpdate;
@property (nonatomic, retain) IBOutlet SettingsExtended *userDetailUpdate;
@property (nonatomic, retain) IBOutlet SettingsExtended *maxSavesUpdate;

@property (nonatomic, retain) IBOutlet UIView *owner_details_view;

- (void)go;
- (IBAction)togglePassword;
- (IBAction)toggleAutomaticEmail;
- (IBAction)toggleShakeReset;
- (IBAction)goToChangePassword;
- (IBAction)removePasswordProtection;

- (IBAction)goToMaxSavesUpdate;
- (IBAction)goToOwnerDetailsUpdate;
- (IBAction)goToDefaultTimeFor:(UIButton *)sender;

- (UIView *)returnRowViewForSection:(NSInteger)section AndSectionRow:(NSInteger)row;


@end
