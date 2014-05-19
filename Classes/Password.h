//
//  Password.h
//  WRUPlayer
//
//  Created by Fergal McDonnell on 22/04/2014.
//  Copyright Tailteann 2014. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DoctotHelper.h"


@interface Password : UIView {
	UINavigationBar *navigation_bar;
	UINavigationItem *navigation_item;
	
	UILabel *password_label;
	UILabel *warning_label;
	UIImageView *warning_image;
	UITextField *password;
	UITextField *password_char1;
	UITextField *password_char2;
	UITextField *password_char3;
	UITextField *password_char4;
	UIButton *clearPassword;
	UIImageView *login_background;
	
	NSString *passwordToDate;
}

@property (nonatomic, retain) IBOutlet UINavigationBar *navigation_bar;
@property (nonatomic, retain) IBOutlet UINavigationItem *navigation_item;

@property (nonatomic, retain) IBOutlet UILabel *password_label;
@property (nonatomic, retain) IBOutlet UILabel *warning_label;
@property (nonatomic, retain) IBOutlet UIImageView *warning_image;
@property (nonatomic, retain) IBOutlet UITextField *password_char1;
@property (nonatomic, retain) IBOutlet UITextField *password_char2;
@property (nonatomic, retain) IBOutlet UITextField *password_char3;
@property (nonatomic, retain) IBOutlet UITextField *password_char4;
@property (nonatomic, retain) IBOutlet UIButton *clearPassword;
@property (nonatomic, retain) IBOutlet UIImageView *login_background;

@property (nonatomic, retain) IBOutlet NSString *passwordToDate;

- (void)go;
- (void)goUpdate;
- (void)pressButton:(int)button_num;
- (IBAction)press1;
- (IBAction)press2;
- (IBAction)press3;
- (IBAction)press4;
- (IBAction)press5;
- (IBAction)press6;
- (IBAction)press7;
- (IBAction)press8;
- (IBAction)press9;
- (IBAction)press0;
- (IBAction)clearLastDigit;
- (void)removeWarning;
- (void)attemptLogin;
- (IBAction)resetPassword;
- (void)clearPasswordProtection;
- (void)dismissView;


@end