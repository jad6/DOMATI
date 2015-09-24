//
//  DOMYearsPickerHandler.m
//  DOMATI
//
//  Created by Jad Osseiran on 11/11/2013.
//  Copyright (c) 2013 Jad. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer. Redistributions in binary
//  form must reproduce the above copyright notice, this list of conditions and
//  the following disclaimer in the documentation and/or other materials
//  provided with the distribution. Neither the name of the nor the names of
//  its contributors may be used to endorse or promote products derived from
//  this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.

#import "DOMYearsPickerHandler.h"

@interface DOMYearsPickerHandler ()

@property (nonatomic) NSInteger currentYear;

@end

@implementation DOMYearsPickerHandler

- (void)populatedPicker:(UIPickerView *)pickerView
        withInitialYear:(NSInteger)year
               delegate:(id<DOMYearsPickerHandlerDelegate>)delegate {
    pickerView.delegate = self;
    pickerView.dataSource = self;
    self.pickerView = pickerView;

    self.delegate = delegate;

    [self selectYear:year animated:NO];
}

- (NSInteger)currentYear {
    if (!self->_currentYear) {
        NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:[NSDate date]];
        self->_currentYear = [comps year];
    }

    return self->_currentYear;
}

#pragma mark - Logic

- (void)selectYear:(NSInteger)year animated:(BOOL)animated {
    self.selectedYear = year;
    NSInteger row = [self rowForYear:self.selectedYear];

    [self.pickerView selectRow:row
                   inComponent:0
                      animated:animated];

    if ([self.delegate respondsToSelector:@selector(pickerView:didChangeYear:)]) {
        [self.delegate pickerView:self.pickerView didChangeYear:self.selectedYear];
    }
}

- (void)selectYear:(NSInteger)year {
    [self selectYear:year animated:YES];
}

/**
 *  Gets the row index for the given year.
 *
 *  @param year The year of the row index.
 *
 *  @return The row index for the given year.
 */
- (NSInteger)rowForYear:(NSInteger)year {
    return (self.currentYear - year) + 1;
}

/**
 *  Gets the year for the given row index.
 *
 *  @param row The row index.
 *
 *  @return The year for the given row index.
 */
- (NSInteger)yearFromRow:(NSInteger)row {
    return (row == 0) ? 0 : self.currentYear - (row - 1);
}

#pragma mark - Helper Class Methods

+ (NSInteger)yearForTitile:(NSString *)title {
    return [title integerValue];
}

+ (NSString *)titleForYear:(NSInteger)year {
    return [[NSString alloc] initWithFormat:@"%li", (long)year];
}

#pragma mark - Picker data source

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    // Last 100 years including the current one.
    return 101;
}

#pragma mark - Picker delegate

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view {
    UILabel *label = (UILabel *)[super pickerView:pickerView
                                       viewForRow:row
                                     forComponent:component
                                      reusingView:view];

    if (row > 0) {
        label.text = [[self class] titleForYear:[self yearFromRow:row]];
    }

    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectedYear = [self yearFromRow:row];
    if ([self.delegate respondsToSelector:@selector(pickerView:didChangeYear:)]) {
        [self.delegate pickerView:self.pickerView didChangeYear:self.selectedYear];
    }
}

@end
