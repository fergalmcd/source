//
//  MailComposerViewController.m
//  WRUPlayer
//
//  Created by Fergal McDonnell on 22/04/2014.
//  Copyright Tailteann 2014. All rights reserved.
//

#import "MailComposerViewController.h"
#import "Constants.h"

@implementation MailComposerViewController
@synthesize message, picker;

NSUserDefaults *prefs;
NSArray *toRecipients;
NSString *emailSubject;
NSString *emailBody;

-(void)setEmailDataForScale:(NSString *)scale WithText:(NSString *)bodyText
{
	NSString *tempEmailBody;
	
	prefs = [NSUserDefaults standardUserDefaults];
	toRecipients = [ NSArray arrayWithObject:[prefs stringForKey:@"Email"] ];
	emailSubject = [[NSString alloc] initWithFormat:@"%@ %@", scale, NSLocalizedString(@"Email_Results", @"")];
	tempEmailBody = [bodyText stringByReplacingOccurrencesOfString:@"-1" withString:@"-"];
	tempEmailBody = [tempEmailBody stringByReplacingOccurrencesOfString:@"= 0" withString:@"= -"];
	emailBody = tempEmailBody;
}

- (void)setBasicEmailWithRecipient:(NSString *)recipient andSubject:(NSString *)subject andText:(NSString *)bodyText
{
	prefs = [NSUserDefaults standardUserDefaults];
	toRecipients = [ NSArray arrayWithObject:recipient];
	emailSubject = subject;
	emailBody = bodyText;
}

#pragma mark -
#pragma mark Compose Mail

// Displays an email composition interface inside the application. Populates all the Mail fields. 
-(void)displayComposerSheet 
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowMail:) name:UIKeyboardWillShowNotification object:nil];
	
	picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
	[picker setSubject:emailSubject];
	[picker setToRecipients:toRecipients];
	[picker setMessageBody:emailBody isHTML:NO];

	[self presentModalViewController:picker animated:YES];
}


// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
	message.hidden = NO;
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			message.text = NSLocalizedString(@"Email_Cancelled", @"");
			break;
		case MFMailComposeResultSaved:
			message.text =NSLocalizedString(@"Email_Saved", @"");
			break;
		case MFMailComposeResultSent:
			message.text =NSLocalizedString(@"Email_Sent", @"");
			break;
		case MFMailComposeResultFailed:
			message.text = NSLocalizedString(@"Email_Cancelled", @"");
			break;
		default:
			message.text =NSLocalizedString(@"Email_Cancelled", @"");
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark Workaround

// Launches the Mail application on the device.
-(void)launchMailAppOnDevice
{
	NSString *recipients = [[NSString alloc] initWithFormat:@"mailto:%@&subject=%@", [prefs stringForKey:@"Email"], emailSubject];
	NSString *body = [[NSString alloc] initWithFormat:@"&body=%@", emailBody];
	
	NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}


#pragma mark -
#pragma mark Unload views

- (void)viewDidLoad 
{
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil)
	{
		// We must always check whether the current device is configured for sending emails
		if ([mailClass canSendMail])
		{
			NSLog(@"Can send email");
			[self displayComposerSheet];
		}
		else
		{
			[self launchMailAppOnDevice];
		}
	}
	else
	{
		[self launchMailAppOnDevice];
	}
}

- (void)viewDidUnload 
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.message = nil;
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc 
{
    [message release];
	[picker release];
	[super dealloc];
}

- (void)keyboardWillShowMail:(NSNotification *)note
{
	// Set Up the Keyboard View
	UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
	UIView* keyboard;
	
	for(int i = 0; i < [tempWindow.subviews count]; i++)
	{
		//Set Up the Button
		UIButton *barButtonItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 215, 320, 59)];
		[barButtonItem setBackgroundColor:[UIColor blackColor]];
		[barButtonItem setBackgroundImage:[UIImage imageNamed:hideKeyboard] forState:UIControlStateNormal];
		[barButtonItem addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
		
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

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    return YES;
}

@end
