//
//  ScaleScore.m
//  WRUPlayer
//
//  Created by Fergal McDonnell on 22/04/2014.
//  Copyright 2014 Tailteann. All rights reserved.
//

#import "ScaleScore.h"
#import "Constants.h"
#import "DoctotHelper.h"
#import "IndividualScoreCell.h"


@implementation ScaleScore

@synthesize fetchedResultsController, managedObjectContext;
@synthesize headerView, score_view;

IndividualScore *individualScoreToDisplay;
IndividualScore *individualScoreSelected;
NSUserDefaults *prefs;
NSString *scaleId;
NSString *publicPrdeicate;
NSDateFormatter *scoreDateFormat;
BOOL dateSortAscending;
BOOL lastNameSortAscending;
BOOL scoreSortAscending;

BOOL dontEnterAgain;
UISlider *deleteSlider;
NSDate *scoreDate;

UIBarButtonItem *backButtonItem;
NSString * const NOTIF_DeleteScore = @"DeleteScore";
NSString * const NOTIF_DismissScoreView = @"DismissScoreView";

- (void)viewDidLoad {
    [super viewDidLoad];
	
	prefs = [NSUserDefaults standardUserDefaults];
	scaleId = [[NSString alloc] initWithFormat:@"%@", [prefs stringForKey:@"CurrentScale"]];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteCurrentScorePreventDoubleTouch) name:NOTIF_DeleteScore object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissSelectedIndividualScoreView) name:NOTIF_DismissScoreView object:nil];
	
	[headerView go];
	self.tableView.tableHeaderView = headerView;
	
	// Set Up the Top Left of the Nav Bar
	//backButtonItem = [[UIBarButtonItem alloc] initWithTitle:[scaleId uppercaseString] style:UIBarButtonItemStylePlain target:self action:@selector(dismissSavedScoreView)];
	//self.navigationItem.leftBarButtonItem = backButtonItem;
	//self.navigationItem.rightBarButtonItem = self.editButtonItem;
	self.navigationItem.title = NSLocalizedString(@"Save_ScoresTitle", @"");
	// Set Up the Top Left of the Nav Bar
    UIButton* leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 43, 49)];
	[leftButton addTarget:self action:@selector(dismissSavedScoreView) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setImage:[UIImage imageNamed:@"icon_back.png"] forState:UIControlStateNormal];
	UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
	individualScoreToDisplay = [[IndividualScore alloc] init];	// The current score for display in the table (used in a loop to populate table)
 	individualScoreSelected = [[IndividualScore alloc] init];	// The score selected by the user
	
	NSError *error = nil;
	if (![[self fetchedResultsController] performFetch:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
	
	// Refreshes the table initially
	[self sortTableBy:@"score" InDirection:scoreSortAscending];
}

- (IBAction)dismissSavedScoreView{
	[self.tableView setEditing:NO animated:YES]; // If editing is left ON, it can cause complications
	[DoctotHelper flipTransition:[[[self navigationController] view] superview] From:@"right"];
	[[self navigationController] popViewControllerAnimated:NO];
}

- (IBAction)dismissSelectedIndividualScoreView{
	[DoctotHelper slideInForView:self.view For:@"left"];
	[score_view removeFromSuperview];
	[[self tableView] reloadData];
}

#pragma mark -
#pragma mark Add a new object

- (IBAction)insertNewObject:(IndividualScore *)newScore {
	
	// Create a new instance of the entity managed by the fetched results controller.
	NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
	NSEntityDescription *entity = [[fetchedResultsController fetchRequest] entity];
	NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
	
	// Generates an ID for the new record
	NSString *new_id;
	int totalScalesRecorded = [prefs integerForKey:@"numberOfScalesRecorded"];
	totalScalesRecorded = totalScalesRecorded + 1;
	[prefs setInteger:totalScalesRecorded forKey:@"numberOfScalesRecorded"];
	new_id = [[NSString alloc] initWithFormat:@"%@%i", scaleId, totalScalesRecorded];
	
	// Configure the new managed object
	[newManagedObject setValue:scaleId forKey:@"scale"];
	[newManagedObject setValue:new_id forKey:@"id"];
	[newManagedObject setValue:[NSDate date] forKey:@"date"];
	[newManagedObject setValue:newScore.firstName forKey:@"firstName"];
	[newManagedObject setValue:newScore.lastName forKey:@"lastName"];
	[newManagedObject setValue:[NSNumber numberWithFloat:newScore.score] forKey:@"score"];
	//NSString *total_score = [[NSString alloc] initWithFormat:@"%f", newScore.score];
	[newManagedObject setValue:newScore.scoreAsString forKey:@"total"];
	[newManagedObject setValue:newScore.diagnosis forKey:@"diagnosis"];
	[newManagedObject setValue:newScore.diagnosisExtended forKey:@"diagnosisExtended"];
	[newManagedObject setValue:[[NSString alloc] initWithFormat:@"%i", newScore.diagnosisLevel] forKey:@"diagnosisLevel"];
	[newManagedObject setValue:newScore.diagnosisColour forKey:@"diagnosisColour"];
	
	[newManagedObject setValue:[[NSString alloc] initWithFormat:@"%.1f", newScore.q1] forKey:@"q1"];
	[newManagedObject setValue:[[NSString alloc] initWithFormat:@"%.1f", newScore.q2] forKey:@"q2"];
	[newManagedObject setValue:[[NSString alloc] initWithFormat:@"%.1f", newScore.q3] forKey:@"q3"];
	[newManagedObject setValue:[[NSString alloc] initWithFormat:@"%.1f", newScore.q4] forKey:@"q4"];
	[newManagedObject setValue:[[NSString alloc] initWithFormat:@"%.1f", newScore.q5] forKey:@"q5"];
	[newManagedObject setValue:[[NSString alloc] initWithFormat:@"%.1f", newScore.q6] forKey:@"q6"];
	[newManagedObject setValue:[[NSString alloc] initWithFormat:@"%.1f", newScore.q7] forKey:@"q7"];
	
	[newManagedObject setValue:newScore.q1Extended forKey:@"q1Extended"];
	[newManagedObject setValue:newScore.q2Extended forKey:@"q2Extended"];
	[newManagedObject setValue:newScore.q3Extended forKey:@"q3Extended"];
	[newManagedObject setValue:newScore.q4Extended forKey:@"q4Extended"];
	[newManagedObject setValue:newScore.q5Extended forKey:@"q5Extended"];
	[newManagedObject setValue:newScore.q6Extended forKey:@"q6Extended"];
	[newManagedObject setValue:newScore.q7Extended forKey:@"q7Extended"];
	
	// Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }
}

// DELETE: For Slider action
- (IBAction)deleteCurrentScore:(id)sender {
	
	deleteSlider = (UISlider *)sender;
	
	if(deleteSlider.value > resetSliderDistanceToExit) {
		[self deleteCurrentScorePreventDoubleTouch];
	}

}

// DELETE: For Nav Bar Button action
- (IBAction)deleteCurrentScorePreventDoubleTouch {	
	if( !dontEnterAgain ){
		dontEnterAgain = YES;
		[self deleteCurrentScoreQuery];
	}
}


- (IBAction)deleteCurrentScoreQuery {
		
		UIActionSheet *styleAlert =
		[[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Delete_ConfirmQuestion", @"")
									delegate:self cancelButtonTitle:NSLocalizedString(@"Button_Cancel", @"") destructiveButtonTitle:nil
						   otherButtonTitles:NSLocalizedString(@"Button_OK", @""), nil, nil, nil, nil];
		
		[styleAlert showInView:self.view];
		[styleAlert release];
	
}

- (void)executeCurrentScoreDeletion {
	
	publicPrdeicate = [[NSString alloc] initWithFormat:@"id == '%@'", individualScoreSelected.pk];
	[self deleteCommandWithPredicate:publicPrdeicate AndSortColumn:@"id" InSortOrder:YES];
	
	[self dismissSelectedIndividualScoreView];
	[[self tableView] reloadData];
	[self sortTableByDate];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"TotalScores" object:nil];
}

- (void)deleteFirstRecordFromTable:(NSString *)deletionScale {
	
	publicPrdeicate = [[NSString alloc] initWithFormat:@"scale == '%@'", deletionScale];
	[self deleteCommandWithPredicate:publicPrdeicate AndSortColumn:@"date" InSortOrder:YES];

}

- (void)deleteCommandWithPredicate:(NSString *)deletionPredicate AndSortColumn:(NSString *)deletionSort InSortOrder:(BOOL)deletionSortOrder {
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"ScaleScore" inManagedObjectContext:managedObjectContext];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:deletionPredicate];
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:deletionSort ascending:deletionSortOrder];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	
	[fetchRequest setEntity:entity];
	[fetchRequest setPredicate:predicate];
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	[fetchRequest setFetchBatchSize:20];
	
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
    aFetchedResultsController.delegate = self;
	self.fetchedResultsController = aFetchedResultsController;
	
	NSError *error = nil;
	if (![[self fetchedResultsController] performFetch:&error]) {
		abort();
	}
	
	NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
	NSManagedObject *objectToDelete = [self.fetchedResultsController.fetchedObjects objectAtIndex:0];
	[context deleteObject:objectToDelete];
	if (![context save:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
	
	[aFetchedResultsController release];
	[fetchRequest release];
	[sortDescriptor release];
	[sortDescriptors release];
}


#pragma mark Action Delegate Implementation

// change the navigation bar style, also make the status bar match with it
- (void)actionSheet:(UIActionSheet *)modalView clickedButtonAtIndex:(NSInteger)buttonIndex{
	
	dontEnterAgain = NO;
	[deleteSlider setValue:0.0];
	
	switch (buttonIndex)
	{
		case 0:{
			[self executeCurrentScoreDeletion];
			break;
		}
		case 1:{
			break;
		}
	}
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{}
- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{}
- (void)actionSheetCancel:(UIActionSheet *)actionSheet{}
- (void)didPresentActionSheet:(UIActionSheet *)actionSheet{}
- (void)willPresentActionSheet:(UIActionSheet *)actionSheet{}

//////// Returns Number of Records for Scale ///////////

- (NSInteger)returnNumberOfScoresForScale {
	[self.tableView reloadData];
	return (NSInteger)[self.tableView numberOfRowsInSection:0];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Sorting
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (IBAction)sortTableByDate{
	
	dateSortAscending = !dateSortAscending;
	[self sortTableBy:@"date" InDirection:dateSortAscending];
	
	if(dateSortAscending == YES){
		[headerView.dateSortArrow setImage:[UIImage imageNamed:savedScoresUp]];
	}else{
		[headerView.dateSortArrow setImage:[UIImage imageNamed:savedScoresDown]];
	}
	
}

- (IBAction)sortTableByLastname{
	
	lastNameSortAscending = !lastNameSortAscending;
	[self sortTableBy:@"lastName" InDirection:lastNameSortAscending];
	
	if(lastNameSortAscending == YES){
		[headerView.nameSortArrow setImage:[UIImage imageNamed:savedScoresUp]];
	}else{
		[headerView.nameSortArrow setImage:[UIImage imageNamed:savedScoresDown]];
	}
	
}

- (IBAction)sortTableByScore{
	
	scoreSortAscending = !scoreSortAscending;
	[self sortTableBy:@"score" InDirection:scoreSortAscending];
	
	if(scoreSortAscending == YES){
		[headerView.scoreSortArrow setImage:[UIImage imageNamed:savedScoresUp]];
	}else{
		[headerView.scoreSortArrow setImage:[UIImage imageNamed:savedScoresDown]];
	}
	
}

- (void)sortTableBy:(NSString *)criteria InDirection:(BOOL)direction {
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"ScaleScore" inManagedObjectContext:managedObjectContext];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"scale == %@", scaleId];
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:criteria ascending:direction];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	
	[fetchRequest setEntity:entity];
	[fetchRequest setPredicate:predicate];
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	[fetchRequest setFetchBatchSize:20];
	
	// Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
    aFetchedResultsController.delegate = self;
	self.fetchedResultsController = aFetchedResultsController;
	
	NSError *error = nil;
	if (![[self fetchedResultsController] performFetch:&error]) {
		abort();
	}
	
	[self clearAllSortArrows];
	[[self tableView] reloadData];
	
	[aFetchedResultsController release];
	[fetchRequest release];
	[sortDescriptor release];
	[sortDescriptors release];
	
}

