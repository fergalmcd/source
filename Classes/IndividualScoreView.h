//
//  IndividualScoreView.h
//  WRUPlayer
//
//  Created by Fergal McDonnell on 22/04/2014.
//  Copyright 2014 Tailteann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndividualScore.h"
#import "Constants.h"


@interface IndividualScoreView : UIView <UIScrollViewDelegate> {

	IBOutlet UINavigationBar *navigation_bar;
	IBOutlet UINavigationItem *navigation_item;
	
	IBOutlet UIImageView *background_top;
	IBOutlet UIImageView *background_middle;
	IBOutlet UIImageView *background_bottom;
	IBOutlet UIScrollView *scrollView;
	
	IBOutlet UILabel *fullName;
	IBOutlet UILabel *date;
	IBOutlet UILabel *score;
	IBOutlet UILabel *diagnosis;
	IBOutlet NSString *diagnosisString;
	IBOutlet NSString *diagnosisLevel;
	IBOutlet NSString *diagnosisColour;
	IBOutlet NSString *diagnosisExtended;
	IBOutlet UIImageView *diagnosis_image;
		
	IBOutlet UILabel *fullName_label;
	IBOutlet UILabel *date_label;
	IBOutlet UILabel *score_label;
	IBOutlet UILabel *frequency_label;
	IBOutlet UILabel *intensity_label;
	IBOutlet UILabel *total_label;
	
	IBOutlet UILabel *q1;	IBOutlet UILabel *q2;	IBOutlet UILabel *q3;	IBOutlet UILabel *q4;	IBOutlet UILabel *q5;	
	IBOutlet UILabel *q6;	IBOutlet UILabel *q7;	IBOutlet UILabel *q8;	IBOutlet UILabel *q9;	IBOutlet UILabel *q10;
	IBOutlet UILabel *q11;	IBOutlet UILabel *q12;	IBOutlet UILabel *q13;	IBOutlet UILabel *q14;	IBOutlet UILabel *q15;
	
	IBOutlet UILabel *q1_label;		IBOutlet UILabel *q2_label;		IBOutlet UILabel *q3_label;		IBOutlet UILabel *q4_label;		IBOutlet UILabel *q5_label;
	IBOutlet UILabel *q6_label;		IBOutlet UILabel *q7_label;		IBOutlet UILabel *q8_label;		IBOutlet UILabel *q9_label;		IBOutlet UILabel *q10_label;
	IBOutlet UILabel *q11_label;	IBOutlet UILabel *q12_label;	IBOutlet UILabel *q13_label;	IBOutlet UILabel *q14_label;	IBOutlet UILabel *q15_label;
	
	IBOutlet UIButton *q1_button;	IBOutlet UIButton *q2_button;	IBOutlet UIButton *q3_button;	IBOutlet UIButton *q4_button;	IBOutlet UIButton *q5_button;	
	IBOutlet UIButton *q6_button;	IBOutlet UIButton *q7_button;	IBOutlet UIButton *q8_button;	IBOutlet UIButton *q9_button;	IBOutlet UIButton *q10_button;
	IBOutlet UIButton *q11_button;	IBOutlet UIButton *q12_button;	IBOutlet UIButton *q13_button;	IBOutlet UIButton *q14_button;	IBOutlet UIButton *q15_button;
	
	IBOutlet NSString *q1Extended;	IBOutlet NSString *q2Extended;	IBOutlet NSString *q3Extended;	IBOutlet NSString *q4Extended;	IBOutlet NSString *q5Extended;	
	IBOutlet NSString *q6Extended;	IBOutlet NSString *q7Extended;	IBOutlet NSString *q8Extended;	IBOutlet NSString *q9Extended;	IBOutlet NSString *q10Extended;
	IBOutlet NSString *q11Extended;	IBOutlet NSString *q12Extended;	IBOutlet NSString *q13Extended;	IBOutlet NSString *q14Extended;	IBOutlet NSString *q15Extended;
	
	IBOutlet UIButton *backButton;
	IBOutlet UILabel *slideInstruction;
	IBOutlet UISlider *clearSelectionSlider;
	IBOutlet UIImageView *clearSelectionTrack;
	
	IndividualScore *score_from_view;
}

@property (nonatomic, retain) UINavigationBar *navigation_bar;
@property (nonatomic, retain) UINavigationItem *navigation_item;

@property (nonatomic, retain) UIImageView *background_top;
@property (nonatomic, retain) UIImageView *background_middle;
@property (nonatomic, retain) UIImageView *background_bottom;
@property (nonatomic, retain) UIScrollView *scrollView;

