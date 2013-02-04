//
//  Reservation.m
//  iHotels v1.0
//
//  Created by Desislava on 2/3/13.
//  Copyright (c) 2013 Student14. All rights reserved.
//

#import "Reservation.h"
#import "Friend.h"


@implementation Reservation

@dynamic days;
@dynamic hotelId;
@dynamic startDate;
@dynamic hotelName;
@dynamic friends;

- (BOOL) isVisited
{
    NSDate *dateNow = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:self.days.intValue];
    
    NSDate *dateAfterTheTrip = [[NSCalendar currentCalendar]
                                dateByAddingComponents:dateComponents
                                toDate:self.startDate options:0];
    
    if ([dateNow compare:dateAfterTheTrip] == NSOrderedDescending) {
        NSLog(@"datenow: %@", dateNow);
        NSLog(@"dateafter: %@", dateAfterTheTrip);
        
        NSLog(@"datenow is later than dateAfterTrip");
        return YES;
        
    } else if ([dateNow compare:dateAfterTheTrip] == NSOrderedAscending) {
        NSLog(@"datenow: %@", dateNow);
        NSLog(@"dateafter: %@", dateAfterTheTrip);
        NSLog(@"datenow is earlier than dateAfterTrip");
        return NO;
        
    } else {
        NSLog(@"dates are the same");
        return YES;
    }
}

@end
