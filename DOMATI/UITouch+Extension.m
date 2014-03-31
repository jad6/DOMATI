//
//  UITouch+Extension.m
//  DOMATI
//
//  Created by Jad Osseiran on 2/11/2013.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import "UITouch+Extension.h"

@implementation UITouch (Extension)

- (CGFloat)radius
{
    CGFloat radius = 0.0;

    if (CGFLOAT_IS_DOUBLE)
    {
        radius = [[self valueForKey:@"pathMajorRadius"] doubleValue];
    }
    else
    {
        radius = [[self valueForKey:@"pathMajorRadius"] floatValue];
    }

    return radius;
}

@end
