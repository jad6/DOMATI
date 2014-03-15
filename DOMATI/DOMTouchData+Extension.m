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
#import "UIDevice+Extension.h"

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

+ (instancetype)touchData:(void (^)(DOMTouchData *touchData))touchDataBlock
                inContext:(NSManagedObjectContext *)context
{
     return [DOMTouchData newEntity:NSStringFromClass([DOMTouchData class])
                              inContext:context
                            idAttribute:@"identifier"
                                  value:[DOMTouchData localIdentifier]
                               onInsert:^(DOMTouchData *object) {
                                   if (touchDataBlock) {
                                       touchDataBlock(object);
                                   }
                               }];
}

+ (NSArray *)unsyncedTouchData
{
    return [self fetchRequest:^(NSFetchRequest *fs) {
        [fs setPredicate:[NSPredicate predicateWithFormat:@"identifier < 0"]];
    } inContext:[DOMCoreDataManager sharedManager].managedContext];
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
    
    dictionary[@"acceleration_avg"] = self.accelerationAvg;
    dictionary[@"duration"] = self.duration;
    dictionary[@"max_radius"] = self.maxRadius;
    dictionary[@"rotation_avg"] = self.rotationAvg;
    dictionary[@"x_delta"] = self.xDetla;
    dictionary[@"y_delta"] = self.yDelta;
    dictionary[@"cali_strength"] = self.calibrationStrength;
    dictionary[@"group"] = self.group;

    dictionary[@"device"] = [[UIDevice currentDevice] model];
    dictionary[@"device_model"] = [[UIDevice currentDevice] modelDetailed];
    dictionary[@"app_version"] = [UIApplication version];
    dictionary[@"user_id"] = @([DOMUser currentUser].identifier);
    
    return dictionary;
}

@end
