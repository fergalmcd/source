//
//  InfoItem.h
//  WRUPlayer
//
//  Created by Fergal McDonnell on 22/04/2014.
//  Copyright Tailteann 2014. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface InfoItem : UIViewController {
	UILabel *infoType;
	NSString *scale;	
	UITextView *infoTextView;
}

@property (nonatomic, retain) IBOutlet UILabel *infoType;
@property (nonatomic, retain) NSString *scale;
@property (nonatomic, retain) IBOutlet UITextView *infoTextView;


@end
