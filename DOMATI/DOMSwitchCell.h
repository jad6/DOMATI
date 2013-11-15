//
//  DOMSwitchCell.h
//  DOMATI
//
//  Created by Jad Osseiran on 11/11/2013.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DOMTableViewCell.h"

@interface DOMSwitchCell : DOMTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *switchInfoLabel;
@property (weak, nonatomic) IBOutlet UISwitch *cellSwitch;

@end
