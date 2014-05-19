//
//  StartView.m
//  WRUPlayer
//
//  Created by Fergal McDonnell on 22/04/2014.
//  Copyright Tailteann 2014. All rights reserved.
//

#import "StartView.h"
#import "Constants.h"


@implementation StartView

@synthesize support_label;
@synthesize continue_button;

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
	[welcome_label release];
	[support_label release];
	[continue_button release];
	
    [super dealloc];
}


- (void)go{
	//welcome_label.text = NSLocalizedString(@"Welcome_To_Doctot", @"");
	//support_label.text = NSLocalizedString(@"Support", @"");
	
	//[continue_button setTitle:NSLocalizedString(@"Button_Continue", @"") forState:UIControlStateNormal];
	//[continue_button setBackgroundImage:[UIImage imageNamed:resetButton] forState:UIControlStateNormal];
	//[continue_button setBackgroundImage:[UIImage imageNamed:resetButtonDown] forState:UIControlStateSelected];
}


@end
