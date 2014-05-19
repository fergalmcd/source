//
//  Favourite.m
//  IPHA
//
//  Created by Fergal McDonnell on 21/02/2014.
//
//

#import "Survey.h"

@implementation Survey

@synthesize entries;

- (id)init {
    
    if ((self = [super init])) {
        self.entries = [[NSMutableArray alloc] init];
    }
    return self;
    
}

- (void) dealloc {
    self.entries = nil;
    [super dealloc];
}


@end
