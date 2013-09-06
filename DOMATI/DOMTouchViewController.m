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

@property (strong, nonatomic) CADisplayLink *displayLink;

@property (strong, nonatomic) NSMutableDictionary *touchesTimestamps;

@property (nonatomic) BOOL monitoring;

@end

@implementation DOMTouchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:nil
                                                   selector:nil];
    self.touchesTimestamps = [[NSMutableDictionary alloc] init];
}

#pragma mark - Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%@", [touches anyObject]);
    
    [touches enumerateObjectsUsingBlock:^(UITouch *touch, BOOL *stop) {
        self.touchesTimestamps[[touch pointerStr]] = @(touch.timestamp);
    }];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [touches enumerateObjectsUsingBlock:^(UITouch *touch, BOOL *stop) {
        [self.touchesTimestamps removeObjectForKey:[touch pointerStr]];
    }];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%@", [touches anyObject]);
    
}

@end
