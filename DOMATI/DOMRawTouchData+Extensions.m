//
//  DOMRawTouchData+Extensions.m
//  DOMATI
//
//  Created by Jad Osseiran on 25/02/2014.
//  Copyright (c) 2014 Jad. All rights reserved.
//

#import "DOMRawTouchData+Extensions.h"

#import "DOMTouchData.h"

#import "NSManagedObject+Appulse.h"

@implementation DOMRawTouchData (Extensions)

+ (instancetype)rawTouchDataInContext:(NSManagedObjectContext *)context
    fromTouchInfo:(NSDictionary *)touchInfo
{
    return [self newEntity:@"DOMRawTouchData" inContext:context idAttribute:@"identifier" value:[self localIdentifier] onInsert:^(DOMRawTouchData * object) {

                object.x = touchInfo[@"x"];
                object.y = touchInfo[@"y"];

                object.radius = touchInfo[@"radius"];

                object.phase = touchInfo[@"phase"];
                object.timestamp = touchInfo[@"timestamp"];
            }];
}

- (NSDictionary *)postDictionary
{
    NSMutableDictionary * dictionary = [[NSMutableDictionary alloc] init];

    dictionary[@"x"] = self.x;
    dictionary[@"y"] = self.y;
    dictionary[@"radius"] = self.radius;
    dictionary[@"phase"] = self.phase;
    dictionary[@"timestamp"] = self.timestamp;

    dictionary[@"touch_datum_id"] = self.touchData.identifier;

    return dictionary;
}

@end
