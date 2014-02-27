//
//  DOMItem.m
//  DOMATI
//
//  Created by Jad Osseiran on 25/02/2014.
//  Copyright (c) 2014 Jad. All rights reserved.
//

#import <CoreMotion/CMDeviceMotion.h>

#import "DOMItem.h"

@implementation DOMItem

- (id)initWithDeviceMotion:(CMDeviceMotion *)deviceMotion
{
    self = [super init];
    if (self) {
        self->_deviceMotion = deviceMotion;
    }
    return self;
}

@end
