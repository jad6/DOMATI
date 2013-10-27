//
//  DOMFingerCell.m
//  DOMATI
//
//  Created by Jad Osseiran on 13/08/13.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import "DOMFingerCell.h"

@implementation DOMFingerCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setTitleLabel:(UILabel *)titleLabel
{
    if (_titleLabel != titleLabel) {
        _titleLabel = titleLabel;
        
        _titleLabel.textColor = DOMATI_COLOR;
    }
}

@end
