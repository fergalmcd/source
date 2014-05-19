//
//  IndividualScoreCell.m
//  WRUPlayer
//
//  Created by Fergal McDonnell on 22/04/2014.
//  Copyright 2014 Tailteann. All rights reserved.
//

#import "IndividualScoreCell.h"
#import "Constants.h"


@interface IndividualScoreCell (PrivateMethods)

- (UILabel *)newLabelWithPrimaryColor:(UIColor *)primaryColor 
						selectedColor:(UIColor *)selectedColor
						fontSize	 :(CGFloat)  fontSize
						bold		 :(BOOL)	 bold;

@end


@implementation IndividualScoreCell

@synthesize individualScore;
@synthesize fullName_label, date_label, score_label;
@synthesize categoryImage;

@synthesize colourDotAsString_label;

UIView *myContentView;
NSString *scale;
NSString *colourDotAsString;


- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        myContentView = self.contentView;
		
		self.date_label = [self newLabelWithPrimaryColor:[UIColor blackColor] selectedColor:[UIColor whiteColor] fontSize:10.0 bold:YES];
		[myContentView addSubview:self.date_label];	
		[self.date_label release];
		
		self.fullName_label = [self newLabelWithPrimaryColor:[UIColor blackColor] selectedColor:[UIColor whiteColor] fontSize:14.0 bold:YES];
		[myContentView addSubview:self.fullName_label];	
		[self.fullName_label release];
		
		self.score_label = [self newLabelWithPrimaryColor:[UIColor blackColor] selectedColor:[UIColor whiteColor] fontSize:14.0 bold:YES];
		[myContentView addSubview:self.score_label];	
		[self.score_label release];
		
		self.categoryImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:whiteDot]];
		[myContentView addSubview:self.categoryImage];	
		
		self.colourDotAsString_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
		[myContentView addSubview:self.colourDotAsString_label];	
		[self.colourDotAsString_label release];
		
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];
	
    UIColor *bkColor = nil;
	if(selected){	bkColor = [UIColor clearColor];
	} else			bkColor = [UIColor whiteColor];
	
	self.fullName_label.backgroundColor = bkColor;
	self.fullName_label.highlighted = selected;
	self.fullName_label.opaque = !selected;
	
	self.date_label.backgroundColor = bkColor;
	self.date_label.highlighted = selected;
	self.date_label.opaque = !selected;
	
	[bkColor release];
}


- (void)dealloc {
	[individualScore release];
	[myContentView release];
	[scale release];
	[colourDotAsString release];
	[categoryImage release];
	
    [super dealloc];
}


- (IndividualScore *)individualScore{
	return self.individualScore;
}

- (void)setIndividualScore:(IndividualScore *)newIndividualScore{
	individualScore = newIndividualScore;
	self.fullName_label.text = [[NSString alloc] initWithFormat:@"%@ %@", individualScore.firstName, individualScore.lastName ];

	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init]  autorelease];
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	individualScore.date = [dateFormatter stringFromDate:individualScore.dateForDisplay];
	
	self.date_label.text = individualScore.date;
	scale = individualScore.scale;
	
	self.score_label.text = [[NSString alloc] initWithFormat:@"%.0f", individualScore.score ];
		
	self.colourDotAsString_label.text = individualScore.diagnosisColour;
	
	[self setNeedsDisplay];
	
}


- (UILabel *)newLabelWithPrimaryColor:(UIColor *)primaryColor selectedColor:(UIColor *)selectedColor fontSize:(CGFloat)fontSize bold:(BOOL)bold {
	UIFont *font;
	if (bold) {	font = [UIFont boldSystemFontOfSize:fontSize];
	} else		font = [UIFont systemFontOfSize:fontSize];
	
	UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	newLabel.backgroundColor = [UIColor whiteColor];
	newLabel.opaque = YES;
	newLabel.textColor = primaryColor;
	newLabel.highlightedTextColor = selectedColor;
	newLabel.font = font;
	
	return newLabel;
}

- (UIImage *)imageForPriority:(NSInteger)priority{
	switch (priority) {
		case 2:
			return nil;
			break;
		default:
			return nil;
			break;
	}
	return nil;
}

- (void)layoutSubviews{
#define FIRST_COLUMN_OFFSET 10
#define FIRST_COLUMN_WIDTH 75

#define SECOND_COLUMN_OFFSET 100
#define SECOND_COLUMN_WIDTH 200

#define THIRD_COLUMN_OFFSET 270
#define THIRD_COLUMN_WIDTH 50
	
#define UPPER_ROW_TOP 4
#define UPPER_ROW_HEIGHT 17
	
#define IMAGE_HEIGHT 12

#define FRAME_HEIGHT 15
	
	[super layoutSubviews];
	
	if(!self.editing){
		CGRect frame;
		
		frame = CGRectMake(  FIRST_COLUMN_OFFSET , UPPER_ROW_TOP , FIRST_COLUMN_WIDTH , UPPER_ROW_HEIGHT);
		frame.origin.y = FRAME_HEIGHT;
		self.date_label.frame = frame;
		
		frame = CGRectMake(  SECOND_COLUMN_OFFSET , UPPER_ROW_TOP , SECOND_COLUMN_WIDTH , UPPER_ROW_HEIGHT);
		frame.origin.y = FRAME_HEIGHT;
		self.fullName_label.frame = frame;
		
		frame = CGRectMake(  THIRD_COLUMN_OFFSET , UPPER_ROW_TOP , THIRD_COLUMN_WIDTH , UPPER_ROW_HEIGHT);
		frame.origin.y = FRAME_HEIGHT;
		self.score_label.frame = frame;
		
		frame = CGRectMake(  FIRST_COLUMN_WIDTH , UPPER_ROW_TOP , IMAGE_HEIGHT , IMAGE_HEIGHT);
		frame.origin.y = FRAME_HEIGHT;
		self.categoryImage.frame = frame;
		
		
		colourDotAsString = colourDotAsString_label.text;
		
		self.score_label.textColor = [UIColor blackColor];
		self.categoryImage.image = [UIImage imageNamed:whiteDot];

		if([colourDotAsString isEqualToString:@"red"])	self.categoryImage.image = [UIImage imageNamed:redDot];
		if([colourDotAsString isEqualToString:@"orange"])	self.categoryImage.image = [UIImage imageNamed:orangeDot];
		if([colourDotAsString isEqualToString:@"yellow"])	self.categoryImage.image = [UIImage imageNamed:yellowDot];
		if([colourDotAsString isEqualToString:@"blue"])	self.categoryImage.image = [UIImage imageNamed:blueDot];
		if([colourDotAsString isEqualToString:@"white"])	self.categoryImage.image = [UIImage imageNamed:whiteDot];
				
	}
}


@end
