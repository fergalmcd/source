//
//  ScaleScoreHeader.m
//  WRUPlayer
//
//  Created by Fergal McDonnell on 22/04/2014.
//  Copyright 2014 Tailteann. All rights reserved.
//

#import "ScaleScoreHeader.h"
#import "Constants.h"


@implementation ScaleScoreHeader

@synthesize header, divider1, divider2;
@synthesize headerDate, headerName, headerScore;
@synthesize dateSortArrow, nameSortArrow, scoreSortArrow;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)go {
	
	[header setImage:[UIImage imageNamed:savedScoresHeader]];
	[divider1 setImage:[UIImage imageNamed:savedScoresDivider]];
	[divider2 setImage:[UIImage imageNamed:savedScoresDivider]];
		
	[headerDate setTitle:NSLocalizedString(@"Save_Date", @"") forState:UIControlStateNormal];
	[headerName setTitle:NSLocalizedString(@"Save_FullName", @"") forState:UIControlStateNormal];
	[headerScore setTitle:NSLocalizedString(@"Save_Score", @"") forState:UIControlStateNormal];

}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
    [super dealloc];
}


@end
