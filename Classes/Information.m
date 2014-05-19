//
//  Information.m
//  WRUPlayer
//
//  Created by Fergal McDonnell on 22/04/2014.
//  Copyright Tailteann 2014. All rights reserved.
//

#import "Information.h"
#import "Constants.h"
#import "DoctotHelper.h"


@implementation Information

@synthesize heading, subHeading, reference, infoitem1_label, infoitem1, infoitem2_label, infoitem2, infoitem3_label, infoitem3, infoitem4_label, infoitem4;
@synthesize groupedTable;
@synthesize currentLabelText;
@synthesize infoItem;
@synthesize helpViewController, helpContentsViewController;
@synthesize backButtonItem, backButton;

NSString *text_for_overview;
NSString *text_for_commentary;
NSString *text_for_mainPurpose;
NSString *text_for_scoring;
NSString *text_for_versions;
NSString *text_for_additionalReferences;
NSString *text_for_address;
NSString *text_for_help;

UIView *myContent;
UIButton *cellButton;
UILabel *cellLabel;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self)
	{
		// this will appear as the title in the navigation bar
	}
	
	return self;
}

- (void)dealloc
{
	[super dealloc];
	
	[heading release];
	[subHeading release];
	[reference release];
	[infoitem1_label release];
	[infoitem1 release];
	[infoitem2_label release];
	[infoitem2 release];
	[infoitem3_label release];
	[infoitem3 release];
	[infoitem4_label release];
	[infoitem4 release];
	
	[groupedTable release];
	[myContent release];
	[cellButton release];
	[cellLabel release];

	[currentLabelText release];
	[infoItem release];
	[helpContentsViewController release];
	[helpViewController release];
	[backButtonItem release];
	[backButton release];
	
	[text_for_overview release];
	[text_for_mainPurpose release];
	[text_for_commentary release];
	[text_for_scoring release];
	[text_for_versions release];
	[text_for_additionalReferences release];
	[text_for_address release];
	[text_for_help release];
}

// fetch objects from our bundle based on keys in our Info.plist
- (id)infoValueForKey:(NSString*)key
{
	if ([[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:key])
		return [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:key];
	return [[[NSBundle mainBundle] infoDictionary] objectForKey:key];
}

// Automatically invoked after -loadView
// This is the preferred override point for doing additional setup after -initWithNibName:bundle:
//
- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.navigationItem.title = NSLocalizedString(@"Button_Information", @"");
    
    // Set Up the Top Left of the Nav Bar
    UIButton* leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 43, 49)];
	[leftButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setImage:[UIImage imageNamed:@"icon_back.png"] forState:UIControlStateNormal];
	UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
	
	infoItem = [[InfoItem alloc] initWithNibName:@"InfoItem" bundle:nil];
	helpContentsViewController = [[HelpContents alloc] initWithNibName:@"HelpContents" bundle:nil];
	helpViewController = [[Help alloc] initWithNibName:@"Help" bundle:nil];
	
	infoitem1_label.text = NSLocalizedString(@"Info_Rating", @"");
	infoitem2_label.text = NSLocalizedString(@"Info_AdministrationTime", @"");
	infoitem3_label.text = NSLocalizedString(@"Info_MainPurpose", @"");
	infoitem4_label.text = NSLocalizedString(@"Info_Population", @"");
	
	currentLabelText.text = text_for_commentary;
	
	extern NSString *infoScale;
	[self setInfoFor:infoScale];
	
	groupedTable.backgroundColor = [UIColor clearColor];
	[groupedTable reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
	// do something here as our view re-appears
}

