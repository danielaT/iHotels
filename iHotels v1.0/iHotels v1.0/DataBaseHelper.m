//
//  DataBaseHelper.m
//  iHotels v1.0
//
//  Created by Student14 on 2/9/13.
//  Copyright (c) 2013 Student14. All rights reserved.
//

#import "DataBaseHelper.h"
#import "Reservation.h"
#import "HotelVisited.h"
#import "AppDelegate.h"

@implementation DataBaseHelper

+(void)moveReservationsToVisitedPlaces
{
    NSError *error;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Reservation"];
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    NSArray* reservations = [delegate.managedObjectContext executeFetchRequest:request error:&error];

    for (Reservation* res in reservations)
    {
        if (res.isVisited == YES)
        {
            HotelVisited *hotelVisited = [NSEntityDescription insertNewObjectForEntityForName:@"HotelVisited" inManagedObjectContext:delegate.managedObjectContext];
            hotelVisited.startDate = res.startDate;
            hotelVisited.hotelImage = res.hotelImage;
            hotelVisited.hotelName = res.hotelName;
            hotelVisited.friends = res.friends;
            hotelVisited.hotelRate = res.hotelRate;
            //delete reservation from database
            [delegate.managedObjectContext deleteObject:res];
        }
    }
    
    [delegate.managedObjectContext save:&error];
    
    //    NSFetchRequest *request2 = [[NSFetchRequest alloc] initWithEntityName:@"Friend"];
    //    NSArray* orders2 = [self.managedObjectContext executeFetchRequest:request2 error:&error1];
    //
    //    for(Friend* fr in orders2)
    //    {
    //        NSLog(@"fr: %@",fr.name);
    //    }
}

+(NSArray*) reloadVisitedPlaces
{
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = delegate.managedObjectContext;
    NSError *error;
    NSFetchRequest *request1 = [[NSFetchRequest alloc] initWithEntityName:@"HotelVisited"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startDate" ascending:YES];
    request1.sortDescriptors = @[sortDescriptor];
    return [context executeFetchRequest:request1 error:&error];
}

+(NSArray*) reloadReservations
{
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = delegate.managedObjectContext;
    NSError *error;
    NSFetchRequest *request1 = [[NSFetchRequest alloc] initWithEntityName:@"Reservation"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc ]initWithKey:@"startDate" ascending:YES];
    request1.sortDescriptors = @[sortDescriptor];
    return [context executeFetchRequest:request1 error:&error];
}

+ (NSArray*) getHotels
{
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = delegate.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"HotelVisited"];
    NSSortDescriptor *descriptor =[[NSSortDescriptor alloc] initWithKey:@"startDate" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:descriptor];
    NSError *error;
    if (error) {
        NSLog(@"Error fetching: %@", error);
    }
    
    return [context executeFetchRequest:request error:&error];
}

+(void) saveContext {
    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    NSError* error;
    if (![delegate.managedObjectContext save:&error])
    {
        NSLog(@"error updating photo path: %@", error.localizedDescription);
    }
}

@end
