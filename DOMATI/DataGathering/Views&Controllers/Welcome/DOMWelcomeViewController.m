//
//  DOMWelcomeViewController.m
//  DOMATI
//
//  Created by Jad Osseiran on 27/01/2014.
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

#import "DOMWelcomeViewController.h"

#import "DOMNavigationController.h"

#import "DOMLocalNotificationHelper.h"

@implementation DOMWelcomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // If the app opened due to a local notification skip straight to the
    // calibration screen. Still keep the other view controllers in a
    // navigation stack though.
    if ([DOMLocalNotificationHelper didOpenFromLocalNotification])
    {
        id userInfoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DOMUserInfoViewController"];
        id calibrationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DOMCalibrationViewController"];

        NSMutableArray *viewControllers = [self.navigationController.viewControllers mutableCopy];
        [viewControllers addObjectsFromArray:@[userInfoVC, calibrationVC]];
        [self.navigationController setViewControllers:viewControllers animated:NO];

        self.navigationController.toolbarHidden = YES;

        // Reset the local notifications.
        [DOMLocalNotificationHelper reset];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.navigationController setToolbarHidden:NO
                                       animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [self.navigationController setToolbarHidden:YES
                                       animated:animated];
}

#pragma mark - Logic

/**
 *  Helper method to present a view controller modall with a close button
 *  whose target is this class.
 *
 *  @param identifier the storyboard identifier for the controller.
 *  @param title      the title for the controller.
 */
- (void)presentViewControllerWithIdentifier:(NSString *)identifier withTitle:(NSString *)title
{
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:identifier];

    DOMNavigationController *navController = [[DOMNavigationController alloc] initWithRootViewController:controller];
    UIBarButtonItem *closeBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleBordered target:self action:@selector(dismissAction:)];

    [[controller navigationItem] setLeftBarButtonItem:closeBarButton];

    if (title)
    {
        controller.title = title;
    }

    [self presentViewController:navController animated:YES completion:nil];
}

/**
 *  Helper method to present a titleless view controller modall with a close button
 *  whose target is this class.
 *
 *  @param identifier the storyboard identifier for the controller.
 */
- (void)presentViewControllerWithIdentifier:(NSString *)identifier
{
    [self presentViewControllerWithIdentifier:identifier withTitle:nil];
}

#pragma mark - Alert View

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // If the user has selected to read the PCF present it.
    if (buttonIndex == 1)
    {
        [self pcfAction:nil];
    }

    // Carry on with the user info screen.
    if (buttonIndex == 0)
    {
        [self performSegueWithIdentifier:@"User Info Segue" sender:self];
    }
}

#pragma mark - Actions

/**
 *  Presnents a warning that the app will take some user information.
 *  Useless really, but the ethics rules are the useless rules.
 *
 *  @param sender the sender of the action.
 */
- (IBAction)nextAction:(id)sender
{
    UIAlertView *pcfAV = [[UIAlertView alloc] initWithTitle:@"Consent" message:@"By selecting \"I Agree\" you agree to the terms in the Participant Consent Form (PCF) with UWA HREO ethics approval ref RA/4/1/6642 and can proceed with the app." delegate:self cancelButtonTitle:@"I Agree" otherButtonTitles:@"Show PCF", @"Cancel", nil];

    [pcfAV show];
}

/**
 *  Shows the Participant Consent Form (PCF).
 *
 *  @param sender the sender of the action.
 */
- (IBAction)pcfAction:(id)sender
{
    [self presentViewControllerWithIdentifier:@"DOMPCFViewController" withTitle:@"Participant Consent Form"];
}

/**
 *  Shows the Participant Information Form (PIF).
 *
 *  @param sender the sender of the action.
 */
- (IBAction)pifAction:(id)sender
{
    [self presentViewControllerWithIdentifier:@"DOMPIFViewController" withTitle:@"Participant Information Form"];
}

/**
 *  Shows the thesis porject summary.
 *
 *  @param sender the sender of the action.
 */
- (IBAction)moreInfoAction:(id)sender
{
    [self presentViewControllerWithIdentifier:@"DOMProjectSummaryViewController"];
}

/**
 *  The action which dismisses the modal views which were presented with
 *  presentViewControllerWithIdentifier:withTitle:
 *
 *  @param sender the sender of the action.
 */
- (void)dismissAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
