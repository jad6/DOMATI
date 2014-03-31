//
//  DOMTableViewCell.m
//  DOMATI
//
//  Created by Jad Osseiran on 27/10/2013.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import "DOMTableViewCell.h"

@implementation DOMTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    UIView *backgroundView = [[UIView alloc] initWithFrame:self.frame];
    backgroundView.backgroundColor = SELECTION_COLOR;
    self.selectedBackgroundView = backgroundView;

    self.textLabel.textColor = TEXT_COLOR;
    self.detailTextLabel.textColor = DETAIL_TEXT_COLOR;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
