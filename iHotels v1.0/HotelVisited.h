//
//  HotelVisited.h
//  iHotels v1.0
//
//  Created by Desislava on 2/3/13.
//  Copyright (c) 2013 Student14. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Friend;

@interface HotelVisited : NSManagedObject

@property (nonatomic, retain) NSNumber * hotelId;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSString * hotelName;
@property (nonatomic, retain) NSNumber * hotelRate;
@property (nonatomic, retain) NSSet *friends;
@end

@interface HotelVisited (CoreDataGeneratedAccessors)

- (void)addFriendsObject:(Friend *)value;
- (void)removeFriendsObject:(Friend *)value;
- (void)addFriends:(NSSet *)values;
- (void)removeFriends:(NSSet *)values;

@end
