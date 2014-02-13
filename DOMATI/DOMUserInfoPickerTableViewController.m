//
//  DOMUserInfoPickerTableViewController.m
//  DOMATI
//
//  Created by Jad Osseiran on 13/02/2014.
//  Copyright (c) 2014 Jad. All rights reserved.
//

#import "DOMUserInfoPickerTableViewController.h"

#import "DOMPickerCell.h"

@interface DOMUserInfoPickerTableViewController ()

@property (nonatomic, strong) DOMPickerHandler *currentPickerHandler;

@end

@implementation DOMUserInfoPickerTableViewController

- (Class)pickerCellClass
{
    return [DOMPickerCell class];
}

- (void)reloadPicker
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:(self.pickerIndexPath.row - 1) inSection:self.pickerIndexPath.section]];
    DOMPickerCell *pickerCell = (DOMPickerCell *)[self.tableView cellForRowAtIndexPath:self.pickerIndexPath];
    
    [self populatePicker:pickerCell.picker
             atIndexPath:self.pickerIndexPath
                    cell:cell];
}

#pragma mark - Logic

- (void)setDetailText:(NSString *)text undisclosed:(BOOL)undisclosed
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.activeCellIndexPath];
    cell.detailTextLabel.text = (undisclosed) ? [DOMPickerHandler undisclosedValue] : text;
}

#pragma mark - Picker Handler

- (void)populatePicker:(UIPickerView *)picker
           atIndexPath:(NSIndexPath *)indexPath
                  cell:(UITableViewCell *)cell
{
    DOMPickerHandler *currentHandler = nil;
    if (indexPath.section == 0 && indexPath.row == 2) {
        NSInteger year = ([cell.detailTextLabel.text isEqualToString:[DOMPickerHandler undisclosedValue]]) ? 1990 : [DOMYearsPickerHandler yearForTitile:cell.detailTextLabel.text];
        
        DOMYearsPickerHandler *yearsHandler = [[DOMYearsPickerHandler alloc] init];
        [yearsHandler populatedPicker:picker
                      withInitialYear:year
                             delegate:self];
        
        currentHandler = yearsHandler;
    } else if (indexPath.section == 2) {
        NSString *initialProf = ([cell.detailTextLabel.text isEqualToString:[DOMPickerHandler undisclosedValue]]) ? nil : cell.detailTextLabel.text;
        
        DOMProfessionPickerHandler *professionHandler = [[DOMProfessionPickerHandler alloc] init];
        [professionHandler populatedPicker:picker
                     withInitialProfession:initialProf
                                  delegate:self];
        
        currentHandler = professionHandler;
    }
    
    self.currentPickerHandler = currentHandler;
}

#pragma mark - Information Delegate

- (void)pickerView:(UIPickerView *)pickerView didChangeYear:(NSInteger)year;
{
    BOOL undisclosed = (year <= 0);
    
    [self setDetailText:[DOMYearsPickerHandler titleForYear:year]
            undisclosed:undisclosed];
    
    self.user.birthYear = year;
}

- (void)pickerView:(UIPickerView *)pickerView didChangeProfession:(NSString *)profession
{
    BOOL undisclosed = (profession == nil);
    
    [self setDetailText:profession
            undisclosed:undisclosed];
    
    self.user.profession = profession;
}

- (void)textFieldDidEndEditing:(UITextField *)textField withCellType:(DOMTextFieldCellType)type
{
    CGFloat value = (CGFLOAT_IS_DOUBLE) ? [textField.text doubleValue] : [textField.text floatValue];
    
    switch (type) {
        case DOMTextFieldCellTypeHeight:
            self.user.height = value;
            break;
            
        case DOMTextFieldCellTypeWeight:
            self.user.weight = value;
            break;
            
        default:
            break;
    }
}

- (void)segmentedControl:(UISegmentedControl *)segmentedControl didChangeGender:(DOMGender)gender
{
    self.user.gender = gender;
}

@end
