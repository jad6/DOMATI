//
//  DOMInfoViewController.m
//  DOMATI
//
//  Created by Jad Osseiran on 10/08/13.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import <MessageUI/MessageUI.h>

#import "DOMInfoViewController.h"

@interface DOMInfoViewController () <MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableViewCell *feedbackCell, *calibrationExpiryCell;

@end

@implementation DOMInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.feedbackCell.textLabel.textColor = TINT_COLOR;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self refreshCalibrationExpiryText];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Logic

- (void)refreshCalibrationExpiryText
{
    NSString *text = [[NSUserDefaults standardUserDefaults] valueForKey:DEFAULTS_CALI_EXPR_TEXT];
    
    if (!text) {
        text = @"Never";
    }
    
    self.calibrationExpiryCell.detailTextLabel.text = text;
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Feedback

- (void)feedback:(id)sender
{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
        composer.mailComposeDelegate = self;
        composer.view.tintColor = TINT_COLOR;
        [composer setToRecipients:@[@"20507033@student.uwa.edu.au"]];
        [composer setSubject:@"DOMATI Feedback"];
        [composer setMessageBody:@"Something constructive right here..." isHTML:NO];
        
        [self presentViewController:composer animated:YES completion:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:^{
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForCell:self.feedbackCell] animated:YES];
    }];
}

#pragma mark - Table view

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell isEqual:self.feedbackCell]) {
        [self feedback:cell];
    }
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
