//
//  Reservation.m
//  iHotels v1.0
//
//  Created by Desislava on 2/7/13.
//  Copyright (c) 2013 Student14. All rights reserved.
//

#import "Reservation.h"
#import "Friend.h"


@implementation Reservation

@dynamic days;
@dynamic hotelId;
@dynamic hotelName;
@dynamic startDate;
@dynamic friends;

- (BOOL) isVisited
{
    NSDate *dateNow = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:self.days.intValue];
    
    NSDate *dateAfterTheTrip = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self.startDate options:0];
    
    if ([dateNow compare:dateAfterTheTrip] == NSOrderedDescending)
    {
        return YES;
    }
    else if ([dateNow compare:dateAfterTheTrip] == NSOrderedAscending)
    {
        return NO;
    } else
    {
        return YES;
    }
}

@end
