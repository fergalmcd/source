//
//  WRUPlayerAppDelegate.h
//  WRUPlayer
//
//  Created by Fergal McDonnell on 22/04/2014.
//  Copyright Tailteann 2014. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "StartView.h"
#import "SignUp.h"
#import "Password.h"
#import "DoctotHelper.h"

@class MainViewController;

@interface WRUPlayerAppDelegate : NSObject <UIApplicationDelegate> {
    
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
	
    MainViewController *mainViewController;
    StartView				*startView;
    SignUp					*signUp;
    Password				*password;
	
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, retain) IBOutlet MainViewController *mainViewController;
@property (nonatomic, retain) IBOutlet StartView *startView;
@property (nonatomic, retain) IBOutlet SignUp *signUp;
@property (nonatomic, retain) IBOutlet Password *password;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

- (NSString *)applicationDocumentsDirectory;

- (void)goToStartScreen;
- (void)uploadUserWithEmail:(NSString *)e_mail AndPassword:(NSString *)thePassword;
- (IBAction)goToHomeScreen;
- (void)initialiseUserPreferences;
- (IBAction)registerApp;
- (void)constructUpcomingNotifications;
- (NSDate *)returnModifiedDate:(NSDate *)theDate withHours:(int)theHours andMinutes:(int)theMinutes;
- (void)getPlayerJSONData:(int)player_id;

 
@end

