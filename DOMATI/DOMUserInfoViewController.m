//
//  DOMUserInfoViewController.m
//  DOMATI
//
//  Created by Jad Osseiran on 11/11/2013.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import "DOMUserInfoViewController.h"

#import "DOMUser.h"

static NSString *SegmentCellIdentifier = @"Segment Cell";
static NSString *DetailCellIdentifier = @"Detail Cell";
static NSString *TextFieldCellIdentifier = @"Text Field Cell";
static NSString *PickerCellIdentifier = @"Picker Cell";

static NSInteger kUndisclosedAlertTag = 10;

@interface DOMUserInfoViewController () <UIAlertViewDelegate>

// Keep a reference to the first responder to easily resign it.
@property (nonatomic, strong) id currentFirstResponder;
// The footers & headers text for the table.
@property (nonatomic, strong) NSArray *footersText, *headersText;

@end

@implementation DOMUserInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.user = [DOMUser currentUser];
    
    NSDictionary *tableInfo = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"UserInfoTable" ofType:@"plist"]];
    self.headersText = tableInfo[@"Headers"];
    self.footersText = tableInfo[@"Footers"];
}

#pragma mark - Actions

/**
 *  Checks that each field has been filled and alerts the user otherwise.
 *  Still allows to continue if not all fields are filled.
 *
 *  @param sender the sender of the action.
 */
- (IBAction)nextAction:(id)sender
{
    NSArray *undisclosedFields = [self undisclosedFields];
    NSUInteger undisclosedFieldsCount = [undisclosedFields count];
    if (undisclosedFieldsCount > 0) {
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
    // Bring up the calibration screen upon the user's request.
    if (alertView.tag == kUndisclosedAlertTag && buttonIndex == 0) {
        [self performSegueWithIdentifier:@"Calibration Segue" sender:nil];
    }
}

#pragma mark - Logic

/**
 *  Gets the undisclosed fields.
 *
 *  @return array of the undisclosed fields.
 */
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

/**
 *  Resigns the first responder from the current first responder if any.
 *
 *  @return the result of the resignation.
 */
- (BOOL)resignCurrentResponder
{
    if (!self.currentFirstResponder) {
        return NO;
    }
    
    BOOL success = NO;
    
    success = [self.currentFirstResponder resignFirstResponder];
    
    if (success) {
        // If the currentFirstResponder can be disabled, do so.
        if ([self.currentFirstResponder respondsToSelector:@selector(setEnabled:)]) {
            [self.currentFirstResponder setEnabled:NO];
        }
        
        // Reset the variables which have to do with the currentFirstResponder
        self.activeCellIndexPath = nil;
        self.currentFirstResponder = nil;
    }
    
    return success;
}

/**
 *  This sets the table in the following format: Gender, Birth Year | 
 *  Height, Weight | Profession. 
 *
 *  Unless there is exisiting user data the rows will be set as "Undisclosed".
 *
 *  @param cell      the cell to setup.
 *  @param indexPath the indexPath of the cell.
 */
- (void)setupCell:(UITableViewCell *)cell
     forIndexPath:(NSIndexPath *)indexPath
{
    // If the indexPath is the picker cell do nothing.
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
                    text = nil;
                    DOMGenderSegmentCell *genderCell = (DOMGenderSegmentCell *)cell;
                    
                    genderCell.titleLabel.text = @"Gender";
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

/**
 *  Returns the corresponding cell identifier for the given indexPath.
 *
 *  @param indexPath indexPath for the cell who's identifier we need.
 *
 *  @return the corresponding cell identifier for the given indexPath
 */
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
    return self.headersText[section];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return self.footersText[section];
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
        // A picker cell is selected, resign whoever was first responder.
        [self resignCurrentResponder];
        
        [self displayInlineDatePickerForRowAtIndexPath:indexPath];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
        // If we have a picker that is showing scroll to it.
        if (self.pickerIndexPath) {
            [tableView scrollToRowAtIndexPath:self.pickerIndexPath
                             atScrollPosition:UITableViewScrollPositionMiddle
                                     animated:YES];
        }
    } else if ([cell.reuseIdentifier isEqualToString:TextFieldCellIdentifier]) {
        // Remove the picker if there is one.
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
    
    // Set the selected row's detail label to the app tint color.
    cell.detailTextLabel.textColor = ([indexPath isEqual:self.activeCellIndexPath]) ? DOMATI_COLOR : DETAIL_TEXT_COLOR;
}

#pragma mark - Scroll View

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self resignCurrentResponder];
}

@end
