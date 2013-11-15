//
//  DOMGenderSwitchCell.m
//  DOMATI
//
//  Created by Jad Osseiran on 15/11/2013.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import "DOMGenderSwitchCell.h"

@implementation DOMGenderSwitchCell

@synthesize cellSwitch = _cellSwitch;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setCellSwitch:(UISwitch *)cellSwitch
{
    if (_cellSwitch != cellSwitch) {
        _cellSwitch = cellSwitch;
        
        _cellSwitch.tintColor = MALE_SWITCH_COLOR;
        _cellSwitch.onTintColor = FEMALE_SWITCH_COLOR;
    }
}

@end
