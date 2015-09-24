//
//  DOMCalibrationExpiryViewController.m
//  DOMATI
//
//  Created by Jad Osseiran on 11/08/13.
//  Copyright (c) 2013 Jad. All rights reserved.
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

#import "DOMCalibrationExpiryViewController.h"

@interface DOMCalibrationExpiryViewController ()

@property (nonatomic, strong) NSIndexPath *checkIndexPath;

@end

@implementation DOMCalibrationExpiryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    NSIndexPath *selectedIndexPath = nil;

    NSUbiquitousKeyValueStore *keyStore = [NSUbiquitousKeyValueStore defaultStore];
    NSNumber *selectedIndex = [keyStore objectForKey:KEYSTORE_CALI_EXPR_INDEX];
    if (selectedIndex) {
        selectedIndexPath = [NSIndexPath indexPathForRow:[selectedIndex integerValue] inSection:0];
        [self tableView:self.tableView didSelectRowAtIndexPath:selectedIndexPath];
    } else {
        selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self tableView:self.tableView didSelectRowAtIndexPath:selectedIndexPath];

        [keyStore setObject:@(0) forKey:KEYSTORE_CALI_EXPR_INDEX];
        [keyStore synchronize];
    }

    self.checkIndexPath = selectedIndexPath;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Logic

- (NSDateComponents *)expiryDurationFromIndexPath:(NSIndexPath *)indexPath {
    NSDateComponents *duration = [[NSDateComponents alloc] init];

    switch (indexPath.row) {
        case 1:
        case 2:
        case 3:
            [duration setMonth:indexPath.row];
            break;

        case 4:
            [duration setMonth:6];
            break;

        case 5:
            [duration setYear:1];
            break;

        case 6:
            [duration setYear:2];
            break;

        default:
            break;
    }

    return duration;
}

#pragma mark - Table view

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:self.checkIndexPath];

    cell.accessoryType = UITableViewCellAccessoryNone;

    cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;

    NSData *durationData = [NSKeyedArchiver archivedDataWithRootObject:[self expiryDurationFromIndexPath:indexPath]];

    NSUbiquitousKeyValueStore *keyStore = [NSUbiquitousKeyValueStore defaultStore];
    [keyStore setObject:@(indexPath.row) forKey:KEYSTORE_CALI_EXPR_INDEX];
    [keyStore setObject:durationData forKey:KEYSTORE_CALI_EXPR_DURATION_DATA];
    [keyStore setObject:cell.textLabel.text forKey:KEYSTORE_CALI_EXPR_TEXT];
    [keyStore synchronize];

    self.checkIndexPath = indexPath;
}

@end
