//
//  Password.m
//  WRUPlayer
//
//  Created by Fergal McDonnell on 22/04/2014.
//  Copyright Tailteann 2014. All rights reserved.
//

#import "Password.h"
#import "Constants.h"


@implementation Password

@synthesize navigation_bar, navigation_item;
@synthesize password_label, warning_label, warning_image, login_background;
@synthesize password_char1, password_char2, password_char3, password_char4;

@synthesize clearPassword;
@synthesize passwordToDate;

NSUserDefaults *prefs;
UIBarButtonItem *dismissScoreButton;

BOOL inUpdateMode = NO;

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
	[navigation_item release];
	[navigation_bar release];
	[dismissScoreButton release];
	
	[password_label release];
	[warning_label release];
	[warning_image release];
	[login_background release];
	
	[password_char1 release];
	[password_char2 release];
	[password_char3 release];
	[password_char4 release];
	
	[clearPassword release];
	[passwordToDate release];
	
	[prefs release];
	
    [super dealloc];
}


- (void)go{
	
	//dismissScoreButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissView)];
	self.navigation_bar.tintColor = [[UIColor alloc] initWithRed:headerColour_Red green:headerColour_Green blue:headerColour_Blue alpha:headerColour_Alpha];
	self.navigation_item.title = [[NSString alloc] initWithString:NSLocalizedString(@"Settings_Heading2", @"")];
	UIButton *dismissScoreButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 43, 49)];
	[dismissScoreButton addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
    [dismissScoreButton setImage:[UIImage imageNamed:@"icon_back.png"] forState:UIControlStateNormal];
    UIBarButtonItem *dismissScoreButtonItem = [[UIBarButtonItem alloc] initWithCustomView:dismissScoreButton];
    self.navigation_item.leftBarButtonItem = dismissScoreButtonItem;
    
	prefs = [NSUserDefaults standardUserDefaults];
	
	password_label.text = NSLocalizedString(@"Settings_Password", @"");
	password_char1.secureTextEntry = TRUE;	password_char1.enabled = FALSE;
	password_char2.secureTextEntry = TRUE;	password_char2.enabled = FALSE;
	password_char3.secureTextEntry = TRUE;	password_char3.enabled = FALSE;
	password_char4.secureTextEntry = TRUE;	password_char4.enabled = FALSE;
	passwordToDate = @"";
	[clearPassword setTitle:NSLocalizedString(@"Settings_Password_Clear", @"") forState:UIControlStateNormal];
	
	[self removeWarning];
	[login_background setImage:[UIImage imageNamed:passwordBackground]];
}

- (void)pressButton:(int)button_num{
	if([passwordToDate length] < 4){
		NSString *tempPassword;
		tempPassword = [[NSString alloc] initWithFormat:@"%@%i", passwordToDate, button_num]; 
		passwordToDate = tempPassword;
		
		tempPassword = [[NSString alloc] initWithFormat:@"%i", button_num]; 		
		
		[self removeWarning];
		
		if([password_char1.text length] == 0){	
			password_char1.text = [[NSString alloc] initWithFormat:@"%i", button_num];
		}else{
			if([password_char2.text length] == 0){	
				password_char2.text = [[NSString alloc] initWithFormat:@"%i", button_num];
			}else{
				if([password_char3.text length] == 0){	
					password_char3.text = [[NSString alloc] initWithFormat:@"%i", button_num];
				}else{
					if([password_char4.text length] == 0)	
						password_char4.text = [[NSString alloc] initWithFormat:@"%i", button_num];
						if(inUpdateMode)
							[self resetPassword];
						else
							[self attemptLogin];
				}
			}
		}
		[tempPassword release];
	}
}

- (IBAction)press1 {	[self pressButton:1];	}
- (IBAction)press2 {	[self pressButton:2];	}
- (IBAction)press3 {	[self pressButton:3];	}
- (IBAction)press4 {	[self pressButton:4];	}
- (IBAction)press5 {	[self pressButton:5];	}
- (IBAction)press6 {	[self pressButton:6];	}
- (IBAction)press7 {	[self pressButton:7];	}
- (IBAction)press8 {	[self pressButton:8];	}
- (IBAction)press9 {	[self pressButton:9];	}
- (IBAction)press0 {	[self pressButton:0];	}

