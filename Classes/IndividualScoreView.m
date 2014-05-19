//
//  IndividualScoreView.m
//  WRUPlayer
//
//  Created by Fergal McDonnell on 22/04/2014.
//  Copyright 2014 Tailteann. All rights reserved.
//

#import "IndividualScoreView.h"
#import "DoctotHelper.h"
#import "Constants.h"


@implementation IndividualScoreView

@synthesize navigation_bar, navigation_item;
@synthesize background_top, background_middle, background_bottom, scrollView;
@synthesize fullName, date, score, diagnosis, diagnosisString, diagnosisLevel, diagnosisExtended, diagnosisColour, diagnosis_image;
@synthesize fullName_label, date_label, score_label, frequency_label, intensity_label, total_label;
@synthesize q1, q2, q3, q4, q5, q6, q7, q8, q9, q10, q11, q12, q13, q14, q15;
@synthesize q1_label, q2_label, q3_label, q4_label, q5_label, q6_label, q7_label, q8_label, q9_label, q10_label, q11_label, q12_label, q13_label, q14_label, q15_label;
@synthesize q1_button, q2_button, q3_button, q4_button, q5_button, q6_button, q7_button, q8_button, q9_button, q10_button, q11_button, q12_button, q13_button, q14_button, q15_button;
@synthesize q1Extended, q2Extended, q3Extended, q4Extended, q5Extended, q6Extended, q7Extended, q8Extended, q9Extended, q10Extended, q11Extended, q12Extended, q13Extended, q14Extended, q15Extended;
@synthesize score_from_view;

@synthesize backButton;
@synthesize slideInstruction;
@synthesize clearSelectionSlider, clearSelectionTrack;

UIBarButtonItem *deleteScoreButton;

UIColor *level1Colour;
UIColor *level2Colour;
UIColor *level3Colour;
UIColor *level4Colour;
UIColor *level5Colour;
UIImage *level1Dot;
UIImage *level2Dot;
UIImage *level3Dot;
UIImage *level4Dot;
UIImage *level5Dot;
int scaleUpperBoundsLevel1 = -1;
int scaleUpperBoundsLevel2 = -1;
int scaleUpperBoundsLevel3 = -1;
int scaleUpperBoundsLevel4 = -1;
NSString *diagnosis_level1;
NSString *diagnosis_level2;
NSString *diagnosis_level3;
NSString *diagnosis_level4;
NSString *diagnosis_level5;
NSString *diagnosis_extended_level1;
NSString *diagnosis_extended_level2;
NSString *diagnosis_extended_level3;
NSString *diagnosis_extended_level4;
NSString *diagnosis_extended_level5;

UIAlertView *diagnosisAlert;
NSString *item_score_heading;
NSString *item_score_text;


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
    [super dealloc];
	
	[navigation_bar release];
	[navigation_item release];
	
	[background_top release];	[background_middle release];	[background_bottom release];
	[scrollView release];
	[deleteScoreButton release];
	
	[level1Colour release];
	[level2Colour release];
	[level3Colour release];
	[level4Colour release];
	[level5Colour release];
	[level1Dot release];
	[level2Dot release];
	[level3Dot release];
	[level4Dot release];
	[level5Dot release];
	[diagnosis_level1 release];
	[diagnosis_level2 release];
	[diagnosis_level3 release];
	[diagnosis_level4 release];
	[diagnosis_level5 release];
	[diagnosis_extended_level1 release];
	[diagnosis_extended_level2 release];
	[diagnosis_extended_level3 release];
	[diagnosis_extended_level4 release];
	[diagnosis_extended_level5 release];
	
	[fullName release];
	[date release];
	[score release];
	[diagnosis release];
	[diagnosisString release];	[diagnosisLevel release];	[diagnosisColour release];	[diagnosisExtended release];
	[diagnosis_image release];
	[diagnosisAlert release];
	[item_score_heading release];
	[item_score_text release];
		
	[fullName_label release];
	[date_label release];
	[score_label release];
	[frequency_label release];
	[intensity_label release];
	[total_label release];
	
	[q1 release];	[q2 release];	[q3 release];	[q4 release];	[q5 release];
	[q6 release];	[q7 release];	[q8 release];	[q9 release];	[q10 release];
	[q11 release];	[q12 release];	[q13 release];	[q14 release];	[q15 release];
	[q1_label release];		[q2_label release];		[q3_label release];		[q4_label release];		[q5_label release];
	[q6_label release];		[q7_label release];		[q8_label release];		[q9_label release];		[q10_label release];
	[q11_label release];	[q12_label release];	[q13_label release];	[q14_label release];	[q15_label release];
	[q1_button release];	[q2_button release];	[q3_button release];	[q4_button release];	[q5_button release];
	[q6_button release];	[q7_button release];	[q8_button release];	[q9_button release];	[q10_button release];
	[q11_button release];	[q12_button release];	[q13_button release];	[q14_button release];	[q15_button release];
	[q1Extended release];	[q2Extended release];	[q3Extended release];	[q4Extended release];	[q5Extended release];
	[q6Extended release];	[q7Extended release];	[q8Extended release];	[q9Extended release];	[q10Extended release];
	[q11Extended release];	[q12Extended release];	[q13Extended release];	[q14Extended release];	[q15Extended release];
	
	[backButton release];
	[slideInstruction release];
	[clearSelectionSlider release];	[clearSelectionTrack release];
	
	[score_from_view release];
}

