//
//  DOMUserInfoPickerTableViewController.h
//  DOMATI
//
//  Created by Jad Osseiran on 13/02/2014.
//  Copyright (c) 2014 Jad. All rights reserved.
//

#import "DOMPickerTableViewController.h"

#import "DOMYearsPickerHandler.h"
#import "DOMProfessionPickerHandler.h"

#import "DOMGenderSegmentCell.h"
#import "DOMTextFieldCell.h"

#import "DOMUser.h"

@interface DOMUserInfoPickerTableViewController : DOMPickerTableViewController <DOMYearsPickerHandlerDelegate, DOMProfessionPickerHandlerDelegate, DOMTextFieldCellDelegate, DOMGenderSegmentCellDelegate>

@property (nonatomic, strong, readonly) DOMPickerHandler *currentPickerHandler;

@property (nonatomic, strong) DOMUser *user;

@end
