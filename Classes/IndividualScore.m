//
//  IndividualScore.m
//  WRUPlayer
//
//  Created by Fergal McDonnell on 22/04/2014.
//  Copyright 2014 Tailteann. All rights reserved.
//

#import "IndividualScore.h"


@implementation IndividualScore

@synthesize pk, tablePosition, firstName, lastName, date, dateForDisplay, score, scoreAsString, diagnosis, diagnosisExtended, diagnosisLevel, diagnosisColour;
@synthesize q1, q2, q3, q4, q5, q6, q7, q8, q9, q10, q11, q12, q13, q14, q15;
@synthesize q1Extended, q2Extended, q3Extended, q4Extended, q5Extended, q6Extended, q7Extended, q8Extended, q9Extended, q10Extended, q11Extended, q12Extended, q13Extended, q14Extended, q15Extended;
@synthesize scale;

- (float)returnScore{
	return score;
}

- (void)dealloc {
	[pk release];
	[firstName release];
	[lastName release];
	[date release];
	[dateForDisplay release];
	[diagnosis release];
	[scoreAsString release];
	[diagnosisExtended release];
	[diagnosisColour release];
	[q1Extended release];
	[q2Extended release];
	[q3Extended release];
	[q4Extended release];
	[q5Extended release];
	[q6Extended release];
	[q7Extended release];
	[q8Extended release];
	[q9Extended release];
	[q10Extended release];
	[q11Extended release];
	[q12Extended release];
	[q13Extended release];
	[q14Extended release];
	[q15Extended release];
	[scale release];
	
	[super dealloc];
}

@end
