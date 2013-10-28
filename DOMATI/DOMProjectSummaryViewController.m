//
//  DOMProjectSummaryViewController.m
//  DOMATI
//
//  Created by Jad Osseiran on 28/10/2013.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import "DOMProjectSummaryViewController.h"

#import "UITextView+Sharing.h"

@interface DOMProjectSummaryViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation DOMProjectSummaryViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)share:(id)sender
{
    [self.textView shareContentInController:self];
}

@end
