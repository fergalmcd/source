//
//  Injury.h
//  WRUPlayer
//
//  Created by Fergal McDonnell on 25/04/2014.
//
//

#import <Foundation/Foundation.h>

@interface Injury : UIView {

    NSString *type; // Injury/Stiffness
    
    NSString *area;
    int severity;
    
}

@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *area;
@property int severity;

- (void)initialiseInjury;


@end
