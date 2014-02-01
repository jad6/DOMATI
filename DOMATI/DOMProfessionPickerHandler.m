//
//  DOMProfessionPickerHandler.m
//  DOMATI
//
//  Created by Jad Osseiran on 1/02/2014.
//  Copyright (c) 2014 Jad. All rights reserved.
//

#import "DOMProfessionPickerHandler.h"

@interface DOMProfessionPickerHandler ()

@property (nonatomic, strong) NSArray *professions;

@end

@implementation DOMProfessionPickerHandler

- (void)populatedPicker:(UIPickerView *)pickerView
  withInitialProfession:(NSString *)profession
               delegate:(id<DOMProfessionPickerHandlerDelegate>)delegate
{
    pickerView.delegate = self;
    pickerView.dataSource = self;
    self.pickerView = pickerView;
    
    self.delegate = delegate;
    
    if (profession) {
        [self selectProfession:profession animated:NO];
    }
}

- (NSArray *)professions
{
    if (!_professions) {
        NSArray *professions = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Professions" ofType:@"plist"]];
        _professions = [professions sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    }
    
    return _professions;
}

#pragma mark - Logic

- (void)selectProfession:(NSString *)profession animated:(BOOL)animated
{
    self.selectedProfession = profession;
    NSInteger row = [self rowForProfession:self.selectedProfession];
    
    [self.pickerView selectRow:row
                   inComponent:0
                      animated:animated];
    
    if ([self.delegate respondsToSelector:@selector(pickerView:didChangeProfession:)]) {
        [self.delegate pickerView:self.pickerView didChangeProfession:self.selectedProfession];
    }
}

- (void)selectProfession:(NSString *)profession
{
    [self selectProfession:profession animated:YES];
}

- (NSInteger)rowForProfession:(NSString *)profession
{
    return [self.professions indexOfObject:profession] + 1;
}

- (NSString *)professionFromRow:(NSInteger)row
{
    return (row == 0) ? nil : [self.professions objectAtIndex:(row - 1)];
}

#pragma mark - Picker data source

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.professions count] + 1;
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
        label.text = [self professionFromRow:row];
    }
    
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectedProfession = [self professionFromRow:row];
    if ([self.delegate respondsToSelector:@selector(pickerView:didChangeProfession:)]) {
        [self.delegate pickerView:self.pickerView didChangeProfession:self.selectedProfession];
    }
}

@end
