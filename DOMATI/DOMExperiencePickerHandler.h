//
//  DOMExperiencePickerHandler.h
//  DOMATI
//
//  Created by Jad Osseiran on 1/02/2014.
//  Copyright (c) 2014 Jad. All rights reserved.
//

#import "DOMPickerHandler.h"

#import "DOMUser.h"

@protocol DOMExperiencePickerHandlerDelegate <DOMPickerHandlerDelegate>

@optional
- (void)pickerView:(UIPickerView *)pickerView didChangeExperience:(DOMTechnologyExperience)techExp;

@end

@interface DOMExperiencePickerHandler : DOMPickerHandler

@property (weak, nonatomic) id<DOMExperiencePickerHandlerDelegate> delegate;

@property (nonatomic) DOMTechnologyExperience selectedExperience;

- (void)populatedPicker:(UIPickerView *)pickerView
            withTechExp:(DOMTechnologyExperience)techExp
               delegate:(id<DOMExperiencePickerHandlerDelegate>)delegate;

+ (NSString *)titleForTechExp:(DOMTechnologyExperience)techExp;
+ (DOMTechnologyExperience)techExpForTitle:(NSString *)title;

- (void)selectTechExp:(DOMTechnologyExperience)techExp;

@end
