//
//  DataBaseHelper.h
//  iHotels v1.0
//
//  Created by Student14 on 2/9/13.
//  Copyright (c) 2013 Student14. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataBaseHelper : NSObject

+(void) moveReservationsToVisitedPlaces;
+(NSArray*) reloadVisitedPlaces;
+(NSArray*) reloadReservations;
+(NSArray*) getHotels;
+(void) saveContext;
+(NSArray*) getAllCitiesFromPlist;
+(NSArray*) sortArray:(NSArray*)array;

@end
