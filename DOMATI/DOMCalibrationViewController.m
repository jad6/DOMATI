//
//  DOMCalibrationViewController.m
//  DOMATI
//
//  Created by Jad Osseiran on 11/11/2013.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import "DOMCalibrationViewController.h"

#import "DOMYearsPickerHandler.h"

#import "DOMGenderSegmentCell.h"
#import "DOMPickerCell.h"
#import "DOMCalibrateCell.h"

@interface DOMCalibrationViewController () <DOMYearsPickerHandlerDelegate>

@property (nonatomic, strong) DOMYearsPickerHandler *yearsPickerHandler;

@property (strong, nonatomic) UITableViewCell *birthYearCell;
@property (strong, nonatomic) NSIndexPath *visiblePickerIndexPath;

@property (nonatomic) BOOL showingPicker;

@end

static NSString *GenderCellIdentifier = @"Gender Cell";
static NSString *AgeCellIdentifier = @"Age Cell";
static NSString *PickerCellIdentifier = @"Picker Cell";
static NSString *CalibrateCellIdentifier = @"Calibrate Cell";

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
    
    self.navigationController.toolbarHidden = YES;
    
    if (self.showDoneBarButton) {
        [self showDoneButtonWithTitle:@"Done" animated:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (UITableViewCell *)birthYearCell
{
    if (!_birthYearCell) {
        _birthYearCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    }
    
    return _birthYearCell;
}

#pragma mark - Actions

- (void)done:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Logic

- (void)hideDoneButtonAnimated:(BOOL)animated
{
    [self.navigationItem setRightBarButtonItem:nil animated:animated];
}

- (void)showDoneButtonWithTitle:(NSString *)title animated:(BOOL)animated
{
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleDone target:self action:@selector(done:)] animated:animated];
}

- (id)setupCell:(UITableViewCell *)cell withIdentider:(NSString *)CellIdentifier
{
    if ([CellIdentifier isEqualToString:GenderCellIdentifier]) {
        DOMGenderSegmentCell *genderCell = (DOMGenderSegmentCell *)cell;
        genderCell.titleLabel.text = @"Gender";
        
        return genderCell;
    } else if ([CellIdentifier isEqualToString:AgeCellIdentifier]) {
        cell.textLabel.text = @"Birth Year";
        cell.detailTextLabel.text = @"Undisclosed";
    }
    
    return cell;
}

#pragma mark - Table view logic

- (void)insertPickerViewUnderCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    self.showingPicker = YES;
    self.birthYearCell.detailTextLabel.textColor = DOMATI_COLOR;
    
    self.visiblePickerIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
    
    [self.tableView insertRowsAtIndexPaths:@[self.visiblePickerIndexPath] withRowAnimation:UITableViewRowAnimationTop];
    
    DOMPickerCell *yearPickerCell = (DOMPickerCell *)[self.tableView cellForRowAtIndexPath:self.visiblePickerIndexPath];
    self.yearsPickerHandler = [[DOMYearsPickerHandler alloc] initWithPicker:yearPickerCell.picker
                                                                   withYear:1990
                                                                   delegate:self];
    yearPickerCell.picker.hidden = NO;
    
    [self.tableView scrollToRowAtIndexPath:self.visiblePickerIndexPath
                          atScrollPosition:UITableViewScrollPositionMiddle
                                  animated:YES];
}

- (void)deleteVisiblePickerCell
{
    self.showingPicker = NO;
    self.birthYearCell.detailTextLabel.textColor = DETAIL_TEXT_COLOR;
    
    DOMPickerCell *yearPickerCell = (DOMPickerCell *)[self.tableView cellForRowAtIndexPath:self.visiblePickerIndexPath];
    yearPickerCell.picker.hidden = YES;
    
    [self.tableView deleteRowsAtIndexPaths:@[self.visiblePickerIndexPath] withRowAnimation:UITableViewRowAnimationTop];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return (self.showingPicker) ? 3 : 2;
            break;
            
        default:
            return 1;
            break;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Personal Information";
            break;
            
        case 1:
            return @"Touch Calibration";
            break;
            
        default:
            return nil;
            break;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"The data collected above will be used to better understand the collected data. Whilst not compulsary, it would be fantastic if you could enter your details.";
            break;
            
        default:
            return nil;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return (IPAD) ? 308.0 : 220.0;
    }
    
    switch (indexPath.row) {
        case 1:
            if (self.showingPicker) {
                return 216.0;
            } else {
                return (IPAD) ? 44.0 : 88.0;
            }
            break;
            
        case 2:
            return (IPAD) ? 44.0 : 88.0;
            break;
            
        default:
            return 44.0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = nil;

    if (indexPath.section == 1) {
        CellIdentifier = CalibrateCellIdentifier;
    } else {
        switch (indexPath.row) {
            case 0:
                CellIdentifier = AgeCellIdentifier;
                break;
                
            case 1:
                CellIdentifier = (self.showingPicker) ? PickerCellIdentifier : GenderCellIdentifier;
                break;
                
            case 2:
                CellIdentifier = GenderCellIdentifier;
                break;
                
            default:
                break;
        }
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    return [self setupCell:cell withIdentider:CellIdentifier];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.reuseIdentifier isEqualToString:AgeCellIdentifier]) {
        if (self.visiblePickerIndexPath) {
            [self deleteVisiblePickerCell];
        } else {
            [self insertPickerViewUnderCell:cell atIndexPath:indexPath];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell.reuseIdentifier isEqualToString:CalibrateCellIdentifier]) {
        cell.backgroundColor = [UIColor blackColor];
    }
}

@end
