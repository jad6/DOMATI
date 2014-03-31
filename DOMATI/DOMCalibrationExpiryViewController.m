//
//  DOMCalibrationExpiryViewController.m
//  DOMATI
//
//  Created by Jad Osseiran on 11/08/13.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import "DOMCalibrationExpiryViewController.h"

@interface DOMCalibrationExpiryViewController ()

@property (strong, nonatomic) NSIndexPath * checkIndexPath;

@end

@implementation DOMCalibrationExpiryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    NSIndexPath * selectedIndexPath = nil;

    NSUbiquitousKeyValueStore * keyStore = [NSUbiquitousKeyValueStore defaultStore];
    NSNumber * selectedIndex = [keyStore objectForKey:KEYSTORE_CALI_EXPR_INDEX];
    if (selectedIndex)
    {
        selectedIndexPath = [NSIndexPath indexPathForRow:[selectedIndex integerValue] inSection:0];
        [self tableView:self.tableView didSelectRowAtIndexPath:selectedIndexPath];
    }
    else
    {
        selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self tableView:self.tableView didSelectRowAtIndexPath:selectedIndexPath];

        [keyStore setObject:@(0) forKey:KEYSTORE_CALI_EXPR_INDEX];
        [keyStore synchronize];
    }

    self.checkIndexPath = selectedIndexPath;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Logic

- (NSDateComponents *)expiryDurationFromIndexPath:(NSIndexPath *)indexPath
{
    NSDateComponents * duration = [[NSDateComponents alloc] init];

    switch (indexPath.row)
    {
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:self.checkIndexPath];

    cell.accessoryType = UITableViewCellAccessoryNone;

    cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;

    NSData * durationData = [NSKeyedArchiver archivedDataWithRootObject:[self expiryDurationFromIndexPath:indexPath]];

    NSUbiquitousKeyValueStore * keyStore = [NSUbiquitousKeyValueStore defaultStore];
    [keyStore setObject:@(indexPath.row) forKey:KEYSTORE_CALI_EXPR_INDEX];
    [keyStore setObject:durationData forKey:KEYSTORE_CALI_EXPR_DURATION_DATA];
    [keyStore setObject:cell.textLabel.text forKey:KEYSTORE_CALI_EXPR_TEXT];
    [keyStore synchronize];

    self.checkIndexPath = indexPath;
}

@end