- (void)clearAllSortArrows{
	[headerView.dateSortArrow setImage:[UIImage imageNamed:@""]];	
	[headerView.nameSortArrow setImage:[UIImage imageNamed:@""]];	
	[headerView.scoreSortArrow setImage:[UIImage imageNamed:@""]];	
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Table view methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[fetchedResultsController sections] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"IndividualScoreCell";
	
	IndividualScoreCell *cell = (IndividualScoreCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //cell = [[[IndividualScoreCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
        cell = [[IndividualScoreCell alloc] initWithFrame:CGRectZero];
	}
	
	NSManagedObject *managedObject = [fetchedResultsController objectAtIndexPath:indexPath];
	individualScoreToDisplay.scale = scaleId;
	individualScoreToDisplay.date = [[managedObject valueForKey:@"date"] description];
	individualScoreToDisplay.dateForDisplay = [managedObject valueForKey:@"date"];
	individualScoreToDisplay.firstName = [[managedObject valueForKey:@"firstName"] description];
	individualScoreToDisplay.lastName = [[managedObject valueForKey:@"lastName"] description];
	individualScoreToDisplay.score = [[[managedObject valueForKey:@"score"] description] floatValue];
	individualScoreToDisplay.diagnosisColour = [[managedObject valueForKey:@"diagnosisColour"] description];
	
	// For CHADS2
	individualScoreToDisplay.q5 = (NSInteger)[[managedObject valueForKey:@"q5"] description];
	
	[cell setIndividualScore:individualScoreToDisplay];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSManagedObject *selectedObject = [[self fetchedResultsController] objectAtIndexPath:indexPath];
	individualScoreSelected.pk = [[selectedObject valueForKey:@"id"] description];
	
	if(self.score_view == nil){
		[score_view initWithFrame:CGRectZero];
	}
	
	scoreDateFormat = [[[NSDateFormatter alloc] init] autorelease];
	scoreDate = [selectedObject valueForKey:@"date"]; 
	[scoreDateFormat setDateStyle:NSDateFormatterMediumStyle];
	
	score_view.date.text = [[NSString alloc] initWithFormat:@"%@", [scoreDateFormat stringFromDate:scoreDate] ];
	score_view.fullName.text = [[NSString alloc] initWithFormat:@"%@ %@", [[selectedObject valueForKey:@"firstName"] description], [[selectedObject valueForKey:@"lastName"] description]];
	score_view.score.text = [[NSString alloc] initWithFormat:@"%.1f", [[[selectedObject valueForKey:@"score"] description] floatValue] ];
	score_view.diagnosisString = [[NSString alloc] initWithFormat:@"%@", [[selectedObject valueForKey:@"diagnosis"] description]];
	score_view.diagnosisLevel = [[NSString alloc] initWithFormat:@"%@", [[selectedObject valueForKey:@"diagnosisLevel"] description]];
	score_view.diagnosisColour = [[NSString alloc] initWithFormat:@"%@", [[selectedObject valueForKey:@"diagnosisColour"] description]];
	score_view.diagnosisExtended = [[NSString alloc] initWithFormat:@"%@", [[selectedObject valueForKey:@"diagnosisExtended"] description]];
	score_view.q1.text = [[NSString alloc] initWithFormat:@"%@", [[selectedObject valueForKey:@"q1"] description]];
	score_view.q2.text = [[NSString alloc] initWithFormat:@"%@", [[selectedObject valueForKey:@"q2"] description]];
	score_view.q3.text = [[NSString alloc] initWithFormat:@"%@", [[selectedObject valueForKey:@"q3"] description]];
	score_view.q4.text = [[NSString alloc] initWithFormat:@"%@", [[selectedObject valueForKey:@"q4"] description]];
	score_view.q5.text = [[NSString alloc] initWithFormat:@"%@", [[selectedObject valueForKey:@"q5"] description]];
	score_view.q6.text = [[NSString alloc] initWithFormat:@"%@", [[selectedObject valueForKey:@"q6"] description]];
	score_view.q7.text = [[NSString alloc] initWithFormat:@"%@", [[selectedObject valueForKey:@"q7"] description]];
	score_view.q1Extended = [[NSString alloc] initWithFormat:@"%@", [[selectedObject valueForKey:@"q1Extended"] description]];
	score_view.q2Extended = [[NSString alloc] initWithFormat:@"%@", [[selectedObject valueForKey:@"q2Extended"] description]];
	score_view.q3Extended = [[NSString alloc] initWithFormat:@"%@", [[selectedObject valueForKey:@"q3Extended"] description]];
	score_view.q4Extended = [[NSString alloc] initWithFormat:@"%@", [[selectedObject valueForKey:@"q4Extended"] description]];
	score_view.q5Extended = [[NSString alloc] initWithFormat:@"%@", [[selectedObject valueForKey:@"q5Extended"] description]];
    score_view.q6Extended = [[NSString alloc] initWithFormat:@"%@", [[selectedObject valueForKey:@"q6Extended"] description]];
    score_view.q7Extended = [[NSString alloc] initWithFormat:@"%@", [[selectedObject valueForKey:@"q7Extended"] description]];
    
	[self correctForNulls];
	[self correctForUntestables];
	[self cleanUpIntegers];
	
	[score_view go:scaleId];
	[self readjustDisplayForAwkwardScalesWithTotal:(NSString *)[[selectedObject valueForKey:@"total"] description]];	
	[score_view setDiagnosisForScale];

	[DoctotHelper slideInForView:score_view For:@"right"];
	[self.view.window addSubview:score_view];
	
}

