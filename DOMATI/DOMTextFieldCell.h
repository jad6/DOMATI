//
//  DOMTextFieldCell.h
//  DOMATI
//
//  Created by Jad Osseiran on 31/01/2014.
//  Copyright (c) 2014 Jad. All rights reserved.
//

#import "DOMTableViewCell.h"

@interface DOMTextFieldCell : DOMTableViewCell

@property (nonatomic, weak) IBOutlet UILabel *textLabel;
@property (nonatomic, weak) IBOutlet UITextField *textField;

@end
