//
//  ProgressViewColoured.h
//  WRUPlayer
//
//  Created by Fergal McDonnell on 22/04/2014.
//  Copyright Tailteann 2014. All rights reserved.
//

#import "ProgressViewColoured.h"


@implementation ProgressViewColoured

int barHeight = 19;
int barWidth = 318;
int progressOffset = 0;

- (id) initWithCoder: (NSCoder*)aDecoder {
	if(self=[super initWithCoder: aDecoder]) {
	}
	return self;
}

- (id) initWithProgressViewStyle: (UIProgressViewStyle) style {
	if(self=[super initWithProgressViewStyle: style]) {
	}
	return self;
}

- (void)drawRect:(CGRect)rect {	
	
	UIImage *pb_on = [UIImage imageNamed:@"prog_bar_both.png"];
	int currentProgressPosition = ((barWidth/2) * self.progress) - (barWidth / 2) - progressOffset;
	[pb_on drawInRect:CGRectMake(currentProgressPosition, 0, barWidth, barHeight)];

}


- (void)dealloc {
    [super dealloc];
}


@end