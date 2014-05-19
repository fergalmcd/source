//
//  DoctotHelper.h
//  WRUPlayer
//
//  Created by Fergal McDonnell on 22/04/2014.
//  Copyright Tailteann 2014. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/CAAnimation.h>
#import <QuartzCore/CAMediaTimingFunction.h>


@interface DoctotHelper : NSObject {

}

- (void)flipToInfo:(UIViewController *)vc To:(UIView *)to;
+ (void)flipTransition:(UIView *)flipView From:(NSString *)direction;
+ (void)slideInFor:(UIScrollView *)scroll For:(NSString *)direction;
+ (void)slideInForView:(UIView *)slideView For:(NSString *)direction;
+ (void)curlTransitionFor:(UIScrollView *)scroll inDirection:(NSString *)direction;
+ (char *)returnTodaysDateAsChar;
+ (NSString *)returnTodaysDateAsString;
+ (double)returnTodaysDateAsDouble;
+ (void) sendEmailWithSubject:(NSString *) subject withBody:(NSString *)body;

@end
