//
//  WRUPlayerAppDelegate.m
//  WRUPlayer
//
//  Created by Fergal McDonnell on 22/04/2014.
//  Copyright Tailteann 2014. All rights reserved.
//

#import "WRUPlayerAppDelegate.h"
#import "Constants.h"
#import "MainViewController.h"


@implementation WRUPlayerAppDelegate

@synthesize startView, signUp, password;
@synthesize window, navigationController;
@synthesize mainViewController;

NSString *user_name;
NSString *user_firstName;
NSString *user_password;
NSUserDefaults *prefs;
NSTimer *startPause;
int playerID;
NSString * const NOTIF_AccessPause = @"AccessPause";

#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {    

	[startView go];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToStartScreen) name:NOTIF_AccessPause object:nil];
    
	prefs = [NSUserDefaults standardUserDefaults];
	user_name = [[NSString alloc] initWithFormat:@"%@", [prefs stringForKey:@"RegistrationID"] ];
	user_firstName = [prefs stringForKey:@"FirstName"];
	user_password = [[NSString alloc] initWithFormat:@"%@", [prefs stringForKey:@"Password"] ];
    
    // Comment out these 2 lines for full version //////
    [prefs setObject:@"ppp" forKey:@"LastSurveyDate"];
    playerID = 180;
    ////////////////////////////////////////////////////
    
	if([user_name isEqualToString:@"(null)"] == YES){
		[signUp go];
		[window addSubview:signUp];
		[self initialiseUserPreferences];
	} 
	else{
		if( [[prefs stringForKey:@"RegisterCompletionStatus"] isEqualToString:@"ERROR"] ){
			[self uploadUserWithEmail:[prefs stringForKey:@"Email"] AndPassword:user_password ];
		}
		if( ([user_password isEqualToString:@"(null)"] == NO) && (user_password.length > 0) ){
            [password go];
			[window addSubview:startView];
			[window addSubview:password];
		}
		else{
			[self goToStartScreen];
		}
	}
	
	// Sets the maximum number of saved records allowed per rating scale
	if ( [prefs integerForKey:@"maxSavesAllowed"] > 0 ){
	}else{
		[prefs setInteger:maxSavesAllowed forKey:@"maxSavesAllowed"];
		//[prefs setInteger:0 forKey:@"totalScoresRecorded"];
	}
    
    [self constructUpcomingNotifications];

	[window makeKeyAndVisible];
    
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"] message:notification.alertBody delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// App-level Navigation
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (IBAction)registerApp{
	
	signUp.warning_label.text = @"";
    
    /*
    NSString* usernamepwd =[NSString stringWithFormat:@"%@:%@",signUp.email.text,signUp.password.text];
    NSData* base64=[usernamepwd dataUsingEncoding:NSASCIIStringEncoding];
    
    NSString* authHeader=[NSString stringWithFormat:@"Basic %@", [base64 base64Encoding]];
    [request addValue:authHeader forHTTPHeaderField:@"Authorization"];
	*/
    
	if( ([signUp.email.text length] == 0) || ([signUp.password.text length] == 0) ){
		signUp.warning_label.text = NSLocalizedString(@"Welcome_Error", @"");
		[signUp.warning_image setImage:[UIImage imageNamed:alertImage]];
	}
	else{
		[prefs setObject:signUp.email.text forKey:@"Email"];
		
		NSString *today = [DoctotHelper returnTodaysDateAsString];
		[prefs setObject:today forKey:@"RegistrationDate"];
		
		NSString *registration_id = [[NSString alloc] initWithFormat:@"%@%@%@", registrationApp, signUp.email.text, today];
		[prefs setObject:registration_id forKey:@"RegistrationID"];
		
		[self uploadUserWithEmail:[prefs stringForKey:@"Email"] AndPassword:user_password];
		
		[signUp removeFromSuperview];
		[self goToStartScreen];
	}
}


- (void)goToStartScreen{
	[window addSubview:startView];
	startPause = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(goToHomeScreen) userInfo:nil repeats:NO];
}


