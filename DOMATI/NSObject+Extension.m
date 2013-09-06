//
//  NSObject+Extension.m
//  DOMATI
//
//  Created by Jad Osseiran on 6/09/13.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import <objc/runtime.h>

#import "NSObject+Extension.h"

@implementation NSObject (Extension)

- (void)enumeratePropertiesNames:(void (^)(NSString *propertyName))propertyNameBlock
{
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    for (NSInteger i = 0; i < count; i++) {
        const char *name = property_getName(properties[i]);
        
        // Do not give back properties with '_' at the start, they ar eprivate to Apple and cannot be set.
        if (name[0] != '_' && propertyNameBlock) {
            propertyNameBlock([[NSString alloc] initWithCString:name encoding:NSUTF8StringEncoding]);
        }
    }
}

- (NSString *)pointerStr
{
    return [[NSString alloc] initWithFormat:@"%p", self];
}

@end
