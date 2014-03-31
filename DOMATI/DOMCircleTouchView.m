//
//  DOMCircleTouchView.m
//  DOMATI
//
//  Created by Jad Osseiran on 18/11/2013.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import "DOMCircleTouchView.h"

static CGFloat kOuterCirclePadding = 1.0;

@interface DOMCircleTouchView ()

@property (nonatomic, strong) UILabel * titleLabel;

@property (nonatomic) CGRect innerCircleFrame;

@end

@implementation DOMCircleTouchView

#pragma mark - Public

- (id)initWithFrame:(CGRect)frame
    circleTouchStrength:(DOMCircleTouchStrength)circleTouchStrength
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
    NSString * title = nil;

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
    UILabel * titleLabel = self.titleLabel;

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
    CGContextSetStrokeColor(ctx, CGColorGetComponents(DOMATI_COLOR.CGColor));

    CGRect outerCircleFrame = CGRectMake(rect.origin.x + kOuterCirclePadding,
                                         rect.origin.y + kOuterCirclePadding,
                                         rect.size.width - (2 * kOuterCirclePadding),
                                         rect.size.height - (2 * kOuterCirclePadding));

    UIBezierPath * outerPath = [UIBezierPath bezierPathWithRoundedRect:outerCircleFrame
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

    CGContextSetFillColor(ctx, CGColorGetComponents(DOMATI_COLOR.CGColor));
    CGContextAddEllipseInRect(ctx, innerCircleFrame);
    CGContextFillPath(ctx);

    if (self.title == nil)
    {
        [self drawTitleLabelWithText:[self titleFromTouchStrength:self.circleTouchStrength]];
    }
}

@end
