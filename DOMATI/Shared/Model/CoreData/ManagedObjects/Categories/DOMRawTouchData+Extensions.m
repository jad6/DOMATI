//
//  DOMRawTouchData+Extensions.m
//  DOMATI
//
//  Created by Jad Osseiran on 25/02/2014.
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

#import "DOMRawTouchData+Extensions.h"

#import "DOMTouchData.h"

#import "NSManagedObject+Appulse.h"

@implementation DOMRawTouchData (Extensions)

+ (instancetype)rawTouchDataInContext:(NSManagedObjectContext *)context
                        fromTouchInfo:(NSDictionary *)touchInfo
{
    return [self newEntity:@"DOMRawTouchData" inContext:context idAttribute:@"identifier" value:[self localIdentifier] onInsert:^(DOMRawTouchData *object) {

                object.x = touchInfo[@"x"];
                object.y = touchInfo[@"y"];

                object.radius = touchInfo[@"radius"];

                object.phase = touchInfo[@"phase"];
                object.timestamp = touchInfo[@"timestamp"];
            }];
}

- (NSDictionary *)postDictionary
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];

    dictionary[@"x"] = self.x;
    dictionary[@"y"] = self.y;
    dictionary[@"radius"] = self.radius;
    dictionary[@"phase"] = self.phase;
    dictionary[@"timestamp"] = self.timestamp;

    dictionary[@"touch_datum_id"] = self.touchData.identifier;

    return dictionary;
}

@end
