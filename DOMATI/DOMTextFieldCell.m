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

@synthesize textLabel = _textLabel;

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.textField.enabled = NO;
    self.textField.delegate = self;
    self.textField.keyboardType = UIKeyboardTypeDecimalPad;
    self.textField.textAlignment = NSTextAlignmentRight;
    self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.textField.placeholder attributes:@{ NSForegroundColorAttributeName: DETAIL_TEXT_COLOR }];
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

    if ([self.delegate respondsToSelector:@selector(textFieldDidEndEditing:withCellType:)])
    {
        [self.delegate textFieldDidEndEditing:self.textField withCellType:self.type];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // Allow backspace
    if ([string length] == 0)
    {
        return YES;
    }

    // The text is empty, return NO.
    if ([textField.text length] > 8)
    {
        return NO;
    }

    // Make sure you get the right local for the decimal separator.
    NSLocale * locale = [NSLocale currentLocale];
    NSString * decimalSeparator = [locale objectForKey:NSLocaleDecimalSeparator];

    // Do not allow decimalSeparator at the beggining
    if (range.location == 0 && [string isEqualToString:decimalSeparator])
    {
        return NO;
    }

    // Create the valid character set in this case numbers and the
    // decimal separator.
    NSMutableCharacterSet * validCharacterSet = [[NSMutableCharacterSet alloc] init];
    [validCharacterSet formUnionWithCharacterSet:[NSCharacterSet decimalDigitCharacterSet]];
    [validCharacterSet addCharactersInString:decimalSeparator];

    // If there are no legal characters found return NO.
    if ([string rangeOfCharacterFromSet:validCharacterSet].location == NSNotFound)
    {
        return NO;
    }

    // Make sure we always keep the numbers to two decimal places.
    NSString * newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSArray * comps = [newText componentsSeparatedByString:decimalSeparator];
    if ([comps count] == 2)
    {
        return [[comps lastObject] length] <= 2;
    }
    else if ([comps count] > 2)
    {
        return NO;
    }

    return YES;
}

@end
