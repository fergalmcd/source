//
//  HelpView.m
//  WRUPlayer
//
//  Created by Fergal McDonnell on 22/04/2014.
//  Copyright 2014 Tailteann. All rights reserved.
//

#import "HelpView.h"
#import "Constants.h"


@implementation HelpView

@synthesize heading, explanation;
@synthesize mainImage;
@synthesize label1, label2, label3, label4, label5, label6, label7, label8, label9, label10, label11, label12, label13, label14;
@synthesize image1, image2, image3, image4, image5, image6, image7, image8, image9, image10, image11, image12, image13, image14;

UIColor *labelColour;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}

- (void)setUpView:(int)viewNumber {
	
	heading.textColor = [[UIColor alloc] initWithRed:help_headingColour_Red green:help_headingColour_Green blue:help_headingColour_Blue alpha:1.0];
    explanation.textColor = [[UIColor alloc] initWithRed:help_ExplanationColour_Red green:help_ExplanationColour_Green blue:help_ExplanationColour_Blue alpha:1.0];
    [self setUpLabelColours];
	
	if(viewNumber == 1){
		heading.text = NSLocalizedString(@"Info_QuestionOverview_Heading", @"");
		explanation.text = NSLocalizedString(@"Info_QuestionOverview_Explanations", @"");
		mainImage.image = [UIImage imageNamed:@"help_questionoverview.png"];
		label1.text = NSLocalizedString(@"Info_QuestionOverview_Label1", @"");
		label2.text = NSLocalizedString(@"Info_QuestionOverview_Label2", @"");
		label3.text = NSLocalizedString(@"Info_QuestionOverview_Label3", @"");
		label4.text = NSLocalizedString(@"Info_QuestionOverview_Label4", @"");
		label5.text = NSLocalizedString(@"Info_QuestionOverview_Label5", @"");
		label6.text = NSLocalizedString(@"Info_QuestionOverview_Label6", @"");
		label7.text = NSLocalizedString(@"Info_QuestionOverview_Label7", @"");
		label8.text = NSLocalizedString(@"Info_QuestionOverview_Label8", @"");
		label9.text = NSLocalizedString(@"Info_QuestionOverview_Label9", @"");
		label10.text = NSLocalizedString(@"Info_QuestionOverview_Label10", @"");
		label11.text = NSLocalizedString(@"Info_QuestionOverview_Label11", @"");
		label12.text = NSLocalizedString(@"Info_QuestionOverview_Label12", @"");
		label13.text = NSLocalizedString(@"Info_QuestionOverview_Label13", @"");
		label14.text = NSLocalizedString(@"Info_QuestionOverview_Label14", @"");
		image1.image = [UIImage imageNamed:@"help_questionoverview_totalscore.png"];
		image2.image = [UIImage imageNamed:@"help_questionoverview_itemscore.png"];
		image3.image = [UIImage imageNamed:@"help_questionoverview_back.png"];
		image4.image = [UIImage imageNamed:@"help_questionoverview_info.png"];
		image5.image = [UIImage imageNamed:@"help_questionoverview_moreinfo.png"];
		image6.image = [UIImage imageNamed:@"help_questionoverview_heading.png"];
		image7.image = [UIImage imageNamed:@"help_questionoverview_subheading.png"];
		image8.image = [UIImage imageNamed:@"help_questionoverview_answerselected.png"];
		image9.image = [UIImage imageNamed:@"help_questionoverview_answernotselected.png"];
		image10.image = [UIImage imageNamed:@"help_questionoverview_hint.png"];
		image11.image = [UIImage imageNamed:@"help_questionoverview_resetslider.png"];
		image12.image = [UIImage imageNamed:@"help_questionoverview_prev.png"];
		image13.image = [UIImage imageNamed:@"help_questionoverview_next.png"];
		image14.image = [UIImage imageNamed:@"help_questionoverview_progressbar.png"];
	}
	if(viewNumber == 2){
		heading.text = NSLocalizedString(@"Info_QuestionAnswered_Heading", @"");
		explanation.text = NSLocalizedString(@"Info_QuestionAnswered_Explanations", @"");
		
		label1.text = NSLocalizedString(@"Info_QuestionAnswered_Label1", @"");
		label2.text = NSLocalizedString(@"Info_QuestionAnswered_Label2", @"");
		label3.text = NSLocalizedString(@"Info_QuestionAnswered_Label3", @"");
		label4.text = NSLocalizedString(@"Info_QuestionAnswered_Label4", @"");
		label5.text = NSLocalizedString(@"Info_QuestionAnswered_Label5", @"");
		label6.text = NSLocalizedString(@"Info_QuestionAnswered_Label6", @"");
		label7.text = NSLocalizedString(@"Info_QuestionAnswered_Label7", @"");
		image1.image = [UIImage imageNamed:@"help_questionanswered_flick.png"];
		image2.image = [UIImage imageNamed:@"help_questionanswered_provisional.png"];
		image3.image = [UIImage imageNamed:@"help_questionanswered_selected.png"];
		image4.image = [UIImage imageNamed:@"help_questionanswered_clear.png"];
	}
	if(viewNumber == 3){
		heading.text = NSLocalizedString(@"Info_ShakeToReset_Heading", @"");
		explanation.text = NSLocalizedString(@"Info_ShakeToReset_Explanations", @"");
		mainImage.image = [UIImage imageNamed:@"help_shaketoreset_pre.png"];
		label1.text = NSLocalizedString(@"Info_ShakeToReset_Label1", @"");
		label2.text = NSLocalizedString(@"Info_ShakeToReset_Label2", @"");
		label3.text = NSLocalizedString(@"Info_ShakeToReset_Label3", @"");
		image1.image = [UIImage imageNamed:@"help_shaketoreset_shake1.png"];
		image2.image = [UIImage imageNamed:@"help_shaketoreset_shake2.png"];
		image3.image = [UIImage imageNamed:@"help_shaketoreset_startagain.png"];
	}
	if(viewNumber == 4){
		heading.text = NSLocalizedString(@"Info_SavedScores_Heading", @"");
		explanation.text = NSLocalizedString(@"Info_SavedScores_Explanations", @"");
		mainImage.image = [UIImage imageNamed:@"help_savedscores1.png"];
		label1.text = NSLocalizedString(@"Info_SavedScores_Label1", @"");
		label2.text = NSLocalizedString(@"Info_SavedScores_Label2", @"");
		label3.text = NSLocalizedString(@"Info_SavedScores_Label3", @"");
		label4.text = NSLocalizedString(@"Info_SavedScores_Label4", @"");
		label5.text = NSLocalizedString(@"Info_SavedScores_Label5", @"");
		label6.text = NSLocalizedString(@"Info_SavedScores_Label6", @"");
		image1.image = [UIImage imageNamed:@"help_savedscores2.png"];
		image2.image = [UIImage imageNamed:@"help_savedscores3.png"];
		image3.image = [UIImage imageNamed:@"help_savedscores4.png"];
	}
	if(viewNumber == 5){
		heading.text = NSLocalizedString(@"Info_Settings_Heading", @"");
		explanation.text = NSLocalizedString(@"Info_Settings_Explanations", @"");
		mainImage.image = [UIImage imageNamed:@"help_settings.png"];
		label1.text = NSLocalizedString(@"Info_Settings_Label1", @"");
		label2.text = NSLocalizedString(@"Info_Settings_Label2", @"");
		label3.text = NSLocalizedString(@"Info_Settings_Label3", @"");
		label4.text = NSLocalizedString(@"Info_Settings_Label4", @"");
		label5.text = NSLocalizedString(@"Info_Settings_Label5", @"");
		label6.text = NSLocalizedString(@"Info_Settings_Label6", @"");
	}
	if(viewNumber == 6){
		heading.text = NSLocalizedString(@"Info_Stopwatch_Heading", @"");
		explanation.text = NSLocalizedString(@"Info_Stopwatch_Explanations", @"");
		mainImage.image = [UIImage imageNamed:@"help_stopwatch.png"];
		label1.text = NSLocalizedString(@"Info_Stopwatch_Label1", @"");
		label2.text = NSLocalizedString(@"Info_Stopwatch_Label2", @"");
		label3.text = NSLocalizedString(@"Info_Stopwatch_Label3", @"");
		label4.text = NSLocalizedString(@"Info_Stopwatch_Label4", @"");
		image1.image = [UIImage imageNamed:@"help_stopwatch_on.png"];
		image2.image = [UIImage imageNamed:@"help_stopwatch_stopped.png"];
	}
	
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}

