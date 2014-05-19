//
//  Scale_Start.h
//  WRUPlayer
//
//  Created by Fergal McDonnell on 22/04/2014.
//  Copyright 2014 Tailteann. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Scale_Start : UIView {
	
    UILabel *fullName;
	UILabel *position;
    UIImageView *playerImage;
	
    UILabel *fullTitle;
	UILabel *subTag;
	
	UIButton *startTest;
	UIButton *goToInfo;
	UIButton *goToSavedScores;
	
	UIImageView *background;
}

@property (nonatomic, retain) IBOutlet UILabel *fullName;
@property (nonatomic, retain) IBOutlet UILabel *position;
@property (nonatomic, retain) IBOutlet UIImageView *playerImage;
@property (nonatomic, retain) IBOutlet UILabel *fullTitle;
@property (nonatomic, retain) IBOutlet UILabel *subTag;
@property (nonatomic, retain) IBOutlet UIButton *startTest;
@property (nonatomic, retain) IBOutlet UIButton *goToInfo;
@property (nonatomic, retain) IBOutlet UIButton *goToSavedScores;

@property (nonatomic, retain) IBOutlet UIImageView *background;

- (void)goFor:(NSString *)scale;

@end
