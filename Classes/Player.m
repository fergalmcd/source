//
//  Player.m
//  WRUPlayer
//
//  Created by Fergal McDonnell on 25/04/2014.
//
//

#import "Player.h"

@implementation Player

@synthesize username, wruID, firstName, lastName;
@synthesize surveyDate, dateAsString, weight, weightUnits, previousWeight, weightStatus, sleepTimeHours, sleepTimeMinutes, sleepTimeUnits, sleepAMPMIndicator, wakeupTimeHours, wakeupTimeMinutes, wakeupTimeUnits, wakeupAMPMIndicator, medicationTaken, sleepScore, energyScore, moodScore, sleepScoreLow, energyScoreLow, moodScoreLow, injuries, stiffnesses, illness, commentRecipient, commentRecipientEmail, comments;
@synthesize successfullySubmitted, dateAsInt;

NSUserDefaults *prefs;

- (void)initialisePlayer {
    
    prefs = [NSUserDefaults standardUserDefaults];
    
    username = @"";
    firstName = @"";
    lastName = @"";
    
    username = (NSString *)[prefs stringForKey:@"RegistrationID"];
    firstName = (NSString *)[prefs stringForKey:@"FirstName"];
    lastName = (NSString *)[prefs stringForKey:@"LastName"];
    
    NSString *wruIdAsString = (NSString *)[prefs stringForKey:@"PlayerWRUID"];
    wruID = wruIdAsString.intValue;
    
    weight = [[prefs stringForKey:@"Weight"] floatValue];
    weightUnits = (NSString *)[prefs stringForKey:@"WeightUnits"];
    previousWeight = weight;
    weightStatus = @"Normal";//NSLocalizedString(@"WRUPLAYER_WeightNormal", @"");
    
    sleepTimeUnits = [[NSString alloc] init];
    wakeupTimeUnits = [[NSString alloc] init];
    
    NSString *defaultSleepTimeString = (NSString *)[prefs stringForKey:@"SleepTime"];
    NSArray *defaultSleepTime = [defaultSleepTimeString componentsSeparatedByString:@":"];
    sleepTimeHours = [[defaultSleepTime objectAtIndex:0] intValue];
    sleepTimeMinutes = [[defaultSleepTime objectAtIndex:1] intValue];
    sleepTimeUnits = @"PM";//(NSString *)[defaultSleepTime objectAtIndex:2];
    if( [sleepTimeUnits isEqualToString:@"AM"] ) {
        sleepAMPMIndicator = YES;
    }else{
        sleepAMPMIndicator = NO;
    }
    
    NSString *defaultWakeupTimeString = (NSString *)[prefs stringForKey:@"WakeupTime"];
    NSArray *defaultWakeupTime = [defaultWakeupTimeString componentsSeparatedByString:@":"];
    wakeupTimeHours = [[defaultWakeupTime objectAtIndex:0] intValue];
    wakeupTimeMinutes = [[defaultWakeupTime objectAtIndex:1] intValue];
    wakeupTimeUnits = @"AM";//(NSString *)[defaultWakeupTime objectAtIndex:2];
    if( [wakeupTimeUnits isEqualToString:@"AM"] ) {
        wakeupAMPMIndicator = YES;
    }else{
        wakeupAMPMIndicator = NO;
    }
    
    sleepScoreLow = @"";
    energyScoreLow = @"";
    moodScoreLow = @"";
    
    injuries = [[NSMutableArray alloc] init];
    stiffnesses = [[NSMutableArray alloc] init];
    
    successfullySubmitted = NO;
    dateAsInt = 0;
    
}

@end
