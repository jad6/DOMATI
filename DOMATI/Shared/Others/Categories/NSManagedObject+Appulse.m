//
//  NSManagedObject+Appulse.m
//
//  Created by Jad Osseiran on 10/02/13.
//  Copyright (c) 2013 Appulse. All rights reserved.
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

#import "NSManagedObject+Appulse.h"

@implementation NSManagedObject (Appulse)

+ (id)newEntity:(NSString *)entity
      inContext:(NSManagedObjectContext *)context
    idAttribute:(NSString *)attribute
          value:(id)value
       onInsert:(void (^)(id object))insertBlock {
    id returnedObject = nil;

    NSFetchRequest *fs = [NSFetchRequest fetchRequestWithEntityName:entity];

    fs.predicate = [NSPredicate predicateWithFormat:@"%K = %@", attribute, value];

    if ([context countForFetchRequest:fs error:nil] == 0) {
        returnedObject = [[self alloc] initWithEntity:[self entityInContext:context] insertIntoManagedObjectContext:context];
        [returnedObject setValue:value forKey:attribute];

        if (insertBlock) {
            insertBlock(returnedObject);
        }

        return returnedObject;
    } else {
        fs.fetchLimit = 1;
        id foundObject = [self findFirstByAttribute:attribute value:value inContext:context];

        if (insertBlock) {
            insertBlock(foundObject);
        }

        return foundObject;
    }
}

+ (NSArray *)findAllInContext:(NSManagedObjectContext *)context {
    return [context executeFetchRequest:[self fetchRequestInContext:context] error:nil];
}

+ (NSArray *)findAllByAttribute:(NSString *)attribute
                          value:(id)value
                      inContext:(NSManagedObjectContext *)context {
    return [self fetchRequest:^(NSFetchRequest *fs) {
      fs.predicate = [NSPredicate predicateWithFormat:@"%K = %@", attribute, value];
    } inContext:context];
}

+ (id)findFirstByAttribute:(NSString *)attribute
                     value:(id)value
                 inContext:(NSManagedObjectContext *)context {
    id object = [[self fetchRequest:^(NSFetchRequest *fs) {
      fs.predicate = [NSPredicate predicateWithFormat:@"%K = %@", attribute, value];
      fs.fetchLimit = 1;
    } inContext:context] lastObject];

    return object;
}

+ (NSArray *)fetchRequest:(void (^)(NSFetchRequest *fs))fetchRequestBlock
                inContext:(NSManagedObjectContext *)context {
    NSFetchRequest *fs = [self fetchRequestInContext:context];

    if (fetchRequestBlock) {
        fetchRequestBlock(fs);
    }
    return [context executeFetchRequest:fs error:nil];
}

+ (NSUInteger)countInContext:(NSManagedObjectContext *)context {
    return [context countForFetchRequest:[self fetchRequestInContext:context] error:nil];
}

#pragma mark - Private Methods

+ (NSEntityDescription *)entityInContext:(NSManagedObjectContext *)context {
    return [NSEntityDescription entityForName:NSStringFromClass(self)
                       inManagedObjectContext:context];
}

+ (NSFetchRequest *)fetchRequestInContext:(NSManagedObjectContext *)context {
    NSFetchRequest *fs = [[NSFetchRequest alloc] init];

    fs.entity = [[self class] entityInContext:context];
    return fs;
}

#pragma mark - Identifier

/**
 *  This gives back a negative identifer value which indicates that the
 *  touch still needs to be synced.
 *
 *  @return the negative identifier value.
 */
+ (NSNumber *)localIdentifier {
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

@end
