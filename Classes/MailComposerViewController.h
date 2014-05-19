//
//  MailComposerViewController.h
//  WRUPlayer
//
//  Created by Fergal McDonnell on 22/04/2014.
//  Copyright Tailteann 2014. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface MailComposerViewController : UIViewController <MFMailComposeViewControllerDelegate> 
{
	IBOutlet UILabel *message;
	IBOutlet MFMailComposeViewController *picker;
}

@property (nonatomic, retain) IBOutlet UILabel *message;
@property (nonatomic, retain) IBOutlet MFMailComposeViewController *picker;

-(void)setEmailDataForScale:(NSString *)scale WithText:(NSString *)bodyText;
- (void)setBasicEmailWithRecipient:(NSString *)recipient andSubject:(NSString *)subject andText:(NSString *)bodyText;
-(void)displayComposerSheet;
-(void)launchMailAppOnDevice;

@end
