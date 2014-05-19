//
//  StartView.h
//  WRUPlayer
//
//  Created by Fergal McDonnell on 22/04/2014.
//  Copyright Tailteann 2014. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StartView : UIView {
	UILabel *welcome_label;
	UILabel *support_label;
	UIButton *continue_button;
	
}

@property (nonatomic, retain) IBOutlet UILabel *support_label;
@property (nonatomic, retain) IBOutlet UIButton *continue_button;

- (void)go;

@end
