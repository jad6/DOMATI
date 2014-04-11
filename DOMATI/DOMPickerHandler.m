//
//  DOMPickerHandler.m
//  DOMATI
//
//  Created by Jad Osseiran on 1/02/2014.
//  Copyright (c) 2014 Jad. All rights reserved.
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
