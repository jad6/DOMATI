//
//  DOMUserInfoViewController.m
//  DOMATI
//
//  Created by Jad Osseiran on 11/11/2013.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import "DOMUserInfoViewController.h"

#import "DOMUser.h"

@interface DOMUserInfoViewController () <UIAlertViewDelegate>

@property (nonatomic, strong) id currentFirstResponder;

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

@end
