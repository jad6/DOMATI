//
//  DOMTouchData+Extension.h
//  DOMATI
//
//  Created by Jad Osseiran on 2/11/2013.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import "DOMTouchData.h"

#import "NSManagedObject+Appulse.h"

typedef NS_ENUM(NSInteger, DOMRawDataKind) {
    DOMRawDataKindNotSet = -1,
    DOMRawDataKindMotion,
    DOMRawDataKindTouch
};

@interface DOMTouchData (Extension)

- (DOMRawData *)motionRawData;
- (DOMRawData *)touchRawData;

- (NSDictionary *)postDictionary;

+ (NSArray *)unsyncedTouchData;
- (NSArray *)unsyncedRawData;

@end
