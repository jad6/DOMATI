//
//  DOMCalibrationMothDetailViewController.m
//  DOMATI
//
//  Created by Jad Osseiran on 11/08/13.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import "DOMCalibrationMothDetailViewController.h"

@interface DOMCalibrationMothDetailViewController ()

@end

@implementation DOMCalibrationMothDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"Data Cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    // Configure the cell...
    cell.textLabel.text = @"DD MM YYYY, HH:MM:SS";

    return cell;
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
