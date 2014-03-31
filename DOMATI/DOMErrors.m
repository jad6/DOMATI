//
//  DOMErrors.m
//  DOMATI
//
//  Created by Jad Osseiran on 2/11/2013.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import "DOMErrors.h"

#define DOMAIT_ERROR_DOMAIN @"com.jadosseiran.domati.errors"

@implementation DOMErrors

+ (NSError *)noDeviceMotionError
{
    NSDictionary * userInfo = @{ NSLocalizedDescriptionKey : NSLocalizedString(@"No accelerometer and gyroscope access.", nil),
                                 NSLocalizedFailureReasonErrorKey : NSLocalizedString(@"DOMATI could access the accelerometer and gyroscope.", nil),
                                 NSLocalizedRecoverySuggestionErrorKey : NSLocalizedString(@"Check the device's settings.", nil) };

    return [[NSError alloc] initWithDomain:DOMAIT_ERROR_DOMAIN code:-1200 userInfo:userInfo];
}

@end
