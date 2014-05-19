//
//  Settings.m
//  WRUPlayer
//
//  Created by Fergal McDonnell on 22/04/2014.
//  Copyright Tailteann 2014. All rights reserved.
//

#import "Settings.h"
#import "Constants.h"


@implementation Settings

@synthesize scrollView, groupedTable;
@synthesize owner_details_label, automaticEmail_label, weightUnits_label, shakeReset_label;
@synthesize password_label, passwordSwitch, automaticEmailSwitch, shakeResetSwitch, weightUnitsSwitch;
@synthesize changePassword;
@synthesize dailyNotificationUpdate, sleepTimeUpdate, wakeUpTimeUpdate, userDetailUpdate, maxSavesUpdate;
@synthesize maxSavesUpdateButton, ownerDetailsUpdateButton, dailyNotificationUpdateButton, sleepTimeUpdateButton, wakeUpTimeUpdateButton;
@synthesize owner_details_view;

NSUserDefaults *prefs;
NSString *userFieldToUpdate;
NSInteger currentSavesAllowed;
BOOL passwordStatus;
BOOL automaticEmailStatus;
BOOL shakeResetStatus;

UIView *myContent;
UIView *cellView;
UILabel *emptyLabel;

NSString * const NOTIF_RemovePassword = @"RemovePassword";

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		//[self go];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
	[scrollView release];
	[groupedTable release];
	[myContent release];
	[cellView release];
	[emptyLabel release];
	[userFieldToUpdate release];

	[owner_details_label release];
	[password_label release];
	[automaticEmail_label release];
	[shakeReset_label release];
	
	[passwordSwitch release];
	[automaticEmailSwitch release];
	[shakeResetSwitch release];
	[changePassword release];
	
	[maxSavesUpdateButton release];
	[ownerDetailsUpdateButton release];
	
	[userDetailUpdate release];
	[maxSavesUpdate release];
	
	[owner_details_view release];
	
    [super dealloc];
}


- (void)go{
	
	prefs = [NSUserDefaults standardUserDefaults];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removePasswordProtection) name:NOTIF_RemovePassword object:nil];
	
	owner_details_label.text = NSLocalizedString(@"Settings_OwnerDetails", @"");	
	
	password_label.text = NSLocalizedString(@"Settings_Password_Label", @"");
	if( [[prefs stringForKey:@"Password"] length] > 0 )
		passwordStatus = YES;
	else
		passwordStatus = NO;
	[passwordSwitch setOn:passwordStatus];
	
	[maxSavesUpdateButton setTitle:NSLocalizedString(@"Settings_MaxSave_Label", @"") forState:UIControlStateNormal];
    
    [dailyNotificationUpdateButton setTitle:NSLocalizedString(@"Settings_DailyNotification", @"") forState:UIControlStateNormal];
	[sleepTimeUpdateButton setTitle:NSLocalizedString(@"Settings_SleepTime", @"") forState:UIControlStateNormal];
    [wakeUpTimeUpdateButton setTitle:NSLocalizedString(@"Settings_WakeUpTime", @"") forState:UIControlStateNormal];
    
    /*weightUnitsSwitch.onImage = [UIImage imageNamed:@"answer_click_yes.png"];
    //weightUnitsSwitch.offImage = [UIImage imageNamed:@"answer_off_no.png"];
    weightUnits_label.text = NSLocalizedString(@"Settings_WeightUnits", @"");
    NSString *weightUnitsDefault = [prefs stringForKey:@"WeightUnits"];
    if( [weightUnitsDefault isEqualToString:@"Kgs"]){
		[weightUnitsSwitch setOn:YES];
		[prefs setObject:@"Kgs" forKey:@"WeightUnits"];
	}else{
		[weightUnitsSwitch setOn:NO];
		[prefs setObject:@"lbs" forKey:@"WeightUnits"];
	}
    
    automaticEmail_label.text = NSLocalizedString(@"Settings_AutomaticEmail", @"");
	automaticEmailStatus = [prefs boolForKey:@"AutomaticEmail"];
	if(automaticEmailStatus == YES){
		[automaticEmailSwitch setOn:YES];
		[prefs setBool:YES forKey:@"AutomaticEmail"];
	}else{
		[automaticEmailSwitch setOn:NO];
		[prefs setBool:NO forKey:@"AutomaticEmail"];
	}*/
	
	shakeReset_label.text = NSLocalizedString(@"Settings_ShakeReset", @"");
	shakeResetStatus = [prefs boolForKey:@"ShakeReset"];
	if(shakeResetStatus == YES){
		[shakeResetSwitch setOn:YES];
		[prefs setBool:YES forKey:@"ShakeReset"];
	}else{
		[shakeResetSwitch setOn:NO];
		[prefs setBool:NO forKey:@"ShakeReset"];
	}
	
	groupedTable.backgroundColor = [UIColor clearColor];
	emptyLabel = [[UILabel alloc] init];
	[groupedTable reloadData];
	[scrollView addSubview:groupedTable];
	scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, scrollView.frame.size.height + 50);
	
	[userDetailUpdate go:NSLocalizedString(@"Settings_Heading1", @"")];
	[maxSavesUpdate go:NSLocalizedString(@"Settings_Heading3", @"")];
	
    [dailyNotificationUpdate go:NSLocalizedString(@"Settings_Heading5", @"")];
	[sleepTimeUpdate go:NSLocalizedString(@"Settings_Heading6", @"")];
	[wakeUpTimeUpdate go:NSLocalizedString(@"Settings_Heading7", @"")];
    
}

