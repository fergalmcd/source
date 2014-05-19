#import <Foundation/Foundation.h>

/**
 *	The class used to create the keypad
 */
@interface CustomKeyboard : NSObject {
	
	UITextField *currentTextField;	
	NSTimer *showCustomKeyboardTimer;
	UIButton *hideButton;
	
}

@property (nonatomic, retain) NSTimer *showCustomKeyboardTimer;
@property (nonatomic, retain) UIButton *hideButton;
@property (assign) UITextField *currentTextField;

#pragma mark -
#pragma mark Show the keypad

+ (CustomKeyboard *) keypadForTextField:(UITextField *)textField; 

- (void) removeCustomKeyboard;

@end