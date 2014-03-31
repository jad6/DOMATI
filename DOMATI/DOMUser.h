//
//  DOMUser.h
//  DOMATI
//
//  Created by Jad Osseiran on 28/01/2014.
//  Copyright (c) 2014 Jad. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSInteger, DOMGender) {
    DOMGenderUndisclosed,
    DOMGenderMale,
    DOMGenderFemale
};

@interface DOMUser : NSObject

@property (nonatomic, strong) NSString * occupation;

@property (nonatomic) DOMGender gender;

@property (nonatomic) NSInteger identifier;
@property (nonatomic) NSUInteger birthYear;
@property (nonatomic) CGFloat weight, height;

+ (instancetype)currentUser;

+ (void)refreshCurrentUser;

- (NSDictionary *)postDictionary;

@end
