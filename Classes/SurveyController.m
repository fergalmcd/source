//
//  SurveyController.m
//  WRU
//
//  Created by Fergal McDonnell on 06/05/2014.
//
//

#import "SurveyController.h"
#import "Player.h"
#import "SurveysParser.h"
#import "DoctotHelper.h"
#import "Constants.h"

@interface SurveyController ()

@end

@implementation SurveyController

@synthesize survey;
@synthesize surveyView, surveyTable;
@synthesize detailsView;

UIButton *surveysBackButton;
UIBarButtonItem *surveysBackButtonItem;
UIButton *surveysEditButton;
UIBarButtonItem *surveysEditButtonItem;
UILabel *dateLabel;
UILabel *weightLabel;
UIImageView *submittedIcon;

Player *selectedPlayer;
int selectedTableListing;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Set the Title
    self.title = NSLocalizedString(@"Save_Title", @"");
    
    // Set Up the Top Left of the Nav Bar
	surveysBackButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 43, 49)];
    [surveysBackButton setBackgroundImage:[UIImage imageNamed:@"icon_back.png"] forState:UIControlStateNormal];
    [surveysBackButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
	surveysBackButtonItem = [[UIBarButtonItem alloc] initWithCustomView:surveysBackButton];
	self.navigationItem.leftBarButtonItem = surveysBackButtonItem;
    
    // Set Up the Top Right of the Nav Bar
	surveysEditButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 43, 49)];
    [surveysEditButton setTitle:NSLocalizedString(@"Button_Edit", @"") forState:UIControlStateNormal];
    [surveysEditButton addTarget:self action:@selector(enterEditingMode) forControlEvents:UIControlEventTouchUpInside];
	surveysEditButtonItem = [[UIBarButtonItem alloc] initWithCustomView:surveysEditButton];
	//self.navigationItem.rightBarButtonItem = surveysEditButtonItem;

}

- (void)setup{

    survey = (Survey *)[SurveysParser loadSurvey];
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateAsInt" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSMutableArray *unsortedArray = [[NSMutableArray alloc] init];
    for(Player *aPlayer in survey.entries){
        NSString *theDate = aPlayer.dateAsString;
        int aDay = [[theDate substringWithRange:NSMakeRange (0, 2)] intValue];
        int aMonth = [[theDate substringWithRange:NSMakeRange (3, 2)] intValue];
        int aYear = [[theDate substringWithRange:NSMakeRange (6, 4)] intValue];
        aPlayer.dateAsInt = (aYear * 10000) + (aMonth * 100) + aDay;
        [unsortedArray addObject:aPlayer];
    }
    NSArray *sortedArray;
    sortedArray = (NSArray *)[unsortedArray sortedArrayUsingDescriptors:sortDescriptors];
    
    survey.entries = (NSMutableArray *)sortedArray;
    
    [surveyTable reloadData];
    
}

- (void)popViewController{
    
    [[self navigationController] popViewControllerAnimated:YES];
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Table view methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [survey.entries count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"SurveyCell";
    
	UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
	}
    
    Player *thisPlayer = (Player *)[survey.entries objectAtIndex:indexPath.row];
    
    dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, 150, 25)];
    dateLabel.text = thisPlayer.dateAsString;
    dateLabel.font = [UIFont fontWithName:@"Helvetica" size:10];
    dateLabel.textColor = [UIColor blackColor];
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.numberOfLines = 2;
    
    weightLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 10, 120, 25)];
    weightLabel.text = [NSString stringWithFormat:@"%.1f Kgs", thisPlayer.weight];
    weightLabel.font = [UIFont fontWithName:@"Helvetica" size:10];
    weightLabel.textColor = [UIColor blackColor];
    weightLabel.backgroundColor = [UIColor clearColor];
    weightLabel.numberOfLines = 2;
    
    submittedIcon = [[UIImageView alloc] initWithFrame:CGRectMake(300, 15, 10, 10)];
    if( thisPlayer.successfullySubmitted ){
        submittedIcon.image = [UIImage imageNamed:@"orb_green.png"];
    }else{
        submittedIcon.image = [UIImage imageNamed:@"orb_red.png"];
    }

    [cell addSubview:dateLabel];
    [cell addSubview:weightLabel];
    [cell addSubview:submittedIcon];
    
    [dateLabel release];
    [weightLabel release];
    [submittedIcon release];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    selectedTableListing = (int)indexPath.row;
    selectedPlayer = (Player *)[survey.entries objectAtIndex:selectedTableListing];
    
    detailsView = [[SurveyDetail alloc] initWithNibName:@"SurveyDetail" bundle:nil];
    [detailsView setup:selectedPlayer atLocation:selectedTableListing];
    [[self navigationController] pushViewController:detailsView animated:YES];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [survey.entries removeObjectAtIndex:indexPath.row];
    }
    [SurveysParser saveSurvey:survey];
    [surveyTable reloadData];
    
}

- (void)enterEditingMode {
    
    if( surveyTable.isEditing ){
        [surveyTable setEditing:NO animated:YES];
    }else{
        [surveyTable setEditing:YES animated:YES];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
