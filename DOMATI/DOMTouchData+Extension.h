//
//  DOMTouchData+Extension.h
//  DOMATI
//
//  Created by Jad Osseiran on 2/11/2013.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import "DOMTouchData.h"

typedef NS_ENUM(NSInteger, DOMDataFileKind) {
    DOMDataFileKindNotSet = -1,
    DOMDataFileKindMotion,
    DOMDataFileKindTouch
};

@interface DOMTouchData (Extension)

+ (NSNumber *)localIdentifier;

- (DOMDataFile *)motionDataFile;
- (DOMDataFile *)touchDataFile;

- (NSDictionary *)postDictionary;

@end
