//
//  DOMRawMotionData+Extensions.m
//  DOMATI
//
//  Created by Jad Osseiran on 25/02/2014.
//  Copyright (c) 2014 Jad. All rights reserved.
//

#import <CoreMotion/CMDeviceMotion.h>

#import "DOMRawMotionData+Extensions.h"

#import "NSManagedObject+Appulse.h"

#import "DOMTouchData.h"

@implementation DOMRawMotionData (Extensions)

+ (instancetype)rawMotionDataInContext:(NSManagedObjectContext *)context
    fromDeviceMotion:(CMDeviceMotion *)deviceMotion
{
    return [self newEntity:@"DOMRawMotionData" inContext:context idAttribute:@"identifier" value:[self localIdentifier] onInsert:^(DOMRawMotionData * object) {
                object.userAccelX = @(deviceMotion.userAcceleration.x);
                object.userAccelY = @(deviceMotion.userAcceleration.y);
                object.userAccelZ = @(deviceMotion.userAcceleration.z);

                object.rotationRateX = @(deviceMotion.rotationRate.x);
                object.rotationRateY = @(deviceMotion.rotationRate.y);
                object.rotationRateZ = @(deviceMotion.rotationRate.z);

                object.quaternionX = @(deviceMotion.attitude.quaternion.x);
                object.quaternionY = @(deviceMotion.attitude.quaternion.y);
                object.quaternionZ = @(deviceMotion.attitude.quaternion.z);
                object.quaternionW = @(deviceMotion.attitude.quaternion.w);

                object.roll = @(deviceMotion.attitude.roll);
                object.yaw = @(deviceMotion.attitude.yaw);
                object.pitch = @(deviceMotion.attitude.pitch);
            }];
}

- (NSDictionary *)postDictionary
{
    NSMutableDictionary * dictionary = [[NSMutableDictionary alloc] init];

    dictionary[@"user_accel_x"] = self.userAccelX;
    dictionary[@"user_accel_y"] = self.userAccelY;
    dictionary[@"user_accel_z"] = self.userAccelZ;

    dictionary[@"rotation_rate_x"] = self.rotationRateX;
    dictionary[@"rotation_rate_y"] = self.rotationRateY;
    dictionary[@"rotation_rate_z"] = self.rotationRateZ;

    dictionary[@"quaternion_x"] = self.quaternionX;
    dictionary[@"quaternion_y"] = self.quaternionY;
    dictionary[@"quaternion_z"] = self.quaternionZ;
    dictionary[@"quaternion_w"] = self.quaternionW;

    dictionary[@"roll"] = self.roll;
    dictionary[@"pitch"] = self.pitch;
    dictionary[@"yaw"] = self.yaw;

    dictionary[@"touch_datum_id"] = self.touchData.identifier;

    return dictionary;
}

@end
