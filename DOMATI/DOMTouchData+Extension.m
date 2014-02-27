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

#import "DOMRawMotionData.h"
#import "DOMRawTouchData.h"
#import "DOMUser.h"

@implementation DOMTouchData (Extension)

#pragma mark - Logic

- (NSArray *)unsyncedDataForClass:(Class)class
{
    NSAssert([class isSubclassOfClass:[NSManagedObject class]], @"%@ is not a subclass of NSManagedObject", class);
    
    return [class fetchRequest:^(NSFetchRequest *fs) {
        [fs setPredicate:[NSPredicate predicateWithFormat:@"identifier < 0 AND touchData == %@", self]];
    } inContext:[self managedObjectContext]];
}

#pragma mark - Public

+ (NSArray *)unsyncedTouchData
{
    return [self fetchRequest:^(NSFetchRequest *fs) {
        [fs setPredicate:[NSPredicate predicateWithFormat:@"identifier < 0"]];
    } inContext:[DOMCoreDataManager sharedManager].mainContext];
}

- (NSArray *)unsyncedRawMotionData
{
    return [self unsyncedDataForClass:[DOMRawMotionData class]];
}

- (NSArray *)unsyncedRawTouchData
{
    return [self unsyncedDataForClass:[DOMRawTouchData class]];
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
