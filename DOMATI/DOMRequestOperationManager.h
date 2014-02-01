//
//  DOMRequestOperationManager.h
//  DOMATI-JSON
//
//  Created by Jad Osseiran on 30/01/2014.
//  Copyright (c) 2014 Jad Osseiran. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface DOMRequestOperationManager : AFHTTPRequestOperationManager

+ (instancetype)sharedManager;

- (void)uploadDataWhenPossible;

@end
