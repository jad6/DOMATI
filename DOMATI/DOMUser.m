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

static NSString *kIdentifierKey = @"DOMUserIdentifierKey";
static NSString *kProfessionKey = @"DOMUserProfessionKey";
static NSString *kGenderKey = @"DOMUserGenderKey";
static NSString *kBirthYearKey = @"DOMUserBirthYearKey";
static NSString *kWeightKey = @"DOMUserWeightKey";
static NSString *kHeightKey = @"DOMUserHeightKey";

@implementation DOMUser

@synthesize identifier = _identifier;
@synthesize profession = _profession;
@synthesize gender = _gender;
@synthesize birthYear = _birthYear;
@synthesize weight = _weight;
@synthesize height = _height;

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
    
    user.identifier = user.identifier;
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
    
    dictionary[@"birth_year"] = @(self.birthYear);
    dictionary[@"gender"] = @(self.gender);
    dictionary[@"weight"] = @(self.weight);
    dictionary[@"height"] = @(self.height);
    dictionary[@"profession"] = self.profession;
    
    return dictionary;
}

#pragma mark - Setters & Getters

- (void)setIdentifier:(NSInteger)identifier
{
    if (!_identifier != identifier) {
        _identifier = identifier;
    }
    
    [self keyStoreSetValue:@(identifier) forKey:kIdentifierKey];
}

- (NSInteger)identifier
{
    if (!_identifier) {
        NSNumber *identifier = [self.keyStore objectForKey:kIdentifierKey];
        _identifier = (identifier) ? [identifier integerValue] : -1;
    }
    
    return _identifier;
}

- (void)setProfession:(NSString *)profession
{
    if (_profession != profession) {
        _profession = profession;
        
        [self keyStoreSetValue:profession forKey:kProfessionKey];
    }
}

- (NSString *)profession
{
    if (!_profession) {
        _profession = [self.keyStore objectForKey:kProfessionKey];
    }
    
    return _profession;
}

- (void)setGender:(DOMGender)gender
{
    if (_gender != gender) {
        _gender = gender;
    }
    
    [self keyStoreSetValue:@(gender) forKey:kGenderKey];
}

- (DOMGender)gender
{
    if (!_gender) {
        _gender = [[self.keyStore objectForKey:kGenderKey] integerValue];
    }
    
    return _gender;
}

- (void)setBirthYear:(NSUInteger)age
{
    if (_birthYear != age) {
        _birthYear = age;
    }
    
    [self keyStoreSetValue:@(age) forKey:kBirthYearKey];
}

- (NSUInteger)birthYear
{
    if (!_birthYear) {
        _birthYear = [[self.keyStore objectForKey:kBirthYearKey] unsignedIntegerValue];
    }
    
    return _birthYear;
}

- (void)setWeight:(CGFloat)weight
{
    if (_weight != weight) {
        _weight = weight;
    }
    
    [self keyStoreSetValue:@(weight) forKey:kWeightKey];
}

- (CGFloat)weight
{
    if (!_weight) {
        NSNumber *weight = [self.keyStore objectForKey:kWeightKey];
        _weight = (CGFLOAT_IS_DOUBLE) ? [weight doubleValue] : [weight floatValue];
    }
    
    return _weight;
}

- (void)setHeight:(CGFloat)height
{
    if (_height != height) {
        _height = height;
    }
    
    [self keyStoreSetValue:@(height) forKey:kHeightKey];
}

- (CGFloat)height
{
    if (!_height) {
        NSNumber *height = [self.keyStore objectForKey:kHeightKey];
        _height = (CGFLOAT_IS_DOUBLE) ? [height doubleValue] : [height floatValue];
    }
    
    return _height;
}

@end
