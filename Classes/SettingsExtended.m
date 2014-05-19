//
//  SettingsExtended.m
//  WRUPlayer
//
//  Created by Fergal McDonnell on 22/04/2014.
//  Copyright Tailteann 2014. All rights reserved.
//

#import "SettingsExtended.h"
#import "Constants.h"
#import "DoctotHelper.h"
#import "WRUPlayerAppDelegate.h"


@implementation SettingsExtended


@synthesize navigation_bar, navigation_item, scrollView;
@synthesize first_name_label, last_name_label, email_label;
@synthesize first_name, last_name, email, owner_details;
@synthesize max_save_instruction, max_save_slider, max_save_track, max_save, max_save_for_display;
@synthesize dailyNotificationTimer, sleepTimer, wakeUpTimer, outputTime, outputTimeConfirm;

NSUserDefaults *prefs;
NSInteger currentSavesAllowed;
NSString *tempStr;

UIBarButtonItem *dismissScoreButton;

NSDate *dateFromString;
WRUPlayerAppDelegate *updateNotifications;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
    [super dealloc];
	
	[navigation_bar release];
	[navigation_item release];
	[scrollView release];
	[dismissScoreButton release];
	
	[first_name_label release];
	[last_name_label release];
	[email_label release];
	[first_name release];
	[last_name release]; 
	[email release];
	[max_save_instruction release];
	[max_save_slider release];
	[max_save_track release];
	[max_save release];
	
	[owner_details release];
	[max_save_for_display release];
	
	[tempStr release];
}

- (void)go:(NSString *)context {
	
    prefs = [NSUserDefaults standardUserDefaults];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowSettings:) name:UIKeyboardWillShowNotification object:nil];
	updateNotifications = (WRUPlayerAppDelegate *)[[UIApplication sharedApplication] delegate];
    
	//dismissScoreButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissView)];
	self.navigation_bar.tintColor = [[UIColor alloc] initWithRed:headerColour_Red green:headerColour_Green blue:headerColour_Blue alpha:headerColour_Alpha];
	self.navigation_item.title = [[NSString alloc] initWithString:context];
    UIButton *dismissScoreButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 43, 49)];
	[dismissScoreButton addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
    [dismissScoreButton setImage:[UIImage imageNamed:@"icon_back.png"] forState:UIControlStateNormal];
    UIBarButtonItem *dismissScoreButtonItem = [[UIBarButtonItem alloc] initWithCustomView:dismissScoreButton];
    self.navigation_item.leftBarButtonItem = dismissScoreButtonItem;
    
	scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, scrollView.frame.size.height + 100);
	
	first_name_label.text = NSLocalizedString(@"Final_Insert_First_Name", @"");
	last_name_label.text = NSLocalizedString(@"Final_Insert_Last_Name", @"");
	email_label.text = NSLocalizedString(@"Save_Email", @"");
	
	first_name.text = [[NSString alloc] initWithFormat:@"%@", [prefs stringForKey:@"FirstName"]];
	last_name.text = [[NSString alloc] initWithFormat:@"%@", [prefs stringForKey:@"LastName"]];
	email.text = [[NSString alloc] initWithFormat:@"%@", [prefs stringForKey:@"Email"]];
	
	owner_details.text = [[NSString alloc] initWithFormat:@"%@ %@ %@", first_name.text, last_name.text, email.text];
	
    NSString *dailyNotificationString = [prefs objectForKey:@"DailyNotification"];
    NSString *sleepTimeString = [prefs objectForKey:@"SleepTime"];
    NSString *wakeUpTimeString = [prefs objectForKey:@"WakeupTime"];
    
    if( [context isEqualToString:NSLocalizedString(@"Settings_Heading5", @"")] ){   outputTime.text = dailyNotificationString;    }
    if( [context isEqualToString:NSLocalizedString(@"Settings_Heading6", @"")] ){   outputTime.text = sleepTimeString;    }
    if( [context isEqualToString:NSLocalizedString(@"Settings_Heading7", @"")] ){   outputTime.text = wakeUpTimeString;    }
    [outputTimeConfirm setTitle:NSLocalizedString(@"Button_Done", @"") forState:UIControlStateNormal];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss +1000"];
    
    NSString *dailyNotificationFormat = [NSString stringWithFormat:@"1970-01-01 %@:00 +1000", dailyNotificationString];
    dateFromString = (NSDate *)[dateFormatter dateFromString:dailyNotificationFormat];
    [dailyNotificationTimer setDate:dateFromString];

    NSString *sleepFormat = [NSString stringWithFormat:@"1970-01-01 %@:00 +1000", sleepTimeString];
    dateFromString = (NSDate *)[dateFormatter dateFromString:sleepFormat];
    [sleepTimer setDate:dateFromString];
    
    NSString *wakeUpFormat = [NSString stringWithFormat:@"1970-01-01 %@:00 +1000", wakeUpTimeString];
    dateFromString = (NSDate *)[dateFormatter dateFromString:wakeUpFormat];
    [wakeUpTimer setDate:dateFromString];
	
}


