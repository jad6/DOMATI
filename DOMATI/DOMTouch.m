//
//  DOMTouch.m
//  DOMATI
//
//  Created by Jad Osseiran on 6/09/13.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import "DOMTouch.h"

#import "NSObject+Extension.h"

@interface DOMTouch ()

@property (strong, nonatomic) UITouch *touch;

@property (strong, nonatomic) NSDictionary *gyroscopeInfo, *accelerometerInfo, *microphoneInfo;

@property (nonatomic) CGFloat strength, radius, avgStrength;

@property (nonatomic) CGFloat x, y;

@end

@implementation DOMTouch

- (instancetype)initWithTouch:(UITouch *)touch
{
    self = [super init];
    if (self) {
        self.touch = touch;
        
        CGPoint location = [touch locationInView:[UIApplication sharedApplication].keyWindow];
        self.x = location.x;
        self.y = location.y;
        
        // Strictly speaking still not App Store approved.
        self.radius = [[touch valueForKey:@"pathMajorRadius"] floatValue];
    }
    return self;
}

#pragma mark - Object Forwarding

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSMethodSignature *signature = [_touch methodSignatureForSelector:aSelector];
    if (!signature) {
        if ([self respondsToSelector:aSelector])
            return [super methodSignatureForSelector:aSelector];
    }
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    [anInvocation invokeWithTarget:_touch];
}

@end
