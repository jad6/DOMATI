//
//  DOMYearsPickerHandler.h
//  DOMATI
//
//  Created by Jad Osseiran on 11/11/2013.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import "DOMPickerHandler.h"

@protocol DOMYearsPickerHandlerDelegate <DOMPickerHandlerDelegate>

@optional
/**
 *  The picker view has changed the selected year.
 *
 *  @param pickerView The year picker view.
 *  @param year       The new selected year.
 */
- (void)pickerView:(UIPickerView *)pickerView didChangeYear:(NSInteger)year;

@end

@interface DOMYearsPickerHandler : DOMPickerHandler

@property (weak, nonatomic) id<DOMYearsPickerHandlerDelegate> delegate;

@property (nonatomic) NSInteger selectedYear;

- (void)populatedPicker:(UIPickerView *)pickerView
        withInitialYear:(NSInteger)year
               delegate:(id<DOMYearsPickerHandlerDelegate>)delegate;

- (void)selectYear:(NSInteger)year;

+ (NSInteger)yearForTitile:(NSString *)title;
+ (NSString *)titleForYear:(NSInteger)year;

@end
