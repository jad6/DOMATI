//
//  DOMCalibrateCell.m
//  DOMATI
//
//  Created by Jad Osseiran on 17/11/2013.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import "DOMCalibrateCell.h"

#import "DOMCircleTouchView.h"

#import "DOMStrengthGestureRecognizer.h"

@interface DOMCalibrateCell ()

@property (strong, nonatomic) DOMCircleTouchView *circleTouchView;

@end

static CGFloat kTouchCircleRadius = 44.0;

@implementation DOMCalibrateCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (void)changeCircleTouchStrengthHard
{
    self.circleTouchView.circleTouchStrength = DOMCircleTouchStrengthHard;
    
    [self performSelector:@selector(changeCircleTouchStrengthMed) withObject:nil afterDelay:2.0];
}

- (void)changeCircleTouchStrengthSoft
{
    self.circleTouchView.circleTouchStrength = DOMCircleTouchStrengthSoft;
    
    [self performSelector:@selector(changeCircleTouchStrengthHard) withObject:nil afterDelay:2.0];
}

- (void)changeCircleTouchStrengthMed
{
    self.circleTouchView.circleTouchStrength = DOMCircleTouchStrengthModerate;
    
    [self performSelector:@selector(changeCircleTouchStrengthSoft) withObject:nil afterDelay:2.0];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    CGRect frame = CGRectMake((self.frame.size.width / 2.0) - kTouchCircleRadius,
                                  (self.frame.size.height / 2.0) - kTouchCircleRadius,
                                  kTouchCircleRadius * 2.0, kTouchCircleRadius * 2.0);
    
    DOMCircleTouchView *circleTouchView = [[DOMCircleTouchView alloc] initWithFrame:frame
                                                 circleTouchStrength:DOMCircleTouchStrengthModerate];
    DOMStrengthGestureRecognizer *strengthGR = [[DOMStrengthGestureRecognizer alloc] initWithTarget:self action:@selector(strengthDetected:)];
    
    [circleTouchView addGestureRecognizer:strengthGR];
    [self addSubview:circleTouchView];
    
    self.circleTouchView = circleTouchView;

    [self performSelector:@selector(changeCircleTouchStrengthSoft) withObject:nil afterDelay:2.0];
}

#pragma mark - Actions

- (void)strengthDetected:(DOMStrengthGestureRecognizer *)strnegthGR
{
    
}

@end
