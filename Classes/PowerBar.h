//
//  PowerBar.h
//  DoctotChest
//
//  Created by Fergal McDonnell on 02/01/2012.
//  Copyright (c) 2012 Doctot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PowerBar : UIScrollView <UIScrollViewDelegate>{
    
    NSString *identifier;
    
    NSInteger startingValue;
    NSInteger endingValue;
    NSInteger range;
    
    NSInteger pixelGapBetweenValues;
    
    float score;
}

@property (nonatomic, retain) NSString *identifier;
@property NSInteger startingValue;
@property NSInteger endingValue;
@property NSInteger range;
@property NSInteger pixelGapBetweenValues;
@property float score;

- (void)setupPowerBarStartingAt:(int)startValue andEndingAt:(int)endValue forIdentifier:(NSString *)theIdentifier;
- (void)roundOffBar;


@end
