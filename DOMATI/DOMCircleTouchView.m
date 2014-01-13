//
//  DOMCircleTouchView.m
//  DOMATI
//
//  Created by Jad Osseiran on 18/11/2013.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import "DOMCircleTouchView.h"

static CGFloat kOuterCirclePadding = 1.0;

@implementation DOMCircleTouchView

#pragma mark - Public

- (id)initWithFrame:(CGRect)frame
circleTouchStrength:(DOMCircleTouchStrength)circleTouchStrength
{
    self = [super initWithFrame:frame];
    if (self) {
        self.circleTouchStrength = circleTouchStrength;
    }
    return self;
}

- (void)setCircleTouchStrength:(DOMCircleTouchStrength)circleTouchStrength
{
    if (_circleTouchStrength != circleTouchStrength) {
        _circleTouchStrength = circleTouchStrength;
        
        [self setNeedsDisplay];
    }
}

#pragma mark - Private

- (void)drawOuterCircle:(CGRect)rect inContext:(CGContextRef)ctx
{
    CGContextSetStrokeColor(ctx, CGColorGetComponents(DOMATI_COLOR.CGColor));

    CGRect outerCircle = CGRectMake(rect.origin.x + kOuterCirclePadding,
                                    rect.origin.y + kOuterCirclePadding,
                                    rect.size.width - (2 * kOuterCirclePadding),
                                    rect.size.height - (2 * kOuterCirclePadding));
    
    UIBezierPath *outerPath = [UIBezierPath bezierPathWithRoundedRect:outerCircle
                                                         cornerRadius:(outerCircle.size.width / 2.0)];
    [outerPath stroke];
}

- (void)drawInnerCircle:(CGRect)rect inContext:(CGContextRef)ctx
{
    CGFloat padding = (rect.size.width / 4.0) * self.circleTouchStrength;
    
    CGRect innerCircle = CGRectZero;
    innerCircle.size = CGSizeMake(rect.size.width - (kOuterCirclePadding + padding),
                                  rect.size.height - (kOuterCirclePadding + padding));
    innerCircle.origin = CGPointMake((rect.size.width - innerCircle.size.width) / 2.0,
                                     (rect.size.height - innerCircle.size.height) / 2.0);
    
    CGContextSetFillColor(ctx, CGColorGetComponents(DOMATI_COLOR.CGColor));
    CGContextAddEllipseInRect(ctx, innerCircle);
    CGContextFillPath(ctx);
}

- (void)drawRect:(CGRect)rect
{
    NSAssert(rect.size.width == rect.size.height, @"The given CGRect %@ is not a squre. You must provide a squre for a valid DOMCircleTouchView", NSStringFromCGRect(rect));
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClearRect(ctx, rect);
    [self drawOuterCircle:rect inContext:ctx];
    [self drawInnerCircle:rect inContext:ctx];
}

@end
