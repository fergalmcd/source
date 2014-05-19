//
//  DocTOT_Info.m
//  WRUPlayer
//
//  Created by Fergal McDonnell on 22/04/2014.
//  Copyright Tailteann 2014. All rights reserved.
//

#import "DocTOT_Info.h"
#import "Constants.h"

@implementation DocTOT_Info

@synthesize settings;
@synthesize appName;
@synthesize copyright;
@synthesize welcomeLabel;
@synthesize spielLabel, sponsorLabel, sponsorURL, sponsorAddInfoLabel, sponsorButton;

NSURL *theUrl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self)
	{
		// this will appear as the title in the navigation bar
		self.title = NSLocalizedString(@"DocTOTInfoTitle", @"");
	}
	
	return self;
}

- (void)dealloc
{
	[super dealloc];
	
	[settings release];
	[appName release];
	[welcomeLabel release];
	[spielLabel release];
	[sponsorLabel release];
	[sponsorAddInfoLabel release];
	[sponsorURL release];
	[sponsorButton release];
	
	[theUrl release];
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
    // Set Up the Top Left of the Nav Bar
    UIButton* leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 43, 49)];
	[leftButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setImage:[UIImage imageNamed:@"icon_back.png"] forState:UIControlStateNormal];
	UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
	welcomeLabel.text = NSLocalizedString(@"Welcome_To_Doctot", @"");
	appName.text = [self infoValueForKey:@"CFBundleName"];
	copyright.text = NSLocalizedString(@"Copyright", @"");
	//spielLabel.text = NSLocalizedString(@"DocTOTInfoExplain", @"");
	//spielLabel.editable = NO;
	sponsorLabel.text = NSLocalizedString(@"Support", @"");
	sponsorAddInfoLabel.text = NSLocalizedString(@"Support_AddInfo", @"");
	sponsorURL.text = NSLocalizedString(@"Support_URL", @"");

    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *theBaseURL = [NSURL fileURLWithPath:path];
    //[spielLabel loadHTMLString:NSLocalizedString(@"DocTOTInfoExplain", @"") baseURL:theBaseURL];
    
    NSString *urlString = NSLocalizedString(@"WRUContactInfoLink", @"");
    NSURL *promoURL = [[NSURL alloc] initWithString:urlString];
    NSURLRequest *promoURLRequest = [[NSURLRequest alloc] initWithURL:promoURL];
    
    NSData *urlData;
	NSURLResponse *response;
	NSError *error = [[NSError alloc] init];
	urlData = [NSURLConnection sendSynchronousRequest:promoURLRequest returningResponse:&response error:&error];
	int error_code = [error code];
	if(error_code == 0){
		[spielLabel loadRequest:promoURLRequest];
	}else{
        // If can't connect to internet
		[spielLabel loadHTMLString:NSLocalizedString(@"DocTOTInfoExplain", @"") baseURL:theBaseURL];
	}
    
}

- (void)viewDidAppear:(BOOL)animated
{
	// do something here as our view re-appears
}

- (IBAction)goToInfo
{
	[settings removeFromSuperview];
	self.title = NSLocalizedString(@"DocTOTInfoTitle", @"");
}

- (IBAction)goToSettings
{
	if(self.settings == nil){
		[settings initWithFrame:CGRectZero];
	}
	self.title = NSLocalizedString(@"DocTOTSettingsTitle", @"");
	[settings go];
	[self.view addSubview:settings];
	
	if(settings.userDetailUpdate != NULL)
		[settings.userDetailUpdate removeFromSuperview];
	if(settings.changePassword != NULL)
		[settings.changePassword removeFromSuperview];
	if(settings.maxSavesUpdate != NULL)
		[settings.maxSavesUpdate removeFromSuperview];
}

- (IBAction)goToSponsorSite
{
	theUrl = [NSURL URLWithString:@"http://www.wru.co.uk"];
	[[UIApplication sharedApplication] openURL:theUrl];
}

- (void)popViewController {
    [[self navigationController] popViewControllerAnimated:YES];
}


@end