- (void)go:(NSString *)scale{
	
	deleteScoreButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteScore)];
	
	self.navigation_bar.tintColor = [[UIColor alloc] initWithRed:headerColour_Red green:headerColour_Green blue:headerColour_Blue alpha:headerColour_Alpha];
	self.navigation_item.title = [[NSString alloc] initWithFormat:@"%@ %@", [scale uppercaseString], NSLocalizedString(@"Save_ScoresIndividual", @"")];
	UIButton *dismissScoreButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 43, 49)];
	[dismissScoreButton addTarget:self action:@selector(dismissScoreView) forControlEvents:UIControlEventTouchUpInside];
    [dismissScoreButton setImage:[UIImage imageNamed:@"icon_back.png"] forState:UIControlStateNormal];
    UIBarButtonItem *dismissScoreButtonItem = [[UIBarButtonItem alloc] initWithCustomView:dismissScoreButton];
    self.navigation_item.leftBarButtonItem = dismissScoreButtonItem;
    
	[background_top setImage:[UIImage imageNamed:savedScoresIndividualTop]];
	[background_middle setImage:[UIImage imageNamed:savedScoresIndividualMiddle]];
	[background_bottom setImage:[UIImage imageNamed:savedScoresIndividualBottom]];
   
    scrollView.delegate = self;
	
	slideInstruction.text = NSLocalizedString(@"SlideInstructionDelete", @"");
	[clearSelectionSlider setThumbImage:[UIImage imageNamed:resetSliderThumb] forState:UIControlStateNormal];
	[clearSelectionSlider setThumbImage:[UIImage imageNamed:resetSliderThumb] forState:UIControlStateHighlighted];
	[clearSelectionSlider setMinimumTrackImage:[UIImage imageNamed:emptyImage] forState:UIControlStateNormal];
	[clearSelectionSlider setMinimumTrackImage:[UIImage imageNamed:emptyImage] forState:UIControlStateHighlighted];
	[clearSelectionSlider setMaximumTrackImage:[UIImage imageNamed:emptyImage] forState:UIControlStateNormal];
	[clearSelectionSlider setMaximumTrackImage:[UIImage imageNamed:emptyImage] forState:UIControlStateHighlighted];
	clearSelectionSlider.bounds = CGRectMake(0.0, 0.0, 300.0, 50.0);
	[clearSelectionTrack setImage:[UIImage imageNamed:resetSliderTrack]];
	
	fullName_label.text = NSLocalizedString(@"Save_FullName", @"");
	date_label.text = NSLocalizedString(@"Save_Date", @"");
	score_label.text = NSLocalizedString(@"Save_Score", @"");
	
	if([scale isEqualToString:@"wruplayer"]){
		scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, scrollView.frame.size.height);
		q1_label.text = NSLocalizedString(@"WRUPLAYER_Q1", @"");
		q2_label.text = NSLocalizedString(@"WRUPLAYER_Q2", @"");
		q3_label.text = NSLocalizedString(@"WRUPLAYER_Q3", @"");
		q4_label.text = NSLocalizedString(@"WRUPLAYER_Q4", @"");
		q5_label.text = NSLocalizedString(@"WRUPLAYER_Q5", @"");
        q6_label.text = NSLocalizedString(@"WRUPLAYER_Q6", @"");
        q7_label.text = NSLocalizedString(@"WRUPLAYER_Q7", @"");
        q8_label.text = NSLocalizedString(@"WRUPLAYER_Q8", @"");
        q9_label.text = NSLocalizedString(@"WRUPLAYER_Q9", @"");
        q10_label.text = NSLocalizedString(@"WRUPLAYER_Q10", @"");
	}
		
	// Button Set up
	
	[q1_button setBackgroundImage:[UIImage imageNamed:disclosureButton] forState:UIControlStateNormal];		[q1_button setBackgroundImage:[UIImage imageNamed:emptyButton] forState:UIControlStateDisabled];
	[q2_button setBackgroundImage:[UIImage imageNamed:disclosureButton] forState:UIControlStateNormal];		[q2_button setBackgroundImage:[UIImage imageNamed:emptyButton] forState:UIControlStateDisabled];
	[q3_button setBackgroundImage:[UIImage imageNamed:disclosureButton] forState:UIControlStateNormal];		[q3_button setBackgroundImage:[UIImage imageNamed:emptyButton] forState:UIControlStateDisabled];
	[q4_button setBackgroundImage:[UIImage imageNamed:disclosureButton] forState:UIControlStateNormal];		[q4_button setBackgroundImage:[UIImage imageNamed:emptyButton] forState:UIControlStateDisabled];
	[q5_button setBackgroundImage:[UIImage imageNamed:disclosureButton] forState:UIControlStateNormal];		[q5_button setBackgroundImage:[UIImage imageNamed:emptyButton] forState:UIControlStateDisabled];
	[q6_button setBackgroundImage:[UIImage imageNamed:disclosureButton] forState:UIControlStateNormal];		[q6_button setBackgroundImage:[UIImage imageNamed:emptyButton] forState:UIControlStateDisabled];
	[q7_button setBackgroundImage:[UIImage imageNamed:disclosureButton] forState:UIControlStateNormal];		[q7_button setBackgroundImage:[UIImage imageNamed:emptyButton] forState:UIControlStateDisabled];
	[q8_button setBackgroundImage:[UIImage imageNamed:disclosureButton] forState:UIControlStateNormal];		[q8_button setBackgroundImage:[UIImage imageNamed:emptyButton] forState:UIControlStateDisabled];
	[q9_button setBackgroundImage:[UIImage imageNamed:disclosureButton] forState:UIControlStateNormal];		[q9_button setBackgroundImage:[UIImage imageNamed:emptyButton] forState:UIControlStateDisabled];
	[q10_button setBackgroundImage:[UIImage imageNamed:disclosureButton] forState:UIControlStateNormal];	[q10_button setBackgroundImage:[UIImage imageNamed:emptyButton] forState:UIControlStateDisabled];
	
	if([q1_label.text isEqualToString:@""])		[q1_button setEnabled:NO];
	if([q2_label.text isEqualToString:@""])		[q2_button setEnabled:NO];
	if([q3_label.text isEqualToString:@""])		[q3_button setEnabled:NO];
	if([q4_label.text isEqualToString:@""])		[q4_button setEnabled:NO];
	if([q5_label.text isEqualToString:@""])		[q5_button setEnabled:NO];
	if([q6_label.text isEqualToString:@""])		[q6_button setEnabled:NO];
	if([q7_label.text isEqualToString:@""])		[q7_button setEnabled:NO];
	if([q8_label.text isEqualToString:@""])		[q8_button setEnabled:NO];
	if([q9_label.text isEqualToString:@""])		[q9_button setEnabled:NO];
	if([q10_label.text isEqualToString:@""])	[q10_button setEnabled:NO];
	
	[self getResultView];
	
	[backButton setTitle:NSLocalizedString(@"Button_Back", @"") forState:UIControlStateNormal];
	 
}

