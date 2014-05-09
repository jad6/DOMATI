//
//  DOMItem.m
//  DOMATI
//
//  Created by Jad Osseiran on 25/02/2014.
//  Copyright (c) 2014 Jad. All rights reserved.
//

#import <CoreMotion/CMDeviceMotion.h>

#import "DOMMotionItem.h"

@interface DOMMotionItem ()

@property (nonatomic, strong) CMDeviceMotion *deviceMotion;

@end

@implementation DOMMotionItem

- (instancetype)initWithDeviceMotion:(CMDeviceMotion *)deviceMotion
{
    self = [super init];
    if (self)
    {
        self.deviceMotion = deviceMotion;
        self.timestamp = deviceMotion.timestamp;
    }
    return self;
}

@end
