//
//  DOMUserInfoViewController.m
//  DOMATI
//
//  Created by Jad Osseiran on 11/11/2013.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import "DOMUserInfoViewController.h"

#import "DOMYearsPickerHandler.h"
#import "DOMExperiencePickerHandler.h"
#import "DOMProfessionPickerHandler.h"

#import "DOMGenderSegmentCell.h"
#import "DOMPickerCell.h"
#import "DOMTextFieldCell.h"

@interface DOMUserInfoViewController () <DOMYearsPickerHandlerDelegate, DOMExperiencePickerHandlerDelegate, DOMProfessionPickerHandlerDelegate>

@property (nonatomic, strong) UILabel *pickerLabel;
@property (nonatomic, strong) NSIndexPath *visiblePickerIndexPath;
@property (nonatomic, strong) DOMPickerHandler *currentPickerHandler;
@property (nonatomic, strong) id currentFirstResponder;

@end

static NSString *SegmentCellIdentifier = @"Segment Cell";
static NSString *DetailCellIdentifier = @"Detail Cell";
static NSString *TextFieldCellIdentifier = @"Text Field Cell";
static NSString *PickerCellIdentifier = @"Picker Cell";

@implementation DOMUserInfoViewController

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

#pragma mark - Actions

- (void)done:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Logic

- (BOOL)resignCurrentResponder
{
    BOOL success = NO;
    
    success = [self.currentFirstResponder resignFirstResponder];
    
    if (success) {
        if ([self.currentFirstResponder respondsToSelector:@selector(setEnabled:)]) {
            [self.currentFirstResponder setEnabled:NO];
        }
        
        self.currentFirstResponder = nil;
    }
    
    return success;
}

- (void)hideDoneButtonAnimated:(BOOL)animated
{
    [self.navigationItem setRightBarButtonItem:nil animated:animated];
}

- (void)showDoneButtonWithTitle:(NSString *)title animated:(BOOL)animated
{
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleDone target:self action:@selector(done:)] animated:animated];
}

- (void)populatePicker:(UIPickerView *)picker
           atIndexPath:(NSIndexPath *)indexPath
                  cell:(UITableViewCell *)cell
{
    DOMPickerHandler *currentHandler = nil;
    if (indexPath.section == 0 && indexPath.row == 1) {
        NSInteger year = ([cell.detailTextLabel.text isEqualToString:[DOMPickerHandler undisclosedValue]]) ? 1990 : [DOMYearsPickerHandler yearForTitile:cell.detailTextLabel.text];
        
        DOMYearsPickerHandler *yearsHandler = [[DOMYearsPickerHandler alloc] init];
        [yearsHandler populatedPicker:picker
                      withInitialYear:year
                             delegate:self];
        
        currentHandler = yearsHandler;
    } else if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0: {
                NSString *initialProf = ([cell.detailTextLabel.text isEqualToString:[DOMPickerHandler undisclosedValue]]) ? nil : cell.detailTextLabel.text;
                
                DOMProfessionPickerHandler *professionHandler = [[DOMProfessionPickerHandler alloc] init];
                [professionHandler populatedPicker:picker
                             withInitialProfession:initialProf
                                          delegate:self];
                
                currentHandler = professionHandler;
                break;
            }
                
            case 1: {
                DOMTechnologyExperience techExp = [DOMExperiencePickerHandler techExpForTitle:cell.detailTextLabel.text];
                
                DOMExperiencePickerHandler *expHandler = [[DOMExperiencePickerHandler alloc] init];
                [expHandler populatedPicker:picker
                                withTechExp:techExp
                                   delegate:self];
                
                currentHandler = expHandler;
                break;
            }
        }
    }
    
    self.currentPickerHandler = currentHandler;
}

- (void)setDetailText:(NSString *)text undisclosed:(BOOL)undisclosed
{
    self.pickerLabel.text = (undisclosed) ? [DOMPickerHandler undisclosedValue] : text;
}

/**
 * This makes the table look like so:
 *
 *  GENDER
 *  AGE
 *  ------
 *  WEIGHT
 *  HEIGHT
 *  ------
 *  PROFESSION
 *  TECHEXP
 *
 *  @param cell      cell description
 *  @param indexPath indexPath description
 */
- (void)setupCell:(UITableViewCell *)cell
     forIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath isEqual:self.visiblePickerIndexPath]) {
        return;
    }
    
    NSString *text = nil;
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    text = @"Gender";
                    break;
                    
                case 1:
                    text = @"Birth Year";
                    break;
            }
            break;
            
        case 1:
            switch (indexPath.row) {
                case 0:
                    text = @"Height (cm)";
                    break;
                    
                case 1:
                    text = @"Weight (kg)";
                    break;
                }
            break;
            
        case 2:
            switch (indexPath.row) {
                case 0:
                    text = @"Profession";
                    break;
                    
                case 1:
                case 2:
                    text = @"Tech Experience";
                    break;
            }
            break;
    }
    
    cell.textLabel.text = text;
    cell.detailTextLabel.text = @"Undisclosed";
}

