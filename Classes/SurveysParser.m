//
//  FavouritesParser.m
//  IPHA
//
//  Created by Fergal McDonnell on 21/02/2014.
//
//

#import "SurveysParser.h"
#import "Survey.h"
#import "GDataXMLNode.h"
#import "Player.h"
#import "Injury.h"


@implementation SurveysParser

+ (NSString *)dataFilePath:(BOOL)forSave {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *documentsPath = [documentsDirectory stringByAppendingPathComponent:@"Survey.xml"];
    if (forSave || [[NSFileManager defaultManager] fileExistsAtPath:documentsPath]) {
        return documentsPath;
    }else{
        return [[NSBundle mainBundle] pathForResource:@"Survey" ofType:@"xml"];
    }
    
}

+ (Survey *)loadSurvey {
    
    NSString *filePath = [self dataFilePath:FALSE];
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData
                                                           options:0 error:&error];
    if (doc == nil) { return nil; }
    
    Survey *survey = [[Survey alloc] init];
    NSArray *surveyEntries = [doc.rootElement elementsForName:@"Entry"];
    for (GDataXMLElement *surveyEntry in surveyEntries) {

        NSString *username;
        int *wruId;
        NSString *firstName;
        NSString *lastName;
        NSString *dateAsString;
        float  weight;
        NSString *weightUnit;
        NSString *weightStatus;
        int sleepTimeHour;
        int sleepTimeMinute;
        NSString *sleepTimeUnit;
        int wakeupTimeHour;
        int wakeupTimeMinute;
        NSString *wakeupTimeUnit;
        NSString *medicationTaken;
        float sleepScore;
        float energyScore;
        float moodScore;
        NSString *sleepScoreLow;
        NSString *energyScoreLow;
        NSString *moodScoreLow;
        NSString *illness;
        NSString *commentRecipient;
        NSString *commentRecipientEmail;
        NSString *comment;
        
        BOOL *connectionEstablished;
        NSString *connectionEstablishedString;
        
        // Username
        NSArray *usernames = [surveyEntry elementsForName:@"Username"];
        if (usernames.count > 0) {
            GDataXMLElement *theUserName = (GDataXMLElement *) [usernames objectAtIndex:0];
            username = [NSString stringWithFormat:@"%@", theUserName.stringValue];
            
        } else continue;
        
        // WRU ID
        NSArray *wruIds = [surveyEntry elementsForName:@"WRUID"];
        if (wruIds.count > 0) {
            GDataXMLElement *theWRUIds = (GDataXMLElement *) [wruIds objectAtIndex:0];
            wruId = theWRUIds.stringValue.intValue;
        } else continue;
        
        // First Name
        NSArray *firstNames = [surveyEntry elementsForName:@"FirstName"];
        if (firstNames.count > 0) {
            GDataXMLElement *theFirstName = (GDataXMLElement *) [firstNames objectAtIndex:0];
            firstName = [NSString stringWithFormat:@"%@", theFirstName.stringValue];
        } else continue;
        
        // Last Name
        NSArray *lastNames = [surveyEntry elementsForName:@"LastName"];
        if (lastNames.count > 0) {
            GDataXMLElement *theFirstName = (GDataXMLElement *) [lastNames objectAtIndex:0];
            lastName = [NSString stringWithFormat:@"%@", theFirstName.stringValue];
        } else continue;
        
        // DateAsString
        NSArray *dateAsStrings = [surveyEntry elementsForName:@"DateAsString"];
        if (dateAsStrings.count > 0) {
            GDataXMLElement *dateName = (GDataXMLElement *) [dateAsStrings objectAtIndex:0];
            dateAsString = [NSString stringWithFormat:@"%@", dateName.stringValue];
        } else continue;
        
        // Weight
        NSArray *weights = [surveyEntry elementsForName:@"Weight"];
        if (weights.count > 0) {
            GDataXMLElement *theWeight = (GDataXMLElement *) [weights objectAtIndex:0];
            weight = theWeight.stringValue.floatValue;
        } else continue;
        
        // Weight Unit
        NSArray *weightStatuses = [surveyEntry elementsForName:@"WeightStatus"];
        if (weightStatuses.count > 0) {
            GDataXMLElement *theWeightStatus = (GDataXMLElement *) [weightStatuses objectAtIndex:0];
            weightStatus = [NSString stringWithFormat:@"%@", theWeightStatus.stringValue];
        } else continue;
        
        // Weight Status
        NSArray *weightUnits = [surveyEntry elementsForName:@"WeightUnit"];
        if (weightUnits.count > 0) {
            GDataXMLElement *theWeightUnits = (GDataXMLElement *) [weightUnits objectAtIndex:0];
            weightUnit = [NSString stringWithFormat:@"%@", theWeightUnits.stringValue];
        } else continue;
        
        // Sleep Time Hour
        NSArray *sleepTimeHours = [surveyEntry elementsForName:@"SleepTimeHour"];
        if (sleepTimeHours.count > 0) {
            GDataXMLElement *theSleepTimeHours = (GDataXMLElement *) [sleepTimeHours objectAtIndex:0];
            sleepTimeHour = theSleepTimeHours.stringValue.intValue;
        } else continue;
        
        // Sleep Time Minute
        NSArray *sleepTimeMinutes = [surveyEntry elementsForName:@"SleepTimeMinute"];
        if (sleepTimeMinutes.count > 0) {
            GDataXMLElement *theSleepTimeMinutes = (GDataXMLElement *) [sleepTimeMinutes objectAtIndex:0];
            sleepTimeMinute = theSleepTimeMinutes.stringValue.intValue;
        } else continue;
        
        // Sleep Time Unit
        NSArray *sleepTimeUnits = [surveyEntry elementsForName:@"SleepTimeUnit"];
        if (sleepTimeUnits.count > 0) {
            GDataXMLElement *theSleepTimeUnits = (GDataXMLElement *) [sleepTimeUnits objectAtIndex:0];
            sleepTimeUnit = [NSString stringWithFormat:@"%@", theSleepTimeUnits.stringValue];
        } else continue;
        
        // Wakeup Time Hour
        NSArray *wakeupTimeHours = [surveyEntry elementsForName:@"WakeupTimeHour"];
        if (wakeupTimeHours.count > 0) {
            GDataXMLElement *theWakeupTimeHours = (GDataXMLElement *) [wakeupTimeHours objectAtIndex:0];
            wakeupTimeHour = theWakeupTimeHours.stringValue.intValue;
        } else continue;
        
        // Wakeup Time Minute
        NSArray *wakeupTimeMinutes = [surveyEntry elementsForName:@"WakeupTimeMinute"];
        if (wakeupTimeMinutes.count > 0) {
            GDataXMLElement *theWakeupTimeMinutes = (GDataXMLElement *) [wakeupTimeMinutes objectAtIndex:0];
            wakeupTimeMinute = theWakeupTimeMinutes.stringValue.intValue;
        } else continue;
        
        // Wakeup Time Unit
        NSArray *wakeupTimeUnits = [surveyEntry elementsForName:@"WakeupTimeUnit"];
        if (wakeupTimeUnits.count > 0) {
            GDataXMLElement *theWakeupTimeUnits = (GDataXMLElement *) [wakeupTimeUnits objectAtIndex:0];
            wakeupTimeUnit = [NSString stringWithFormat:@"%@", theWakeupTimeUnits.stringValue];
        } else continue;
        
        // Medication Taken
        NSArray *medicationsTaken = [surveyEntry elementsForName:@"MedicationTaken"];
        if (medicationsTaken.count > 0) {
            GDataXMLElement *theMedicationsTaken = (GDataXMLElement *) [medicationsTaken objectAtIndex:0];
            medicationTaken = [NSString stringWithFormat:@"%@", theMedicationsTaken.stringValue];
        } else continue;
        
        // Sleep Score
        NSArray *sleepScores = [surveyEntry elementsForName:@"SleepScore"];
        if (sleepScores.count > 0) {
            GDataXMLElement *theSleepScores = (GDataXMLElement *) [sleepScores objectAtIndex:0];
            sleepScore = theSleepScores.stringValue.floatValue;
        } else continue;
        
        // Energy Score
        NSArray *energyScores = [surveyEntry elementsForName:@"EnergyScore"];
        if (energyScores.count > 0) {
            GDataXMLElement *theEnergyScores = (GDataXMLElement *) [energyScores objectAtIndex:0];
            energyScore = theEnergyScores.stringValue.floatValue;
        } else continue;
        
        // Mood Score
        NSArray *moodScores = [surveyEntry elementsForName:@"MoodScore"];
        if (moodScores.count > 0) {
            GDataXMLElement *theMoodScores = (GDataXMLElement *) [moodScores objectAtIndex:0];
            moodScore = theMoodScores.stringValue.floatValue;
        } else continue;
        
        // Sleep Score Low
        NSArray *sleepScoreLows = [surveyEntry elementsForName:@"SleepScoreLow"];
        if (sleepScoreLows.count > 0) {
            GDataXMLElement *theSleepScoreLow = (GDataXMLElement *) [sleepScoreLows objectAtIndex:0];
            sleepScoreLow = [NSString stringWithFormat:@"%@", theSleepScoreLow.stringValue];
        } else continue;
        
        // Energy Score Low
        NSArray *energyScoreLows = [surveyEntry elementsForName:@"EnergyScoreLow"];
        if (energyScoreLows.count > 0) {
            GDataXMLElement *theEnergyScoreLow = (GDataXMLElement *) [energyScoreLows objectAtIndex:0];
            energyScoreLow = [NSString stringWithFormat:@"%@", theEnergyScoreLow.stringValue];
        } else continue;
        
        // Mood Score Low
        NSArray *moodScoreLows = [surveyEntry elementsForName:@"MoodScoreLow"];
        if (moodScoreLows.count > 0) {
            GDataXMLElement *theMoodScoreLow = (GDataXMLElement *) [moodScoreLows objectAtIndex:0];
            moodScoreLow = [NSString stringWithFormat:@"%@", theMoodScoreLow.stringValue];
        } else continue;
        
        // Illness
        NSArray *illnesses = [surveyEntry elementsForName:@"Illness"];
        if (illnesses.count > 0) {
            GDataXMLElement *theIllness = (GDataXMLElement *) [illnesses objectAtIndex:0];
            illness = [NSString stringWithFormat:@"%@", theIllness.stringValue];
        } else continue;
        
        // Comment Recipient
        NSArray *commentRecipients = [surveyEntry elementsForName:@"CommentRecipient"];
        if (commentRecipients.count > 0) {
            GDataXMLElement *theCommentRecipient = (GDataXMLElement *) [commentRecipients objectAtIndex:0];
            commentRecipient = [NSString stringWithFormat:@"%@", theCommentRecipient.stringValue];
        } else continue;
        
        // Comment Recipient Email
        NSArray *commentRecipientEmails = [surveyEntry elementsForName:@"CommentRecipientEmail"];
        if (commentRecipientEmails.count > 0) {
            GDataXMLElement *theCommentRecipientEmail = (GDataXMLElement *) [commentRecipientEmails objectAtIndex:0];
            commentRecipientEmail = [NSString stringWithFormat:@"%@", theCommentRecipientEmail.stringValue];
        } else continue;
        
        // Comment
        NSArray *comments = [surveyEntry elementsForName:@"Comment"];
        if (comments.count > 0) {
            GDataXMLElement *theComment = (GDataXMLElement *) [comments objectAtIndex:0];
            comment = [NSString stringWithFormat:@"%@", theComment.stringValue];
        } else continue;
        
        // Connection Established
        NSArray *connectionsEstablished = [surveyEntry elementsForName:@"ConnectionEstablished"];
        if (connectionsEstablished.count > 0) {
            GDataXMLElement *theConnectionsEstablished = (GDataXMLElement *) [connectionsEstablished objectAtIndex:0];
            connectionEstablishedString = [NSString stringWithFormat:@"%@", theConnectionsEstablished.stringValue];
            if( [connectionEstablishedString isEqualToString:@"YES"] ){
                connectionEstablished = YES;
            }else{
                connectionEstablished = NO;
            }
        } else continue;
        
        
        Player *entry = [[Player alloc] init];
        entry.username = username;
        entry.wruID = wruId;
        entry.firstName = firstName;
        entry.lastName = lastName;
        entry.dateAsString = dateAsString;
        entry.weight = weight;
        entry.weightUnits = weightUnit;
        entry.weightStatus = weightStatus;
        entry.sleepTimeHours = sleepTimeHour;
        entry.sleepTimeMinutes = sleepTimeMinute;
        entry.sleepTimeUnits = sleepTimeUnit;
        entry.wakeupTimeHours = wakeupTimeHour;
        entry.wakeupTimeMinutes = wakeupTimeMinute;
        entry.wakeupTimeUnits = wakeupTimeUnit;
        entry.medicationTaken = medicationTaken;
        entry.sleepScore = sleepScore;
        entry.energyScore = sleepScore;
        entry.moodScore = sleepScore;
        entry.sleepScoreLow = sleepScoreLow;
        entry.energyScoreLow = sleepScoreLow;
        entry.moodScoreLow = sleepScoreLow;
        entry.illness = illness;
        entry.commentRecipient = commentRecipient;
        entry.commentRecipientEmail = commentRecipientEmail;
        entry.comments = comment;
        entry.successfullySubmitted = connectionEstablished;
        
        // Injuries
        Injury *thisInjury;
        entry.injuries = [[NSMutableArray alloc] init];
        
        NSArray *playerInjuries = [surveyEntry elementsForName:@"Injury_Element"];
        if (playerInjuries.count > 0) {
            for( int i = 0; i < [playerInjuries count]; i++ ){
                
                GDataXMLElement *playerInjury = (GDataXMLElement *) [playerInjuries objectAtIndex:i];
                thisInjury = [[Injury alloc] init];
                
                NSArray *types = [playerInjury elementsForName:@"Injury_Type"];
                NSArray *areas = [playerInjury elementsForName:@"Injury_Area"];
                NSArray *severities = [playerInjury elementsForName:@"Injury_Severity"];
                
                for (GDataXMLElement *indexElement in types) {
                    
                    GDataXMLElement *type = (GDataXMLElement *) [types objectAtIndex:0];
                    GDataXMLElement *area = (GDataXMLElement *) [areas objectAtIndex:0];
                    GDataXMLElement *severity = (GDataXMLElement *) [severities objectAtIndex:0];
                    
                    thisInjury.type = type.stringValue;
                    thisInjury.area = area.stringValue;
                    thisInjury.severity = severity.stringValue.intValue;
                    
                }
                
                [entry.injuries addObject:thisInjury];
                
            }
        }
        
        
        // Stiffnesses
        Injury *thisStiffness;
        entry.stiffnesses = [[NSMutableArray alloc] init];
        
        NSArray *playerStiffnesses = [surveyEntry elementsForName:@"Stiffness_Element"];
        if (playerStiffnesses.count > 0) {
            for( int i = 0; i < [playerStiffnesses count]; i++ ){
                
                GDataXMLElement *playerStiffness = (GDataXMLElement *) [playerStiffnesses objectAtIndex:i];
                thisStiffness = [[Injury alloc] init];
                
                NSArray *types = [playerStiffness elementsForName:@"Stiffness_Type"];
                NSArray *areas = [playerStiffness elementsForName:@"Stiffness_Area"];
                NSArray *severities = [playerStiffness elementsForName:@"Stiffness_Severity"];
                
                for (GDataXMLElement *indexElement in types) {
                    
                    GDataXMLElement *type = (GDataXMLElement *) [types objectAtIndex:0];
                    GDataXMLElement *area = (GDataXMLElement *) [areas objectAtIndex:0];
                    GDataXMLElement *severity = (GDataXMLElement *) [severities objectAtIndex:0];
                    
                    thisStiffness.type = type.stringValue;
                    thisStiffness.area = area.stringValue;
                    thisStiffness.severity = severity.stringValue.intValue;
                    
                }
                
                [entry.stiffnesses addObject:thisStiffness];
                
            }
        }
        
        
        // Add the player's Entry to the Survey entries
        
        [survey.entries addObject:entry];
        
    }
    
    [doc release];
    [xmlData release];
    return survey;
    
}