- (void)setDiagnosisForScale{
	
	diagnosis.text = diagnosisString;
	
	if([diagnosisColour isEqual:@"red"]){		[diagnosis_image setImage:[UIImage imageNamed:redDot]];			diagnosis.textColor = [UIColor redColor];	}
	if([diagnosisColour isEqual:@"orange"]){	[diagnosis_image setImage:[UIImage imageNamed:orangeDot]];		diagnosis.textColor = [UIColor orangeColor];	}
	if([diagnosisColour isEqual:@"yellow"]){	[diagnosis_image setImage:[UIImage imageNamed:yellowDot]];		diagnosis.textColor = [UIColor yellowColor];	}
	if([diagnosisColour isEqual:@"blue"]){		[diagnosis_image setImage:[UIImage imageNamed:blueDot]];		diagnosis.textColor = [UIColor blueColor];	}
	if([diagnosisColour isEqual:@"white"]){		[diagnosis_image setImage:[UIImage imageNamed:whiteDot]];		diagnosis.textColor = [UIColor whiteColor];	}
	
}

- (IBAction)sliderSpringsBack{

	if(clearSelectionSlider.value <= resetSliderDistanceToExit ){
		clearSelectionSlider.value = 0.0;
	}
	
}

- (IBAction)diagnosisAlert{
	
	if([diagnosisString length] > 0){
		diagnosisAlert = [[UIAlertView alloc] initWithTitle:diagnosisString message:diagnosisExtended delegate:self cancelButtonTitle:NSLocalizedString(@"Button_OK", @"") otherButtonTitles:nil,nil];
		[diagnosisAlert dismissWithClickedButtonIndex:0 animated:TRUE];
		[diagnosisAlert show];	
	}
	
}