- (IBAction)togglePassword{
	
	// Determine original Password Status (On or Off)
	if( [[prefs stringForKey:@"Password"] length] > 0 )
		passwordStatus = YES;
	else
		passwordStatus = NO;
	
	// Toggle to new Password Status
	if(passwordStatus == YES){
		passwordStatus = NO;
		[self removePasswordProtection];
	}else{
		passwordStatus = YES;
		[self goToChangePassword];
	}
	
	[passwordSwitch setOn:passwordStatus];
}

- (IBAction)toggleAutomaticEmail{
	if(automaticEmailStatus == YES)
		automaticEmailStatus = NO;
	else
		automaticEmailStatus = YES;
		
	[automaticEmailSwitch setOn:automaticEmailStatus];
	[prefs setBool:automaticEmailStatus forKey:@"AutomaticEmail"];
}

- (IBAction)toggleShakeReset{
	if(shakeResetStatus == YES)
		shakeResetStatus = NO;
	else
		shakeResetStatus = YES;
	
	[shakeResetSwitch setOn:shakeResetStatus];
	[prefs setBool:shakeResetStatus forKey:@"ShakeReset"];
}

- (IBAction)goToChangePassword{
	[changePassword goUpdate];
	[self.window addSubview:changePassword];
	[DoctotHelper slideInForView:changePassword For:@"right"];
}

- (IBAction)removePasswordProtection{
	[changePassword clearPasswordProtection];
	[passwordSwitch setOn:NO];
}

- (IBAction)goToMaxSavesUpdate{
	[self.window addSubview:maxSavesUpdate];
	[DoctotHelper slideInForView:changePassword For:@"right"];
}


- (IBAction)goToOwnerDetailsUpdate{
	[self.window addSubview:userDetailUpdate];
	[DoctotHelper slideInForView:userDetailUpdate For:@"right"];
	
	userFieldToUpdate = [[NSString alloc] initWithFormat:@"%@", userDetailUpdate.first_name.text];
	[userDetailUpdate.first_name becomeFirstResponder];
	userDetailUpdate.first_name.text = [[NSString alloc] initWithFormat:@"%@", userFieldToUpdate];
}

- (IBAction)goToDefaultTimeFor:(UIButton *)sender {

    if( sender == dailyNotificationUpdateButton ){
        NSLog(@"Daily Notification");
        [self.window addSubview:dailyNotificationUpdate];
    }
    if( sender == sleepTimeUpdateButton ){
        NSLog(@"sleepTimeUpdateButton");
        [self.window addSubview:sleepTimeUpdate];
    }
    if( sender == wakeUpTimeUpdateButton ){
        NSLog(@"wakeUpTimeUpdateButton");
        [self.window addSubview:wakeUpTimeUpdate];
    }
    
}


