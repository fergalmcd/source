//
//  Swiper.h
//  DoctotSyncope
//
//  Created by Fergal McDonnell on 22/04/2014.
//  Copyright 2014 Tailteann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Swiper : UIScrollView <UIScrollViewDelegate> {
    
    NSString *type;
    float score;
    float redMarkerPosition;
    BOOL longIncrement;
    float jumpDistanceByValue;
    float jumpDistanceInPixels;
    float startingValue;
    float endingValue;
    NSString *percision;
    
    UIView *theContent;
    
}

@property (nonatomic, retain) NSString *type;
@property float score;
@property float redMarkerPosition;
@property BOOL longIncrement;
@property float jumpDistanceByValue;
@property float jumpDistanceInPixels;
@property float startingValue;
@property float endingValue;
@property (nonatomic, retain) NSString *percision;
@property (nonatomic, retain) IBOutlet UIView *theContent;

- (void)setupSwiperOfType:(NSString *)theType andStartValue:(float)startValue andEndValue:(float)endValue withDefaultScore:(float)defaultScore;
- (IBAction)updateSwipeScore;
- (void)setTheScore;
- (void)jumpToScore:(float)newScore;


@end
