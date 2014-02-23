
//
//  DOMRawData+Extension.m
//  DOMATI
//
//  Created by Jad Osseiran on 30/01/2014.
//  Copyright (c) 2014 Jad. All rights reserved.
//

#import <CoreMotion/CMDeviceMotion.h>

#import "NSObject+Extensions.h"
#import "CMDeviceMotion+Extensions.h"

#import "DOMRawData+Extension.h"
#import "DOMTouchData.h"

@implementation DOMRawData (Extension)

- (NSDictionary *)postDictionary
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];

    NSMutableArray *data = [[NSMutableArray alloc] initWithCapacity:[self.data count]];
    for (CMDeviceMotion *deviceMotion in self.data) {
        [data addObject:[deviceMotion dictionaryForm]];
    }
    
    dictionary[@"data"] = [data serializedForm];
    
    dictionary[@"kind"] = self.kind;
    dictionary[@"touch_datum_id"] = self.touchData.identifier;
    
    return dictionary;
}

@end
