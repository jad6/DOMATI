//
//  DOMDataFile+Extension.m
//  DOMATI
//
//  Created by Jad Osseiran on 30/01/2014.
//  Copyright (c) 2014 Jad. All rights reserved.
//

#import "DOMDataFile+Extension.h"

#import "DOMTouchData.h"

@implementation DOMDataFile (Extension)

- (NSDictionary *)postDictionary
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    dictionary[@"kind"] = self.kind;
    
    id object = [NSKeyedUnarchiver unarchiveObjectWithFile:self.path];
    dictionary[@"data"] = object;
    
    dictionary[@"touch_data_id"] = self.touchData.identifier;
    
    return dictionary;
}

@end