@property (nonatomic, retain) UILabel *fullName;
@property (nonatomic, retain) UILabel *date;
@property (nonatomic, retain) UILabel *score;
@property (nonatomic, retain) UILabel *diagnosis;
@property (nonatomic, retain) NSString *diagnosisString;
@property (nonatomic, retain) NSString *diagnosisLevel;
@property (nonatomic, retain) NSString *diagnosisColour;
@property (nonatomic, retain) NSString *diagnosisExtended;
@property (nonatomic, retain) UIImageView *diagnosis_image;

@property (nonatomic, retain) UILabel *fullName_label;
@property (nonatomic, retain) UILabel *date_label;
@property (nonatomic, retain) UILabel *score_label;
@property (nonatomic, retain) UILabel *frequency_label;
@property (nonatomic, retain) UILabel *intensity_label;
@property (nonatomic, retain) UILabel *total_label;

@property (nonatomic, retain) UILabel *q1;
@property (nonatomic, retain) UILabel *q2;
@property (nonatomic, retain) UILabel *q3;
@property (nonatomic, retain) UILabel *q4;
@property (nonatomic, retain) UILabel *q5;
@property (nonatomic, retain) UILabel *q6;
@property (nonatomic, retain) UILabel *q7;
@property (nonatomic, retain) UILabel *q8;
@property (nonatomic, retain) UILabel *q9;
@property (nonatomic, retain) UILabel *q10;
@property (nonatomic, retain) UILabel *q11;
@property (nonatomic, retain) UILabel *q12;
@property (nonatomic, retain) UILabel *q13;
@property (nonatomic, retain) UILabel *q14;
@property (nonatomic, retain) UILabel *q15;
@property (nonatomic, retain) UILabel *q1_label;
@property (nonatomic, retain) UILabel *q2_label;
@property (nonatomic, retain) UILabel *q3_label;
@property (nonatomic, retain) UILabel *q4_label;
@property (nonatomic, retain) UILabel *q5_label;
@property (nonatomic, retain) UILabel *q6_label;
@property (nonatomic, retain) UILabel *q7_label;
@property (nonatomic, retain) UILabel *q8_label;
@property (nonatomic, retain) UILabel *q9_label;
@property (nonatomic, retain) UILabel *q10_label;
@property (nonatomic, retain) UILabel *q11_label;
@property (nonatomic, retain) UILabel *q12_label;
@property (nonatomic, retain) UILabel *q13_label;
@property (nonatomic, retain) UILabel *q14_label;
@property (nonatomic, retain) UILabel *q15_label;
@property (nonatomic, retain) UIButton *q1_button;
@property (nonatomic, retain) UIButton *q2_button;
@property (nonatomic, retain) UIButton *q3_button;
@property (nonatomic, retain) UIButton *q4_button;
@property (nonatomic, retain) UIButton *q5_button;
@property (nonatomic, retain) UIButton *q6_button;
@property (nonatomic, retain) UIButton *q7_button;
@property (nonatomic, retain) UIButton *q8_button;
@property (nonatomic, retain) UIButton *q9_button;
@property (nonatomic, retain) UIButton *q10_button;
@property (nonatomic, retain) UIButton *q11_button;
@property (nonatomic, retain) UIButton *q12_button;
@property (nonatomic, retain) UIButton *q13_button;
@property (nonatomic, retain) UIButton *q14_button;
@property (nonatomic, retain) UIButton *q15_button;
@property (nonatomic, retain) NSString *q1Extended;
@property (nonatomic, retain) NSString *q2Extended;
@property (nonatomic, retain) NSString *q3Extended;
@property (nonatomic, retain) NSString *q4Extended;
@property (nonatomic, retain) NSString *q5Extended;
@property (nonatomic, retain) NSString *q6Extended;
@property (nonatomic, retain) NSString *q7Extended;
@property (nonatomic, retain) NSString *q8Extended;
@property (nonatomic, retain) NSString *q9Extended;
@property (nonatomic, retain) NSString *q10Extended;
@property (nonatomic, retain) NSString *q11Extended;
@property (nonatomic, retain) NSString *q12Extended;
@property (nonatomic, retain) NSString *q13Extended;
@property (nonatomic, retain) NSString *q14Extended;
@property (nonatomic, retain) NSString *q15Extended;

@property (nonatomic, retain) UIButton *backButton;
@property (nonatomic, retain) UILabel *slideInstruction;
@property (nonatomic, retain) UISlider *clearSelectionSlider;
@property (nonatomic, retain) UIImageView *clearSelectionTrack;

@property (nonatomic, retain) IndividualScore *score_from_view;

- (void)go:(NSString *)scale;
//- (IBAction)dismissSelectedIndividualScoreView:(id)sender;
- (IBAction)sliderSpringsBack;
- (IBAction)diagnosisAlert;
- (IBAction)alertRelatedToScore:(id)sender;
- (void)setDiagnosisForScale;//:(NSString *)scaleId WithScore:(int)finalScore;
- (IBAction)dismissScoreView;
- (IBAction)deleteScore;
- (void)getResultView;

@end
