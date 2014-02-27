//
//  DOMItem.h
//  DOMATI
//
//  Created by Jad Osseiran on 25/02/2014.
//  Copyright (c) 2014 Jad. All rights reserved.
//

#import "LLItem.h"

@class CMDeviceMotion;

@interface DOMItem : LLItem

@property (nonatomic, strong, readonly) CMDeviceMotion *deviceMotion;

- (id)initWithDeviceMotion:(CMDeviceMotion *)deviceMotion;

@end
