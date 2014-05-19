//
//  Question.m
//  WRUPlayer
//
//  Created by Fergal McDonnell on 22/04/2014.
//  Copyright Tailteann 2014. All rights reserved.
//

#import "Question.h"
#import "Constants.h"


@implementation Question

@synthesize question, questionSubheading, questionHint;
@synthesize item0, item1, item2, item3, item4, item5, item6, itemUntestable;

NSString *q_string;			NSString *qSubheading_string;
NSString *qItemUntestable_string;
NSString *qItem0_string;	NSString *qItem1_string;	NSString *qItem2_string;	NSString *qItem3_string;	NSString *qItem4_string;	NSString *qItem5_string;	NSString *qItem6_string;
NSString *new_scale;
NSInteger new_question_num;

NSUserDefaults *prefs;
NSDate *today;
NSDateFormatter *dateFormat;

- (void)dealloc {
	
	[question release];	
	[questionSubheading release];
	[questionHint release];
	[item0 release];		[item1 release];		[item2 release];		[item3 release];		[item4 release];		[item5 release];		[item6 release];
	[itemUntestable release];
	[q_string release];		
	[qSubheading_string release];
    [qItem0_string release];	[qItem1_string release];	[qItem2_string release];	[qItem3_string release];	[qItem4_string release];	[qItem5_string release];	[qItem6_string release];
	[qItemUntestable_string release];
    [new_scale release];
	
	[prefs release];
	[today release];
	[dateFormat release];
	
    [super dealloc];

}

- (void)setupQuestion:(NSInteger)question_num ForScale:(NSString *)scale{
	
	prefs = [NSUserDefaults standardUserDefaults];
	dateFormat = [[NSDateFormatter alloc] init];
	today = [NSDate date];
	
	item0 = [[QuestionItem alloc] init];
	item1 = [[QuestionItem alloc] init];
	item2 = [[QuestionItem alloc] init];
	item3 = [[QuestionItem alloc] init];
	item4 = [[QuestionItem alloc] init];
	item5 = [[QuestionItem alloc] init];
	item6 = [[QuestionItem alloc] init];

	itemUntestable = [[QuestionItem alloc] init];
	
	if([scale isEqual:[scale1Id uppercaseString]] == YES){
        if( question_num >= 4 ){
            [self standardQuestionSetupFor:question_num OfScale:scale];
        }else{
            [self yesNoQuestionSetupFor:question_num OfScale:scale];
            //[self setQuestionHintFor:question_num OfScale:scale];
        }
	}
	
}

- (void)standardQuestionSetupFor:(NSInteger)question_num OfScale:(NSString *)scale{
	
	q_string = [[NSString alloc] initWithFormat:@"%@_Q%i", scale, question_num];
	qSubheading_string = [[NSString alloc] initWithFormat:@"%@_Subheading", q_string];
	
	question = NSLocalizedString(q_string, @"");
	questionSubheading = NSLocalizedString(qSubheading_string, @"");
	
	qItem0_string  = [[NSString alloc] initWithFormat:@"%@_Item0", q_string];
	qItem1_string  = [[NSString alloc] initWithFormat:@"%@_Item1", q_string];
	qItem2_string  = [[NSString alloc] initWithFormat:@"%@_Item2", q_string];
	qItem3_string  = [[NSString alloc] initWithFormat:@"%@_Item3", q_string];
	qItem4_string  = [[NSString alloc] initWithFormat:@"%@_Item4", q_string];
	qItem5_string  = [[NSString alloc] initWithFormat:@"%@_Item5", q_string];
	qItem6_string  = [[NSString alloc] initWithFormat:@"%@_Item6", q_string];
	
	item0.item_no = 1;
	item0.description = NSLocalizedString(qItem0_string, @"");
	item0.score = 0;
	
	item1.item_no = 2; 
	item1.description = NSLocalizedString(qItem1_string, @"");
	item1.score = 1;
	
	item2.item_no = 3;
	item2.description = NSLocalizedString(qItem2_string, @"");
	item2.score = 2;
	
	item3.item_no = 4;
	item3.description = NSLocalizedString(qItem3_string, @"");
	item3.score = 3;
	
	item4.item_no = 5;
	item4.description = NSLocalizedString(qItem4_string, @"");
	item4.score = 4;
	
	item5.item_no = 6;
	item5.description = NSLocalizedString(qItem5_string, @"");
	item5.score = 5;
	
	item6.item_no = 7;
	item6.description = NSLocalizedString(qItem6_string, @"");
	item6.score = 6;
	
}

- (void)yesNoQuestionSetupFor:(NSInteger)question_num OfScale:(NSString *)scale{
	
	q_string = [[NSString alloc] initWithFormat:@"%@_Q%i", scale, question_num];
	qSubheading_string = [[NSString alloc] initWithFormat:@"%@_Subheading", q_string];
	
	question = NSLocalizedString(q_string, @"");
	questionSubheading = NSLocalizedString(qSubheading_string, @"");
	
	item0 = [[QuestionItem alloc] init];
	item1 = [[QuestionItem alloc] init];
	
	qItem0_string  = [[NSString alloc] initWithFormat:@"%@_Item0", scale];
	qItem1_string  = [[NSString alloc] initWithFormat:@"%@_Item1", scale];
	
	item0.item_no = 1;
	item0.description = NSLocalizedString(qItem0_string, @"");
	item0.score = 0;
	
	item1.item_no = 2;
	item1.description = NSLocalizedString(qItem1_string, @"");
	item1.score = 1;
	
}

// NIHSS
- (void)addUntestableItemFor:(NSInteger)question_num OfScale:(NSString *)scale{}
// OPS
- (void)setQuestionHintFor:(NSInteger)question_num OfScale:(NSString *)scale{}


@end