///// Table Methods /////
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 0;
	
	if(section == 0)	rows = 1;
	if(section == 1)	rows = 1;
	if(section == 2)	rows = 4;
	
	return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section       
{
    UIView *sectionHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 40)];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 250, 40)];
	
	[sectionHeader setBackgroundColor:[UIColor clearColor]];
	[headerLabel setBackgroundColor:[UIColor clearColor]];
	[headerLabel setTextColor:[UIColor whiteColor]];
	
	if(section == 0)	headerLabel.text = NSLocalizedString(@"Settings_Heading1", @"");
	if(section == 1)	headerLabel.text = NSLocalizedString(@"Settings_Heading2", @"");
	if(section == 2)	headerLabel.text = NSLocalizedString(@"Settings_Heading3", @"");
	
	[sectionHeader addSubview:headerLabel];
	
    return sectionHeader;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"SettingsCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		//cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
        cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
	}
	
	myContent = cell.contentView;
	
	// Set up the cells
	
	cellView = [self returnRowViewForSection:indexPath.section AndSectionRow:indexPath.row];
	[myContent addSubview:cellView];
	
	return cell;
}

- (UIView *)returnRowViewForSection:(NSInteger)section AndSectionRow:(NSInteger)row{

#define ROW_HEIGHT 45
#define ROW_WIDTH 300
#define FIRST_COLUMN_OFFSET 10
	
	UIView *rowView;
	
	rowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ROW_WIDTH, ROW_HEIGHT)];
	
	// Owner Details
	if( (section == 0) && (row == 0) ){
		ownerDetailsUpdateButton.frame = CGRectMake(0 , 0 , ROW_WIDTH , ROW_HEIGHT);
		[rowView addSubview:ownerDetailsUpdateButton];

		owner_details_label.frame = CGRectMake(FIRST_COLUMN_OFFSET , 0 , 75 , ROW_HEIGHT);
		[rowView addSubview:owner_details_label];
		
		userDetailUpdate.owner_details.frame = CGRectMake(FIRST_COLUMN_OFFSET + 90 , 0 , 200 , ROW_HEIGHT);
		userDetailUpdate.owner_details.textAlignment = NSTextAlignmentRight;
		[rowView addSubview:userDetailUpdate.owner_details];
	}
	
	// Access PIN
	if( (section == 1) && (row == 0) ){
		password_label.frame = CGRectMake(FIRST_COLUMN_OFFSET , 0 , 150 , ROW_HEIGHT);
		[rowView addSubview:password_label];

		passwordSwitch.frame = CGRectMake(FIRST_COLUMN_OFFSET + 190 , 9 , 94 , 27);
		[rowView addSubview:passwordSwitch];
	}
	
	// Defaults: Daily Notification
	if( (section == 2) && (row == 0) ){
		dailyNotificationUpdateButton.frame = CGRectMake(FIRST_COLUMN_OFFSET , 0 , 200 , ROW_HEIGHT);
		[rowView addSubview:dailyNotificationUpdateButton];
		
        dailyNotificationUpdate.outputTime.frame = CGRectMake(FIRST_COLUMN_OFFSET + 190 , 9 , 94 , 27);
        [rowView addSubview:dailyNotificationUpdate.outputTime];
	}
	
	// Defaults: Sleep Time
	if( (section == 2) && (row == 1) ){
		sleepTimeUpdateButton.frame = CGRectMake(FIRST_COLUMN_OFFSET , 0 , 200 , ROW_HEIGHT);
		[rowView addSubview:sleepTimeUpdateButton];
		
		sleepTimeUpdate.outputTime.frame = CGRectMake(FIRST_COLUMN_OFFSET + 190 , 9 , 94 , 27);
        [rowView addSubview:sleepTimeUpdate.outputTime];
	}
	
	// Defaults: Wake Up Time
	if( (section == 2) && (row == 2) ){
		wakeUpTimeUpdateButton.frame = CGRectMake(FIRST_COLUMN_OFFSET , 0 , 200 , ROW_HEIGHT);
		[rowView addSubview:wakeUpTimeUpdateButton];
		
		wakeUpTimeUpdate.outputTime.frame = CGRectMake(FIRST_COLUMN_OFFSET + 190 , 9 , 94 , 27);
        [rowView addSubview:wakeUpTimeUpdate.outputTime];
	}
    
	// Defaults: Allow Shake to Reset
	if( (section == 2) && (row == 3) ){
		shakeReset_label.frame = CGRectMake(FIRST_COLUMN_OFFSET , 0 , 200 , ROW_HEIGHT);
		[rowView addSubview:shakeReset_label];
		
		shakeResetSwitch.frame = CGRectMake(FIRST_COLUMN_OFFSET + 190 , 9 , 94 , 27);
		[rowView addSubview:shakeResetSwitch];
	}
    
	
	return rowView;
}


@end
