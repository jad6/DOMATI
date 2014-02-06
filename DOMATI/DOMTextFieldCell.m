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

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.textColor = DOMATI_COLOR;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    textField.textColor = DETAIL_TEXT_COLOR;
    
    if ([self.delegate respondsToSelector:@selector(textFieldDidEndEditing:withCellType:)]) {
        [self.delegate textFieldDidEndEditing:self.textField withCellType:self.type];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // Allow backspace
    if ([string length] == 0) {
        return YES;
    }
    
    if ([textField.text length] > 8) {
        return NO;
    }
    
    NSLocale *locale = [NSLocale currentLocale];
    NSString *decimalSeparator = [locale objectForKey:NSLocaleDecimalSeparator];
    
    // Do not allow decimalSeparator at the beggining
    if (range.location == 0 && [string isEqualToString:decimalSeparator]) {
        return NO;
    }
    
    NSMutableCharacterSet *validCharacterSet = [[NSMutableCharacterSet alloc] init];
    [validCharacterSet formUnionWithCharacterSet:[NSCharacterSet decimalDigitCharacterSet]];
    [validCharacterSet addCharactersInString:decimalSeparator];
    
    if ([string rangeOfCharacterFromSet:validCharacterSet].location == NSNotFound) {
        return NO;
    }
    
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSArray *comps = [newText componentsSeparatedByString:decimalSeparator];
    if ([comps count] == 2) {
        return [[comps lastObject] length] <= 2;
    } else if ([comps count] > 2) {
        return NO;
    }
    
    return YES;
}

@end
