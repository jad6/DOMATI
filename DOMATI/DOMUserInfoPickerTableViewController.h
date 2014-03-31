//
//  DOMUserInfoPickerTableViewController.h
//  DOMATI
//
//  Created by Jad Osseiran on 13/02/2014.
//  Copyright (c) 2014 Jad. All rights reserved.
//

#import "DOMPickerTableViewController.h"

#import "DOMYearsPickerHandler.h"
#import "DOMOccupationPickerHandler.h"

#import "DOMGenderSegmentCell.h"
#import "DOMTextFieldCell.h"

#import "DOMUser.h"

@interface DOMUserInfoPickerTableViewController : DOMPickerTableViewController <DOMYearsPickerHandlerDelegate, DOMOccupationPickerHandlerDelegate, DOMTextFieldCellDelegate, DOMGenderSegmentCellDelegate>

// The current handler that is being used by the visible picker.
@property (nonatomic, strong, readonly) DOMPickerHandler *currentPickerHandler;
// The current user.
@property (nonatomic, strong) DOMUser *user;

@end