- (void)uploadUserWithEmail:(NSString *)e_mail AndPassword:(NSString *)thePassword {
	
	NSString *url_string = [[NSString alloc] initWithFormat:@"%@?app=%@&username=%@&password=%@", registrationLocation, registrationApp, e_mail, thePassword];
	NSURL *urlToSend = [[NSURL alloc] initWithString:url_string];
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:urlToSend cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
	
	NSData *urlData;
	NSURLResponse *response;
	NSError *error = [[NSError alloc] init];
	// Tempoarily turned off until coordination with Karol
    //urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
	
	int error_code = [error code];
	
	if(error_code == 0){
		[prefs setObject:@"OK" forKey:@"RegisterCompletionStatus"];
		NSLog(@"Registration Complete!");
	}else{
		[prefs setObject:@"ERROR" forKey:@"RegisterCompletionStatus"];
		NSLog(@"Error!");
	}
	
	[error release];
	[url_string release];
	[urlToSend release];
}


- (IBAction)goToHomeScreen{
    [self getPlayerJSONData:playerID];
	[startPause invalidate];
	[startView removeFromSuperview];
	// add the navigation controller's view to the window
	[window addSubview:[navigationController view]];
	[window makeKeyAndVisible];
}


- (void)initialiseUserPreferences{
	[prefs setObject:Settings_WeightKgsUnits forKey:@"WeightUnits"];
	[prefs setObject:Settings_Weight forKey:@"Weight"];
	[prefs setObject:Settings_SleepTime forKey:@"SleepTime"];
    [prefs setObject:Settings_WakeupTime forKey:@"WakeupTime"];
    [prefs setObject:Settings_DailyNotification forKey:@"DailyNotification"];
    [prefs setObject:@"blank" forKey:@"LastSurveyDate"];
	[prefs setBool:YES forKey:@"ShakeReset"];
    
    [self getPlayerJSONData:playerID];
    
}

