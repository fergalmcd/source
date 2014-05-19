//
//  HelpContents.m
//  WRUPlayer
//
//  Created by Fergal McDonnell on 22/04/2014.
//  Copyright 2014 Tailteann. All rights reserved.
//

#import "HelpContents.h"


@implementation HelpContents

@synthesize groupedTable, help, background;

UIView *myContent;
UIButton *cellButton;
UILabel *cellLabel;
UIImage *tableCellBackgroundImage;


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = NSLocalizedString(@"Info_Help", @"");
    
    // Set Up the Top Left of the Nav Bar
    UIButton* leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 43, 49)];
	[leftButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setImage:[UIImage imageNamed:@"icon_back.png"] forState:UIControlStateNormal];
	UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
	
	help = [[Help alloc] initWithNibName:@"Help" bundle:nil];
	
	cellLabel = [[UILabel alloc] init];
	background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:questionBackground]];
	tableCellBackgroundImage = [UIImage imageNamed:tableCellImage];
	groupedTable.backgroundColor = [UIColor clearColor];
	[groupedTable reloadData];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)popViewController {
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


///// Table Methods /////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"HelpContentCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		//cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
        cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
	}
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	myContent = cell.contentView;
	
	cellButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 300, 44)];
	[cellButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	//[cellButton setBackgroundImage:tableCellBackgroundImage forState:UIControlStateNormal ];
	//[cellButton setBackgroundColor:[UIColor blackColor]];
	//cellButton.titleLabel.text = @"Hey";
	//[cellButton.titleLabel setTextColor:[UIColor redColor]];
	//cellButton.font = [UIFont fontWithName:@"Arial" size: 22.0];
	
	// Set up the cell...	
	if( (indexPath.section == 0) && (indexPath.row == 0) )	{
		[cellButton setTitle:NSLocalizedString(@"Info_QuestionOverview_Heading", @"") forState:UIControlStateNormal];
		[cellButton addTarget:self action:@selector(helpPage1) forControlEvents:UIControlEventTouchDown];
	}
	if( (indexPath.section == 0) && (indexPath.row == 1) )	{
		[cellButton setTitle:NSLocalizedString(@"Info_QuestionAnswered_Heading", @"") forState:UIControlStateNormal];
		[cellButton addTarget:self action:@selector(helpPage2) forControlEvents:UIControlEventTouchDown];
	}
	if( (indexPath.section == 0) && (indexPath.row == 2) )	{
		[cellButton setTitle:NSLocalizedString(@"Info_ShakeToReset_Heading", @"") forState:UIControlStateNormal];
		[cellButton addTarget:self action:@selector(helpPage3) forControlEvents:UIControlEventTouchDown];
	}
	if( (indexPath.section == 0) && (indexPath.row == 3) )	{
		[cellButton setTitle:NSLocalizedString(@"Info_SavedScores_Heading", @"") forState:UIControlStateNormal];
		[cellButton addTarget:self action:@selector(helpPage4) forControlEvents:UIControlEventTouchDown];
	}
	if( (indexPath.section == 0) && (indexPath.row == 4) )	{
		[cellButton setTitle:NSLocalizedString(@"Info_Settings_Heading", @"") forState:UIControlStateNormal];
		[cellButton addTarget:self action:@selector(helpPage5) forControlEvents:UIControlEventTouchDown];
	}
	if( (indexPath.section == 0) && (indexPath.row == 5) )	{
		[cellButton setTitle:NSLocalizedString(@"Info_Stopwatch_Heading", @"") forState:UIControlStateNormal];
		[cellButton addTarget:self action:@selector(helpPage6) forControlEvents:UIControlEventTouchDown];
	}

	cellButton.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
	[myContent addSubview:cellButton];
	
	return cell;
}

-(void)helpPage1{	[self helpPage:1];	}
-(void)helpPage2{	[self helpPage:2];	}
-(void)helpPage3{	[self helpPage:3];	}
-(void)helpPage4{	[self helpPage:4];	}
-(void)helpPage5{	[self helpPage:5];	}
-(void)helpPage6{	[self helpPage:6];	}

-(void)helpPage:(int)newPage{
	[[self navigationController] pushViewController:help animated:YES];
	[help goToSpecificHelpPage:newPage];
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////


- (void)dealloc {
	[groupedTable release];
	[help release];
	[background release];
	[myContent release];
	[cellButton release];
	[cellLabel release];
	[tableCellBackgroundImage release];
	
    [super dealloc];
}


@end
