//
//  DOMOccupationPickerHandler.m
//  DOMATI
//
//  Created by Jad Osseiran on 1/02/2014.
//  Copyright (c) 2014 Jad. All rights reserved.
//

#import "DOMOccupationPickerHandler.h"

@interface DOMOccupationPickerHandler ()

@property (nonatomic, strong) NSArray *occupations;

@end

@implementation DOMOccupationPickerHandler

- (void)populatedPicker:(UIPickerView *)pickerView
  withInitialOccupation:(NSString *)occupation
               delegate:(id<DOMOccupationPickerHandlerDelegate>)delegate
{
    pickerView.delegate = self;
    pickerView.dataSource = self;
    self.pickerView = pickerView;
    
    self.delegate = delegate;
    
    // Select the occupation if it is given.
    if (occupation) {
        [self selectOccupation:occupation animated:NO];
    }
}

- (NSArray *)occupations
{
    if (!self->_occupations) {
        // Data taken from http://www.censusdata.abs.gov.au/census_services/getproduct/census/2011/quickstat/0
        self->_occupations = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Occupations" ofType:@"plist"]];
    }
    
    return self->_occupations;
}

#pragma mark - Logic

- (void)selectOccupation:(NSString *)occupation
                animated:(BOOL)animated
{
    self.selectedOccupation = occupation;
    NSInteger row = [self rowForOccupation:self.selectedOccupation];
    
    [self.pickerView selectRow:row
                   inComponent:0
                      animated:animated];
    
    if ([self.delegate respondsToSelector:@selector(pickerView:didChangeOccupation:)]) {
        [self.delegate pickerView:self.pickerView didChangeOccupation:self.selectedOccupation];
    }
}

- (void)selectOccupation:(NSString *)occupation
{
    [self selectOccupation:occupation animated:YES];
}

/**
 *  Gets the row index for the given occupation.
 *
 *  @param occupation The occupation of the row index.
 *
 *  @return The row index for the given occupation.
 */
- (NSInteger)rowForOccupation:(NSString *)occupation
{
    return [self.occupations indexOfObject:occupation] + 1;
}

/**
 *  Gets the occupation for the given row index.
 *
 *  @param row The row index.
 *
 *  @return The occupation for the given row index.
 */
- (NSString *)occupationFromRow:(NSInteger)row
{
    return (row == 0) ? nil : [self.occupations objectAtIndex:(row - 1)];
}

#pragma mark - Picker data source

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.occupations count] + 1;
}

#pragma mark - Picker delegate

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view
{
    UILabel *label = (UILabel *)[super pickerView:pickerView
                                       viewForRow:row
                                     forComponent:component
                                      reusingView:view];
    
    if (row > 0) {
        label.text = [self occupationFromRow:row];
    }
    
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectedOccupation = [self occupationFromRow:row];
    if ([self.delegate respondsToSelector:@selector(pickerView:didChangeOccupation:)]) {
        [self.delegate pickerView:self.pickerView didChangeOccupation:self.selectedOccupation];
    }
}

@end
