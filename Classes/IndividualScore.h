//
//  IndividualScore.h
//  WRUPlayer
//
//  Created by Fergal McDonnell on 22/04/2014.
//  Copyright 2009 Doctot. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface IndividualScore : NSObject {
	NSString *pk;
	NSInteger tablePosition;
	NSString *firstName;
	NSString *lastName;
	NSString *date;
	NSDate *dateForDisplay;
	float score;
	NSString *scoreAsString;
	NSString *diagnosis;
	NSString *diagnosisExtended;
	NSInteger diagnosisLevel;
	NSString *diagnosisColour;
	float q1;	float q2;	float q3;	float q4;	float q5;	
	float q6;	float q7;	float q8;	float q9;	float q10;
	float q11;	float q12;	float q13;	float q14;	float q15;	
	NSString *q1Extended;	NSString *q2Extended;	NSString *q3Extended;	NSString *q4Extended;	NSString *q5Extended;
	NSString *q6Extended;	NSString *q7Extended;	NSString *q8Extended;	NSString *q9Extended;	NSString *q10Extended;
	NSString *q11Extended;	NSString *q12Extended;	NSString *q13Extended;	NSString *q14Extended;	NSString *q15Extended;
	NSString *scale;
}

@property (nonatomic, retain) NSString *pk;
@property (nonatomic) NSInteger tablePosition;
@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *lastName;
@property (nonatomic, retain) NSString *date;
@property (nonatomic, retain) NSDate *dateForDisplay;
@property (nonatomic) float score;
@property (nonatomic, retain) NSString *scoreAsString;
@property (nonatomic, retain) NSString *diagnosis;
@property (nonatomic, retain) NSString *diagnosisExtended;
@property (nonatomic) NSInteger diagnosisLevel;
@property (nonatomic, retain) NSString *diagnosisColour;
@property (nonatomic) float q1;
@property (nonatomic) float q2;
@property (nonatomic) float q3;
@property (nonatomic) float q4;
@property (nonatomic) float q5;
@property (nonatomic) float q6;
@property (nonatomic) float q7;
@property (nonatomic) float q8;
@property (nonatomic) float q9;
@property (nonatomic) float q10;
@property (nonatomic) float q11;
@property (nonatomic) float q12;
@property (nonatomic) float q13;
@property (nonatomic) float q14;
@property (nonatomic) float q15;
@property (nonatomic, retain) NSString *q1Extended;
@property (nonatomic, retain) NSString *q2Extended;
@property (nonatomic, retain) NSString *q3Extended;
@property (nonatomic, retain) NSString *q4Extended;
@property (nonatomic, retain) NSString *q5Extended;
@property (nonatomic, retain) NSString *q6Extended;
@property (nonatomic, retain) NSString *q7Extended;
@property (nonatomic, retain) NSString *q8Extended;
@property (nonatomic, retain) NSString *q9Extended;
@property (nonatomic, retain) NSString *q10Extended;
@property (nonatomic, retain) NSString *q11Extended;
@property (nonatomic, retain) NSString *q12Extended;
@property (nonatomic, retain) NSString *q13Extended;
@property (nonatomic, retain) NSString *q14Extended;
@property (nonatomic, retain) NSString *q15Extended;
@property (nonatomic, retain) NSString *scale;

-(float)returnScore;


@end
