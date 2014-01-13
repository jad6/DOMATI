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
            [error show];
            return nil;
        }
    }
    
    return [dataSubDirectory stringByAppendingPathComponent:[[NSString alloc] initWithFormat:@"%@", self.identifier]];
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
 *  This gives back a negative identifer value which indicates that the 
 *  touch still needs to be synced.
 *
 *  @return the negative identifier value.
 */
+ (NSNumber *)localIdentifier
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults valueForKey:DEFAULTS_NEGATIVE_IDENTIFIER]) {
        [defaults setValue:@(-1) forKey:DEFAULTS_NEGATIVE_IDENTIFIER];
    }
    
    NSInteger decrementNumber = [[defaults valueForKey:DEFAULTS_NEGATIVE_IDENTIFIER] integerValue];
    decrementNumber--;
    [defaults setObject:@(decrementNumber) forKey:DEFAULTS_NEGATIVE_IDENTIFIER];
    [defaults synchronize];
    
    return @(decrementNumber);
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
