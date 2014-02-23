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
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey : NSLocalizedString(@"No accelerometer and gyroscope access.", nil),
                               NSLocalizedFailureReasonErrorKey : NSLocalizedString(@"DOMATI could access the accelerometer and gyroscope.", nil),
                               NSLocalizedRecoverySuggestionErrorKey : NSLocalizedString(@"Check the device's settings.", nil)};
    return [[NSError alloc] initWithDomain:DOMAIT_ERROR_DOMAIN code:-1200 userInfo:userInfo];
}

+ (NSError *)couldNotWriteFileError
{
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey : NSLocalizedString(@"Could not write file.", nil),
                               NSLocalizedFailureReasonErrorKey : NSLocalizedString(@"Could not successfully write file to the document folder", nil),
                               NSLocalizedRecoverySuggestionErrorKey : NSLocalizedString(@"Check where you are writing to.", nil)};
    return [[NSError alloc] initWithDomain:DOMAIT_ERROR_DOMAIN code:-1300 userInfo:userInfo];
}

+ (NSError *)invalidJSONError
{
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey : NSLocalizedString(@"Invalid JSON object.", nil),
                               NSLocalizedFailureReasonErrorKey : NSLocalizedString(@"Could not serialize the given object to JSON.", nil),
                               NSLocalizedRecoverySuggestionErrorKey : NSLocalizedString(@"Make sure that object can indeed be serialized.", nil)};
    return [[NSError alloc] initWithDomain:DOMAIT_ERROR_DOMAIN code:-1400 userInfo:userInfo];
}

@end