- (IBAction)alertRelatedToScore:(id)sender{
		
	if(sender == q1_button){	item_score_heading = q1_label.text;		item_score_text = q1Extended;	}
	if(sender == q2_button){	item_score_heading = q2_label.text;		item_score_text = q2Extended;	}
	if(sender == q3_button){	item_score_heading = q3_label.text;		item_score_text = q3Extended;	}
	if(sender == q4_button){	item_score_heading = q4_label.text;		item_score_text = q4Extended;	}
	if(sender == q5_button){	item_score_heading = q5_label.text;		item_score_text = q5Extended;	}
	if(sender == q6_button){	item_score_heading = q6_label.text;		item_score_text = q6Extended;	}
	if(sender == q7_button){	item_score_heading = q7_label.text;		item_score_text = q7Extended;	}
	if(sender == q8_button){	item_score_heading = q8_label.text;		item_score_text = q8Extended;	}
	if(sender == q9_button){	item_score_heading = q9_label.text;		item_score_text = q9Extended;	}
	if(sender == q10_button){	item_score_heading = q10_label.text;	item_score_text = q10Extended;	}
	
	diagnosisAlert = [[UIAlertView alloc] initWithTitle:item_score_heading message:item_score_text delegate:self cancelButtonTitle:NSLocalizedString(@"Button_OK", @"") otherButtonTitles:nil,nil];
	[diagnosisAlert dismissWithClickedButtonIndex:0 animated:TRUE];
	[diagnosisAlert show];	
	
}

- (IBAction)dismissScoreView{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"DismissScoreView" object:nil];
}

- (IBAction)deleteScore{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"DeleteScore" object:nil];
}

- (void)getResultView{
	
	[scrollView addSubview:q1_label];	[scrollView addSubview:q2_label];	[scrollView addSubview:q3_label];	[scrollView addSubview:q4_label];	[scrollView addSubview:q5_label];
	[scrollView addSubview:q6_label];	[scrollView addSubview:q7_label];	[scrollView addSubview:q8_label];	[scrollView addSubview:q9_label];	[scrollView addSubview:q10_label];
	[scrollView addSubview:q11_label];	[scrollView addSubview:q12_label];	[scrollView addSubview:q13_label];	[scrollView addSubview:q14_label];	[scrollView addSubview:q15_label];
	
	[scrollView addSubview:q1];			[scrollView addSubview:q2];			[scrollView addSubview:q3];			[scrollView addSubview:q4];			[scrollView addSubview:q5];
	[scrollView addSubview:q6];			[scrollView addSubview:q7];			[scrollView addSubview:q8];			[scrollView addSubview:q9];			[scrollView addSubview:q10];
	[scrollView addSubview:q11];		[scrollView addSubview:q12];		[scrollView addSubview:q13];		[scrollView addSubview:q14];		[scrollView addSubview:q15];
	
	[scrollView addSubview:q1_button];	[scrollView addSubview:q2_button];	[scrollView addSubview:q3_button];	[scrollView addSubview:q4_button];	[scrollView addSubview:q5_button];
	[scrollView addSubview:q6_button];	[scrollView addSubview:q7_button];	[scrollView addSubview:q8_button];	[scrollView addSubview:q9_button];	[scrollView addSubview:q10_button];
	[scrollView addSubview:q11_button];	[scrollView addSubview:q12_button];	[scrollView addSubview:q13_button];	[scrollView addSubview:q14_button];	[scrollView addSubview:q15_button];

}

@end
