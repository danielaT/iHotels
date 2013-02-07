//
//  Reservation.h
//  iHotels v1.0
//
//  Created by Desislava on 2/7/13.
//  Copyright (c) 2013 Student14. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Friend;

@interface Reservation : NSManagedObject

@property (nonatomic, retain) NSNumber * days;
@property (nonatomic, retain) NSString * hotelId;
@property (nonatomic, retain) NSString * hotelName;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSSet *friends;
@end

@interface Reservation (CoreDataGeneratedAccessors)

- (void)addFriendsObject:(Friend *)value;
- (void)removeFriendsObject:(Friend *)value;
- (void)addFriends:(NSSet *)values;
- (void)removeFriends:(NSSet *)values;

- (BOOL) isVisited;

@end
