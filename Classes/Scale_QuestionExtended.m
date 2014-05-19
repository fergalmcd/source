//
//  Scale_QuestionExtended.m
//  WRUPlayer
//
//  Created by Apple on 22/04/2014.
//  Copyright 2014 Tailteann. All rights reserved.
//

#import "Scale_QuestionExtended.h"


@implementation Scale_QuestionExtended

@synthesize mainButton, prev, next;
NSString *buttonImageName;


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	[self presentButton:buttonImageName];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)presentButton:(NSString *)buttonImage{
	buttonImageName = buttonImage;
	self.navigationController.navigationBarHidden = YES;
	[mainButton setBackgroundImage:[UIImage imageNamed:buttonImage] forState:UIControlStateNormal];
}


- (IBAction)nextImage{
	if([buttonImageName isEqualToString:@"q13Kitchen.png"]){
		[self presentButton:@"q13Objects.png"];
	}else{
		if([buttonImageName isEqualToString:@"q13Objects.png"]){
			[self presentButton:@"q13Sentences.png"];
		}else{
			if([buttonImageName isEqualToString:@"q13Sentences.png"]){	
				[self presentButton:@"q13Kitchen.png"];
			}
		}
	}
	
	if([buttonImageName isEqualToString:@"q14Words.png"])
		[self dismissViewController];
}

- (IBAction)prevImage{
	if([buttonImageName isEqualToString:@"q13Kitchen.png"]){
		[self presentButton:@"q13Sentences.png"];
	}else{
		if([buttonImageName isEqualToString:@"q13Objects.png"]){
			[self presentButton:@"q13Kitchen.png"];
		}else{
			if([buttonImageName isEqualToString:@"q13Sentences.png"]){
				[self presentButton:@"q13Objects.png"];
			}
		}
	}
	
	if([buttonImageName isEqualToString:@"q14Words.png"])
		[self dismissViewController];
}
	
	
- (IBAction)dismissViewController{
	self.navigationController.navigationBarHidden = NO;
	[[self navigationController] popViewControllerAnimated:NO];
}


- (void)dealloc {
	[mainButton release];
	[prev release];
	[next release];
	[buttonImageName release];
	
    [super dealloc];
}


@end
