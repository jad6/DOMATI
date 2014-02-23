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
    if (!error) {
        JSONString = [[NSString alloc] initWithData:JSONData
                                           encoding:NSUTF8StringEncoding];
    }
    
    return JSONString;
}

#pragma mark - Logic 

- (NSMutableString *)serializeObject:(id)object
                      withJSONString:(NSMutableString *)JSONString
                               error:(NSError * __autoreleasing *)error
{
    if (*error || ![NSJSONSerialization isValidJSONObject:object]) {
        if (!*error) {
            *error = [DOMErrors invalidJSONError];
        }
        return nil;
    }
    
    if (!JSONString) {
        JSONString = [[NSMutableString alloc] init];
    }
    
    if ([self isKindOfClass:[NSDictionary class]]) {
        [(NSDictionary *)self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [JSONString appendString:[self serializeObject:object
                                            withJSONString:JSONString
                                                     error:error]];
        }];
    } else if ([self isKindOfClass:[NSArray class]]) {
        for (id obj in (NSArray *)self) {
            [JSONString appendString:[self serializeObject:object
                                            withJSONString:JSONString
                                                     error:error]];
        }
    }
    
    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:error];
    if (!*error) {
        [JSONString appendString:[[NSString alloc] initWithData:JSONData
                                                       encoding:NSUTF8StringEncoding]];
    }
    
    return JSONString;
}

@end
