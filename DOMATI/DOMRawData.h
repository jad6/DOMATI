//
//  DOMRawData.h
//  DOMATI
//
//  Created by Jad Osseiran on 25/02/2014.
//  Copyright (c) 2014 Jad. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DOMRawData <NSObject>

@property (nonatomic, strong) NSNumber *identifier;

- (NSDictionary *)postDictionary;

@end
