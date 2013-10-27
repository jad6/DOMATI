//
//  DOMTouchViewController.m
//  DOMATI
//
//  Created by Jad Osseiran on 5/09/13.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import "DOMTouchViewController.h"

#import "NSObject+Extension.h"

#import "DOMTouch.h"

#import "DOMCoreDataManager.h"

@interface DOMTouchViewController ()

@property (nonatomic) BOOL monitoring;

@end

@implementation DOMTouchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    NSLog(@"%@", touches);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
//    NSLog(@"%@", touches);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
//    NSLog(@"%@", touches);
}

@end
