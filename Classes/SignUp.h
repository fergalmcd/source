//
//  SignUp.h
//  WRUPlayer
//
//  Created by Fergal McDonnell on 22/04/2014.
//  Copyright Tailteann 2014. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SignUp : UIView <UITextFieldDelegate> {
    UILabel *welcome_message;
    UILabel *first_name_label;
    UILabel *last_name_label;
    UILabel *email_label;
    UILabel *password_label;
    UILabel *warning_label;
    UIImageView *warning_image;
	
    UITextField *first_name;
    UITextField *last_name;
    UITextField *email;
    UITextField *password;
    UIImageView *register_app_background;
    UIButton *register_app;
}

@property (nonatomic, retain) IBOutlet UILabel *welcome_message;
@property (nonatomic, retain) IBOutlet UILabel *first_name_label;
@property (nonatomic, retain) IBOutlet UILabel *last_name_label;
@property (nonatomic, retain) IBOutlet UILabel *email_label;
@property (nonatomic, retain) IBOutlet UILabel *password_label;
@property (nonatomic, retain) IBOutlet UILabel *warning_label;
@property (nonatomic, retain) IBOutlet UIImageView *warning_image;
@property (nonatomic, retain) IBOutlet UITextField *first_name;
@property (nonatomic, retain) IBOutlet UITextField *last_name;
@property (nonatomic, retain) IBOutlet UITextField *email;
@property (nonatomic, retain) IBOutlet UITextField *password;
@property (nonatomic, retain) IBOutlet UIImageView *register_app_background;
@property (nonatomic, retain) IBOutlet UIButton *register_app;

- (void)go;
- (void)resetPositionOfTextfield:(UITextField *)text_field;
- (void)resetPositionOfLabel:(UILabel *)text_label;
- (void)resetPositionOfImage:(UIImageView *)background_image;
- (void)resetPositionOfButton:(UIButton *)button;

@end
