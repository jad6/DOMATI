//
//  DOMExperiencePickerHandler.m
//  DOMATI
//
//  Created by Jad Osseiran on 1/02/2014.
//  Copyright (c) 2014 Jad. All rights reserved.
//

#import "DOMExperiencePickerHandler.h"

@interface DOMExperiencePickerHandler ()

@end

@implementation DOMExperiencePickerHandler

- (void)populatedPicker:(UIPickerView *)pickerView
            withTechExp:(DOMTechnologyExperience)techExp
               delegate:(id<DOMExperiencePickerHandlerDelegate>)delegate
{
    pickerView.delegate = self;
    pickerView.dataSource = self;
    self.pickerView = pickerView;
    
    self.delegate = delegate;
    
    [self selectTechExp:techExp animated:NO];
}

+ (NSDictionary *)techExpTitles
{
    static NSDictionary *techExpTitles = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        techExpTitles = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"TechExpMapping" ofType:@"plist"]];
    });
    
    return techExpTitles;
}

#pragma mark - Logic

- (void)selectTechExp:(DOMTechnologyExperience)techExp animated:(BOOL)animated
{
    self.selectedExperience = techExp;
    NSInteger row = self.selectedExperience;
    
    [self.pickerView selectRow:row
                   inComponent:0
                      animated:animated];
    
    if ([self.delegate respondsToSelector:@selector(pickerView:didChangeExperience:)]) {
        [self.delegate pickerView:self.pickerView didChangeExperience:self.selectedExperience];
    }
}

- (void)selectTechExp:(DOMTechnologyExperience)techExp
{
    [self selectTechExp:techExp animated:YES];
}

#pragma mark - Helper Class Methods

+ (NSString *)titleForTechExp:(DOMTechnologyExperience)techExp
{
    NSString *key = [[NSString alloc] initWithFormat:@"%i", techExp];
    
    return [self techExpTitles][key];
}

+ (DOMTechnologyExperience)techExpForTitle:(NSString *)title
{
    return [[[[self techExpTitles] allKeysForObject:title] firstObject] integerValue];
}

#pragma mark - Picker data source

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [[[self class] techExpTitles] count];
}

#pragma mark - Picker delegate

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view
{
    UILabel *label = (UILabel *)[super pickerView:pickerView
                                       viewForRow:row
                                     forComponent:component
                                      reusingView:view];
    
    if (row > 0) {
        label.text = [[self class] titleForTechExp:row];
    }
    
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([self.delegate respondsToSelector:@selector(pickerView:didChangeExperience:)]) {
        [self.delegate pickerView:self.pickerView didChangeExperience:row];
    }
}

@end