- (void)setInfoFor:(NSString *)scale{

	scale = [scale uppercaseString];
	
	NSString *reference_string = [[NSString alloc] initWithFormat:@"%@_Info_Reference", scale];
	NSString *infoitem1_string = [[NSString alloc] initWithFormat:@"%@_Info_Rating", scale];
	NSString *infoitem2_string = [[NSString alloc] initWithFormat:@"%@_Info_AdministrationTime", scale];
	NSString *infoitem3_string = [[NSString alloc] initWithFormat:@"%@_Info_MainPurpose", scale];
	NSString *infoitem4_string = [[NSString alloc] initWithFormat:@"%@_Info_Population", scale];
	NSString *text_for_mainPurpose_string = [[NSString alloc] initWithFormat:@"%@_Info_MainPurpose", scale];
	NSString *text_for_commentary_string = [[NSString alloc] initWithFormat:@"%@_Info_Commentary", scale];
	NSString *text_for_scoring_string = [[NSString alloc] initWithFormat:@"%@_Info_Scoring", scale];
	NSString *text_for_versions_string = [[NSString alloc] initWithFormat:@"%@_Info_Versions", scale];
	NSString *text_for_additionalReferences_string = [[NSString alloc] initWithFormat:@"%@_Info_AdditionalReferences", scale];
	NSString *text_for_address_string = [[NSString alloc] initWithFormat:@"%@_Info_Address", scale];
	
	infoItem.scale = scale;
	reference.text = NSLocalizedString(reference_string, @"");
		
	infoitem1.text = NSLocalizedString(infoitem1_string, @"");
	infoitem2.text = NSLocalizedString(infoitem2_string, @"");
	infoitem3.text = NSLocalizedString(infoitem3_string, @"");
	infoitem4.text = NSLocalizedString(infoitem4_string, @"");
	
	text_for_overview = [[NSString alloc] initWithFormat:@"%@:\n%@\n\n%@:\n%@\n\n%@:\n%@\n", 
						 NSLocalizedString(@"Info_Rating", @""), NSLocalizedString(infoitem1_string, @""),  
						 NSLocalizedString(@"Info_Population", @""), NSLocalizedString(infoitem4_string, @""), 
						 NSLocalizedString(@"Info_AdministrationTime", @""), NSLocalizedString(infoitem2_string, @"")];
	text_for_mainPurpose = NSLocalizedString(text_for_mainPurpose_string, @"");
	text_for_commentary = NSLocalizedString(text_for_commentary_string, @"");
	text_for_scoring = NSLocalizedString(text_for_scoring_string, @"");
	text_for_versions = NSLocalizedString(text_for_versions_string, @"");
	text_for_additionalReferences = NSLocalizedString(text_for_additionalReferences_string, @"");
	text_for_address = NSLocalizedString(text_for_address_string, @"");
	
	[reference_string release];
	[infoitem1_string release];
	[infoitem2_string release];
	[infoitem3_string release];
	[infoitem4_string release];
	[text_for_mainPurpose_string release];
	[text_for_commentary_string release];
	[text_for_scoring_string release];
	[text_for_versions_string release];
	[text_for_additionalReferences_string release];
	[text_for_address_string release];
}


- (IBAction)setTextForOverview{	
	[self transitionToInfoItem];
	infoItem.infoTextView.text = text_for_overview;
	infoItem.infoType.text = NSLocalizedString(@"Info_Overview", @"");
	infoItem.navigationItem.title = NSLocalizedString(@"Info_Overview", @"");
}
- (IBAction)setTextForMainPurpose{	
	[self transitionToInfoItem];
	infoItem.infoTextView.text = text_for_mainPurpose;
	infoItem.infoType.text = NSLocalizedString(@"Info_MainPurpose", @"");
	infoItem.navigationItem.title = NSLocalizedString(@"Info_MainPurpose", @"");
}
- (IBAction)setTextForCommentary{	
	[self transitionToInfoItem];
	infoItem.infoTextView.text = text_for_commentary;
	infoItem.infoType.text = NSLocalizedString(@"Info_Commentary", @"");
	infoItem.navigationItem.title = NSLocalizedString(@"Info_Commentary", @"");
}
- (IBAction)setTextForScoring{
	[self transitionToInfoItem];
	infoItem.infoTextView.text = text_for_scoring;
	infoItem.infoType.text = NSLocalizedString(@"Info_Scoring", @"");
	infoItem.navigationItem.title = NSLocalizedString(@"Info_Scoring", @"");
}
- (IBAction)setTextForVersion{	
	[self transitionToInfoItem];
	infoItem.infoTextView.text = text_for_versions;
	infoItem.infoType.text = NSLocalizedString(@"Info_Versions", @"");
	infoItem.navigationItem.title = NSLocalizedString(@"Info_Versions", @"");
}
- (IBAction)setTextForAdditionalReferences{	
	[self transitionToInfoItem];
	infoItem.infoTextView.text = text_for_additionalReferences;
	infoItem.infoType.text = NSLocalizedString(@"Info_AdditionalReferences", @"");
	infoItem.navigationItem.title = NSLocalizedString(@"Info_AdditionalReferences", @"");
}
- (IBAction)setTextForAddress{	
	[self transitionToInfoItem];
	infoItem.infoTextView.text = text_for_address;
	infoItem.infoType.text = NSLocalizedString(@"Info_Address", @"");
	infoItem.navigationItem.title = NSLocalizedString(@"Info_Address", @"");
}
- (void)transitionToInfoItem{
	[[self navigationController] pushViewController:infoItem animated:YES];
}

