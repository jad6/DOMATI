//
//  DOMTouchData+Extension.m
//  DOMATI
//
//  Created by Jad Osseiran on 2/11/2013.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import "DOMTouchData+Extension.h"

#import "NSManagedObject+Appulse.h"

#import "DOMDataFile.h"

@implementation DOMTouchData (Extension)

- (NSString *)filePathForKind:(DOMDataFileKind)kind
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dataDirectory = [[paths firstObject] stringByAppendingPathComponent:@"Data"];
    
    NSString *subDirName = nil;
    switch (kind) {
        case DOMDataFileKindMotion:
            subDirName = @"Motions";
            break;
            
        case DOMDataFileKindTouch:
            subDirName = @"Touches";
            break;
            
        default:
            break;
    }
    NSString *dataSubDirectory = [dataDirectory stringByAppendingPathComponent:subDirName];
    
    NSError *error = nil;
    if (![fileManager fileExistsAtPath:dataSubDirectory]) {
        if (![fileManager createDirectoryAtPath:dataSubDirectory
                    withIntermediateDirectories:YES
                                     attributes:nil
                                          error:&error]) {
            NSLog(@"%@", error);
            return nil;
        }
    }
    
    return [dataSubDirectory stringByAppendingPathComponent:self.identifier];
}

- (DOMDataFile *)dataFileWithKind:(DOMDataFileKind)kind
{
    __block DOMDataFile *dataFile = nil;
    [self.dataFiles enumerateObjectsUsingBlock:^(DOMDataFile *dataFile, BOOL *stop) {
        if ([dataFile.kind integerValue] == kind) {
            dataFile = dataFile;
            *stop = YES;
        }
    }];
    
    if (!dataFile) {
        NSString *dataFilePath = [self filePathForKind:kind];
        if (dataFilePath) {
            dataFile = [DOMDataFile newEntity:@"DOMDataFile"
                                    inContext:[self managedObjectContext]
                                  idAttribute:@"path"
                                        value:dataFilePath
                                     onInsert:^(DOMDataFile *object) {
                                         object.kind = @(kind);
                                         object.touchData = self;
                                     }];
        }
    }
    
    return dataFile;
}

#pragma mark - Public

/**
 *  Watch out as when the app does get run from fresh the counter will start at zero again.
 *
 *  @return unique identifier on that device only
 */
+ (NSString *)uniqueIndentifier
{
    NSString *udid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults valueForKey:DEFAULTS_UDID_TOUCH_DATA_VALUE_KEY]) {
        [defaults setValue:@(0) forKey:DEFAULTS_UDID_TOUCH_DATA_VALUE_KEY];
    }
    
    NSInteger incrementNuumber = [[defaults valueForKey:DEFAULTS_UDID_TOUCH_DATA_VALUE_KEY] integerValue];
    incrementNuumber++;
    [defaults setObject:@(incrementNuumber) forKey:DEFAULTS_UDID_TOUCH_DATA_VALUE_KEY];
    [defaults synchronize];
    
    return [udid stringByAppendingFormat:@"%i", incrementNuumber];
}

- (DOMDataFile *)motionDataFile
{
    return [self dataFileWithKind:DOMDataFileKindMotion];
}

- (DOMDataFile *)touchDataFile
{
    return [self dataFileWithKind:DOMDataFileKindTouch];
}

@end
