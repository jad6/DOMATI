//
//  DOMRawMotionData+Extensions.h
//  DOMATI
//
//  Created by Jad Osseiran on 25/02/2014.
//  Copyright (c) 2014 Jad. All rights reserved.
//

#import "DOMRawMotionData.h"

#import "DOMRawData.h"

@class CMDeviceMotion;

@interface DOMRawMotionData (Extensions) <DOMRawData>

+ (instancetype)rawMotionDataInContext:(NSManagedObjectContext *)context
    fromDeviceMotion:(CMDeviceMotion *)deviceMotion;

- (NSDictionary *)postDictionary;

@end
