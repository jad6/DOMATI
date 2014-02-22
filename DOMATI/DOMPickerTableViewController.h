//
//  DOMPickerTableViewController.h
//  DOMATI
//
//  Created by Jad Osseiran on 13/02/2014.
//  Copyright (c) 2014 Jad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DOMPickerTableViewController : UITableViewController

@property (nonatomic, strong) NSIndexPath *pickerIndexPath, *activeCellIndexPath;

/**
 *  Method to override with the picker cell class.
 *
 *  @return the picker cell class.
 */
- (Class)pickerCellClass;
/**
 *  Method to override with the algorithm to reload current picker.
 */
- (void)reloadPicker;

- (BOOL)hasInlineDatePickerInSection:(NSInteger)section;
- (void)displayInlineDatePickerForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)removePicker;

@end
