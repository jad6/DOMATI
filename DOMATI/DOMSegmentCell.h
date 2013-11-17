//
//  DOMSegmentCell.h
//  DOMATI
//
//  Created by Jad Osseiran on 17/11/2013.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DOMTableViewCell.h"

@interface DOMSegmentCell : DOMTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@end
