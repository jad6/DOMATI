//
//  DOMTouch.h
//  DOMATI
//
//  Created by Jad Osseiran on 6/09/13.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DOMTouch : UITouch

@property (strong, nonatomic, readonly) NSDictionary *gyroscopeInfo, *accelerometerInfo, *microphoneInfo;

@property (nonatomic, readonly) CGFloat strength, radius, avgStrength;
@property (nonatomic, readonly) NSTimeInterval duration;

// Always in relation to the UIWindow.
@property (nonatomic, readonly) CGFloat x, y;

- (instancetype)initWithTouch:(UITouch *)touch;

@end