+ (void)saveSurvey:(Survey *)survey {
    
    GDataXMLElement *surveyElement = [GDataXMLNode elementWithName:@"Survey"];
    
    for(Player *player in survey.entries) {
        
        GDataXMLElement *playerElement = [GDataXMLNode elementWithName:@"Entry"];
        GDataXMLElement *usernameElement = [GDataXMLNode elementWithName:@"Username" stringValue:player.username];
        GDataXMLElement *wruIdElement = [GDataXMLNode elementWithName:@"WRUID" stringValue:[NSString stringWithFormat:@"%i", player.wruID]];
        GDataXMLElement *firstNameElement = [GDataXMLNode elementWithName:@"FirstName" stringValue:player.firstName];
        GDataXMLElement *lastNameElement = [GDataXMLNode elementWithName:@"LastName" stringValue:player.lastName];
        GDataXMLElement *dateElement = [GDataXMLNode elementWithName:@"DateAsString" stringValue:player.dateAsString];
        GDataXMLElement *weightElement = [GDataXMLNode elementWithName:@"Weight" stringValue:[NSString stringWithFormat:@"%.1f", player.weight]];
        GDataXMLElement *weightUnitElement = [GDataXMLNode elementWithName:@"WeightUnit" stringValue:player.weightUnits];
        GDataXMLElement *weightStatusElement = [GDataXMLNode elementWithName:@"WeightStatus" stringValue:player.weightStatus];
        GDataXMLElement *sleepTimeHourElement = [GDataXMLNode elementWithName:@"SleepTimeHour" stringValue:[NSString stringWithFormat:@"%i", player.sleepTimeHours]];
        GDataXMLElement *sleepTimeMinuteElement = [GDataXMLNode elementWithName:@"SleepTimeMinute" stringValue:[NSString stringWithFormat:@"%i", player.sleepTimeMinutes]];
        GDataXMLElement *sleepTimeUnitElement = [GDataXMLNode elementWithName:@"SleepTimeUnit" stringValue:player.sleepTimeUnits];
        GDataXMLElement *wakeUpTimeHourElement = [GDataXMLNode elementWithName:@"WakeupTimeHour" stringValue:[NSString stringWithFormat:@"%i", player.wakeupTimeHours]];
        GDataXMLElement *wakeUpTimeMinuteElement = [GDataXMLNode elementWithName:@"WakeupTimeMinute" stringValue:[NSString stringWithFormat:@"%i", player.wakeupTimeMinutes]];
        GDataXMLElement *wakeUpTimeUnitElement = [GDataXMLNode elementWithName:@"WakeupTimeUnit" stringValue:player.wakeupTimeUnits];
        GDataXMLElement *medicationTakenElement = [GDataXMLNode elementWithName:@"MedicationTaken" stringValue:player.medicationTaken];
        GDataXMLElement *sleepScoreElement = [GDataXMLNode elementWithName:@"SleepScore" stringValue:[NSString stringWithFormat:@"%.1f", player.sleepScore]];
        GDataXMLElement *energyScoreElement = [GDataXMLNode elementWithName:@"EnergyScore" stringValue:[NSString stringWithFormat:@"%.1f", player.energyScore]];
        GDataXMLElement *moodScoreElement = [GDataXMLNode elementWithName:@"MoodScore" stringValue:[NSString stringWithFormat:@"%.1f", player.sleepScore]];
        GDataXMLElement *sleepScoreLowElement = [GDataXMLNode elementWithName:@"SleepScoreLow" stringValue:player.sleepScoreLow];
        GDataXMLElement *energyScoreLowElement = [GDataXMLNode elementWithName:@"EnergyScoreLow" stringValue:player.energyScoreLow];
        GDataXMLElement *moodScoreLowElement = [GDataXMLNode elementWithName:@"MoodScoreLow" stringValue:player.moodScoreLow];
        GDataXMLElement *illnessElement = [GDataXMLNode elementWithName:@"Illness" stringValue:player.illness];
        GDataXMLElement *commentRecipient = [GDataXMLNode elementWithName:@"CommentRecipient" stringValue:player.commentRecipient];
        GDataXMLElement *commentRecipientEmail = [GDataXMLNode elementWithName:@"CommentRecipientEmail" stringValue:player.commentRecipientEmail];
        GDataXMLElement *comment = [GDataXMLNode elementWithName:@"Comment" stringValue:player.comments];
        GDataXMLElement *connectionEstablished;
        if( player.successfullySubmitted ){
            connectionEstablished = [GDataXMLNode elementWithName:@"ConnectionEstablished" stringValue:@"YES"];
        }else{
             connectionEstablished = [GDataXMLNode elementWithName:@"ConnectionEstablished" stringValue:@"NO"];
        }
        
        [playerElement addChild:usernameElement];
        [playerElement addChild:wruIdElement];
        [playerElement addChild:firstNameElement];
        [playerElement addChild:lastNameElement];
        [playerElement addChild:dateElement];
        [playerElement addChild:weightElement];
        [playerElement addChild:weightUnitElement];
        [playerElement addChild:weightStatusElement];
        [playerElement addChild:sleepTimeHourElement];
        [playerElement addChild:sleepTimeMinuteElement];
        [playerElement addChild:sleepTimeUnitElement];
        [playerElement addChild:wakeUpTimeHourElement];
        [playerElement addChild:wakeUpTimeMinuteElement];
        [playerElement addChild:wakeUpTimeUnitElement];
        [playerElement addChild:medicationTakenElement];
        [playerElement addChild:sleepScoreElement];
        [playerElement addChild:energyScoreElement];
        [playerElement addChild:moodScoreElement];
        [playerElement addChild:sleepScoreLowElement];
        [playerElement addChild:energyScoreLowElement];
        [playerElement addChild:moodScoreLowElement];
        [playerElement addChild:illnessElement];
        [playerElement addChild:commentRecipient];
        [playerElement addChild:commentRecipientEmail];
        [playerElement addChild:comment];
        [playerElement addChild:connectionEstablished];
        
        
        // Adding the Injuries
        
        Injury *thisInjury;
        GDataXMLElement *injuryElement;
        GDataXMLElement *typeElement;
        GDataXMLElement *areaElement;
        GDataXMLElement *severityElement;
        
        for( int i = 0; i < [player.injuries count]; i++ ){
            thisInjury = (Injury *)[player.injuries objectAtIndex:i];
            injuryElement = [GDataXMLNode elementWithName:@"Injury_Element"];
            
                typeElement = [GDataXMLNode elementWithName:@"Injury_Type" stringValue:thisInjury.type];
                areaElement = [GDataXMLNode elementWithName:@"Injury_Area" stringValue:thisInjury.area];
                severityElement = [GDataXMLNode elementWithName:@"Injury_Severity" stringValue:thisInjury.severity];
            
            [injuryElement addChild:typeElement];
            [injuryElement addChild:areaElement];
            [injuryElement addChild:severityElement];
            
            [playerElement addChild:injuryElement];
        }
        
        // Adding the Stiffnesses
        
        Injury *thisStiffness;
        GDataXMLElement *stiffnessElement;
        
        for( int i = 0; i < [player.stiffnesses count]; i++ ){
            thisStiffness = (Injury *)[player.stiffnesses objectAtIndex:i];
            stiffnessElement = [GDataXMLNode elementWithName:@"Stiffness_Element"];
            
            typeElement = [GDataXMLNode elementWithName:@"Stiffness_Type" stringValue:thisInjury.type];
            areaElement = [GDataXMLNode elementWithName:@"Stiffness_Area" stringValue:thisInjury.area];
            severityElement = [GDataXMLNode elementWithName:@"Stiffness_Severity" stringValue:thisInjury.severity];
            
            [stiffnessElement addChild:typeElement];
            [stiffnessElement addChild:areaElement];
            [stiffnessElement addChild:severityElement];
            
            [playerElement addChild:stiffnessElement];
        }
    
        // Adding the player's Entry to the Survey list
        
        [surveyElement addChild:playerElement];
        
    }
        
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithRootElement:surveyElement];
    NSData *xmlData = document.XMLData;
    
    NSString *filePath = [self dataFilePath:TRUE];
    NSLog(@"Saving xml data to %@...", filePath);
    [xmlData writeToFile:filePath atomically:YES];
    
}


@end
