//
//  DOMInfoViewController.m
//  DOMATI
//
//  Created by Jad Osseiran on 10/08/13.
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

#import <MessageUI/MessageUI.h>

#import "DOMInfoViewController.h"

#import "DOMPreviewItem.h"

@interface DOMInfoViewController () <MFMailComposeViewControllerDelegate, QLPreviewControllerDataSource>

@property (weak, nonatomic) IBOutlet UITableViewCell *feedbackCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *calibrationExpiryCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *projectProposalCell;

@property (strong, nonatomic) DOMPreviewItem *previewItem;

@end

@implementation DOMInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"DOMATI";
    self.feedbackCell.textLabel.textColor = [UIColor domatiColor];
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
    NSString *text = [[NSUbiquitousKeyValueStore defaultStore] objectForKey:KEYSTORE_CALI_EXPR_TEXT];

    if (!text)
    {
        text = @"Never";
    }

    self.calibrationExpiryCell.detailTextLabel.text = text;
}

#pragma mark - Actions

- (IBAction)doneAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Feedback

- (void)sendFeedback:(id)sender
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
        composer.mailComposeDelegate = self;
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
    if (error)
    {
        [error handle];
    }

    [self dismissViewControllerAnimated:YES completion:^{
         [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForCell:self.feedbackCell] animated:YES];
     }];
}

#pragma mark - Quick Look

- (void)showDocumentWithLocalURL:(NSURL *)url andTitle:(NSString *)title
{
    self.previewItem = [[DOMPreviewItem alloc] init];
    self.previewItem.localURL = url;
    self.previewItem.documentTitle = title;
    if ([QLPreviewController canPreviewItem:self.previewItem])
    {
        QLPreviewController *quickLookC = [[QLPreviewController alloc] init];
        quickLookC.dataSource = self;

        [self.navigationController pushViewController:quickLookC animated:YES];
    }
}

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller
{
    return 1;
}

- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index;
{
    return self.previewItem;
}

#pragma mark - Table view

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id cell = [tableView cellForRowAtIndexPath:indexPath];

    if ([cell isEqual:self.feedbackCell])
    {
        [self sendFeedback:cell];
    }
    else if ([cell isEqual:self.projectProposalCell])
    {
        [self showDocumentWithLocalURL:[[NSBundle mainBundle] URLForResource:@"Project Proposal" withExtension:@"pdf"]
                              andTitle:@"Project Proposal"];
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
