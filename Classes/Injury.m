//
//  Injury.m
//  WRUPlayer
//
//  Created by Fergal McDonnell on 25/04/2014.
//
//

#import "Injury.h"

@implementation Injury

@synthesize type, area, severity;

- (void)initialiseInjuryOfType:(NSString *)theType atCoordinatesX:(float)xCoordinate andY:(float)yCoordinate {

    type = theType;
    
    self.frame = CGRectMake(xCoordinate, yCoordinate, 50, 50);
    
}

@end
