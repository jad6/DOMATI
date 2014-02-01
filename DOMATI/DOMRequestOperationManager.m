//
//  DOMRequestOperationManager.m
//  DOMATI-JSON
//
//  Created by Jad Osseiran on 30/01/2014.
//  Copyright (c) 2014 Jad Osseiran. All rights reserved.
//

#import "DOMRequestOperationManager.h"

#import "DOMUser.h"
#import "DOMTouchData+Extension.h"
#import "DOMDataFile+Extension.h"

@interface DOMRequestOperationManager ()

@property (nonatomic, strong) NSDictionary *netwrokDict;

@end

@implementation DOMRequestOperationManager

+ (instancetype)sharedManager
{
    static __DISPATCH_ONCE__ DOMRequestOperationManager *singletonObject = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSDictionary *netwrokDict = [[NSDictionary alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"Network" withExtension:@"plist"]];
        NSURL *baseURL = [NSURL URLWithString:netwrokDict[@"baseURL"]];
        
        singletonObject = [[self alloc] initWithBaseURL:baseURL];
        singletonObject.netwrokDict = netwrokDict;
        [singletonObject setSerializer];
    });
    
    return singletonObject;
}

- (void)uploadDataWhenPossible
{
    [self handleReachability];
}

#pragma mark - Authentication

- (void)setSerializer
{
    NSDictionary *netwrokDict = self.netwrokDict;
    
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    [self.requestSerializer clearAuthorizationHeader];
    [self.requestSerializer setAuthorizationHeaderFieldWithUsername:netwrokDict[@"username"] password:netwrokDict[@"password"]];
    
    self.responseSerializer = [AFJSONResponseSerializer serializer];
}

#pragma mark - Reachability

- (void)handleReachability
{
    AFNetworkReachabilityManager *reachbilityManager = [AFNetworkReachabilityManager sharedManager];
    
    [reachbilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
            [self uploadLocalData];
        }
    }];
    
    [reachbilityManager startMonitoring];
}

#pragma mark - Posting

- (NSString *)URLStringFromPath:(NSString *)path
{
    return [[NSString alloc] initWithFormat:@"%@%@", [self.baseURL absoluteString], path];
}

- (void)uploadDataFile:(DOMDataFile *)dataFile
       withTouchDataId:(NSNumber *)touchDataId
{
    NSString *path = [[NSString alloc] initWithFormat:@"data_files.json"];

    [self POST:[self URLStringFromPath:path] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [error handle];
    }];
}

- (void)uploadTouchData:(DOMTouchData *)touchData
{
    NSString *path = [[NSString alloc] initWithFormat:@"touch_data.json"];
    
    [self POST:[self URLStringFromPath:path] parameters:[touchData postDictionary] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"response %@", responseObject);
        //        touchData.identifier =
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [error handle];
    }];
}

- (void)uploadLocalData
{    
    // Check if the user has already been uploaded
    DOMUser *user = [DOMUser currentUser];
    if (user.identifier > 0) {
        [self uploadTouchData:nil];
    } else {
        // No user has been created on the backend so POST the user's info.
        [self POST:[self URLStringFromPath:@"users.json"] parameters:[user postDictionary] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            user.identifier = [responseObject[@"id"] integerValue];
            
            [self uploadTouchData:nil];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [error handle];
        }];
    }
}

@end
