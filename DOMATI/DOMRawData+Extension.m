//
//  DOMRawData+Extension.m
//  DOMATI
//
//  Created by Jad Osseiran on 30/01/2014.
//  Copyright (c) 2014 Jad. All rights reserved.
//

#import "DOMRawData+Extension.h"

#import "DOMTouchData.h"

@implementation DOMRawData (Extension)

- (NSDictionary *)postDictionary
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    dictionary[@"kind"] = self.kind;
    dictionary[@"data"] = self.data;
    dictionary[@"touch_datum_id"] = self.touchData.identifier;
    
    return dictionary;
}

@end
