//
//  DOMCalibrationMonthsViewController.m
//  DOMATI
//
//  Created by Jad Osseiran on 11/08/13.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import "DOMCalibrationMonthsViewController.h"

@interface DOMCalibrationMonthsViewController ()

@end

@implementation DOMCalibrationMonthsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Month Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = @"Month, YYYY";
    
    return cell;
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]];
    
    UIViewController *destinationVC = [segue destinationViewController];
    destinationVC.navigationItem.title = selectedCell.textLabel.text;
}

@end