- (NSString *)cellIdentiferForIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = nil;
    
    if ([indexPath isEqual:self.visiblePickerIndexPath]) {
        CellIdentifier = PickerCellIdentifier;
    } else if (indexPath.section == 0 && indexPath.row == 0) {
        CellIdentifier = SegmentCellIdentifier;
    } else if (indexPath.section == 1) {
        CellIdentifier = TextFieldCellIdentifier;
    } else {
        CellIdentifier = DetailCellIdentifier;
    }

    return CellIdentifier;
}

#pragma mark - Table view logic

- (void)insertPickerViewUnderCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    [self resignCurrentResponder];
    
    self.pickerLabel.textColor = DOMATI_COLOR;
    
    self.visiblePickerIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
    
    [self.tableView insertRowsAtIndexPaths:@[self.visiblePickerIndexPath] withRowAnimation:UITableViewRowAnimationTop];
    
    DOMPickerCell *pickerCell = (DOMPickerCell *)[self.tableView cellForRowAtIndexPath:self.visiblePickerIndexPath];
    
    [self populatePicker:pickerCell.picker atIndexPath:indexPath cell:cell];
    
    [self.tableView scrollToRowAtIndexPath:indexPath
                          atScrollPosition:UITableViewScrollPositionMiddle
                                  animated:YES];
}

- (void)deleteVisiblePickerCell
{
    self.pickerLabel.textColor = DETAIL_TEXT_COLOR;
    
    NSIndexPath *indexPathToDelete = [self.visiblePickerIndexPath copy];
    self.visiblePickerIndexPath = nil;
    
    [self.tableView deleteRowsAtIndexPaths:@[indexPathToDelete] withRowAnimation:UITableViewRowAnimationTop];
    
    self.currentPickerHandler = nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    BOOL pickerInSection = (self.visiblePickerIndexPath &&
                            self.visiblePickerIndexPath.section == section);
    
    switch (section) {
        case 0:
            return (pickerInSection) ? 3 : 2;
            break;

        case 1:
            return 2;
            break;
            
        case 2:
            return (pickerInSection) ? 3 : 2;
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
            return @"Personal Info";
            break;
            
        case 1:
            return @"Physical Info";
            break;
            
        case 2:
            return @"Other";
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
            return @"A correlation with age, gender and the preception of a touch's strength will be extrememly useful in identifying more precise calibration groups. This data is stored anonymously.";
            break;
            
        case 1:
            return @"The physical attibutes of a person can also affect their preception of a touch's strength. Again, this data is stored anonymously.";
            break;
            
        case 2:
            return @"This section allows for extra data to be collected and might assist in creating more tailored calibration groups in future versions of the app. Once again, this data is stored anonymously.";
            break;
            
        default:
            return nil;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.visiblePickerIndexPath isEqual:indexPath]) {
        return 216.0;
    } else if (indexPath.section == 0 && indexPath.row == 0) {
        return 88.0;
    } else {
        return 44.0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = nil;
    CellIdentifier = [self cellIdentiferForIndexPath:indexPath];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [self setupCell:cell forIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.reuseIdentifier isEqualToString:DetailCellIdentifier]) {
        if (self.visiblePickerIndexPath) {
            [self deleteVisiblePickerCell];
        } else {
            self.pickerLabel = cell.detailTextLabel;
            [self insertPickerViewUnderCell:cell atIndexPath:indexPath];
        }
    } else if ([cell.reuseIdentifier isEqualToString:TextFieldCellIdentifier]) {
        if (self.visiblePickerIndexPath) {
            [self deleteVisiblePickerCell];
        }
        
        DOMTextFieldCell *textFieldCell = (DOMTextFieldCell *)cell;
        textFieldCell.textField.enabled = YES;
        if (self.currentFirstResponder && [self.currentFirstResponder respondsToSelector:@selector(setEnabled:)]) {
            [self.currentFirstResponder setEnabled:NO];
        }
        
        [textFieldCell.textField becomeFirstResponder];
        self.currentFirstResponder = textFieldCell.textField;
        
        [tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![cell.reuseIdentifier isEqualToString:DetailCellIdentifier]) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
}

#pragma mark - Scroll View

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{    
    [self resignCurrentResponder];
}

#pragma mark - Picker Handlers Delegate

- (void)pickerView:(UIPickerView *)pickerView didChangeYear:(NSInteger)year;
{
    [self setDetailText:[DOMYearsPickerHandler titleForYear:year]
            undisclosed:(year <= 0)];
}

- (void)pickerView:(UIPickerView *)pickerView didChangeExperience:(DOMTechnologyExperience)techExp
{
    [self setDetailText:[DOMExperiencePickerHandler titleForTechExp:techExp]
            undisclosed:techExp == DOMTechnologyExperienceUndisclosed];
}

- (void)pickerView:(UIPickerView *)pickerView didChangeProfession:(NSString *)profession
{
    [self setDetailText:profession
            undisclosed:(profession == nil)];
}

@end
