//
//  DOMTouchData+Extension.m
//  DOMATI
//
//  Created by Jad Osseiran on 2/11/2013.
//  Copyright (c) 2013 Jad. All rights reserved.
//

#import "DOMTouchData+Extension.h"

#import "NSManagedObject+Appulse.h"

#import "DOMDataFile+Extension.h"
#import "DOMUser.h"

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
            [error handle];
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

#pragma mark - Network

- (NSDictionary *)postDictionary
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    dictionary[@"acceleration"] = self.acceleration;
    dictionary[@"duration"] = self.duration;
    dictionary[@"numTouches"] = self.numTouches;
    dictionary[@"radius"] = self.radius;
    dictionary[@"rotation"] = self.rotation;
    dictionary[@"strength"] = self.strength;
    dictionary[@"x"] = self.x;
    dictionary[@"y"] = self.y;
    
    NSMutableArray *rawData = [[NSMutableArray alloc] init];
    for (DOMDataFile *dataFile in self.dataFiles) {
        [rawData addObject:[dataFile postDictionary]];
    }
    dictionary[@"rawData"] = rawData;
    
    dictionary[@"user_id"] = @([DOMUser currentUser].identifier);
    
    return dictionary;
}

@end
