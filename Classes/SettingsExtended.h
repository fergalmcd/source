//
//  SettingsExtended.h
//  WRUPlayer
//
//  Created by Fergal McDonnell on 22/04/2014.
//  Copyright Tailteann 2014. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DoctotHelper.h"


@interface SettingsExtended : UIView <UITextFieldDelegate> {

	IBOutlet UINavigationBar *navigation_bar;
	IBOutlet UINavigationItem *navigation_item;
	IBOutlet UIScrollView *scrollView;
	
	IBOutlet UILabel *first_name_label;
	IBOutlet UILabel *last_name_label;
	IBOutlet UILabel *email_label;
	
	IBOutlet UITextField *first_name;
	IBOutlet UITextField *last_name;
	IBOutlet UITextField *email;

	IBOutlet UILabel *max_save_instruction;
	IBOutlet UISlider *max_save_slider;
	IBOutlet UIImageView *max_save_track;
	IBOutlet UILabel *max_save;
	
	IBOutlet UILabel *max_save_for_display;
	IBOutlet UILabel *owner_details;
    
    UIDatePicker *dailyNotificationTimer;
    UIDatePicker *sleepTimer;
    UIDatePicker *wakeUpTimer;
    
    UILabel *outputTime;
    UIButton *outputTimeConfirm;
    
}

@property (nonatomic, retain) UINavigationBar *navigation_bar;
@property (nonatomic, retain) UINavigationItem *navigation_item;
@property (nonatomic, retain) UIScrollView *scrollView;

@property (nonatomic, retain) UILabel *first_name_label;
@property (nonatomic, retain) UILabel *last_name_label;
@property (nonatomic, retain) UILabel *email_label;
@property (nonatomic, retain) UITextField *first_name;
@property (nonatomic, retain) UITextField *last_name;
@property (nonatomic, retain) UITextField *email;

@property (nonatomic, retain) UILabel *max_save_instruction;
@property (nonatomic, retain) UISlider *max_save_slider;
@property (nonatomic, retain) UIImageView *max_save_track;
@property (nonatomic, retain) UILabel *max_save;

@property (nonatomic, retain) UILabel *max_save_for_display;
@property (nonatomic, retain) UILabel *owner_details;

@property (nonatomic, retain) IBOutlet UIDatePicker *dailyNotificationTimer;
@property (nonatomic, retain) IBOutlet UIDatePicker *sleepTimer;
@property (nonatomic, retain) IBOutlet UIDatePicker *wakeUpTimer;

@property (nonatomic, retain) IBOutlet UILabel *outputTime;
@property (nonatomic, retain) IBOutlet UIButton *outputTimeConfirm;

- (void)go:(NSString *)context;
- (IBAction)updateFirstName;
- (IBAction)updateLastName;
- (IBAction)updateEmail;
- (IBAction)updateMaxSavesAllowed;
- (IBAction)dismissView;
- (IBAction)updateDefaultTimer:(id)sender;


@end
