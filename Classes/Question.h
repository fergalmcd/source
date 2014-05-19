//
//  Question.h
//  WRUPlayer
//
//  Created by Fergal McDonnell on 22/04/2014.
//  Copyright Tailteann 2014. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuestionItem.h"


@interface Question : NSObject {
	NSString *question;
	NSString *questionSubheading;
	NSString *questionHint;
	QuestionItem *item0;
	QuestionItem *item1;
	QuestionItem *item2;
	QuestionItem *item3;
	QuestionItem *item4;
	QuestionItem *item5;	// OPS & RANKIN ONLY ???
	QuestionItem *item6;	// RANKIN ONLY ???
	QuestionItem *itemUntestable;	// NIHSS ONLY
}

@property (nonatomic, retain) NSString *question;
@property (nonatomic, retain) NSString *questionSubheading;
@property (nonatomic, retain) NSString *questionHint;

@property (nonatomic, retain) QuestionItem *item0;
@property (nonatomic, retain) QuestionItem *item1;
@property (nonatomic, retain) QuestionItem *item2;
@property (nonatomic, retain) QuestionItem *item3;
@property (nonatomic, retain) QuestionItem *item4;
@property (nonatomic, retain) QuestionItem *item5;	// OPS & RANKIN ONLY ???
@property (nonatomic, retain) QuestionItem *item6;	// RANKIN ONLY ???
@property (nonatomic, retain) QuestionItem *itemUntestable;	// NIHSS ONLY

- (void)setupQuestion:(NSInteger)question_num ForScale:(NSString *)scale;
- (void)standardQuestionSetupFor:(NSInteger)question_num OfScale:(NSString *)scale;
- (void)yesNoQuestionSetupFor:(NSInteger)question_num OfScale:(NSString *)scale;
- (void)addUntestableItemFor:(NSInteger)question_num OfScale:(NSString *)scale;	// NIHSS ONLY
- (void)setQuestionHintFor:(NSInteger)question_num OfScale:(NSString *)scale;


@end
