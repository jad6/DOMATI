//
//  DOMCalibrationDataViewController.m
//  DOMATI
//
//  Created by Jad Osseiran on 11/08/13.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import "DOMCalibrationDataViewController.h"

#import "UITextView+Sharing.h"

@interface DOMCalibrationDataViewController ()

@property (weak, nonatomic) IBOutlet UITextView * textView;

@end

@implementation DOMCalibrationDataViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.textView.backgroundColor = BACKGROUND_COLOR;
    self.textView.textColor = TEXT_COLOR;
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
