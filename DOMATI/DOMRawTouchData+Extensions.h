//
//  DOMRawTouchData+Extensions.h
//  DOMATI
//
//  Created by Jad Osseiran on 25/02/2014.
//  Copyright (c) 2014 Jad. All rights reserved.
//

#import "DOMRawTouchData.h"

#import "DOMRawData.h"

@interface DOMRawTouchData (Extensions) <DOMRawData>

- (NSDictionary *)postDictionary;

@end