- (void)constructUpcomingNotifications
{
    // Clear All Notifications
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    // Create Dates for Notification
    NSDate *currentDate = [NSDate date];
    NSMutableArray *notificationDates = [[NSMutableArray alloc] init];
    
    int dayOfWeek = (int)[[[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:currentDate] weekday];
    int daysToSunday, daysToWednesday, daysToFriday;
    if( dayOfWeek >= 1 ){
        daysToSunday = 7 - (dayOfWeek - 1);
    }else{
        daysToSunday = 1 - dayOfWeek;
    }
    if( dayOfWeek >= 4 ){
        daysToWednesday = 7 - (dayOfWeek - 4);
    }else{
        daysToWednesday = 4 - dayOfWeek;
    }
    if( dayOfWeek >= 6 ){
        daysToFriday = 7 - (dayOfWeek - 6);
    }else{
        daysToFriday = 6 - dayOfWeek;
    }
    
    NSDate *nextSundayDay = [currentDate dateByAddingTimeInterval:(60*60*24*daysToSunday)];
    NSDate *nextWednesdayDay = [currentDate dateByAddingTimeInterval:(60*60*24*daysToWednesday)];
    NSDate *nextFridayDay = [currentDate dateByAddingTimeInterval:(60*60*24*daysToFriday)];
    
    NSString *preferredTime = (NSString *)[prefs objectForKey:@"DailyNotification"];
    int preferredTimeHours = [[preferredTime substringToIndex:2] intValue];
    int preferredTimeMinutes = [[preferredTime substringFromIndex:3] intValue];
    
    // Compensates for one hour lag
    NSDate *nextSunday = [self returnModifiedDate:nextSundayDay withHours:(preferredTimeHours - 1) andMinutes:preferredTimeMinutes];
    NSDate *nextWednesday = [self returnModifiedDate:nextWednesdayDay withHours:(preferredTimeHours - 1) andMinutes:preferredTimeMinutes];
    NSDate *nextFriday = [self returnModifiedDate:nextFridayDay withHours:(preferredTimeHours - 1) andMinutes:preferredTimeMinutes];
    
    // 11:45 with one hour lag
    NSDate *nextSundayLastChance = [self returnModifiedDate:nextSundayDay withHours:10 andMinutes:45];
    NSDate *nextWednesdayLastChance = [self returnModifiedDate:nextWednesdayDay withHours:10 andMinutes:45];
    NSDate *nextFridayLastChance = [self returnModifiedDate:nextFridayDay withHours:10 andMinutes:45];
    
    [notificationDates addObject:nextSunday];
    [notificationDates addObject:nextWednesday];
    [notificationDates addObject:nextFriday];
    [notificationDates addObject:nextSundayLastChance];
    [notificationDates addObject:nextWednesdayLastChance];
    [notificationDates addObject:nextFridayLastChance];
    
    NSDate *targetDate;
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
    //NSLog(@"notificationDates = %@", notificationDates);
    
    for( int i = 0; i < [notificationDates count] ; i++ ){
        
        currentDate = [NSDate date];
        targetDate = (NSDate *)[notificationDates objectAtIndex:i];
        localNotification = [[UILocalNotification alloc] init];
        
        localNotification.fireDate = targetDate;
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.repeatInterval = NSWeekCalendarUnit;
        localNotification.alertBody = [NSString stringWithFormat:@"%@", NSLocalizedString(@"Notification_Message", @"")];
        localNotification.alertAction = NSLocalizedString(@"Button_Perform", @"");
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.applicationIconBadgeNumber += 1;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        
    }
    
    [[UIApplication sharedApplication]registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
    
}

- (NSDate *)returnModifiedDate:(NSDate *)theDate withHours:(int)theHours andMinutes:(int)theMinutes {

    NSDate *modifiedDate;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *modifiedDateString = [dateFormat stringFromDate:theDate];
    modifiedDateString = [[modifiedDateString substringToIndex:10] stringByAppendingFormat:@" %i:%i", (theHours + 1), theMinutes];
    modifiedDate = [dateFormat dateFromString:modifiedDateString];
    
    return modifiedDate;
    
}

- (void)getPlayerJSONData:(int)player_id {
    
    NSString *playerURLString = [NSString stringWithFormat:@"http://wru-dev.cloudapp.net:8080/players/%i", player_id];
    NSURL *thePlayerURL = [[NSURL alloc] initWithString:playerURLString];
    NSData *playerData = [NSData dataWithContentsOfURL:thePlayerURL];
    
    if(playerData == NULL){
        
        UIAlertView *noWifi = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Notification_NoWifiHeading", @"") message:NSLocalizedString(@"Notification_NoWifiMessage", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Button_OK", @"") otherButtonTitles: nil];
        [noWifi show];
        
    }else{
        
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:playerData options:kNilOptions error:&error];
        
        NSString *idString = (NSString *)[json objectForKey:@"id"];
        [prefs setObject:idString forKey:@"PlayerWRUID"];
        
        //NSArray *fullNameArray = [json objectForKey:@"name"];
        //NSString *fullName = (NSString *)[fullNameArray objectAtIndex:0];
        NSString *fullName = (NSString *)[json objectForKey:@"name"];
        NSArray *splitName = [fullName componentsSeparatedByString:@" "];
        NSString *delimitedFirstName = (NSString *)[splitName objectAtIndex:0];
        NSString *delimitedLastName = (NSString *)[splitName objectAtIndex:1];
        [prefs setObject:delimitedFirstName forKey:@"FirstName"];
        [prefs setObject:delimitedLastName forKey:@"LastName"];
        
        NSString *position = (NSString *)[json objectForKey:@"position"];
        [prefs setObject:position forKey:@"PlayerPosition"];
        
        NSString *imageURL = [NSString stringWithFormat:@"http://wru-dev.cloudapp.net/flex/%@", [json objectForKey:@"fullImagePath"]];
        [prefs setObject:imageURL forKey:@"PlayerImageURL"];
        
    }
    
}


/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */

- (void)applicationWillTerminate:(UIApplication *)application {
	
    NSError *error = nil;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
        } 
    }
}

#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */

- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}



/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */

- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"DoctotStroke.sqlite"]];
	
	NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }    
	
    return persistentStoreCoordinator;
}

#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */

- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	
    [managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
	
	[startView release];
	[signUp release];
	[password release];
	
	[user_name release];
	[user_firstName release];
	[user_password release];
	[prefs release];
	[startPause release];
    
	[navigationController release];
	[window release];
	[super dealloc];
	
}


@end