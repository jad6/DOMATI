//
//  DOMSegmentCell.m
//  DOMATI
//
//  Created by Jad Osseiran on 17/11/2013.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import "DOMSegmentCell.h"

@implementation DOMSegmentCell

@synthesize textLabel = _textLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    [self.contentView bringSubviewToFront:self.segmentedControl];
}

@end
