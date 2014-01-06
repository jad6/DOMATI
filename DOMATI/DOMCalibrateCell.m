//
//  DOMCalibrateCell.m
//  DOMATI
//
//  Created by Jad Osseiran on 17/11/2013.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import "DOMCalibrateCell.h"

#import "DOMCircleTouchView.h"

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

- (void)changeCircleTouchStrength
{
    self.circleTouchView.circleTouchStrength = DOMCircleTouchStrengthHard;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    CGRect frame = CGRectMake((self.frame.size.width / 2.0) - kTouchCircleRadius,
                                  (self.frame.size.height / 2.0) - kTouchCircleRadius,
                                  kTouchCircleRadius * 2.0, kTouchCircleRadius * 2.0);
    
    self.circleTouchView = [[DOMCircleTouchView alloc] initWithFrame:frame
                                                 circleTouchStrength:DOMCircleTouchStrengthSoft];
    [self addSubview:self.circleTouchView];

    [self performSelector:@selector(changeCircleTouchStrength) withObject:Nil afterDelay:2.0];
}

@end
