//
//  DOMItem.h
//  DOMATI
//
//  Created by Jad Osseiran on 25/02/2014.
//  Copyright (c) 2014 Jad. All rights reserved.
//

#import "LLItem.h"

@class CMDeviceMotion;

@interface DOMMotionItem : LLItem

@property (nonatomic, strong, readonly) CMDeviceMotion * deviceMotion;

@property (nonatomic) NSTimeInterval timestamp;

- (id)initWithDeviceMotion:(CMDeviceMotion *)deviceMotion;

@end
