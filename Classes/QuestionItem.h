//
//  QuestionItem.h
//  WRUPlayer
//
//  Created by Fergal McDonnell on 22/04/2014.
//  Copyright Tailteann 2014. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QuestionItem : NSObject {
	NSInteger item_no;
	NSString *description;
	float score;
}

@property (nonatomic) NSInteger item_no;
@property (nonatomic, retain) NSString *description;
@property (nonatomic) float score;

@end
