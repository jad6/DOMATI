//
//  DOMPickerHandler.h
//  DOMATI
//
//  Created by Jad Osseiran on 1/02/2014.
//  Copyright (c) 2014 Jad. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DOMPickerHandlerDelegate <NSObject>

@optional
- (void)pickerView:(UIPickerView *)pickerView didChangeSelection:(id)selection;

@end

@interface DOMPickerHandler : NSObject <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) id<DOMPickerHandlerDelegate> delegate;

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UILabel *oldSelectionLabel, *selectionLabel;

- (void)populatedPicker:(UIPickerView *)pickerView
               delegate:(id<DOMPickerHandlerDelegate>)delegate;

+ (NSString *)undisclosedValue;

@end
