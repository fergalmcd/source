//
//  FavouriteDetail.h
//  IPHA
//
//  Created by Fergal McDonnell on 24/02/2014.
//
//

#import <UIKit/UIKit.h>
#import "Player.h"
#import "Survey.h"

@interface SurveyDetail : UIViewController {
    
    UIView *detailsView;
    UILabel *detailsInfo;
    UIWebView *detailsContent;
    UIButton *resubmitButton;
    
    Player *detailPlayer;
    int location;
    
    Survey *survey;

}

@property (nonatomic, retain) IBOutlet UIView *detailsView;
@property (nonatomic, retain) IBOutlet UILabel *detailsInfo;
@property (nonatomic, retain) IBOutlet UIWebView *detailsContent;
@property (nonatomic, retain) IBOutlet UIButton *resubmitButton;
@property (nonatomic, retain) Player *detailPlayer;
@property int location;
@property (nonatomic, retain) Survey *survey;

- (void)setup:(Player *)selectedPlayer atLocation:(int)theLocation;
- (IBAction)resubmitPlayer;


@end
