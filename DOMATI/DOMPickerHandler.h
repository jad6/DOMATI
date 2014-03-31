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
/**
 *  The picker view has changed the selection.
 *
 *  @param pickerView The picker view who's selection has changed.
 *  @param selection  The new selection.
 */
- (void)pickerView:(UIPickerView *)pickerView didChangeSelection:(id)selection;

@end

@interface DOMPickerHandler : NSObject <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) id<DOMPickerHandlerDelegate> delegate;

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
