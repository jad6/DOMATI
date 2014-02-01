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
static NSString *kTechExpKey = @"DOMUserTechnologyExperienceKey";
static NSString *kAgeKey = @"DOMUserAgeKey";
static NSString *kWeightKey = @"DOMUserWeightKey";
static NSString *kHeightKey = @"DOMUserHeightKey";

@implementation DOMUser

@synthesize identifier = _identifier;
@synthesize profession = _profession;
@synthesize gender = _gender;
@synthesize techExp = _techExp;
@synthesize age = _age;
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
    if (!_keyStore) {
        _keyStore = [NSUbiquitousKeyValueStore defaultStore];
    }
    
    return _keyStore;
}

- (void)keyStoreSetBool:(BOOL)boolean forKey:(NSString *)key
{
    NSUbiquitousKeyValueStore *store = self.keyStore;
    [store setBool:boolean forKey:key];
    [store synchronize];
}

- (void)keyStoreSetValue:(id)value forKey:(NSString *)key
{
    NSUbiquitousKeyValueStore *store = self.keyStore;
    [store setValue:value forKey:key];
    [store synchronize];
}

#pragma mark - Network

- (NSDictionary *)postDictionary
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    dictionary[@"device"] = [[UIDevice currentDevice] model];
    dictionary[@"age"] = @(self.age);
    dictionary[@"gender"] = @(self.gender);
    dictionary[@"weight"] = @(self.weight);
    dictionary[@"height"] = @(self.height);
    dictionary[@"techExp"] = @(self.techExp);
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
        NSNumber *identifier = [self.keyStore valueForKey:kIdentifierKey];
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
        _profession = [self.keyStore valueForKey:kProfessionKey];
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
        _gender = [[self.keyStore valueForKey:kGenderKey] integerValue];
    }
    
    return _gender;
}

- (void)setTechExp:(DOMTechnologyExperience)techExp
{
    if (_techExp != techExp) {
        _techExp = techExp;
    }
    
    [self keyStoreSetValue:@(techExp) forKey:kTechExpKey];
}

- (DOMTechnologyExperience)techExp
{
    if (!_techExp) {
        _techExp = [[self.keyStore valueForKey:kTechExpKey] integerValue];
    }
    
    return _techExp;
}

- (void)setAge:(NSUInteger)age
{
    if (_age != age) {
        _age = age;
    }
    
    [self keyStoreSetValue:@(age) forKey:kAgeKey];
}

- (NSUInteger)age
{
    if (!_age) {
        _age = [[self.keyStore valueForKey:kAgeKey] unsignedIntegerValue];
    }
    
    return _age;
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
        NSNumber *weight = [self.keyStore valueForKey:kWeightKey];
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
        NSNumber *height = [self.keyStore valueForKey:kHeightKey];
        _height = (CGFLOAT_IS_DOUBLE) ? [height doubleValue] : [height floatValue];
    }
    
    return _height;
}

@end
