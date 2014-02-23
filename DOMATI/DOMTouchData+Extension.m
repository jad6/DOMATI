//
//  DOMTouchData+Extension.m
//  DOMATI
//
//  Created by Jad Osseiran on 2/11/2013.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import "DOMTouchData+Extension.h"

#import "DOMCoreDataManager.h"

#import "NSManagedObject+Appulse.h"
#import "UIApplication+Extensions.h"

#import "DOMRawData+Extension.h"
#import "DOMUser.h"

@implementation DOMTouchData (Extension)

- (DOMRawData *)rawDataWithKind:(DOMRawDataKind)kind
{
    __block DOMRawData *rawData = nil;
    [self.rawData enumerateObjectsUsingBlock:^(DOMRawData *object, BOOL *stop) {
        if ([object.kind integerValue] == kind) {
            rawData = object;
            *stop = YES;
        }
    }];
    
    if (!rawData) {
        rawData = [DOMRawData newEntity:@"DOMRawData"
                              inContext:[self managedObjectContext]
                            idAttribute:@"identifier"
                                  value:[DOMRawData localIdentifier]
                               onInsert:^(DOMRawData *object) {
                                   object.kind = @(kind);
                                   object.touchData = self;
                               }];
    }
    
    return rawData;
}

#pragma mark - Public

- (DOMRawData *)motionRawData
{
    return [self rawDataWithKind:DOMRawDataKindMotion];
}

- (DOMRawData *)touchRawData
{
    return [self rawDataWithKind:DOMRawDataKindTouch];
}

+ (NSArray *)unsyncedTouchData
{
    return [self fetchRequest:^(NSFetchRequest *fs) {
        [fs setPredicate:[NSPredicate predicateWithFormat:@"identifier < 0"]];
    } inContext:[DOMCoreDataManager sharedManager].mainContext];
}

- (NSArray *)unsyncedRawData
{
    return [DOMRawData fetchRequest:^(NSFetchRequest *fs) {
        [fs setPredicate:[NSPredicate predicateWithFormat:@"identifier < 0 AND touchData == %@", self]];
    } inContext:[self managedObjectContext]];
}

#pragma mark - Network

- (NSDictionary *)postDictionary
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];

    dictionary[@"acceleration"] = self.acceleration;
    dictionary[@"duration"] = self.duration;
    dictionary[@"num_touches"] = self.numTouches;
    dictionary[@"radius"] = self.radius;
    dictionary[@"rotation"] = self.rotation;
    dictionary[@"strength"] = self.strength;
    dictionary[@"x"] = self.x;
    dictionary[@"y"] = self.y;
    dictionary[@"cali_strength"] = self.calibrationStrength;

    dictionary[@"device"] = [UIDevice currentDevice].model;
    dictionary[@"app_version"] = [UIApplication version];
    dictionary[@"user_id"] = @([DOMUser currentUser].identifier);
    
    return dictionary;
}

@end
