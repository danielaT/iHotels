//
//  Friend.h
//  iHotels v1.0
//
//  Created by Desislava on 2/3/13.
//  Copyright (c) 2013 Student14. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class HotelVisited;

@interface Friend : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *reservations;
@property (nonatomic, retain) NSSet *hotelsVisited;
@end

@interface Friend (CoreDataGeneratedAccessors)

- (void)addReservationsObject:(NSManagedObject *)value;
- (void)removeReservationsObject:(NSManagedObject *)value;
- (void)addReservations:(NSSet *)values;
- (void)removeReservations:(NSSet *)values;

- (void)addHotelsVisitedObject:(HotelVisited *)value;
- (void)removeHotelsVisitedObject:(HotelVisited *)value;
- (void)addHotelsVisited:(NSSet *)values;
- (void)removeHotelsVisited:(NSSet *)values;

@end
