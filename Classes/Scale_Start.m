//
//  Scale_Start.m
//  WRUPlayer
//
//  Created by Fergal McDonnell on 22/04/2014.
//  Copyright 2014 Tailteann. All rights reserved.
//

#import "Scale_Start.h"
#import "Constants.h"


@implementation Scale_Start


@synthesize fullName, position, playerImage;
@synthesize fullTitle, subTag;
@synthesize background;

@synthesize startTest;
@synthesize goToInfo;
@synthesize goToSavedScores;

NSUserDefaults *prefs;


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}


- (void)goFor:(NSString *)scale{
	
    prefs = [NSUserDefaults standardUserDefaults];
    
	if([scale isEqualToString:scale1Id]){
		fullTitle.text = NSLocalizedString(@"PageOneFullTitle", @"");
		subTag.text = NSLocalizedString(@"PageOneSubTag", @"");
	}
	
    fullName.text = [NSString stringWithFormat:@"%@ %@", [prefs objectForKey:@"FirstName"], [prefs objectForKey:@"LastName"]];
    position.text = [NSString stringWithFormat:@"%@", [prefs objectForKey:@"PlayerPosition"]];
    
    NSString *theImageURL = (NSString *)[prefs objectForKey:@"PlayerImageURL"];
    NSURL *url = [NSURL URLWithString:theImageURL];
    NSData *data = [NSData dataWithContentsOfURL:url];
    playerImage.image = [[UIImage alloc] initWithData:data];
    
	[startTest setTitle:NSLocalizedString(@"Button_StartTest", @"") forState:UIControlStateNormal];
	[goToInfo setTitle:NSLocalizedString(@"Button_Information", @"") forState:UIControlStateNormal];
	[goToSavedScores setTitle:NSLocalizedString(@"Button_SavedScores", @"") forState:UIControlStateNormal];
	
	[background setImage:[UIImage imageNamed:questionLanding]];
	
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
	[fullTitle release];
	[subTag release];
	[background release];
	[startTest release];
	[goToInfo release];
	[goToSavedScores release];
	
    [super dealloc];
}


@end
