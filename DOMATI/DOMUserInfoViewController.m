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

#import "DOMUser.h"

@interface DOMUserInfoViewController () <DOMYearsPickerHandlerDelegate, DOMExperiencePickerHandlerDelegate, DOMProfessionPickerHandlerDelegate, DOMTextFieldCellDelegate, DOMGenderSegmentCellDelegate>

@property (nonatomic, strong) UILabel *pickerLabel;
@property (nonatomic, strong) NSIndexPath *visiblePickerIndexPath;
@property (nonatomic, strong) DOMPickerHandler *currentPickerHandler;
@property (nonatomic, strong) id currentFirstResponder;

@property (nonatomic, strong) DOMUser *user;

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
    
    self.user = [DOMUser currentUser];
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
    
    DOMUser *user = self.user;
    
    NSString *text = nil;
    NSString *detailText = nil;
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 0: {
                    text = @"Gender";
                    
                    DOMGenderSegmentCell *genderCell = (DOMGenderSegmentCell *)cell;
                    
                    genderCell.segmentedControl.selectedSegmentIndex = user.gender;
                    genderCell.delegate = self;
                    
                    cell = genderCell;
                    break;
                }
                    
                case 1:
                    text = @"Birth Year";
                    if (user.birthYear > 0) {
                        detailText = [DOMYearsPickerHandler titleForYear:user.birthYear];
                    }
                    break;
            }
            break;
        }
            
        case 1: {
            DOMTextFieldCell *textFieldCell = (DOMTextFieldCell *)cell;
            
            switch (indexPath.row) {
                case 0:
                    textFieldCell.type = DOMTextFieldCellTypeHeight;
                    text = @"Height (cm)";
                    
                    if (user.height > 0) {
                        detailText = [[NSString alloc] initWithFormat:@"%.2f", user.height];
                    }
                    break;
                    
                case 1:
                    textFieldCell.type = DOMTextFieldCellTypeWeight;
                    text = @"Weight (kg)";
                    
                    if (user.weight > 0) {
                        detailText = [[NSString alloc] initWithFormat:@"%.2f", user.weight];
                    }
                    break;
                }
            
            textFieldCell.delegate = self;
            cell = textFieldCell;
            break;
        }
            
        case 2: {
            switch (indexPath.row) {
                case 0:
                    text = @"Profession";
                    
                    if (user.profession) {
                        detailText = user.profession;
                    }
                    break;
                    
                case 1:
                case 2:
                    text = @"Tech Experience";
                    
                    if (user.techExp != DOMTechnologyExperienceUndisclosed) {
                        detailText = [DOMExperiencePickerHandler titleForTechExp:user.techExp];
                    }
                    break;
            }
            break;
        }
    }
    
    cell.textLabel.text = text;
    cell.detailTextLabel.text = (detailText) ? detailText : @"Undisclosed";
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

#pragma mark - Information Delegate

- (void)pickerView:(UIPickerView *)pickerView didChangeYear:(NSInteger)year;
{
    BOOL undisclosed = (year <= 0);
    
    [self setDetailText:[DOMYearsPickerHandler titleForYear:year]
            undisclosed:undisclosed];
    
    if (!undisclosed) {
        self.user.birthYear = year;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didChangeExperience:(DOMTechnologyExperience)techExp
{
    BOOL undisclosed = (techExp == DOMTechnologyExperienceUndisclosed);

    [self setDetailText:[DOMExperiencePickerHandler titleForTechExp:techExp]
            undisclosed:undisclosed];
    
    if (!undisclosed) {
        self.user.techExp = techExp;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didChangeProfession:(NSString *)profession
{
    BOOL undisclosed = (profession == nil);
    
    [self setDetailText:profession
            undisclosed:undisclosed];
    
    if (!undisclosed) {
        self.user.profession = profession;
    }
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
