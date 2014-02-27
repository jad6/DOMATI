//
//  DOMRawTouchData+Extensions.m
//  DOMATI
//
//  Created by Jad Osseiran on 25/02/2014.
//  Copyright (c) 2014 Jad. All rights reserved.
//

#import "DOMRawTouchData+Extensions.h"

#import "DOMTouchData.h"

@implementation DOMRawTouchData (Extensions)

- (NSDictionary *)postDictionary
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    dictionary[@"touch_datum_id"] = self.touchData.identifier;
    
    return dictionary;
}

@end
