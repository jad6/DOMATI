//
//  DOMOccupationPickerHandler.h
//  DOMATI
//
//  Created by Jad Osseiran on 1/02/2014.
//  Copyright (c) 2014 Jad. All rights reserved.
//

#import "DOMPickerHandler.h"

@protocol DOMOccupationPickerHandlerDelegate <DOMPickerHandlerDelegate>

@optional
/**
 *  The picker view has changed the selected occupation.
 *
 *  @param pickerView The occupation picker view.
 *  @param occupation The new selected occupation.
 */
- (void)pickerView:(UIPickerView *)pickerView didChangeOccupation:(NSString *)occupation;

@end

@interface DOMOccupationPickerHandler : DOMPickerHandler

@property (weak, nonatomic) id<DOMOccupationPickerHandlerDelegate> delegate;

@property (nonatomic) NSString * selectedOccupation;

/**
 *  Populates the picker with the occupations stored locally.
 *
 *  @param pickerView The picker view to populate.
 *  @param occupation The initial occupation to show when the picker is shown.
 *  @param delegate   The delegate for the handler.
 */
- (void)populatedPicker:(UIPickerView *)pickerView
    withInitialOccupation:(NSString *)occupation
    delegate:(id<DOMOccupationPickerHandlerDelegate>)delegate;

/**
 *  Select the given occupation. By default this method animates the
 *  change.
 *
 *  @param occupation The occupation to select.
 */
- (void)selectOccupation:(NSString *)occupation;
/**
 *  Select the given occupation.
 *
 *  @param occupation The occupation to select.
 *  @param animated True if you wish to animate the change.
 */
- (void)selectOccupation:(NSString *)occupation
    animated:(BOOL)animated;

@end
