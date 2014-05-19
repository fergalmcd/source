//
//  ScaleScore.h
//  WRUPlayer
//
//  Created by Fergal McDonnell on 22/04/2014.
//  Copyright 2014 Tailteann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ScaleScoreHeader.h"
#import "IndividualScore.h"
#import "IndividualScoreView.h"


@interface ScaleScore : UITableViewController <NSFetchedResultsControllerDelegate, UIActionSheetDelegate> {
	NSFetchedResultsController *fetchedResultsController;
	NSManagedObjectContext *managedObjectContext;
	
	ScaleScoreHeader *headerView;
	IndividualScoreView *score_view;
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) IBOutlet ScaleScoreHeader *headerView;
@property (nonatomic, retain) IBOutlet IndividualScoreView *score_view;

- (IBAction)dismissSelectedIndividualScoreView;
- (IBAction)dismissSavedScoreView;
- (IBAction)insertNewObject:(IndividualScore *)newScore;
- (void)correctForNulls;
- (void)correctForUntestables;
- (void)cleanUpIntegers;
- (void)readjustDisplayForAwkwardScalesWithTotal:(NSString *)newTotal;
- (IBAction)deleteCurrentScore:(id)sender;
- (IBAction)deleteCurrentScorePreventDoubleTouch;
- (IBAction)deleteCurrentScoreQuery;
- (void)deleteFirstRecordFromTable:(NSString *)deletionScale;
- (void)deleteCommandWithPredicate:(NSString *)deletionPredicate AndSortColumn:(NSString *)deletionSort InSortOrder:(BOOL)deletionSortOrder;
- (NSInteger)returnNumberOfScoresForScale;
- (IBAction)sortTableByDate;
- (IBAction)sortTableByLastname;
- (IBAction)sortTableByScore;
- (void)sortTableBy:(NSString *)criteria InDirection:(BOOL)direction;
- (void)clearAllSortArrows;

@end
