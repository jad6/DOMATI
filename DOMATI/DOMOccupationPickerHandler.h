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

@property (nonatomic) NSString *selectedOccupation;

- (void)populatedPicker:(UIPickerView *)pickerView
  withInitialOccupation:(NSString *)occupation
               delegate:(id<DOMOccupationPickerHandlerDelegate>)delegate;

- (void)selectOccupation:(NSString *)occupation;

@end
