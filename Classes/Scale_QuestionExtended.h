//
//  Scale_QuestionExtended.h
//  WRUPlayer
//
//  Created by Apple on 22/04/2014.
//  Copyright 2014 Tailteann. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Scale_QuestionExtended : UIViewController {
	IBOutlet UIButton *mainButton;
	IBOutlet UIButton *prev;
	IBOutlet UIButton *next;
}

@property (nonatomic, retain) UIButton *mainButton;
@property (nonatomic, retain) UIButton *prev;
@property (nonatomic, retain) UIButton *next;

- (void)presentButton:(NSString *)buttonImage;
- (IBAction)nextImage;
- (IBAction)prevImage;
- (IBAction)dismissViewController;

@end
