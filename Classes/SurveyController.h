//
//  SurveyController.h
//  WRU
//
//  Created by Fergal McDonnell on 06/05/2014.
//
//

#import <UIKit/UIKit.h>
#import "SurveysParser.h"
#import "Player.h"
#import "Survey.h"
#import "SurveyDetail.h"

@class Survey;

@interface SurveyController : UIViewController <UITableViewDelegate> {

    Survey *survey;
    
    UIView *surveyView;
    UITableView *surveyTable;
    
    SurveyDetail *detailsView;
    
}

@property (nonatomic, retain) Survey *survey;

@property (nonatomic, retain) IBOutlet UIView *surveyView;
@property (nonatomic, retain) IBOutlet UITableView *surveyTable;

@property (nonatomic, retain) IBOutlet SurveyDetail *detailsView;

- (void)setup;
- (void)displaySelectedSurveyDetails:(Player *)entryToDisplay;
- (void)displayUpdateMessage;
- (BOOL)surveyIsUpToDate;
- (void)getUpdatedInformationForSelectedEntry;


@end
