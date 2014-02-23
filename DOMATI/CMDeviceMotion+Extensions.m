//
//  CMDeviceMotion+Extensions.m
//  DOMATI
//
//  Created by Jad Osseiran on 23/02/2014.
//  Copyright (c) 2014 Jad. All rights reserved.
//

#import "CMDeviceMotion+Extensions.h"

@implementation CMDeviceMotion (Extensions)

- (NSDictionary *)dictionaryForm
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    dictionary[@"UserAccelX"] = @(self.userAcceleration.x);
    dictionary[@"UserAccelY"] = @(self.userAcceleration.y);
    dictionary[@"UserAccelZ"] = @(self.userAcceleration.z);
    
    dictionary[@"RotationRateX"] = @(self.rotationRate.x);
    dictionary[@"RotationRateY"] = @(self.rotationRate.y);
    dictionary[@"RotationRateZ"] = @(self.rotationRate.z);
    
    dictionary[@"QuaternionX"] = @(self.attitude.quaternion.x);
    dictionary[@"QuaternionY"] = @(self.attitude.quaternion.y);
    dictionary[@"QuaternionZ"] = @(self.attitude.quaternion.z);
    dictionary[@"QuaternionW"] = @(self.attitude.quaternion.w);
    
    dictionary[@"MagneticFieldX"] = @(self.magneticField.field.x);
    dictionary[@"MagneticFieldY"] = @(self.magneticField.field.y);
    dictionary[@"MagneticFieldZ"] = @(self.magneticField.field.z);

    dictionary[@"MagneticFieldAccuracy"] = @(self.magneticField.accuracy);
    
    return dictionary;
}

@end
