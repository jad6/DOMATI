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
    return [[self valueForKey:@"pathMajorRadius"] floatValue];
}

@end
