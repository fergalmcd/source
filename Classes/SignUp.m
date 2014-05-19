//
//  SignUp.m
//  WRUPlayer
//
//  Created by Fergal McDonnell on 22/04/2014.
//  Copyright Tailteann 2014. All rights reserved.
//

#import "SignUp.h"
#import "Constants.h"


@implementation SignUp

@synthesize welcome_message, first_name_label, last_name_label, email_label, password_label, warning_label, warning_image, first_name, last_name, email, password, register_app_background, register_app;

BOOL repositioned;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
	[welcome_message release];
	[first_name_label release];
	[last_name_label release];
	[email_label release];
    [password_label release];
	[warning_label release];
	[warning_image release];
	[first_name release];
	[last_name release];
	[email release];
	[password release];
	[register_app_background release];
	[register_app release];
	
    [super dealloc];
}


- (void)go{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowSignup:) name:UIKeyboardWillShowNotification object:nil];
		
	welcome_message.text = NSLocalizedString(@"Registration", @"");
	first_name_label.text = NSLocalizedString(@"Save_FullName", @"");
	last_name_label.text = NSLocalizedString(@"Final_Insert_Last_Name", @"");
	email_label.text = NSLocalizedString(@"Save_Email", @"");
	password_label.text = NSLocalizedString(@"Save_Password", @"");
	warning_label.text = @"";
	[warning_image setImage:[UIImage imageNamed:@""]];
	
	//[register_app_background setImage:[UIImage imageNamed:registrationBackground]];
	[register_app setTitle:NSLocalizedString(@"Button_Submit", @"") forState:UIControlStateNormal];
	//[register_app setBackgroundImage:[UIImage imageNamed:resetButton] forState:UIControlStateNormal];
	[register_app setBackgroundImage:[UIImage imageNamed:resetButtonDown] forState:UIControlStateSelected];

	repositioned = FALSE;
}


- (void)keyboardWillShowSignup:(NSNotification *)note
{
	if(!repositioned){
        
        CGRect rect;
        
        rect =  self.frame;
        rect.origin.y -= regPageRaiseObjectsBy;
        self.frame = rect;
        
	}
	repositioned = TRUE;
}

- (void)resetPositionOfTextfield:(UITextField *)text_field
{
	CGRect rect;
	
	rect =  text_field.frame;
	rect.origin.y -= regPageRaiseObjectsBy;
	text_field.frame = rect;	
}

- (void)resetPositionOfLabel:(UILabel *)text_label
{
	CGRect rect;
	
	rect =  text_label.frame;
	rect.origin.y -= regPageRaiseObjectsBy;
	text_label.frame = rect;	
}

- (void)resetPositionOfImage:(UIImageView *)background_image
{
	CGRect rect;
	
	rect =  background_image.frame;
	rect.origin.y -= regPageRaiseObjectsBy;
	background_image.frame = rect;	
}

- (void)resetPositionOfButton:(UIButton *)button
{
	CGRect rect;
	
	rect =  button.frame;
	rect.origin.y -= regPageRaiseObjectsBy;
	button.frame = rect;	
}

- (void)buttonClicked:(NSNotification *)noteButton
{
	[email resignFirstResponder];
    [password resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	
	NSString *tempStr;
	
	if (theTextField == email) {
		tempStr = [[NSString alloc] initWithFormat:@"%@", password.text];
		[password becomeFirstResponder];
		password.text = [[NSString alloc] initWithFormat:@"%@", tempStr];
    }
	if (theTextField == password) {
		tempStr = [[NSString alloc] initWithFormat:@"%@", email.text];
		[email becomeFirstResponder];
		email.text = [[NSString alloc] initWithFormat:@"%@", tempStr];
    }
	
	[tempStr release];
	
    return YES;
}


@end