- (void)correctForNulls{
	if([score_view.q1.text hasPrefix:@"-1"]) score_view.q1.text = @"-";
	if([score_view.q2.text hasPrefix:@"-1"]) score_view.q2.text = @"-";
	if([score_view.q3.text hasPrefix:@"-1"]) score_view.q3.text = @"-";
	if([score_view.q4.text hasPrefix:@"-1"]) score_view.q4.text = @"-";
	if([score_view.q5.text hasPrefix:@"-1"]) score_view.q5.text = @"-";
    if([score_view.q6.text hasPrefix:@"-1"]) score_view.q6.text = @"-";
    if([score_view.q7.text hasPrefix:@"-1"]) score_view.q7.text = @"-";
}

- (void)correctForUntestables{
	if([score_view.q1.text hasPrefix:@"-2"]) score_view.q1.text = NSLocalizedString(@"NIHSS_UntestableShortened", @"");
	if([score_view.q2.text hasPrefix:@"-2"]) score_view.q2.text = NSLocalizedString(@"NIHSS_UntestableShortened", @"");
	if([score_view.q3.text hasPrefix:@"-2"]) score_view.q3.text = NSLocalizedString(@"NIHSS_UntestableShortened", @"");
	if([score_view.q4.text hasPrefix:@"-2"]) score_view.q4.text = NSLocalizedString(@"NIHSS_UntestableShortened", @"");
	if([score_view.q5.text hasPrefix:@"-2"]) score_view.q5.text = NSLocalizedString(@"NIHSS_UntestableShortened", @"");
    if([score_view.q6.text hasPrefix:@"-2"]) score_view.q6.text = NSLocalizedString(@"NIHSS_UntestableShortened", @"");
    if([score_view.q7.text hasPrefix:@"-2"]) score_view.q7.text = NSLocalizedString(@"NIHSS_UntestableShortened", @"");
}

