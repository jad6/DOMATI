//
//  DOMUser.m
//  DOMATI
//
//  Created by Jad Osseiran on 28/01/2014.
//  Copyright (c) 2014 Jad. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer. Redistributions in binary
//  form must reproduce the above copyright notice, this list of conditions and
//  the following disclaimer in the documentation and/or other materials
//  provided with the distribution. Neither the name of the nor the names of
//  its contributors may be used to endorse or promote products derived from
//  this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.

#import "DOMUser.h"

@interface DOMUser ()

@property (nonatomic, strong) NSUbiquitousKeyValueStore *keyStore;

@end

static NSString *kIdentifierKey = @"DOMUserIdentifierKey";
static NSString *kOccupationKey = @"DOMUserOccupationKey";
static NSString *kGenderKey = @"DOMUserGenderKey";
static NSString *kBirthYearKey = @"DOMUserBirthYearKey";
static NSString *kWeightKey = @"DOMUserWeightKey";
static NSString *kHeightKey = @"DOMUserHeightKey";

@implementation DOMUser

@synthesize identifier = _identifier;
@synthesize occupation = _occupation;
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
    if (!self->_keyStore)
    {
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
    user.occupation = user.occupation;
}

#pragma mark - Network

- (NSDictionary *)postDictionary
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];

    dictionary[@"birth_year"] = @(self.birthYear);
    dictionary[@"gender"] = @(self.gender);
    dictionary[@"weight"] = @(self.weight);
    dictionary[@"height"] = @(self.height);
    dictionary[@"occupation"] = self.occupation;

    return dictionary;
}

#pragma mark - Setters & Getters

- (void)setIdentifier:(NSInteger)identifier
{
    if (!self->_identifier != identifier)
    {
        self->_identifier = identifier;
    }

    [self keyStoreSetValue:@(identifier) forKey:kIdentifierKey];
}

- (NSInteger)identifier
{
    if (!self->_identifier)
    {
        NSNumber *identifier = [self.keyStore objectForKey:kIdentifierKey];
        self->_identifier = [identifier integerValue];
    }

    return self->_identifier;
}

- (void)setOccupation:(NSString *)occupation
{
    if (self->_occupation != occupation)
    {
        self->_occupation = occupation;

        [self keyStoreSetValue:occupation forKey:kOccupationKey];
    }
}

- (NSString *)occupation
{
    if (!self->_occupation)
    {
        self->_occupation = [self.keyStore objectForKey:kOccupationKey];
    }

    return self->_occupation;
}

- (void)setGender:(DOMGender)gender
{
    if (self->_gender != gender)
    {
        self->_gender = gender;
    }

    [self keyStoreSetValue:@(gender) forKey:kGenderKey];
}

- (DOMGender)gender
{
    if (!self->_gender)
    {
        self->_gender = [[self.keyStore objectForKey:kGenderKey] integerValue];
    }

    return self->_gender;
}

- (void)setBirthYear:(NSUInteger)age
{
    if (self->_birthYear != age)
    {
        self->_birthYear = age;
    }

    [self keyStoreSetValue:@(age) forKey:kBirthYearKey];
}

- (NSUInteger)birthYear
{
    if (!self->_birthYear)
    {
        self->_birthYear = [[self.keyStore objectForKey:kBirthYearKey] unsignedIntegerValue];
    }

    return self->_birthYear;
}

- (void)setWeight:(CGFloat)weight
{
    if (self->_weight != weight)
    {
        self->_weight = weight;
    }

    [self keyStoreSetValue:@(weight) forKey:kWeightKey];
}

- (CGFloat)weight
{
    if (!self->_weight)
    {
        NSNumber *weight = [self.keyStore objectForKey:kWeightKey];
        self->_weight = TO_CGFLOAT(weight);
    }

    return self->_weight;
}

- (void)setHeight:(CGFloat)height
{
    if (self->_height != height)
    {
        self->_height = height;
    }

    [self keyStoreSetValue:@(height) forKey:kHeightKey];
}

- (CGFloat)height
{
    if (!self->_height)
    {
        NSNumber *height = [self.keyStore objectForKey:kHeightKey];
        self->_height = TO_CGFLOAT(height);
    }

    return self->_height;
}

@end
