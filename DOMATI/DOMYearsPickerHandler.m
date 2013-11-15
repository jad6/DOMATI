//
//  DOMYearsPickerHandler.m
//  DOMATI
//
//  Created by Jad Osseiran on 11/11/2013.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import "DOMYearsPickerHandler.h"

@interface DOMYearsPickerHandler () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) UIPickerView *pickerView;
@property (nonatomic) NSInteger currentYear;

@property (strong, nonatomic) UILabel *oldSelectionLabel, *selectionLabel;

@end

@implementation DOMYearsPickerHandler

- (id)initWithPicker:(UIPickerView *)pickerView
            withYear:(NSInteger)year
            delegate:(id<DOMYearsPickerHandlerDelegate>)delegate
{
    self = [super init];
    if (self) {
        pickerView.delegate = self;
        pickerView.dataSource = self;
        self.pickerView = pickerView;
        
        self.delegate = delegate;
        
        [self selectYear:year animated:NO];
    }
    return self;
}

- (void)dealloc
{
    if (self.pickerView.delegate == self) {
        self.pickerView.delegate = nil;
    }
    
    if (self.pickerView.dataSource == self) {
        self.pickerView.dataSource = nil;
    }
}

- (NSInteger)currentYear
{
    if (!_currentYear) {
        NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:[NSDate date]];
        _currentYear = [comps year];
    }
    
    return _currentYear;
}

+ (NSString *)undisclosedYear
{
    return @"Undisclosed";
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
    return (row == 0) ? -1 : self.currentYear - (row - 1);
}

#pragma mark - Picker data source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

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
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, pickerView.frame.size.width, 44.0f)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = TEXT_COLOR;
    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
    
    if (row == 0) {
        label.text = [[self class] undisclosedYear];
    } else {
        label.text = [[NSString alloc] initWithFormat:@"%i", [self yearFromRow:row]];
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
