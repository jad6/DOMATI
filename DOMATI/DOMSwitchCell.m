//
//  DOMSwitchCell.m
//  DOMATI
//
//  Created by Jad Osseiran on 11/11/2013.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import "DOMSwitchCell.h"

@implementation DOMSwitchCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSwitchInfoLabel:(UILabel *)switchInfoLabel
{
    if (_switchInfoLabel != switchInfoLabel) {
        _switchInfoLabel = switchInfoLabel;
        
        _switchInfoLabel.textColor = TEXT_COLOR;
    }
}

@end
