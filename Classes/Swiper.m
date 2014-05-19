//
//  Swiper.m
//  DoctotSyncope
//
//  Created by Fergal McDonnell on 22/04/2014.
//  Copyright 2014 Tailteann. All rights reserved.
//

#import "Swiper.h"
#import "WRUPlayerAppDelegate.h"
#import "MainViewController.h"
#import "Scale_HQ.h"
#import "Scale_Question.h"

@implementation Swiper

@synthesize type, score, redMarkerPosition, longIncrement, jumpDistanceByValue, jumpDistanceInPixels, startingValue, endingValue, percision;
@synthesize theContent;

float INCREMENT_WIDTH = 50;
float INCREMENT_HEIGHT = 99;
float LABEL_WIDTH = 50;
float LABEL_HEIGHT = 50;
float LABEL_OFFSET = 50;
float LABEL_TOP_PADDING = 25;
float PADDING_VALUES_REQUIRED = 3;
float DISTANCE_TO_RED_MARKER;

WRUPlayerAppDelegate *appDelegate;
MainViewController *aMainViewController;
Scale_HQ *currentViewController;
Scale_Question *currentScaleQuestion;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)setupSwiperOfType:(NSString *)theType andStartValue:(float)startValue andEndValue:(float)endValue withDefaultScore:(float)defaultScore{
    
    self.delegate = self;
    
    type = theType;
    startingValue = startValue;
    endingValue = endValue;
    
    score = defaultScore;
    
    appDelegate = (WRUPlayerAppDelegate *)[[UIApplication sharedApplication] delegate];
    aMainViewController = (MainViewController *)appDelegate.mainViewController;
    currentViewController = (Scale_HQ *)aMainViewController.targetViewController;
    
    UIImage *theBackground = [UIImage imageNamed:@"survey_dial_age.png"];
    if( [theType isEqualToString:@"weight"] ){
        theBackground = [UIImage imageNamed:@"survey_dial_weight.png"];
        longIncrement = NO;
        LABEL_WIDTH = 100;
        LABEL_OFFSET = LABEL_WIDTH;
        jumpDistanceInPixels = LABEL_WIDTH / 10;
        jumpDistanceByValue = 1;
        PADDING_VALUES_REQUIRED = 2;
        percision = @"%.1f";
    }else{
        longIncrement = YES;
        LABEL_WIDTH = 50;
        LABEL_OFFSET = LABEL_WIDTH / 2;
        jumpDistanceInPixels = LABEL_WIDTH;
        jumpDistanceByValue = 1;
        PADDING_VALUES_REQUIRED = 3;
        percision = @"%.0f";
    }
    
    startValue -= PADDING_VALUES_REQUIRED;
    endValue += PADDING_VALUES_REQUIRED;
    
    theContent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ((endValue - startValue) * LABEL_WIDTH), INCREMENT_HEIGHT)];
    theContent.backgroundColor = [UIColor colorWithPatternImage:theBackground];

    UILabel *marker;
    float markerValue;
    float nthMarker = 0;
    for(float i = startValue; i <= endValue; i++){
        
        if( (i >= startingValue) && (i <= endingValue) ){
            
            nthMarker = i - startValue;
            marker = [[UILabel alloc] initWithFrame:CGRectMake( ((nthMarker * LABEL_WIDTH) - LABEL_OFFSET), LABEL_TOP_PADDING, LABEL_WIDTH, LABEL_HEIGHT)];
            markerValue = startValue + (nthMarker * jumpDistanceByValue);
            marker.text = [NSString stringWithFormat:@"%.0f", markerValue];
            marker.textAlignment = NSTextAlignmentCenter;
            marker.textColor = [UIColor whiteColor];
            marker.backgroundColor = [UIColor clearColor];
            
            [theContent addSubview:marker];
            
        }
        
    }
    
    DISTANCE_TO_RED_MARKER = self.frame.size.width / 2;
    [self jumpToScore:defaultScore];
     
    [self addSubview:theContent];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self setTheScore];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self setTheScore];
}

