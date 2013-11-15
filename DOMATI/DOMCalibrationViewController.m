//
//  DOMCalibrationViewController.m
//  DOMATI
//
//  Created by Jad Osseiran on 11/11/2013.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import "DOMCalibrationViewController.h"

#import "DOMYearsPickerHandler.h"

#import "DOMGenderSwitchCell.h"
#import "DOMPickerCell.h"

@interface DOMCalibrationViewController () <DOMYearsPickerHandlerDelegate>

@property (nonatomic, strong) DOMYearsPickerHandler *yearsPickerHandler;

@property (strong, nonatomic) UITableViewCell *birthYearCell;
@property (strong, nonatomic) NSIndexPath *visiblePickerIndexPath;

@property (nonatomic) BOOL showingPicker;

@end

static NSString *SwitchCellIdentifier = @"Switch Cell";
static NSString *DetailCellIdentifier = @"Detail Cell";
static NSString *PickerCellIdentifier = @"Picker Cell";

@implementation DOMCalibrationViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!self.pushedOnNavigation) {
        // TODO: Only show the button when the details have been filled.
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (UITableViewCell *)birthYearCell
{
    if (!_birthYearCell) {
        _birthYearCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    }
    
    return _birthYearCell;
}

#pragma mark - Actions

- (void)done:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view logic

- (void)insertPickerViewUnderCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    self.showingPicker = YES;
    self.birthYearCell.detailTextLabel.textColor = DOMATI_COLOR;
    
    self.visiblePickerIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
    
    [self.tableView insertRowsAtIndexPaths:@[self.visiblePickerIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    DOMPickerCell *pickerCell = (DOMPickerCell *)[self.tableView cellForRowAtIndexPath:self.visiblePickerIndexPath];
    pickerCell.picker.hidden = NO;

    self.yearsPickerHandler = [[DOMYearsPickerHandler alloc] initWithPicker:pickerCell.picker
                                                                   withYear:1990
                                                                   delegate:self];
    
    [self.tableView scrollToRowAtIndexPath:self.visiblePickerIndexPath
                          atScrollPosition:UITableViewScrollPositionMiddle
                                  animated:YES];
}

- (void)deleteVisiblePickerCell
{
    self.showingPicker = NO;
    self.birthYearCell.detailTextLabel.textColor = DETAIL_TEXT_COLOR;
    
    DOMPickerCell *cell = (DOMPickerCell *)[self.tableView cellForRowAtIndexPath:self.visiblePickerIndexPath];
    cell.picker.hidden = YES;
    
    [self.tableView deleteRowsAtIndexPaths:@[self.visiblePickerIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    self.visiblePickerIndexPath = nil;
}

#pragma mark - Picker Handler delegate

- (void)pickerView:(UIPickerView *)pickerView didChangeYear:(NSInteger)year;
{
    NSString *detailText = nil;
    if (year > 0) {
        detailText = [[NSString alloc] initWithFormat:@"%i", year];
    } else {
        detailText = [DOMYearsPickerHandler undisclosedYear];
    }
    
    self.birthYearCell.detailTextLabel.text = detailText;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return (self.showingPicker) ? 3 : 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 2:
            return 216.0;
            break;
            
        default:
            return 44.0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = nil;
    switch (indexPath.row) {
        case 0:
            CellIdentifier = SwitchCellIdentifier;
            break;
            
        case 1:
            CellIdentifier = DetailCellIdentifier;
            break;
            
        case 2:
            CellIdentifier = PickerCellIdentifier;
            break;
            
        default:
            break;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    switch (indexPath.row) {
        case 0: {
            DOMGenderSwitchCell *switchCell = (DOMGenderSwitchCell *)cell;
            switchCell.switchInfoLabel.text = @"Gender";
            
            return switchCell;
            break;
        }
            
        case 1: {
            cell.textLabel.text = @"Birth Year";
            cell.detailTextLabel.text = @"Select Year";
            return cell;
            break;
        }
            
        default:
            return cell;
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.reuseIdentifier isEqualToString:DetailCellIdentifier]) {
        if (self.visiblePickerIndexPath) {
            [self deleteVisiblePickerCell];
        } else {
            [self insertPickerViewUnderCell:cell atIndexPath:indexPath];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
