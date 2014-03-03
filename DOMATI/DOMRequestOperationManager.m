//
//  DOMRequestOperationManager.m
//  DOMATI-JSON
//
//  Created by Jad Osseiran on 30/01/2014.
//  Copyright (c) 2014 Jad Osseiran. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

#import "DOMRequestOperationManager.h"

#import "DOMCoreDataManager.h"

#import "DOMUser.h"
#import "DOMTouchData+Extension.h"
#import "DOMRawTouchData+Extensions.h"
#import "DOMRawMotionData+Extensions.h"

#import "UIApplication+Extensions.h"

@interface DOMRequestOperationManager ()

@property (nonatomic, strong) NSDictionary *netwrokDict;

@property (nonatomic, strong) UIView *hudView;

@property (nonatomic) BOOL monitoringInternetAccess, uploading;

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

- (void)uploadDataWhenPossibleWithCompletion:(void (^)(BOOL success))completionBlock
                               showHudInView:(UIView *)view
{
    self.hudView = view;
    
    if (!self.monitoringInternetAccess) {
        AFNetworkReachabilityManager *reachbilityManager = [AFNetworkReachabilityManager sharedManager];
        
        __weak __typeof(AFNetworkReachabilityManager *)weakReachbilityManager = reachbilityManager;
        [reachbilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {\
            __strong __typeof(weakReachbilityManager)strongsReachbilityManager = weakReachbilityManager;
            
            if (status == AFNetworkReachabilityStatusReachableViaWiFi ||
                status == AFNetworkReachabilityStatusReachableViaWWAN) {
                
                [UIApplication showLoading:YES];
                
                MBProgressHUD *hud = nil;
                if (self.hudView) {
                    hud = [MBProgressHUD showHUDAddedTo:self.hudView animated:YES];
                    hud.color = [DOMATI_COLOR colorWithAlphaComponent:0.5];
                    hud.labelText = @"Uploading Data...";
                }
                
                self.uploading = YES;
                [self uploadLocalDataWithCompletion:^(NSError *error) {
                    if (error) {
                        [error handle];
                    } else {
                        [[DOMCoreDataManager sharedManager] saveMainContext];
                    }
                    
                    [strongsReachbilityManager stopMonitoring];
                    [UIApplication showLoading:NO];
                    self.monitoringInternetAccess = NO;
                    
                    if (completionBlock) {
                        completionBlock(error == nil);
                    }
                    
                    self.uploading = NO;
                    [hud hide:YES];
                }];
            } else {
                self.monitoringInternetAccess = NO;
                
                if (completionBlock) {
                    completionBlock(NO);
                }
            }
        }];
        
        [reachbilityManager startMonitoring];
        
        self.monitoringInternetAccess = YES;
    }
}

- (void)uploadDataWhenPossibleWithCompletion:(void (^)(BOOL success))completionBlock
{
    [self uploadDataWhenPossibleWithCompletion:completionBlock showHudInView:nil];
}

- (void)uploadDataWhenPossible
{
    [self uploadDataWhenPossibleWithCompletion:nil];
}

#pragma mark - Logic

- (void)uploadUnsyncedRawData:(NSArray *)unsyncedRawData
                 forTouchData:(DOMTouchData *)touchData
                       toPath:(NSString *)path
                   completion:(void (^)(NSError *error))completionBlock
{
    __block NSError *rawDataUploadError = nil;
    
    dispatch_group_t rawDataGroup = dispatch_group_create();
    
    for (id <DOMRawData> rawData in unsyncedRawData) {
        dispatch_group_enter(rawDataGroup);
        [self POST:[self URLStringFromPath:path] parameters:[rawData postDictionary] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            rawData.identifier = responseObject[@"id"];
            
            dispatch_group_leave(rawDataGroup);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            rawDataUploadError = error;
        }];
    }
    
    dispatch_group_notify(rawDataGroup, dispatch_get_main_queue(), ^ {
        if (completionBlock) {
            completionBlock(rawDataUploadError);
        }
    });
}

#pragma mark - Posting

- (NSString *)URLStringFromPath:(NSString *)path
{
    return [[NSString alloc] initWithFormat:@"%@%@", [self.baseURL absoluteString], path];
}

- (void)uploadUnsyncedRawTouchDataForTouchData:(DOMTouchData *)touchData
                                    completion:(void (^)(NSError *error))completionBlock
{
    NSString *path = [[NSString alloc] initWithFormat:@"raw_touch_data.json"];
    [self uploadUnsyncedRawData:[touchData unsyncedRawTouchData]
                   forTouchData:touchData
                         toPath:path
                     completion:completionBlock];
}

- (void)uploadUnsyncedRawMotionDataForTouchData:(DOMTouchData *)touchData
                                     completion:(void (^)(NSError *error))completionBlock
{
    NSString *path = [[NSString alloc] initWithFormat:@"raw_motion_data.json"];
    [self uploadUnsyncedRawData:[touchData unsyncedRawMotionData]
                   forTouchData:touchData
                         toPath:path
                     completion:completionBlock];
}

- (void)uploadUnsyncedTouchDataWithCompletion:(void (^)(NSError *error))completionBlock
{
    NSString *path = [[NSString alloc] initWithFormat:@"touch_data.json"];
    __block NSError *touchDataUploadError = nil;
    
    dispatch_group_t touchDataGroup = dispatch_group_create();
    
    for (DOMTouchData *touchData in [DOMTouchData unsyncedTouchData]) {
        dispatch_group_enter(touchDataGroup);
        dispatch_group_enter(touchDataGroup);
        [self POST:[self URLStringFromPath:path] parameters:[touchData postDictionary] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            touchData.identifier = responseObject[@"id"];
            
            [self uploadUnsyncedRawMotionDataForTouchData:touchData
                                         completion:^(NSError *error) {
                                             dispatch_group_leave(touchDataGroup);
                                         }];
            [self uploadUnsyncedRawTouchDataForTouchData:touchData
                                               completion:^(NSError *error) {
                                                   dispatch_group_leave(touchDataGroup);
                                               }];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            touchDataUploadError = error;
            dispatch_group_leave(touchDataGroup);
        }];
    }
    
    dispatch_group_notify(touchDataGroup, dispatch_get_main_queue(), ^ {
        if (completionBlock) {
            completionBlock(touchDataUploadError);
        }
    });
}

- (void)uploadLocalDataWithCompletion:(void (^)(NSError *error))completionBlock
{    
    // Check if the user has already been uploaded
    DOMUser *user = [DOMUser currentUser];
    if (user.identifier > 0) {
        NSString *path = [[NSString alloc] initWithFormat:@"users/%i.json" , user.identifier];
        
        [self PUT:path parameters:[user postDictionary] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self uploadUnsyncedTouchDataWithCompletion:completionBlock];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (completionBlock) {
                completionBlock(error);
            }
        }];
    } else {
        // No user has been created on the backend so POST the user's info.
        [self POST:[self URLStringFromPath:@"users.json"] parameters:[user postDictionary] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            user.identifier = [responseObject[@"id"] integerValue];
            
            [self uploadUnsyncedTouchDataWithCompletion:completionBlock];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (completionBlock) {
                completionBlock(error);
            }
        }];
    }
}

@end
