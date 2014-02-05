//
//  DOMUser.h
//  DOMATI
//
//  Created by Jad Osseiran on 28/01/2014.
//  Copyright (c) 2014 Jad. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DOMGender) {
    DOMGenderUndisclosed,
    DOMGenderMale,
    DOMGenderFemale
};

typedef NS_ENUM(NSInteger, DOMTechnologyExperience) {
    DOMTechnologyExperienceUndisclosed,
    DOMTechnologyExperienceNovice,
    DOMTechnologyExperienceIntermediate,
    DOMTechnologyExperienceExperienced,
    DOMTechnologyExperienceAdvanced
};

@interface DOMUser : NSObject

@property (nonatomic, strong) NSString *profession;

@property (nonatomic) DOMGender gender;
@property (nonatomic) DOMTechnologyExperience techExp;

@property (nonatomic) NSInteger identifier;
@property (nonatomic) NSUInteger birthYear;
@property (nonatomic) CGFloat weight, height;

+ (instancetype)currentUser;
- (NSDictionary *)postDictionary;

@end