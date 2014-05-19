//
//  PowerBar.m
//  DoctotChest
//
//  Created by Fergal McDonnell on 02/01/2012.
//  Copyright (c) 2012 Doctot. All rights reserved.
//

#import "PowerBar.h"
#import "WRUPlayerAppDelegate.h"
#import "MainViewController.h"
#import "Scale_HQ.h"
#import "Scale_Question.h"
//#import "CATQuestion.h"

@implementation PowerBar

@synthesize identifier;
@synthesize startingValue, endingValue, range, pixelGapBetweenValues, score;

UIImageView *indicator;
WRUPlayerAppDelegate *appDelegate;
MainViewController *theMainViewController;
Scale_HQ *currentViewController;
Scale_Question *currentScaleQuestion;
//CATQuestion *catQuestion;

- (void)setupPowerBarStartingAt:(int)startValue andEndingAt:(int)endValue forIdentifier:(NSString *)theIdentifier {
    
    appDelegate = (WRUPlayerAppDelegate *)[[UIApplication sharedApplication] delegate];
    theMainViewController = (MainViewController *)appDelegate.mainViewController;
    currentViewController = (Scale_HQ *)theMainViewController.targetViewController;
    
    identifier = theIdentifier;
    startingValue = startValue;
    endingValue = endValue;
    range = endingValue - startingValue;
    
    pixelGapBetweenValues = self.frame.size.width / ( range + 1 );
    //pixelGapBetweenValues = self.frame.size.width / (( range + 1 ) * 10 );
    
    self.delegate = self;
    self.bounces = NO;
    
    self.contentSize = CGSizeMake((self.frame.size.width * 2), self.frame.size.height);
    self.contentOffset = CGPointMake( self.frame.size.width , 0);
    indicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"survey_fill.png"]];
    indicator.frame = CGRectMake( 0, 0, self.frame.size.width, self.frame.size.height);
    
    [self addSubview:indicator];
    
}

////////////////////////////////////////////////////////////////////////////////////
// ScrollView Delegates
////////////////////////////////////////////////////////////////////////////////////

- (void)scrollViewDidScroll:(UIScrollView *) scrollView{
	
	float offsetScore = scrollView.contentOffset.x / pixelGapBetweenValues;
    //float offsetScore = (10 * scrollView.contentOffset.x) / pixelGapBetweenValues;
    
    score = endingValue - (int)offsetScore;
    
    if( ( self.contentOffset.x >= 285 ) && ( self.contentOffset.x != 320 ) ){
        self.contentOffset = CGPointMake(285, self.contentOffset.y);
    }
    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self roundOffBar];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self roundOffBar];
}

- (void) touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event {
	
	UITouch *touch = [touches anyObject];
	CGPoint tap_location = [touch locationInView:self];
    
    float relativePointTapped = tap_location.x - self.contentOffset.x;
    
    score = (int)(relativePointTapped / pixelGapBetweenValues);
    
    [self roundOffBar];
}

- (void)roundOffBar{

    if( score < 0 ){
        score = 0;
    }
    
    self.contentOffset = CGPointMake( ( self.frame.size.width - ((score + 1) * pixelGapBetweenValues) + 1 ) , 0);
    
    score = score / 10;
    
    currentScaleQuestion = (Scale_Question *)currentViewController.currentQuestionView;
    [currentScaleQuestion setPowerBarScore:score forIdentifier:identifier];
 
    //catQuestion = (CATQuestion *)currentViewController.catScale.currentQuestion;
    //[catQuestion setPowerBarScore:score];

}

////////////////////////////////////////////////////////////////////////////////////

- (void)dealloc{
    [indicator release];
    [appDelegate release];
    
    [super dealloc];
}

@end