// Help Options
- (IBAction)goToHelpSection{
	//[[self navigationController] pushViewController:helpViewController animated:YES];
	[[self navigationController] pushViewController:helpContentsViewController animated:YES];
}

- (void)flipTransition{
	[DoctotHelper flipTransition:[[[self navigationController] view] superview] From:@"right"];
	[[self navigationController] popViewControllerAnimated:NO];
}

- (void)popViewController {
    [[self navigationController] popViewControllerAnimated:YES];
}

///// Table Methods /////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0)	return 7;
	if(section == 1)	return 1;
	
	return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	static NSString *CellIdentifier = @"InfoCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		//cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
        cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
	}

	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	myContent = cell.contentView;
	
	cellButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 300, 44)];
	[cellButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	
	// Set up the cell...
	if( (indexPath.section == 0) && (indexPath.row == 0) )	{
		[cellButton setTitle:NSLocalizedString(@"Info_Overview", @"") forState:UIControlStateNormal];
		[cellButton addTarget:self action:@selector(setTextForOverview) forControlEvents:UIControlEventTouchDown];
	}
	if( (indexPath.section == 0) && (indexPath.row == 1) )	{
		[cellButton setTitle:NSLocalizedString(@"Info_MainPurpose", @"") forState:UIControlStateNormal];
		[cellButton addTarget:self action:@selector(setTextForMainPurpose) forControlEvents:UIControlEventTouchDown];
	}
	if( (indexPath.section == 0) && (indexPath.row == 2) )	{
		[cellButton setTitle:NSLocalizedString(@"Info_Commentary", @"") forState:UIControlStateNormal];
		[cellButton addTarget:self action:@selector(setTextForCommentary) forControlEvents:UIControlEventTouchDown];
	}
	if( (indexPath.section == 0) && (indexPath.row == 3) )	{
		[cellButton setTitle:NSLocalizedString(@"Info_AdditionalReferences", @"") forState:UIControlStateNormal];
		[cellButton addTarget:self action:@selector(setTextForAdditionalReferences) forControlEvents:UIControlEventTouchDown];
	}
	if( (indexPath.section == 0) && (indexPath.row == 4) )	{
		[cellButton setTitle:NSLocalizedString(@"Info_Address", @"") forState:UIControlStateNormal];
		[cellButton addTarget:self action:@selector(setTextForAddress) forControlEvents:UIControlEventTouchDown];
	}
	if( (indexPath.section == 0) && (indexPath.row == 5) )	{
		[cellButton setTitle:NSLocalizedString(@"Info_Scoring", @"") forState:UIControlStateNormal];
		[cellButton addTarget:self action:@selector(setTextForScoring) forControlEvents:UIControlEventTouchDown];
	}
	if( (indexPath.section == 0) && (indexPath.row == 6) )	{
		[cellButton setTitle:NSLocalizedString(@"Info_Versions", @"") forState:UIControlStateNormal];
		[cellButton addTarget:self action:@selector(setTextForVersion) forControlEvents:UIControlEventTouchDown];
	}
	
	
	if( (indexPath.section == 1) && (indexPath.row == 0) )	{
		[cellButton setTitle:NSLocalizedString(@"Info_Help", @"") forState:UIControlStateNormal];
		[cellButton addTarget:self action:@selector(goToHelpSection) forControlEvents:UIControlEventTouchDown];
	}
	
	cellButton.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
	[myContent addSubview:cellButton];
	
	return cell;
}


@end
