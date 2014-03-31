//
//  NSObject+Extensions.m
//  DOMATI
//
//  Created by Jad Osseiran on 23/02/2014.
//  Copyright (c) 2014 Jad. All rights reserved.
//

#import "NSObject+Extensions.h"

#import "DOMErrors.h"

@implementation NSObject (Extensions)

- (NSString *)pointerString
{
    return [[NSString alloc] initWithFormat:@"%p", self];
}

- (NSString *)serializedForm
{
    NSError *error = nil;
    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString *JSONString = nil;

    if (!error)
    {
        JSONString = [[NSString alloc] initWithData:JSONData
                                           encoding:NSUTF8StringEncoding];
    }

    return JSONString;
}

@end
