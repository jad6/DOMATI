//
//  DOMTextFieldCell.m
//  DOMATI
//
//  Created by Jad Osseiran on 31/01/2014.
//  Copyright (c) 2014 Jad. All rights reserved.
//

#import "DOMTextFieldCell.h"

@interface DOMTableViewCell () <UITextFieldDelegate>

@end

@implementation DOMTextFieldCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.textField.enabled = NO;
    self.textField.delegate = self;
    self.textField.keyboardType = UIKeyboardTypeDecimalPad;
    self.textField.textAlignment = NSTextAlignmentRight;
    self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.textField.placeholder attributes:@{NSForegroundColorAttributeName: DETAIL_TEXT_COLOR}];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Text Field Delegate 

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.textColor = DOMATI_COLOR;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    textField.textColor = DETAIL_TEXT_COLOR;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    NSLocale *locale = [NSLocale currentLocale];
    NSArray *rateComps = [newText componentsSeparatedByString:[locale objectForKey:NSLocaleDecimalSeparator]];
    if ([rateComps count] == 2) {
        return [[rateComps lastObject] length] <= 2;
    } else if ([rateComps count] > 2) {
        return NO;
    }
    
    return YES;
}

@end
