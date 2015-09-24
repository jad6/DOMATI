//
//  DOMTouchData+Extension.m
//  DOMATI
//
//  Created by Jad Osseiran on 2/11/2013.
//  Copyright (c) 2013 Jad. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer. Redistributions in binary
//  form must reproduce the above copyright notice, this list of conditions and
//  the following disclaimer in the documentation and/or other materials
//  provided with the distribution. Neither the name of the nor the names of
//  its contributors may be used to endorse or promote products derived from
//  this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.

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

- (NSArray *)unsyncedDataForClass:(Class) class
    {
    NSAssert([class isSubclassOfClass:[NSManagedObject class]], @"%@ is not a subclass of NSManagedObject", class);

    return [class fetchRequest:^(NSFetchRequest *fs) {
      [fs setPredicate:[NSPredicate predicateWithFormat:@"identifier < 0 AND touchData == %@", self]];
    } inContext:[self managedObjectContext]];
}

#pragma mark - Public

    + (instancetype)touchData : (void (^)(DOMTouchData *touchData))touchDataBlock
                                inContext : (NSManagedObjectContext *)context {
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

+ (NSArray *)unsyncedTouchData {
    return [self fetchRequest:^(NSFetchRequest *fs) {
      [fs setPredicate:[NSPredicate predicateWithFormat:@"identifier < 0"]];
    } inContext:[DOMCoreDataManager sharedManager].managedContext];
}

- (NSArray *)unsyncedRawMotionData {
    return [self unsyncedDataForClass:[DOMRawMotionData class]];
}

- (NSArray *)unsyncedRawTouchData {
    return [self unsyncedDataForClass:[DOMRawTouchData class]];
}

#pragma mark - Network

- (NSDictionary *)postDictionary {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];

    dictionary[@"acceleration_avg"] = self.accelerationAvg;
    dictionary[@"duration"] = self.duration;
    dictionary[@"max_radius"] = self.maxRadius;
    dictionary[@"rotation_avg"] = self.rotationAvg;
    dictionary[@"x_delta"] = self.xDetla;
    dictionary[@"y_delta"] = self.yDelta;
    dictionary[@"cali_strength"] = self.calibrationStrength;

    dictionary[@"device"] = [[UIDevice currentDevice] model];
    dictionary[@"device_model"] = [[UIDevice currentDevice] modelDetailed];
    dictionary[@"app_version"] = [UIApplication version];
    dictionary[@"user_id"] = @([DOMUser currentUser].identifier);

    return dictionary;
}

@end
