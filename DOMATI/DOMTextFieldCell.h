//
//  DOMTextFieldCell.h
//  DOMATI
//
//  Created by Jad Osseiran on 31/01/2014.
//  Copyright (c) 2014 Jad. All rights reserved.
//

#import "DOMTableViewCell.h"

typedef NS_ENUM (NSInteger, DOMTextFieldCellType) {
    DOMTextFieldCellTypeNone,
    DOMTextFieldCellTypeHeight,
    DOMTextFieldCellTypeWeight
};

@protocol DOMTextFieldCellDelegate <NSObject>

@optional
/**
 *  The textfield of a particular type has started editing.
 *
 *  @param textField The editing textfield.
 *  @param type      The type of the textField.
 */
- (void)textFieldDidEndEditing:(UITextField *)textField withCellType:(DOMTextFieldCellType)type;

@end

@interface DOMTextFieldCell : DOMTableViewCell

@property (nonatomic, weak) id<DOMTextFieldCellDelegate> delegate;

@property (nonatomic, weak) IBOutlet UILabel *textLabel;
@property (nonatomic, weak) IBOutlet UITextField *textField;

@property (nonatomic) DOMTextFieldCellType type;

@end
