//
//  NSObject+Extension.h
//  DOMATI
//
//  Created by Jad Osseiran on 6/09/13.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Extension)

- (void)enumeratePropertiesNames:(void (^)(NSString *propertyName))propertyNameBlock;

- (NSString *)pointerStr;

@end
