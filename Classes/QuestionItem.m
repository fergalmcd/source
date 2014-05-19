//
//  QuestionItem.m
//  WRUPlayer
//
//  Created by Fergal McDonnell on 22/04/2014.
//  Copyright Tailteann 2014. All rights reserved.
//

#import "QuestionItem.h"


@implementation QuestionItem

@synthesize item_no;
@synthesize description;
@synthesize score;

- (void)initialize{
	item_no = -1;
	description = @"";
	score = 0.0;
}

- (void)dealloc {
	
	[description release];
	
    [super dealloc];
	
}

@end
