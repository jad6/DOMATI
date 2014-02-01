//
//  DOMProfessionPickerHandler.h
//  DOMATI
//
//  Created by Jad Osseiran on 1/02/2014.
//  Copyright (c) 2014 Jad. All rights reserved.
//

#import "DOMPickerHandler.h"

@protocol DOMProfessionPickerHandlerDelegate <DOMPickerHandlerDelegate>

@optional
- (void)pickerView:(UIPickerView *)pickerView didChangeProfession:(NSString *)profession;

@end

@interface DOMProfessionPickerHandler : DOMPickerHandler

@property (weak, nonatomic) id<DOMProfessionPickerHandlerDelegate> delegate;

@property (nonatomic) NSString *selectedProfession;

- (void)populatedPicker:(UIPickerView *)pickerView
  withInitialProfession:(NSString *)profession
               delegate:(id<DOMProfessionPickerHandlerDelegate>)delegate;

- (void)selectProfession:(NSString *)profession;

@end
