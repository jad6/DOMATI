//
//  DOMWelcomeViewController.m
//  DOMATI
//
//  Created by Jad Osseiran on 27/01/2014.
//  Copyright (c) 2014 Jad. All rights reserved.
//

#import "DOMWelcomeViewController.h"

#import "DOMNavigationController.h"

@interface DOMWelcomeViewController ()

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

#pragma mark - Actions

- (void)dismissInfo:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)moreInfo:(id)sender
{
    id controller = [self.storyboard instantiateViewControllerWithIdentifier:@"DOMProjectSummaryViewController"];
    
    DOMNavigationController *navController = [[DOMNavigationController alloc] initWithRootViewController:controller];
    UIBarButtonItem *closeBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleBordered target:self action:@selector(dismissInfo:)];
    [[controller navigationItem] setLeftBarButtonItem:closeBarButton];
    
    [self presentViewController:navController animated:YES completion:nil];
}

@end
