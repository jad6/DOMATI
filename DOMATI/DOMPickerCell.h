//
//  DOMPickerCell.h
//  DOMATI
//
//  Created by Jad Osseiran on 11/11/2013.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DOMTableViewCell.h"

@interface DOMPickerCell : DOMTableViewCell

@property (weak, nonatomic) IBOutlet UIPickerView * picker;

@end
