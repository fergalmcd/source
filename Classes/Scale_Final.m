//
//  Scale_Final.m
//  WRUPlayer
//
//  Created by Fergal McDonnell on 22/04/2014.
//  Copyright 2014 Tailteann. All rights reserved.
//

#import "Scale_Final.h"
#import "Constants.h"


@implementation Scale_Final

@synthesize score_intro, insert_first_name, insert_score, save_explanation_label, final_score, diagnosis, first_name, last_name;
@synthesize background, saveBox, questionResultOverlay;
@synthesize save_button, diagnosis_button, diagnosis_extended;
@synthesize surveyReview;
@synthesize customKeyboard;

UIAlertView *diagnosisAlert;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)go{
	
	[background setImage:[UIImage imageNamed:questionBackground]];
	[saveBox setImage:[UIImage imageNamed:scaleResultsBox]];
	[questionResultOverlay setImage:[UIImage imageNamed:questionResultOverlayImage]];
	
	[save_button setTitle:NSLocalizedString(@"Final_Button_Save", @"") forState:UIControlStateNormal];
	[save_button setBackgroundImage:[UIImage imageNamed:resetButton] forState:UIControlStateNormal];
	[save_button setBackgroundImage:[UIImage imageNamed:resetButtonDown] forState:UIControlStateSelected];
	score_intro.text = NSLocalizedString(@"HDRS_Final_Score_Intro", @"");
	insert_first_name.text = NSLocalizedString(@"Save_FullName", @"");
	insert_score.text = NSLocalizedString(@"Save_Score", @"");
	save_explanation_label.text = NSLocalizedString(@"Final_Save_Explanation", @"");
    
}


- (void)dealloc {
	[score_intro release];
	[insert_first_name release];
	[insert_score release];
	[save_explanation_label release];
	[final_score release];
	[diagnosis release];
	[first_name release];
	[last_name release];
	[background release];
	[saveBox release];
	[questionResultOverlay release];
	[save_button release];
	[diagnosis_button release];
	[diagnosis_extended release];
	[diagnosisAlert release];
	[customKeyboard release];
	
    [super dealloc];
}


- (IBAction)displayDiagnosisExtended
{
	if([diagnosis_extended length] > 0){
		diagnosisAlert = [[UIAlertView alloc] initWithTitle:diagnosis.text message:diagnosis_extended delegate:self cancelButtonTitle:NSLocalizedString(@"Button_OK", @"") otherButtonTitles:nil,nil];
		[diagnosisAlert dismissWithClickedButtonIndex:0 animated:TRUE];
		[diagnosisAlert show];	
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    
	NSString *tempStr;
	
	if (theTextField == first_name) {
		tempStr = [[NSString alloc] initWithFormat:@"%@", last_name.text];
		[last_name becomeFirstResponder];
		last_name.text = [[NSString alloc] initWithFormat:@"%@", tempStr];
    }
	if (theTextField == last_name) {
		tempStr = [[NSString alloc] initWithFormat:@"%@", first_name.text];
		[first_name becomeFirstResponder];
		first_name.text = [[NSString alloc] initWithFormat:@"%@", tempStr];
		[first_name resignFirstResponder];
    }
	
	[tempStr release];
	
    return YES;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField {
	/*
	if (!self.customKeyboard) {
		self.customKeyboard = [CustomKeyboard keypadForTextField:textField];
	}else {
		//if we go from one field to another - just change the textfield, don't reanimate the HIDE button
		self.customKeyboard.currentTextField = textField;
	}
	*/
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	
	if (textField == customKeyboard.currentTextField) {
		[self.customKeyboard removeCustomKeyboard];
		self.customKeyboard = nil;
	}
	
}


@end
