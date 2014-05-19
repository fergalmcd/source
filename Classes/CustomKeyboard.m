
#import "CustomKeyboard.h"
#import "Constants.h"


@implementation CustomKeyboard

static CustomKeyboard *keypad;

@synthesize showCustomKeyboardTimer;
@synthesize hideButton;

NSArray *allWindows;
UIWindow *keyboardWindow;

//Assign
@synthesize currentTextField;

#pragma mark -
#pragma mark Release

- (void) dealloc {
	[showCustomKeyboardTimer release];
	[hideButton release];
	[super dealloc];
}

//Private Method
- (void) setupKeyboardWindow {	
	//Add a button to the top, above all windows
	allWindows = [[UIApplication sharedApplication] windows];
	int topWindow = [allWindows count] - 1;
	keyboardWindow = [allWindows objectAtIndex:topWindow];
}

//Private Method //This is executed after a delay from showKeypadForTextField
- (void) addCustomItemsToKeyboard {
	
	[self setupKeyboardWindow];
	
	//Set Up the Custom View
	hideButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 205, 320, 59)];
	[hideButton setBackgroundColor:[UIColor blackColor]];
	[hideButton setBackgroundImage:[UIImage imageNamed:@"hide_keyboard.png"] forState:UIControlStateNormal];
	[hideButton setBackgroundImage:[UIImage imageNamed:@"hide_keyboard.png"] forState:UIControlStateHighlighted];
	[hideButton addTarget:self action:@selector(removeCustomKeyboard) forControlEvents:UIControlEventTouchUpInside];
	[keyboardWindow addSubview:hideButton];
	
}

/*
 Show the keyboard
 */
+ (CustomKeyboard *) keypadForTextField:(UITextField *)textField {
	
	if (!keypad) {
		keypad = [[CustomKeyboard alloc] init];
		keypad.hideButton = [[UIButton alloc] init];
		[keypad.hideButton addTarget:keypad action:@selector(removeCustomKeyboard) forControlEvents:UIControlEventTouchUpInside];
	}
	keypad.currentTextField = textField;
	keypad.showCustomKeyboardTimer = [NSTimer timerWithTimeInterval:0.1 target:keypad selector:@selector(addCustomItemsToKeyboard) userInfo:nil repeats:NO];
	[[NSRunLoop currentRunLoop] addTimer:keypad.showCustomKeyboardTimer forMode:NSDefaultRunLoopMode];
	return keypad;
}

/*
 Hide the keyboard
 */
- (void) removeCustomKeyboard {
	[self.showCustomKeyboardTimer invalidate]; //stop any timers still wanting to show the button
	[currentTextField resignFirstResponder];
	[hideButton removeFromSuperview];
}


@end

