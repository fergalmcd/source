//
//  Player.h
//  WRUPlayer
//
//  Created by Fergal McDonnell on 25/04/2014.
//
//

#import <Foundation/Foundation.h>

@interface Player : NSObject {
    
    NSString *username;
    int wruID;
    NSString *firstName;
    NSString *lastName;
    NSDate *surveyDate;
    NSString *dateAsString;
    
    float weight;
    NSString *weightUnits;
    float previousWeight;
    NSString *weightStatus;
    int sleepTimeHours;
    int sleepTimeMinutes;
    NSString *sleepTimeUnits;
    BOOL sleepAMPMIndicator;
    int wakeupTimeHours;
    int wakeupTimeMinutes;
    NSString *wakeupTimeUnits;
    BOOL wakeupAMPMIndicator;
    NSString *medicationTaken;
    float sleepScore;
    float energyScore;
    float moodScore;
    NSString *sleepScoreLow;
    NSString *energyScoreLow;
    NSString *moodScoreLow;
    NSMutableArray *injuries;
    NSMutableArray *stiffnesses;
    NSString *illness;
    NSString *commentRecipient;
    NSString *commentRecipientEmail;
    NSString *comments;
    
    BOOL successfullySubmitted;
    int dateAsInt;

}

@property (nonatomic, retain) NSString *username;
@property int wruID;
@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *lastName;
@property (nonatomic, retain) NSDate *surveyDate;
@property (nonatomic, retain) NSString *dateAsString;
@property float weight;
@property (nonatomic, retain) NSString *weightUnits;
@property float previousWeight;
@property (nonatomic, retain) NSString *weightStatus;
@property int sleepTimeHours;
@property int sleepTimeMinutes;
@property (nonatomic, retain) NSString *sleepTimeUnits;
@property BOOL sleepAMPMIndicator;
@property int wakeupTimeHours;
@property int wakeupTimeMinutes;
@property (nonatomic, retain) NSString *wakeupTimeUnits;
@property BOOL wakeupAMPMIndicator;
@property (nonatomic, retain) NSString *medicationTaken;
@property float sleepScore;
@property float energyScore;
@property float moodScore;
@property (nonatomic, retain) NSString *sleepScoreLow;
@property (nonatomic, retain) NSString *energyScoreLow;
@property (nonatomic, retain) NSString *moodScoreLow;
@property (nonatomic, retain) NSMutableArray *injuries;
@property (nonatomic, retain) NSMutableArray *stiffnesses;
@property (nonatomic, retain) NSString *illness;
@property (nonatomic, retain) NSString *commentRecipient;
@property (nonatomic, retain) NSString *commentRecipientEmail;
@property (nonatomic, retain) NSString *comments;
@property BOOL successfullySubmitted;
@property int dateAsInt;

- (void)initialisePlayer;


@end
