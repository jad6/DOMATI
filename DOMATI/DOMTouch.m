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

@property (strong, nonatomic) NSDictionary *gyroscopeInfo, *accelerometerInfo, *microphoneInfo;

@property (nonatomic) CGFloat strength, radius, avgStrength;
@property (nonatomic) NSTimeInterval duration;

@property (nonatomic) CGFloat x, y;

@end

@implementation DOMTouch

- (id)initWithTouch:(UITouch *)touch duration:(NSTimeInterval)duration
{
    self = [super init];
    if (self) {
        [touch enumeratePropertiesNames:^(NSString *propertyName) {
            [self setValue:[touch valueForKey:propertyName] forKey:propertyName];
        }];
        
        CGPoint location = [touch locationInView:[UIApplication sharedApplication].keyWindow];
        self.x = location.x;
        self.y = location.y;
        
        // Strictly speaking still not App Store approved.
        self.radius = [[touch valueForKey:@"pathMajorRadius"] floatValue];
    }
    return self;
}

@end
