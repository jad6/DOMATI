//
//  DOMPickerHandler.h
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

#import <Foundation/Foundation.h>

@protocol DOMPickerHandlerDelegate <NSObject>

@optional
/**
 *  The picker view has changed the selection.
 *
 *  @param pickerView The picker view who's selection has changed.
 *  @param selection  The new selection.
 */
- (void)pickerView:(UIPickerView *)pickerView didChangeSelection:(id)selection;

@end

@interface DOMPickerHandler : NSObject <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, weak) id<DOMPickerHandlerDelegate> delegate;

@property (nonatomic, strong) UIPickerView *pickerView;
/// The labels which are associated with the picker selections.
@property (nonatomic, strong) UILabel *oldSelectionLabel, *selectionLabel;

/**
 *  Method to populate the picker view and setting the delegate.
 *  This method is meant to be overridden.
 *
 *  @param pickerView The picker view to populate.
 *  @param delegate   The delegate for the picker handler.
 */
- (void)populatedPicker:(UIPickerView *)pickerView
               delegate:(id<DOMPickerHandlerDelegate>)delegate;

/**
 *  This method returns the default value that should displaed when
 *  the field is left undisclosed..
 *
 *  @return The default string for undisclosed fields.
 */
+ (NSString *)undisclosedValue;

@end
