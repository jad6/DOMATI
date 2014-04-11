//
//  DOMYearsPickerHandler.h
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