- (void)cleanUpIntegers{
	if([score_view.score.text hasSuffix:@".0"]){	score_view.score.text = [[NSString alloc] initWithFormat:@"%i", [score_view.score.text intValue]];	}
	
	if([score_view.q1.text hasSuffix:@".0"]){	score_view.q1.text = [[NSString alloc] initWithFormat:@"%i", [score_view.q1.text intValue]];	}
	if([score_view.q2.text hasSuffix:@".0"]){	score_view.q2.text = [[NSString alloc] initWithFormat:@"%i", [score_view.q2.text intValue]];	}
	if([score_view.q3.text hasSuffix:@".0"]){	score_view.q3.text = [[NSString alloc] initWithFormat:@"%i", [score_view.q3.text intValue]];	}
	if([score_view.q4.text hasSuffix:@".0"]){	score_view.q4.text = [[NSString alloc] initWithFormat:@"%i", [score_view.q4.text intValue]];	}
	if([score_view.q5.text hasSuffix:@".0"]){	score_view.q5.text = [[NSString alloc] initWithFormat:@"%i", [score_view.q5.text intValue]];	}
    if([score_view.q6.text hasSuffix:@".0"]){	score_view.q6.text = [[NSString alloc] initWithFormat:@"%i", [score_view.q6.text intValue]];	}
    if([score_view.q7.text hasSuffix:@".0"]){	score_view.q7.text = [[NSString alloc] initWithFormat:@"%i", [score_view.q7.text intValue]];	}
}

