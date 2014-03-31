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

/**
 *  Populates the picker with the last 100 years as options.
 *
 *  @param pickerView The picker view to populate.
 *  @param year       The initial year to show when the picker is shown.
 *  @param delegate   The delegate for the handler.
 */
- (void)populatedPicker:(UIPickerView *)pickerView
        withInitialYear:(NSInteger)year
               delegate:(id<DOMYearsPickerHandlerDelegate>)delegate;

/**
 *  Select the given year. By default this method animates the
 *  change.
 *
 *  @param year The year to select.
 */
- (void)selectYear:(NSInteger)year;
/**
 *  Select the given year.
 *
 *  @param year     The year to select.
 *  @param animated True if you wish to animate the change.
 */
- (void)selectYear:(NSInteger)year animated:(BOOL)animated;

/**
 *  Gets the year for a given title.
 *
 *  @param title The title to match the year vwith.
 *
 *  @return The matched year.
 */
+ (NSInteger)yearForTitile:(NSString *)title;
/**
 *  Gets the title for a given year.
 *
 *  @param year The year to match the title vwith.
 *
 *  @return The matched title.
 */
+ (NSString *)titleForYear:(NSInteger)year;

@end
