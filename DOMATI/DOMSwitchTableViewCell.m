//
//  DOMSwitchTableViewCell.m
//  DOMATI
//
//  Created by Jad Osseiran on 27/10/2013.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import "DOMSwitchTableViewCell.h"

@implementation DOMSwitchTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setTitleLabel:(UILabel *)titleLabel
{
    if (_titleLabel != titleLabel) {
        _titleLabel = titleLabel;
        
        _titleLabel.textColor = TEXT_COLOR;
    }
}

- (void)setCellSwitch:(UISwitch *)cellSwitch
{
    if (_cellSwitch != cellSwitch) {
        _cellSwitch = cellSwitch;
        
        _cellSwitch.onTintColor = DOMATI_COLOR;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
