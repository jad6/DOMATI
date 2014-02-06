//
//  DOMUserInfoViewController.m
//  DOMATI
//
//  Created by Jad Osseiran on 11/11/2013.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import "DOMUserInfoViewController.h"

#import "DOMYearsPickerHandler.h"
#import "DOMProfessionPickerHandler.h"

#import "DOMGenderSegmentCell.h"
#import "DOMPickerCell.h"
#import "DOMTextFieldCell.h"

#import "DOMUser.h"

@interface DOMUserInfoViewController () <UIAlertViewDelegate, DOMYearsPickerHandlerDelegate, DOMProfessionPickerHandlerDelegate, DOMTextFieldCellDelegate, DOMGenderSegmentCellDelegate>

@property (nonatomic, strong) NSIndexPath *pickerIndexPath, *activeCellIndexPath;
@property (nonatomic, strong) DOMPickerHandler *currentPickerHandler;
@property (nonatomic, strong) id currentFirstResponder;

@property (nonatomic, strong) DOMUser *user;

@end

static NSString *SegmentCellIdentifier = @"Segment Cell";
static NSString *DetailCellIdentifier = @"Detail Cell";
static NSString *TextFieldCellIdentifier = @"Text Field Cell";
static NSString *PickerCellIdentifier = @"Picker Cell";

static NSInteger kUndisclosedAlertTag = 10;

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

- (IBAction)nextAction:(id)sender
{
    NSArray *undisclosedFields = [self undisclosedFields];
    NSUInteger undisclosedFieldsCount = [undisclosedFields count];
    if (undisclosedFields > 0) {
        NSMutableString *list = [[NSMutableString alloc] init];
        for (NSUInteger i = 0; i < undisclosedFieldsCount; i++) {
            if (i < undisclosedFieldsCount - 1) {
                [list appendFormat:@"%@, ", undisclosedFields[i]];
            } else {
                [list appendFormat:@"%@", undisclosedFields[i]];
            }
        }
        
        NSString *message = [[NSString alloc] initWithFormat:@"The following fields are undisclosed: \"%@\". It would great if they could be set. What would you like to do?", list];
        
        UIAlertView *undisclosedAV = [[UIAlertView alloc] initWithTitle:@"Undisclosed Fields" message:message delegate:self cancelButtonTitle:@"Ignore" otherButtonTitles:@"Set Fields", nil];
        undisclosedAV.tag = kUndisclosedAlertTag;
        [undisclosedAV show];
    } else {
        [self performSegueWithIdentifier:@"Calibration Segue" sender:sender];
    }
}

#pragma mark - Alert View

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == kUndisclosedAlertTag && buttonIndex == 0) {
        [self performSegueWithIdentifier:@"Calibration Segue" sender:nil];
    }
}

#pragma mark - Logic

- (NSArray *)undisclosedFields
{
    NSMutableArray *undisclosedFields = [[NSMutableArray alloc] init];
    
    if (self.user.gender == DOMGenderUndisclosed) {
        [undisclosedFields addObject:@"Gender"];
    }
    if (self.user.birthYear == 0) {
        [undisclosedFields addObject:@"Birth Year"];
    }
    if (self.user.height == 0.0) {
        [undisclosedFields addObject:@"Height"];
    }
    if (self.user.weight == 0.0) {
        [undisclosedFields addObject:@"Weight"];
    }
    if (!self.user.profession || [self.user.profession isEqualToString:[DOMPickerHandler undisclosedValue]]) {
        [undisclosedFields addObject:@"Profession"];
    }
    
    return undisclosedFields;
}

- (BOOL)resignCurrentResponder
{
    BOOL success = NO;
    
    success = [self.currentFirstResponder resignFirstResponder];
    
    if (success) {
        if ([self.currentFirstResponder respondsToSelector:@selector(setEnabled:)]) {
            [self.currentFirstResponder setEnabled:NO];
        }
        
        self.activeCellIndexPath = nil;
        self.currentFirstResponder = nil;
    }
    
    return success;
}

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

- (void)setDetailText:(NSString *)text undisclosed:(BOOL)undisclosed
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.activeCellIndexPath];
    cell.detailTextLabel.text = (undisclosed) ? [DOMPickerHandler undisclosedValue] : text;
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
 *
 *  @param cell      cell description
 *  @param indexPath indexPath description
 */
- (void)setupCell:(UITableViewCell *)cell
     forIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath isEqual:self.pickerIndexPath]) {
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
                        textFieldCell.textField.text = [[NSString alloc] initWithFormat:@"%.2f", user.height];
                    }
                    break;
                    
                case 1:
                    textFieldCell.type = DOMTextFieldCellTypeWeight;
                    text = @"Weight (kg)";
                    
                    if (user.weight > 0) {
                        textFieldCell.textField.text = [[NSString alloc] initWithFormat:@"%.2f", user.weight];
                    }
                    break;
                }
            
            textFieldCell.delegate = self;
            break;
        }
            
        case 2: {
            text = @"Profession";
            
            if (user.profession) {
                detailText = user.profession;
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
    
    if ([indexPath isEqual:self.pickerIndexPath]) {
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

/**
 *  Determines if the given indexPath has a cell below it with a picker.
 *
 *  @param indexPath The indexPath to check if its cell has a UIDatePicker below it.
 *
 *  @return
 */
- (BOOL)hasPickerForIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:(indexPath.row + 1) inSection:indexPath.section]];
    
    return [cell isKindOfClass:[DOMPickerCell class]];
}

