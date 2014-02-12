//
//  DOMUser.m
//  DOMATI
//
//  Created by Jad Osseiran on 28/01/2014.
//  Copyright (c) 2014 Jad. All rights reserved.
//

#import "DOMUser.h"

@interface DOMUser ()

@property (nonatomic, strong) NSUbiquitousKeyValueStore *keyStore;

@end

@implementation DOMUser

+ (instancetype)currentUser
{
    static __DISPATCH_ONCE__ id singletonObject = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singletonObject = [[self alloc] init];
    });
    
    return singletonObject;
}

#pragma mark - Ubiquitous Key Value Store

- (NSUbiquitousKeyValueStore *)keyStore
{
    if (!self->_keyStore) {
        self->_keyStore = [NSUbiquitousKeyValueStore defaultStore];
    }
    
    return self->_keyStore;
}

- (void)keyStoreSetValue:(id)value forKey:(NSString *)key
{
    NSUbiquitousKeyValueStore *store = self.keyStore;
    [store setObject:value forKey:key];
    [store synchronize];
}

#pragma mark - Refresh

/**
 *  There must be a better way of doing this...
 */
+ (void)refreshCurrentUser
{
    DOMUser *user = [self currentUser];
    
    user.birthYear = user.birthYear;
    user.gender = user.gender;
    user.weight = user.weight;
    user.height = user.height;
    user.profession = user.profession;
}

#pragma mark - Network

- (NSDictionary *)postDictionary
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    dictionary[@"device"] = [[UIDevice currentDevice] model];
    dictionary[@"birthYear"] = @(self.birthYear);
    dictionary[@"gender"] = @(self.gender);
    dictionary[@"weight"] = @(self.weight);
    dictionary[@"height"] = @(self.height);
    dictionary[@"profession"] = self.profession;
    
    return dictionary;
}

@end