- (IBAction)clearLastDigit{
	
	if([passwordToDate length] == 1){
		password_char1.text = @"";
		passwordToDate = @"";
	}
	if([passwordToDate length] == 2){
		password_char2.text = @"";
		passwordToDate = password_char1.text;
	}
	if([passwordToDate length] == 3){
		password_char3.text = @"";
		passwordToDate = [[NSString alloc] initWithFormat:@"%@%@", password_char1.text, password_char2.text];
	}
	if([passwordToDate length] == 4){
		password_char4.text = @"";
		passwordToDate = [[NSString alloc] initWithFormat:@"%@%@%@", password_char1.text, password_char2.text, password_char3.text];
	}
	
	[self removeWarning];
}

- (void)removeWarning{
	warning_label.text = @"";
	[warning_image setImage:[UIImage imageNamed:@""]];
}

///// Login /////

- (void)attemptLogin{
	warning_label.text = @"";
	
	if( [passwordToDate isEqualToString:[prefs stringForKey:@"Password"]] ){
		[self removeFromSuperview];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"AccessPause" object:nil];
	}else{
		if( [passwordToDate isEqualToString:@"8520"] ){ // In case the user gets locked out
			[self removeFromSuperview];
			[[NSNotificationCenter defaultCenter] postNotificationName:@"AccessPause" object:nil];
		}else{
			warning_label.text = NSLocalizedString(@"Settings_Password_Error", @"");
			[warning_image setImage:[UIImage imageNamed:alertImage]];
			passwordToDate = @"";
			password_char1.text = @"";	password_char2.text = @"";	password_char3.text = @"";	password_char4.text = @"";
		}
	}
}


///// Updating Methods /////

- (void)goUpdate{
	
	[self go];
	
	inUpdateMode = YES;
	
	password_label.text = NSLocalizedString(@"Settings_Password_Update", @"");
	password_char1.text = @"";
	password_char2.text = @"";
	password_char3.text = @"";
	password_char4.text = @"";
	
	password_char1.secureTextEntry = FALSE;
	password_char2.secureTextEntry = FALSE;
	password_char3.secureTextEntry = FALSE;
	password_char4.secureTextEntry = FALSE;

}

- (IBAction)resetPassword{

	prefs = [NSUserDefaults standardUserDefaults];
	
	if( ([passwordToDate length] == 0) || ([passwordToDate length] == 4) ){
		
		UIAlertView *alert;
		if([passwordToDate length] == 0)	
			alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Settings_Password_Empty_Heading", @"") message:NSLocalizedString(@"Settings_Password_Empty_Text", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Button_OK", @"") otherButtonTitles:nil,nil];
		if([passwordToDate length] == 4)	
			alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Settings_Password_Complete_Heading", @"") message:NSLocalizedString(@"Settings_Password_Complete_Text", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Button_OK", @"") otherButtonTitles:nil,nil];
		[alert dismissWithClickedButtonIndex:0 animated:TRUE];
		[alert show];	
		 
		[prefs setObject:passwordToDate forKey:@"Password"];
		[self removeFromSuperview];
		
	}else{
		warning_label.text = NSLocalizedString(@"Settings_Password_Incomplete", @"");
		[warning_image setImage:[UIImage imageNamed:alertImage]];
		passwordToDate = @"";
		password_char1.text = @"";	password_char2.text = @"";	password_char3.text = @"";	password_char4.text = @"";
	}

}

- (void)clearPasswordProtection{
	
	UIAlertView *alert;
	alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Settings_Password_Empty_Heading", @"") message:NSLocalizedString(@"Settings_Password_Empty_Text", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Button_OK", @"") otherButtonTitles:nil,nil];
	[alert dismissWithClickedButtonIndex:0 animated:TRUE];
	[alert show];	
	
	passwordToDate = @"";
	password_char1.text = @"";	password_char2.text = @"";	password_char3.text = @"";	password_char4.text = @"";
	[prefs setObject:passwordToDate forKey:@"Password"];
	
	[self removeFromSuperview];
	
}

- (void)dismissView{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"RemovePassword" object:nil];
}


@end
