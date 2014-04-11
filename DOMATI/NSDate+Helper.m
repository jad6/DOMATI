//
//  NSDate+Helper.m
//  UEC
//
//  Created by Jad Osseiran on 7/02/13.
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

#import "NSDate+Helper.h"

@implementation NSDate (Helper)

#pragma mark - Helper Methods

- (NSDateComponents *)dateComponents
{
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;

    return [[NSCalendar autoupdatingCurrentCalendar] components:unitFlags fromDate:self];
}

- (NSDate *)dateFromComponents:(NSDateComponents *)comps
{
    return [[NSCalendar autoupdatingCurrentCalendar] dateFromComponents:comps];
}

- (NSDate *)dateByAddingUnitsToComps:(void (^)(NSDateComponents *comps))compsBlock
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];

    if (compsBlock)
    {
        compsBlock(comps);
    }
    return [[NSCalendar autoupdatingCurrentCalendar] dateByAddingComponents:comps toDate:self options:0];
}

#pragma mark - Compare Methods

- (BOOL)isBetweenDate:(NSDate *)beginDate andDate:(NSDate *)endDate
{
    if ([self compare:beginDate] == NSOrderedAscending)
    {
        return NO;
    }

    if ([self compare:endDate] == NSOrderedDescending)
    {
        return NO;
    }

    return YES;
}

- (BOOL)isInSameDayAsDate:(NSDate *)date
{
    return [self isBetweenDate:[date beginningOfDay] andDate:[date endOfDay]];
}

- (NSInteger)daysDifferenceToDate:(NSDate *)toDate
{
    unsigned unitFlags = NSDayCalendarUnit;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:unitFlags fromDate:self toDate:toDate options:0];

    return [components day] + 1;
}

#pragma mark - Year Methods

- (NSDate *)startOfCurrentYear
{
    NSDateComponents *comps = [self dateComponents];

    comps.month = 1;
    comps.day = 1;

    return [self dateFromComponents:comps];
}

- (NSDate *)endOfCurrentYear
{
    // Get the number of months till the end of the year.
    NSRange monthsRange = [[NSCalendar currentCalendar] rangeOfUnit:NSMonthCalendarUnit inUnit:NSYearCalendarUnit forDate:self];
    NSInteger numMonthsInYear = monthsRange.length;

    // Save that last month date.
    NSDateComponents *comps = [self dateComponents];
    NSDate *endMonthDate = [self dateByAddingNumberOfMonths:(numMonthsInYear - comps.month)];

    // Get the number of days till the end of the last month.
    NSRange daysRange = [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:endMonthDate];
    NSInteger numDaysInMonth = daysRange.length;

    return [endMonthDate dateByAddingNumberOfDays:(numDaysInMonth - comps.day)];
}

#pragma mark - Day Start & Ends

- (NSDate *)dayWithHour:(NSUInteger)hour
                 minute:(NSUInteger)minute
                 second:(NSUInteger)second
{
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *comps = [[NSCalendar currentCalendar] components:unitFlags fromDate:self];

    comps.hour = hour;
    comps.minute = minute;
    comps.second = second;

    return [[NSCalendar currentCalendar] dateFromComponents:comps];
}

- (NSDate *)beginningOfDay
{
    return [self dayWithHour:0 minute:0 second:0];
}

- (NSDate *)endOfDay
{
    return [self dayWithHour:23 minute:59 second:59];
}

#pragma mark - Adding Methods

- (NSDate *)dateByAddingNumberOfMonths:(NSInteger)months
{
    return [self dateByAddingUnitsToComps:^(NSDateComponents *comps) {
                comps.month = months;
            }];
}

- (NSDate *)dateByAddingNumberOfDays:(NSInteger)days
{
    return [self dateByAddingUnitsToComps:^(NSDateComponents *comps) {
                comps.day = days;
            }];
}

- (NSDate *)dateByAddingNumberOfHours:(NSInteger)hours
{
    return [self dateByAddingUnitsToComps:^(NSDateComponents *comps) {
                comps.hour = hours;
            }];
}

- (NSDate *)dateByAddingNumberOfMinutes:(NSInteger)minutes
{
    return [self dateByAddingUnitsToComps:^(NSDateComponents *comps) {
                comps.minute = minutes;
            }];
}

#pragma mark - Removing Methods

- (NSDate *)dateByRemovingNumberOfMonths:(NSInteger)months
{
    return [self dateByAddingUnitsToComps:^(NSDateComponents *comps) {
                comps.month = -months;
            }];
}

- (NSDate *)dateByRemovingNumberOfDays:(NSInteger)days
{
    return [self dateByAddingUnitsToComps:^(NSDateComponents *comps) {
                comps.day = -days;
            }];
}

- (NSDate *)dateByRemovingNumberOfHours:(NSInteger)hours
{
    return [self dateByAddingUnitsToComps:^(NSDateComponents *comps) {
                comps.hour = -hours;
            }];
}

- (NSDate *)dateByRemovingNumberOfMinutes:(NSInteger)minutes
{
    return [self dateByAddingUnitsToComps:^(NSDateComponents *comps) {
                comps.minute = -minutes;
            }];
}

@end
