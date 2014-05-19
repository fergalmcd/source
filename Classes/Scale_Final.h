//
//  Scale_Final.h
//  WRUPlayer
//
//  Created by Fergal McDonnell on 22/04/2014.
//  Copyright 2014 Tailteann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomKeyboard.h"


@interface Scale_Final : UIView <UITextFieldDelegate> {
	IBOutlet UILabel *score_intro;
	IBOutlet UILabel *insert_first_name;
	IBOutlet UILabel *insert_score;
	IBOutlet UILabel *save_explanation_label;
	
	IBOutlet UILabel *final_score;
	IBOutlet UILabel *diagnosis;
	
	IBOutlet UITextField *first_name;
	IBOutlet UITextField *last_name;
	
	IBOutlet UIImageView *background;
	IBOutlet UIImageView *saveBox;
	IBOutlet UIImageView *questionResultOverlay;
	IBOutlet UIButton *save_button;
	IBOutlet UIButton *diagnosis_button;
	NSString *diagnosis_extended;
    
    UIWebView *surveyReview;
	
	CustomKeyboard *customKeyboard;
}

@property (nonatomic, retain) UILabel *score_intro;
@property (nonatomic, retain) UILabel *insert_first_name;
@property (nonatomic, retain) UILabel *insert_score;
@property (nonatomic, retain) UILabel *save_explanation_label;

@property (nonatomic, retain) UILabel *final_score;
@property (nonatomic, retain) UILabel *diagnosis;

@property (nonatomic, retain) UITextField *first_name;
@property (nonatomic, retain) UITextField *last_name;

@property (nonatomic, retain) UIImageView *background;
@property (nonatomic, retain) UIImageView *saveBox;
@property (nonatomic, retain) UIImageView *questionResultOverlay;
@property (nonatomic, retain) UIButton *save_button;
@property (nonatomic, retain) UIButton *diagnosis_button;
@property (nonatomic, retain) NSString *diagnosis_extended;

@property (nonatomic, retain) IBOutlet UIWebView *surveyReview;

@property (nonatomic, retain) CustomKeyboard *customKeyboard;

- (void)go;
- (IBAction)displayDiagnosisExtended;


@end