/**
 *  Determines if the table view has a picker in any of its cells.
 *
 *  @return
 */
- (BOOL)hasInlineDatePickerInSection:(NSInteger)section
{
    return (self.pickerIndexPath != nil && self.pickerIndexPath.section == section);
}

/**
 *  Determines if the given indexPath points to a cell that contains the picker.
 *
 *  @param indexPath The indexPath to check if it represents a cell with the picker.
 *
 *  @return
 */
- (BOOL)indexPathHasPicker:(NSIndexPath *)indexPath
{
    return ([self hasInlineDatePickerInSection:indexPath.section]
            && self.pickerIndexPath.row == indexPath.row);
}

/**
 *  Remove any picker cell if it exists
 */
- (void)removePicker
{
    if (self.pickerIndexPath) {
        self.activeCellIndexPath = nil;
        
        NSIndexPath *datePickerIndexPathCopy = [self.pickerIndexPath copy];
        self.pickerIndexPath = nil;

        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:datePickerIndexPathCopy.row inSection:datePickerIndexPathCopy.section]]
                              withRowAnimation:UITableViewRowAnimationFade];
    }
}

/**
 *  Adds or removes a picker cell below the given indexPath.
 *
 *  @param indexPath The indexPath to reveal the picker.
 */
- (void)toggleDatePickerForSelectedIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView beginUpdates];
    
    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:(indexPath.row + 1) inSection:indexPath.section]];
    
    // Check if 'indexPath' has an attached picker below it
    if ([self hasPickerForIndexPath:indexPath]) {
        // Found a picker below it, so remove it
        [self.tableView deleteRowsAtIndexPaths:indexPaths
                              withRowAnimation:UITableViewRowAnimationFade];
    } else {
        self.activeCellIndexPath = indexPath;
        
        // Didn't find a picker below it, so we should insert it
        [self.tableView insertRowsAtIndexPaths:indexPaths
                              withRowAnimation:UITableViewRowAnimationFade];
    }
    
    [self.tableView endUpdates];
}

/**
 *  Reveals the date picker inline for the given indexPath, called by
 *  "didSelectRowAtIndexPath".
 *
 *  @param indexPath The indexPath to reveal the picker.
 */
- (void)displayInlineDatePickerForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Display the picker inline with the table content
    [self.tableView beginUpdates];
    
    // Indicates if the picker is below "indexPath", help determine
    // which row to reveal.
    BOOL before = NO;
    if ([self hasInlineDatePickerInSection:indexPath.section]) {
        before = self.pickerIndexPath.row < indexPath.row;
    }
    
    BOOL sameCellClicked = (self.pickerIndexPath.row - 1 == indexPath.row);
    
    [self removePicker];
    
    if (!sameCellClicked) {
        // Hide the old picker and display the new one
        NSInteger rowToReveal = (before ? indexPath.row - 1 : indexPath.row);
        NSIndexPath *indexPathToReveal = [NSIndexPath indexPathForRow:rowToReveal inSection:indexPath.section];
        
        [self toggleDatePickerForSelectedIndexPath:indexPathToReveal];
        self.pickerIndexPath = [NSIndexPath indexPathForRow:indexPathToReveal.row + 1 inSection:indexPath.section];
    }
    
    // Always deselect the row containing the start or end date
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.tableView endUpdates];
    
    // Update picker.
    if (self.pickerIndexPath) {
        DOMPickerCell *pickerCell = (DOMPickerCell *)[self.tableView cellForRowAtIndexPath:self.pickerIndexPath];
        [self populatePicker:pickerCell.picker atIndexPath:self.pickerIndexPath cell:[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:(self.pickerIndexPath.row - 1) inSection:self.pickerIndexPath.section]]];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return ([self hasInlineDatePickerInSection:section]) ? 3 : 2;
            break;

        case 1:
            return 2;
            break;
            
        case 2:
            return ([self hasInlineDatePickerInSection:section]) ? 2 : 1;
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
            return @"Other Info";
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
    if ([self.pickerIndexPath isEqual:indexPath]) {
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
        [self resignCurrentResponder];
        
        [self displayInlineDatePickerForRowAtIndexPath:indexPath];
        
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    } else if ([cell.reuseIdentifier isEqualToString:TextFieldCellIdentifier]) {
        if (self.pickerIndexPath) {
            [self removePicker];
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
    
    cell.detailTextLabel.textColor = ([indexPath isEqual:self.activeCellIndexPath]) ? DOMATI_COLOR : DETAIL_TEXT_COLOR;
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