- (IBAction)updateFirstName{
	[prefs setObject:first_name.text forKey:@"FirstName"];
	owner_details.text = [[NSString alloc] initWithFormat:@"%@ %@ %@", first_name.text, last_name.text, email.text];
}
- (IBAction)updateLastName{
	[prefs setObject:last_name.text forKey:@"LastName"];
	owner_details.text = [[NSString alloc] initWithFormat:@"%@ %@ %@", first_name.text, last_name.text, email.text];
}
- (IBAction)updateEmail{
	[prefs setObject:email.text forKey:@"Email"];
	owner_details.text = [[NSString alloc] initWithFormat:@"%@ %@ %@", first_name.text, last_name.text, email.text];
}

- (IBAction)updateMaxSavesAllowed{
	currentSavesAllowed = (NSInteger)(max_save_slider.value + 0.5);
	max_save_slider.value = currentSavesAllowed;
	[prefs setInteger:currentSavesAllowed forKey:@"maxSavesAllowed"];
	max_save.text = [[NSString alloc] initWithFormat:@"%i", currentSavesAllowed];
	max_save_for_display.text = [[NSString alloc] initWithFormat:@"%i", currentSavesAllowed];
}

- (IBAction)updateDefaultTimer:(id)sender {
    
    NSString *keyToUpdate;
    NSString *timeAsString;
    NSString *hoursAsString;
    NSString *minutesAsString;
    unsigned int compFlags = NSHourCalendarUnit | NSMinuteCalendarUnit;
    NSDateComponents *updateComponents;
    
    if( sender == dailyNotificationTimer ){
        updateComponents = [[NSCalendar currentCalendar] components:compFlags fromDate:dailyNotificationTimer.date];
        keyToUpdate = @"DailyNotification";
    }
    
    if( sender == sleepTimer ){
        updateComponents = [[NSCalendar currentCalendar] components:compFlags fromDate:sleepTimer.date];
        keyToUpdate = @"SleepTime";
    }
    
    if( sender == wakeUpTimer ){
        updateComponents = [[NSCalendar currentCalendar] components:compFlags fromDate:wakeUpTimer.date];
        keyToUpdate = @"WakeupTime";
    }
    
    hoursAsString = [NSString stringWithFormat:@"%i", (int)[updateComponents hour]];
    if( [hoursAsString length] == 1 ){
        hoursAsString = [@"0" stringByAppendingFormat:@"%@", hoursAsString];
    }
    minutesAsString = [NSString stringWithFormat:@"%i", (int)[updateComponents minute]];
    if( [minutesAsString length] == 1 ){
        minutesAsString = [@"0" stringByAppendingFormat:@"%@", minutesAsString];
    }
    timeAsString = [NSString stringWithFormat:@"%@:%@", hoursAsString, minutesAsString];
    outputTime.text = timeAsString;
    
    [prefs setObject:timeAsString forKey:keyToUpdate];
    
    if( sender == dailyNotificationTimer ){
        [updateNotifications constructUpcomingNotifications];
    }
    
}


-(IBAction)dismissView{
	[self removeFromSuperview];
}


- (void)keyboardWillShowSettings:(NSNotification *)note
{
	//Set Up the Button
	UIButton *barButtonItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 215, 320, 59)];
	[barButtonItem setBackgroundColor:[UIColor blackColor]];
	[barButtonItem setBackgroundImage:[UIImage imageNamed:hideKeyboard] forState:UIControlStateNormal];
	[barButtonItem addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
	
	// Set Up the Keyboard View
	UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
	UIView* keyboard;
	
	for(int i = 0; i < [tempWindow.subviews count]; i++)
	{
		//Get a reference of the current view 
		keyboard = [tempWindow.subviews objectAtIndex:i];
		[keyboard setFrame:CGRectMake(0, 0, 320, 220)];
		//Check to see if the description of the view we have referenced is "UIKeyboard" if so then we found
		//the keyboard view that we were looking for
		if([[keyboard description] hasPrefix:@"<UIKeyboard"] == YES)
		{			
			//[keyboard addSubview:barButtonItem];
		}
	}
}

- (void)buttonClicked:(NSNotification *)noteButton
{
	[first_name resignFirstResponder];
	[last_name resignFirstResponder];
	[email resignFirstResponder];
	[self removeFromSuperview];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	
	// Owner Details
    if (theTextField == email) {
		[email resignFirstResponder];
		[self removeFromSuperview];
    } 
	if (theTextField == first_name) {
		tempStr = [[NSString alloc] initWithFormat:@"%@", last_name.text];
        [last_name becomeFirstResponder];
		last_name.text = [[NSString alloc] initWithFormat:@"%@", tempStr];
    }
	if (theTextField == last_name) {
		tempStr = [[NSString alloc] initWithFormat:@"%@", email.text];
        [email becomeFirstResponder];
		email.text = [[NSString alloc] initWithFormat:@"%@", tempStr];
    }
	
    return YES;
}


@end
