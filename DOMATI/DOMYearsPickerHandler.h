//
//  DOMYearsPickerHandler.h
//  DOMATI
//
//  Created by Jad Osseiran on 11/11/2013.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DOMYearsPickerHandlerDelegate <NSObject>

- (void)pickerView:(UIPickerView *)pickerView didChangeYear:(NSInteger)year;

@end

@interface DOMYearsPickerHandler : NSObject 

@property (weak, nonatomic) id<DOMYearsPickerHandlerDelegate> delegate;

@property (nonatomic) NSInteger selectedYear;

+ (NSString *)undisclosedYear;

- (id)initWithPicker:(UIPickerView *)pickerView
            withYear:(NSInteger)year
            delegate:(id<DOMYearsPickerHandlerDelegate>)delegate;

- (void)selectYear:(NSInteger)year;

@end
