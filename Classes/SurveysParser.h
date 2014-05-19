//
//  FavouritesParser.h
//  IPHA
//
//  Created by Fergal McDonnell on 21/02/2014.
//
//

#import <Foundation/Foundation.h>

@class Survey;

@interface SurveysParser : NSObject {
    
}

+ (Survey *)loadSurvey;
+ (void)saveSurvey:(Survey *)survey;

@end
