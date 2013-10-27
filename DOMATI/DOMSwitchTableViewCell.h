//
//  DOMSwitchTableViewCell.h
//  DOMATI
//
//  Created by Jad Osseiran on 27/10/2013.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DOMTableViewCell.h"

@interface DOMSwitchTableViewCell : DOMTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UISwitch *cellSwitch;

@end
