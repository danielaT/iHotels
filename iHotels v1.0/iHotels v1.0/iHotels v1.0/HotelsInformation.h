//
//  HotelsInformation.h
//  iHotels v1.0
//
//  Created by Student14 on 1/31/13.
//  Copyright (c) 2013 Student14. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotelsInformation : NSObject

-(void) getHotelsForCity:(NSString*)cityName handler:(void (^)(NSArray*))callback;
-(void) getHotel:(int)index handler:(void (^)(NSDictionary*))callback;
-(void) getImagesForHotel:(NSDictionary*)hotel handler:(void (^)(NSArray*))callback;
-(NSDictionary*) getSummaryForHotel:(NSDictionary*)hotel;
-(NSDictionary*) getHotelDetailsForHotel:(NSDictionary*)hotel;
-(NSArray*) getRoomTypesForHotel:(NSDictionary*)hotel;
-(NSDictionary*) getRoomAtIndex:(int)index fromRooms:(NSArray*)rooms;
-(NSArray*) getRoomAmenitiesForRoom:(NSDictionary*)room;
-(NSString*) getProfilePhotoForHotel:(NSDictionary*)hotel;
-(NSArray*) getPropertyAmenitiesForHotel:(NSDictionary*)hotel;

@end
