//
//  DOMWelcomeViewController.m
//  DOMATI
//
//  Created by Jad Osseiran on 27/01/2014.
//  Copyright (c) 2014 Jad. All rights reserved.
//

#import "DOMWelcomeViewController.h"

#import "DOMNavigationController.h"

@interface DOMWelcomeViewController () <UIAlertViewDelegate>

@end

@implementation DOMWelcomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.toolbarHidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Logic

- (void)presentViewControllerWithIdentifier:(NSString *)identifier withTitle:(NSString *)title
{
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    
    DOMNavigationController *navController = [[DOMNavigationController alloc] initWithRootViewController:controller];
    UIBarButtonItem *closeBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleBordered target:self action:@selector(dismissAction:)];
    [[controller navigationItem] setLeftBarButtonItem:closeBarButton];
    
    if (title) {
        controller.title = title;
    }
    
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)presentViewControllerWithIdentifier:(NSString *)identifier
{
    [self presentViewControllerWithIdentifier:identifier withTitle:nil];
}

#pragma mark - Alert View

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self pcfAction:nil];
    }
    
    if (buttonIndex == 0) {
        [self performSegueWithIdentifier:@"User Info Segue" sender:self];
    }
}

#pragma mark - Actions

- (IBAction)nextAction:(id)sender
{
    UIAlertView *pcfAV = [[UIAlertView alloc] initWithTitle:@"Consent" message:@"By selecting \"I Agree\" you agree to the terms in the Participant Consent Form (PCF) and can proceed with the app." delegate:self cancelButtonTitle:@"I Agree" otherButtonTitles:@"Show PCF", @"Cancel", nil];
    [pcfAV show];
}

- (IBAction)pcfAction:(id)sender
{
    [self presentViewControllerWithIdentifier:@"DOMPCFViewController" withTitle:@"Participant Consent Form"];
}

- (IBAction)pifAction:(id)sender
{
    [self presentViewControllerWithIdentifier:@"DOMPIFViewController" withTitle:@"Participant Information Form"];
}

- (IBAction)moreInfoAction:(id)sender
{
    [self presentViewControllerWithIdentifier:@"DOMProjectSummaryViewController"];
}

- (void)dismissAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
