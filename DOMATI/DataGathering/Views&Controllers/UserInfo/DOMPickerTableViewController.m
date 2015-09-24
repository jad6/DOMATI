//
//  DOMPickerTableViewController.m
//  DOMATI
//
//  Created by Jad Osseiran on 13/02/2014.
//  Copyright (c) 2014 Jad. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer. Redistributions in binary
//  form must reproduce the above copyright notice, this list of conditions and
//  the following disclaimer in the documentation and/or other materials
//  provided with the distribution. Neither the name of the nor the names of
//  its contributors may be used to endorse or promote products derived from
//  this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.

#import "DOMPickerTableViewController.h"

@interface DOMPickerTableViewController ()

@end

@implementation DOMPickerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Override Methods

- (Class)pickerCellClass {
    return [UITableViewCell class];
}

- (void)reloadPicker {
}

#pragma mark - Pickers

/**
 *  Determines if the given indexPath has a cell below it with a picker.
 *
 *  @param indexPath The indexPath to check if its cell has a UIDatePicker below it.
 *
 *  @return
 */
- (BOOL)hasPickerForIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:(indexPath.row + 1)inSection:indexPath.section]];

    return [cell isKindOfClass:[self pickerCellClass]];
}

/**
 *  Determines if the table view has a picker in any of its cells.
 *
 *  @return
 */
- (BOOL)hasInlineDatePickerInSection:(NSInteger)section {
    return (self.pickerIndexPath != nil && self.pickerIndexPath.section == section);
}

/**
 *  Determines if the given indexPath points to a cell that contains the picker.
 *
 *  @param indexPath The indexPath to check if it represents a cell with the picker.
 *
 *  @return
 */
- (BOOL)indexPathHasPicker:(NSIndexPath *)indexPath {
    return ([self hasInlineDatePickerInSection:indexPath.section] && self.pickerIndexPath.row == indexPath.row);
}

/**
 *  Remove any picker cell if it exists
 */
- (void)removePicker {
    if (self.pickerIndexPath) {
        self.activeCellIndexPath = nil;

        NSIndexPath *datePickerIndexPathCopy = [self.pickerIndexPath copy];
        self.pickerIndexPath = nil;

        UITableViewCell *inactiveCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:(datePickerIndexPathCopy.row - 1)inSection:datePickerIndexPathCopy.section]];
        inactiveCell.detailTextLabel.textColor = [UIColor detailTextColor];

        [self.tableView deleteRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:datePickerIndexPathCopy.row inSection:datePickerIndexPathCopy.section] ]
                              withRowAnimation:UITableViewRowAnimationFade];
    }
}

/**
 *  Adds or removes a picker cell below the given indexPath.
 *
 *  @param indexPath The indexPath to reveal the picker.
 */
- (void)toggleDatePickerForSelectedIndexPath:(NSIndexPath *)indexPath {
    [self.tableView beginUpdates];

    NSArray *indexPaths = @[ [NSIndexPath indexPathForRow:(indexPath.row + 1)inSection:indexPath.section] ];

    // Check if 'indexPath' has an attached picker below it
    if ([self hasPickerForIndexPath:indexPath]) {
        // Found a picker below it, so remove it
        [self.tableView deleteRowsAtIndexPaths:indexPaths
                              withRowAnimation:UITableViewRowAnimationFade];
    } else {
        self.activeCellIndexPath = indexPath;

        // Didn't find a picker below it, so we should insert it
        [self.tableView insertRowsAtIndexPaths:indexPaths
                              withRowAnimation:UITableViewRowAnimationFade];
    }

    [self.tableView endUpdates];
}

/**
 *  Reveals the date picker inline for the given indexPath, called by
 *  "didSelectRowAtIndexPath".
 *
 *  @param indexPath The indexPath to reveal the picker.
 */
- (void)displayInlineDatePickerForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Display the picker inline with the table content
    [self.tableView beginUpdates];

    // Indicates if the picker is below "indexPath", help determine
    // which row to reveal.
    BOOL before = NO;
    if ([self hasInlineDatePickerInSection:indexPath.section]) {
        before = self.pickerIndexPath.row < indexPath.row;
    }

    BOOL sameCellClicked = (self.pickerIndexPath.row - 1 == indexPath.row);

    [self removePicker];

    if (!sameCellClicked) {
        // Hide the old picker and display the new one
        NSInteger rowToReveal = (before ? indexPath.row - 1 : indexPath.row);
        NSIndexPath *indexPathToReveal = [NSIndexPath indexPathForRow:rowToReveal inSection:indexPath.section];

        [self toggleDatePickerForSelectedIndexPath:indexPathToReveal];
        self.pickerIndexPath = [NSIndexPath indexPathForRow:indexPathToReveal.row + 1 inSection:indexPath.section];
    }

    // Always deselect the row containing the start or end date
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    [self.tableView endUpdates];

    // Update picker.
    if (self.pickerIndexPath) {
        [self reloadPicker];
    }
}

@end
