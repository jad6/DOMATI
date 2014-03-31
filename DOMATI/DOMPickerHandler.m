//
//  DOMPickerHandler.m
//  DOMATI
//
//  Created by Jad Osseiran on 1/02/2014.
//  Copyright (c) 2014 Jad. All rights reserved.
//

#import "DOMPickerHandler.h"

@implementation DOMPickerHandler

- (void)populatedPicker:(UIPickerView *)pickerView
    delegate:(id<DOMPickerHandlerDelegate>)delegate
{
    pickerView.delegate = self;
    pickerView.dataSource = self;
    self.pickerView = pickerView;

    self.delegate = delegate;
}

+ (NSString *)undisclosedValue
{
    return @"Undisclosed";
}

- (void)dealloc
{
    if (self.pickerView.delegate == self)
    {
        self.pickerView.delegate = nil;
    }

    if (self.pickerView.dataSource == self)
    {
        self.pickerView.dataSource = nil;
    }
}

#pragma mark - Picker data source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 1;
}

#pragma mark - Picker delegate

- (UIView *)pickerView:(UIPickerView *)pickerView
    viewForRow:(NSInteger)row
    forComponent:(NSInteger)component
    reusingView:(UIView *)view
{
    // Return a label to represent each row.
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, pickerView.frame.size.width, 44.0f)];

    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = TEXT_COLOR;
    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];

    if (row == 0)
    {
        label.text = [[self class] undisclosedValue];
    }

    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([self.delegate respondsToSelector:@selector(pickerView:didChangeSelection:)])
    {
        UILabel *label = (UILabel *)[pickerView viewForRow:row forComponent:component];

        [self.delegate pickerView:self.pickerView
               didChangeSelection:label.text];
    }
}

@end
