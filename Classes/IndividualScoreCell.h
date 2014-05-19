//
//  IndividualScoreCell.h
//  DoctotNeuro
//
//  Created by Fergal McDonnell on 22/04/2014.
//  Copyright 2014 Tailteann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndividualScore.h"


@interface IndividualScoreCell : UITableViewCell {
	IndividualScore *individualScore;
	UILabel *fullName_label;
	UILabel *date_label;
	UILabel *score_label;
	UIImageView *categoryImage;
	
	UILabel *colourDotAsString_label;
	
}

@property (nonatomic, retain) IndividualScore *individualScore;
@property (nonatomic, retain) UILabel *fullName_label;
@property (nonatomic, retain) UILabel *date_label;
@property (nonatomic, retain) UILabel *score_label;
@property (nonatomic, retain) UIImageView *categoryImage;

@property (nonatomic, retain) UILabel *colourDotAsString_label;

- (UIImage *)imageForPriority:(NSInteger)priority;

- (IndividualScore *)individualScore;
- (void)setIndividualScore:(IndividualScore *)newIndividualScore;

@end