- (void)readjustDisplayForAwkwardScalesWithTotal:(NSString *)newTotal{}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the managed object for the given index path
		NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
		[context deleteObject:[fetchedResultsController objectAtIndexPath:indexPath]];
		
		// Save the context.
		NSError *error = nil;
		if (![context save:&error]) {
			/*
			 Replace this implementation with code to handle the error appropriately.
			 
			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
			 */
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}
		
		// Refreshes the "Total Number of Scores saved for this Scale" label
		[[NSNotificationCenter defaultCenter] postNotificationName:@"TotalScores" object:nil];
	}   
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // The table view should not be re-orderable.
    return NO;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Fetched results controller
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (fetchedResultsController != nil) {
        return fetchedResultsController;
    }
    
    /*
	 Set up the fetched results controller.
	 */
	// Create the fetch request for the entity.
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	// Edit the entity name as appropriate.
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"ScaleScore" inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
	
	//NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(lastName like[cd] %@) AND (birthday > %@)", lastNameSearchString, birthdaySearchDate];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"scale == %@", scaleId];
	[fetchRequest setPredicate:predicate];
		
	// Set the batch size to a suitable number.
	[fetchRequest setFetchBatchSize:20];
	
	// Edit the sort key as appropriate.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	// Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
    aFetchedResultsController.delegate = self;
	self.fetchedResultsController = aFetchedResultsController;
	
	[aFetchedResultsController release];
	[fetchRequest release];
	[sortDescriptor release];
	[sortDescriptors release];
	
	return fetchedResultsController;
}    


