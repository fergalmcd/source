//
//  HelpView.h
//  WRUPlayer
//
//  Created by Fergal McDonnell on 22/04/2014.
//  Copyright 2014 Tailteann. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HelpView : UIView {
		
	UILabel *heading;
	UILabel *explanation;
	UIImageView *mainImage;
	
	UILabel *label1;
	UILabel *label2;
	UILabel *label3;
	UILabel *label4;
	UILabel *label5;
	UILabel *label6;
	UILabel *label7;
	UILabel *label8;
	UILabel *label9;
	UILabel *label10;
	UILabel *label11;
	UILabel *label12;
	UILabel *label13;
	UILabel *label14;
	
	UIImageView *image1;
	UIImageView *image2;
	UIImageView *image3;
	UIImageView *image4;
	UIImageView *image5;
	UIImageView *image6;
	UIImageView *image7;
	UIImageView *image8;
	UIImageView *image9;
	UIImageView *image10;
	UIImageView *image11;
	UIImageView *image12;
	UIImageView *image13;
	UIImageView *image14;
}

@property (nonatomic, retain) IBOutlet UILabel *heading;
@property (nonatomic, retain) IBOutlet UILabel *explanation;
@property (nonatomic, retain) IBOutlet UIImageView *mainImage;
@property (nonatomic, retain) IBOutlet UILabel *label1;
@property (nonatomic, retain) IBOutlet UILabel *label2;
@property (nonatomic, retain) IBOutlet UILabel *label3;
@property (nonatomic, retain) IBOutlet UILabel *label4;
@property (nonatomic, retain) IBOutlet UILabel *label5;
@property (nonatomic, retain) IBOutlet UILabel *label6;
@property (nonatomic, retain) IBOutlet UILabel *label7;
@property (nonatomic, retain) IBOutlet UILabel *label8;
@property (nonatomic, retain) IBOutlet UILabel *label9;
@property (nonatomic, retain) IBOutlet UILabel *label10;
@property (nonatomic, retain) IBOutlet UILabel *label11;
@property (nonatomic, retain) IBOutlet UILabel *label12;
@property (nonatomic, retain) IBOutlet UILabel *label13;
@property (nonatomic, retain) IBOutlet UILabel *label14;
@property (nonatomic, retain) IBOutlet UIImageView *image1;
@property (nonatomic, retain) IBOutlet UIImageView *image2;
@property (nonatomic, retain) IBOutlet UIImageView *image3;
@property (nonatomic, retain) IBOutlet UIImageView *image4;
@property (nonatomic, retain) IBOutlet UIImageView *image5;
@property (nonatomic, retain) IBOutlet UIImageView *image6;
@property (nonatomic, retain) IBOutlet UIImageView *image7;
@property (nonatomic, retain) IBOutlet UIImageView *image8;
@property (nonatomic, retain) IBOutlet UIImageView *image9;
@property (nonatomic, retain) IBOutlet UIImageView *image10;
@property (nonatomic, retain) IBOutlet UIImageView *image11;
@property (nonatomic, retain) IBOutlet UIImageView *image12;
@property (nonatomic, retain) IBOutlet UIImageView *image13;
@property (nonatomic, retain) IBOutlet UIImageView *image14;


- (void)setUpView:(int)viewNumber;
- (void)setUpLabelColours;

@end