- (void) touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event {
	
	UITouch *touch = [touches anyObject];
	CGPoint tap_location = [touch locationInView:self];
	CGPoint centrePoint = CGPointMake( ( self.contentOffset.x + (self.frame.size.width / 2) ) , self.contentOffset.y);
    float newXlocation;
    
	switch ([touch tapCount]) {
		case 1: //Single Tap.
			if(tap_location.x > centrePoint.x){
                //NSLog(@"Single: To the right");
                if( [type isEqualToString:@"weight"] ){
                    newXlocation = self.contentOffset.x + (LABEL_WIDTH / 10);
                }else{
                    newXlocation = self.contentOffset.x + LABEL_WIDTH;
                }
			}else{
				//NSLog(@"Single: To the left");
                if( [type isEqualToString:@"weight"] ){
                    newXlocation = self.contentOffset.x - (LABEL_WIDTH / 10);
                }else{
                    newXlocation = self.contentOffset.x - LABEL_WIDTH;
                }
			}
            self.contentOffset = CGPointMake(newXlocation, self.contentOffset.y);
            [self setTheScore];
            
			break;
		case 2: //Double tap.
			if(tap_location.x > centrePoint.x){
                //NSLog(@"Double: To the right");
                if( [type isEqualToString:@"weight"] ){
                    newXlocation = self.contentOffset.x + ((LABEL_WIDTH * 9) / 10);
                }else{
                    newXlocation = self.contentOffset.x + (LABEL_WIDTH * 9);
                }
            }else{
                //NSLog(@"Double: To the left");
                if( [type isEqualToString:@"weight"] ){
                    newXlocation = self.contentOffset.x - ((LABEL_WIDTH * 9) / 10);
                }else{
                    newXlocation = self.contentOffset.x - (LABEL_WIDTH * 9);
                }
			}
            self.contentOffset = CGPointMake(newXlocation, self.contentOffset.y);
            [self setTheScore];
            
			break;
	}
    
}

- (void)setTheScore{
    
    float roundedPosition;
    int roundedPositionInteger;
    float newXOffset;
    redMarkerPosition = self.contentOffset.x / LABEL_WIDTH;
    
    if( [type isEqualToString:@"weight"] ){
        roundedPositionInteger = (redMarkerPosition + .05) * 10;
        roundedPosition = (float)roundedPositionInteger / 10;
        newXOffset = roundedPosition * LABEL_WIDTH;        
    }else{
        roundedPositionInteger = (int)(redMarkerPosition + 0.5);
        newXOffset = roundedPositionInteger * LABEL_WIDTH;
        roundedPosition = roundedPositionInteger;
    }
    
    self.contentOffset = CGPointMake(newXOffset, self.contentOffset.y);
    score = roundedPosition + startingValue;
    
    // Adjustment for weight
    if( [type isEqualToString:@"weight"] ){
        //score /= 2;
    }
    
    // Ajustment for exceeding min and max values
    if( score < startingValue ){
        score = startingValue;
        [self jumpToScore:score];
    }
    if( score > endingValue ){
        score = endingValue;
        [self jumpToScore:score];
    }
    
    [self updateSwipeScore];

}

- (IBAction)updateSwipeScore{
    
    currentScaleQuestion = currentViewController.currentQuestionView;
    
    currentScaleQuestion.score = score;
    currentScaleQuestion.option1Score.text = [NSString stringWithFormat:percision, score];
    
    [currentScaleQuestion updateFromSwiper];
    [currentViewController sliderUpdatesScore];
    
}

- (void)jumpToScore:(float)newScore{
    
    redMarkerPosition = ( (newScore - startingValue) * LABEL_WIDTH ) + DISTANCE_TO_RED_MARKER;
    
    self.contentSize = CGSizeMake(theContent.frame.size.width, theContent.frame.size.height) ;
    self.contentOffset = CGPointMake( (redMarkerPosition - DISTANCE_TO_RED_MARKER), 0);
    
}

- (void)dealloc{
    [theContent release];
    [currentViewController release];    [currentScaleQuestion release];
    [type release]; [percision release];
    
    [super dealloc];
}

@end
