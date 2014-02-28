//
//  DOMYearsPickerHandler.m
//  DOMATI
//
//  Created by Jad Osseiran on 11/11/2013.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import "DOMYearsPickerHandler.h"

@interface DOMYearsPickerHandler ()

@property (nonatomic) NSInteger currentYear;

@end

@implementation DOMYearsPickerHandler

- (void)populatedPicker:(UIPickerView *)pickerView
        withInitialYear:(NSInteger)year
               delegate:(id<DOMYearsPickerHandlerDelegate>)delegate
{
    pickerView.delegate = self;
    pickerView.dataSource = self;
    self.pickerView = pickerView;
    
    self.delegate = delegate;
    
    [self selectYear:year animated:NO];
}

- (NSInteger)currentYear
{
    if (!self->_currentYear) {
        NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:[NSDate date]];
        self->_currentYear = [comps year];
    }
    
    return self->_currentYear;
}

#pragma mark - Logic

- (void)selectYear:(NSInteger)year animated:(BOOL)animated
{
    self.selectedYear = year;
    NSInteger row = [self rowForYear:self.selectedYear];
    
    [self.pickerView selectRow:row
                   inComponent:0
                      animated:animated];
    
    if ([self.delegate respondsToSelector:@selector(pickerView:didChangeYear:)]) {
        [self.delegate pickerView:self.pickerView didChangeYear:self.selectedYear];
    }
}

- (void)selectYear:(NSInteger)year
{
    [self selectYear:year animated:YES];
}

- (NSInteger)rowForYear:(NSInteger)year
{
    return (self.currentYear - year) + 1;
}

- (NSInteger)yearFromRow:(NSInteger)row
{
    return (row == 0) ? 0 : self.currentYear - (row - 1);
}

#pragma mark - Helper Class Methods

+ (NSInteger)yearForTitile:(NSString *)title
{
    return [title integerValue];
}

+ (NSString *)titleForYear:(NSInteger)year
{
    return [[NSString alloc] initWithFormat:@"%i", year];
}

#pragma mark - Picker data source

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 101;
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
        label.text = [[self class] titleForYear:[self yearFromRow:row]];
    }
    
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{    
    self.selectedYear = [self yearFromRow:row];
    if ([self.delegate respondsToSelector:@selector(pickerView:didChangeYear:)]) {
        [self.delegate pickerView:self.pickerView didChangeYear:self.selectedYear];
    }
}

@end
