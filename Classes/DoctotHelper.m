//
//  DoctotHelper.m
//  WRUPlayer
//
//  Created by Fergal McDonnell on 22/04/2014.
//  Copyright Tailteann 2014. All rights reserved.
//

#import "DoctotHelper.h"


@implementation DoctotHelper

- (void)flipToInfo:(UIViewController *)vc To:(UIView *)to {
	
	[vc.view addSubview:to];
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft forView:[vc.view superview] cache:YES];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:1.0];
	
	[UIView commitAnimations];
	
}


+ (void)flipTransition:(UIView *)flipView From:(NSString *)direction{
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	if([direction isEqualToString:@"left"])     [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft forView:flipView cache:YES ];
	if([direction isEqualToString:@"right"])	[UIView setAnimationTransition: UIViewAnimationTransitionFlipFromRight forView:flipView cache:YES ];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:1.0];
	
	[UIView commitAnimations];
}


+ (void)slideInFor:(UIScrollView *)scroll For:(NSString *)direction{
	CATransition *animation = [CATransition animation];
	[animation setDuration:0.5];
	[animation setType:kCATransitionPush];
	if([direction isEqualToString:@"Up"])		[animation setSubtype:kCATransitionFromRight];
	if([direction isEqualToString:@"Down"])     [animation setSubtype:kCATransitionFromLeft];
	[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[[scroll layer] addAnimation:animation forKey:@"swap"];
}

+ (void)slideInForView:(UIView *)slideView For:(NSString *)direction{
	CATransition *animation = [CATransition animation];
	[animation setDuration:0.5];
	[animation setType:kCATransitionPush];
	if([direction isEqualToString:@"right"])	[animation setSubtype:kCATransitionFromRight];
	if([direction isEqualToString:@"left"])     [animation setSubtype:kCATransitionFromLeft];
	[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[[slideView layer] addAnimation:animation forKey:@"swap"];
}


+ (void)curlTransitionFor:(UIScrollView *)scroll inDirection:(NSString *)direction{
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	if([direction isEqualToString:@"Up"])		[UIView setAnimationTransition: UIViewAnimationTransitionCurlUp forView:scroll cache:YES ];
	if([direction isEqualToString:@"Down"])	[UIView setAnimationTransition: UIViewAnimationTransitionCurlDown forView:scroll cache:YES ];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:1.0];
	
	[UIView commitAnimations];
}


+ (char *)returnTodaysDateAsChar {
	
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init]  autorelease];
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	NSString *formattedDateString = [dateFormatter stringFromDate:[NSDate date]];
	char *today = (char *)[formattedDateString UTF8String];
 	
	return today;
}


+ (NSString *)returnTodaysDateAsString {
	
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init]  autorelease];
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	NSString *today = [dateFormatter stringFromDate:[NSDate date]];
 	
	return today;
}


+ (double)returnTodaysDateAsDouble {
	
	double dateAsDouble = [[NSDate date] timeIntervalSince1970];

	return dateAsDouble;
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Email Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

+ (void) sendEmailWithSubject:(NSString *) subject withBody:(NSString *)body {
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString *to = [prefs stringForKey:@"Email"];
	NSString *mailString = [NSString stringWithFormat:@"mailto:?to=%@&subject=%@&body=%@",
							[to stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
							[subject stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
							[body  stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
	NSLog(@"%@", mailString);
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailString]];
	
}


@end