- (void)setUpLabelColours {
	labelColour = [[UIColor alloc] initWithRed:help_LabelColour_Red green:help_LabelColour_Green blue:help_LabelColour_Blue alpha:1.0];
	label1.textColor = labelColour;
	label2.textColor = labelColour;
	label3.textColor = labelColour;
	label4.textColor = labelColour;
	label5.textColor = labelColour;
	label6.textColor = labelColour;
	label7.textColor = labelColour;
	label8.textColor = labelColour;
	label9.textColor = labelColour;
	label10.textColor = labelColour;
	label11.textColor = labelColour;
	label12.textColor = labelColour;
	label13.textColor = labelColour;
	label14.textColor = labelColour;
}

- (void)dealloc {
	[heading release]; 
	[explanation release]; 
	[mainImage release];

	[label1 release]; 	[label2 release];	[label3 release]; 	[label4 release];	[label5 release]; 
	[label6 release];	[label7 release]; 	[label8 release];	[label9 release]; 	[label10 release];
	[label11 release]; 	[label12 release];	[label13 release]; 	[label14 release];
	
	[image1 release]; 	[image2 release];	[image3 release]; 	[image4 release];	[image5 release]; 
	[image6 release];	[image7 release]; 	[image8 release];	[image9 release]; 	[image10 release];
	[image11 release]; 	[image12 release];	[image13 release]; 	[image14 release];
	
	[labelColour release];

    [super dealloc];
}


@end
