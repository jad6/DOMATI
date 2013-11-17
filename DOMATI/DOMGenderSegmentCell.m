//
//  DOMGenderSegmentCell.m
//  DOMATI
//
//  Created by Jad Osseiran on 17/11/2013.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import "DOMGenderSegmentCell.h"

@implementation DOMGenderSegmentCell

@synthesize segmentedControl = _segmentedControl;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (IBAction)setGender:(UISegmentedControl *)segmentedControl
{
    self.selectedGender = segmentedControl.selectedSegmentIndex;
}

@end
