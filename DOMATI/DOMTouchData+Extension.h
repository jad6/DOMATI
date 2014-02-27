//
//  DOMTouchData+Extension.h
//  DOMATI
//
//  Created by Jad Osseiran on 2/11/2013.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import "DOMTouchData.h"

#import "NSManagedObject+Appulse.h"

@interface DOMTouchData (Extension) 

+ (NSArray *)unsyncedTouchData;

- (NSArray *)unsyncedRawMotionData;
- (NSArray *)unsyncedRawTouchData;

- (NSDictionary *)postDictionary;

@end