// NSFetchedResultsControllerDelegate method to notify the delegate that all section and object changes have been processed. 
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	// In the simplest, most efficient, case, reload the table view.
	[self.tableView reloadData];
}

/*
 Instead of using controllerDidChangeContent: to respond to all changes, you can implement all the delegate methods to update the table view in response to individual changes.  This may have performance implications if a large number of changes are made simultaneously.
 
 // Notifies the delegate that section and object changes are about to be processed and notifications will be sent. 
 - (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
 [self.tableView beginUpdates];
 }
 
 - (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
 // Update the table view appropriately.
 }
 
 - (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
 // Update the table view appropriately.
 }
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
 [self.tableView endUpdates];
 } 
 */



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Memory management
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


/*
 - (id)initWithStyle:(UITableViewStyle)style {
 // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 if (self = [super initWithStyle:style]) {
 }
 return self;
 }
 */


/*
 - (void)viewWillAppear:(BOOL)animated {
 [super viewWillAppear:animated];
 }
 */
/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }
 */
/*
 - (void)viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:animated];
 }
 */
/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	// Relinquish ownership of any cached data, images, etc that aren't in use.
}


- (void)dealloc {
	[fetchedResultsController release];
	[managedObjectContext release];
	
	[headerView release];
	[score_view release];
	[individualScoreSelected release];
	[individualScoreToDisplay release];
	[backButtonItem release];
	[prefs release];
	[scaleId release];
	[scoreDateFormat release];
	[scoreDate release];
	
	[publicPrdeicate release];
	
    [super dealloc];
}


@end

