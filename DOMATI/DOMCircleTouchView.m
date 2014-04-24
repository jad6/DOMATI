//
//  DOMCircleTouchView.m
//  DOMATI
//
//  Created by Jad Osseiran on 18/11/2013.
//  Copyright (c) 2013 Jad. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer. Redistributions in binary
//  form must reproduce the above copyright notice, this list of conditions and
//  the following disclaimer in the documentation and/or other materials
//  provided with the distribution. Neither the name of the nor the names of
//  its contributors may be used to endorse or promote products derived from
//  this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.

#import "DOMCircleTouchView.h"

static CGFloat kOuterCirclePadding = 1.0;

@interface DOMCircleTouchView ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic) CGRect innerCircleFrame;

@end

@implementation DOMCircleTouchView

#pragma mark - Public

- (id)initWithFrame:(CGRect)frame circleTouchStrength:(DOMCircleTouchStrength)circleTouchStrength
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.circleTouchStrength = circleTouchStrength;
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.multipleTouchEnabled = NO;
}

- (void)drawRect:(CGRect)rect
{
    NSAssert(rect.size.width == rect.size.height, @"The given CGRect %@ is not a square. You must provide a squre for a valid DOMCircleTouchView", NSStringFromCGRect(rect));

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClearRect(ctx, rect);

    [self drawOuterCircle:rect inContext:ctx];
    [self drawInnerCircle:rect inContext:ctx];
}

- (void)setCircleTouchStrength:(DOMCircleTouchStrength)circleTouchStrength
{
    if (self->_circleTouchStrength != circleTouchStrength)
    {
        self->_circleTouchStrength = circleTouchStrength;
    }

    [UIView animateWithDuration:0.3 animations:^{
         [self setNeedsDisplay];
     }];
}

- (void)setTitle:(NSString *)title
{
    if (self->_title != title)
    {
        self->_title = title;

        [self drawTitleLabelWithText:title];
    }
}

#pragma mark - Logic

- (NSString *)titleFromTouchStrength:(DOMCircleTouchStrength)touchStrength
{
    NSString *title = nil;

    switch (touchStrength)
    {
        case DOMCircleTouchStrengthSoft:
            title = @"Soft";
            break;

        case DOMCircleTouchStrengthModerate:
            title = @"Normal";
            break;

        case DOMCircleTouchStrengthHard:
            title = @"Hard";
            break;

        case DOMCircleTouchStrengthNone:
            title = nil;
            break;
    }

    return title;
}

#pragma mark - Private

- (void)drawTitleLabelWithText:(NSString *)text
{
    UILabel *titleLabel = self.titleLabel;

    if (!titleLabel)
    {
        titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17.0];
        [self addSubview:titleLabel];
    }

    titleLabel.text = text;
    CGRect titleLabelFrame = titleLabel.frame;
    titleLabelFrame.size = [titleLabel sizeThatFits:CGSizeZero];
    titleLabelFrame.origin.x = self.innerCircleFrame.origin.x + (self.innerCircleFrame.size.width / 2.0) - (titleLabelFrame.size.width / 2.0);
    titleLabelFrame.origin.y = self.innerCircleFrame.origin.y + (self.innerCircleFrame.size.height / 2.0) - (titleLabelFrame.size.height / 2.0);
    titleLabel.frame = titleLabelFrame;

    self.titleLabel = titleLabel;
}

- (void)drawOuterCircle:(CGRect)rect inContext:(CGContextRef)ctx
{
    CGContextSetStrokeColor(ctx, CGColorGetComponents([UIColor domatiColor].CGColor));

    CGRect outerCircleFrame = CGRectMake(rect.origin.x + kOuterCirclePadding,
                                         rect.origin.y + kOuterCirclePadding,
                                         rect.size.width - (2 * kOuterCirclePadding),
                                         rect.size.height - (2 * kOuterCirclePadding));

    UIBezierPath *outerPath = [UIBezierPath bezierPathWithRoundedRect:outerCircleFrame
                                                         cornerRadius:(outerCircleFrame.size.width / 2.0)];
    [outerPath stroke];
}

- (void)drawInnerCircle:(CGRect)rect inContext:(CGContextRef)ctx
{
    CGFloat padding = (rect.size.width / 5.0) * self.circleTouchStrength;

    CGRect innerCircleFrame = CGRectZero;

    innerCircleFrame.size = CGSizeMake(rect.size.width - (kOuterCirclePadding + padding),
                                       rect.size.height - (kOuterCirclePadding + padding));
    innerCircleFrame.origin = CGPointMake((rect.size.width - innerCircleFrame.size.width) / 2.0,
                                          (rect.size.height - innerCircleFrame.size.height) / 2.0);

    self.innerCircleFrame = innerCircleFrame;

    CGContextSetFillColor(ctx, CGColorGetComponents([UIColor domatiColor].CGColor));
    CGContextAddEllipseInRect(ctx, innerCircleFrame);
    CGContextFillPath(ctx);

    if (self.title == nil)
    {
        [self drawTitleLabelWithText:[self titleFromTouchStrength:self.circleTouchStrength]];
    }
}

@end
