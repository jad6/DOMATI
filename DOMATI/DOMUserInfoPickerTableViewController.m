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
    NSIndexPath *pickerIndexPath = self.pickerIndexPath;
    
    // Get the cell above the picker.
    UITableViewCell *headerCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:(pickerIndexPath.row - 1) inSection:pickerIndexPath.section]];
    DOMPickerCell *pickerCell = (DOMPickerCell *)[self.tableView cellForRowAtIndexPath:pickerIndexPath];
    
    [self populatePicker:pickerCell.picker
             atIndexPath:pickerIndexPath
              headerCell:headerCell];
}

#pragma mark - Logic

/**
 *  Helper method to populate the detail text and handle the
 *  undisclosed option.
 *
 *  @param text        the text to set on the detail label.
 *  @param undisclosed flag which indicates wether the field should be undisclosed.
 */
- (void)setDetailText:(NSString *)text undisclosed:(BOOL)undisclosed
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.activeCellIndexPath];
    cell.detailTextLabel.text = (undisclosed) ? [DOMPickerHandler undisclosedValue] : text;
}

#pragma mark - Picker Handler

/**
 *  Gets the appropriate picker handler for a picker and populates it
 *  with the appropriate data.
 *
 *  @param picker     The picker to populate
 *  @param indexPath  The indexPath of the picker
 *  @param headerCell The cell above the picker.
 */
- (void)populatePicker:(UIPickerView *)picker
           atIndexPath:(NSIndexPath *)indexPath
            headerCell:(UITableViewCell *)headerCell
{
    DOMPickerHandler *currentHandler = nil;
    if (indexPath.section == 0 && indexPath.row == 2) {
        // Set the year from the possible existing detail value.
        NSInteger year = ([headerCell.detailTextLabel.text isEqualToString:[DOMPickerHandler undisclosedValue]]) ? 1990 : [DOMYearsPickerHandler yearForTitile:headerCell.detailTextLabel.text];
        
        DOMYearsPickerHandler *yearsHandler = [[DOMYearsPickerHandler alloc] init];
        [yearsHandler populatedPicker:picker
                      withInitialYear:year
                             delegate:self];
        
        currentHandler = yearsHandler;
    } else if (indexPath.section == 2) {
        // Set the profession from the possible existing detail value.
        NSString *initialProf = ([headerCell.detailTextLabel.text isEqualToString:[DOMPickerHandler undisclosedValue]]) ? nil : headerCell.detailTextLabel.text;
        
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
