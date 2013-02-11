//
//  JsonParser.m
//  iHotels v1.0
//
//  Created by Student14 on 1/31/13.
//  Copyright (c) 2013 Student14. All rights reserved.
//

#import "JsonParser.h"

#import "ConnectionStore.h"

NSString* const HOTEL_LIST_REQUEST_URL = @"http://api.ean.com/ean-services/rs/hotel/v3/list?cid=55505&apiKey=qzcttg4qwadx4mgrnz2j48tj&minorRev=20&customerUserAgent=iPhone&locale=bg_BG&currencyCode=BGN&countryCode=BG&_type=json&city=";
NSString* const HOTEL_INFO_URL = @"http://api.ean.com/ean-services/rs/hotel/v3/info?cid=55505&apiKey=qzcttg4qwadx4mgrnz2j48tj&minorRev=20&customerUserAgent=iPhone&locale=bg_BG&currencyCode=BGN&countryCode=BG&_type=json&hotelId=";
NSString* const PROPERTY_CATEGORIES = @"propertyCategories";
NSString* const AMENITIES = @"amenities";

@implementation JsonParser

+(void)getJsonForCity:(NSString*)cityName  handler:(void (^)(NSDictionary*))callback{
    
    NSString* stringAppendedWithCityName = [HOTEL_LIST_REQUEST_URL stringByAppendingFormat:@"%@", cityName];
    NSURL* urlForRequest = [NSURL URLWithString:stringAppendedWithCityName];
    [[[ConnectionStore alloc] init] getDataForConnectionWithURL:urlForRequest handler:^(NSData* data) {
        NSError* error;
        callback([NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error]);
    }];
}

+(void)getJsonForHotel:(int)hotelId handler:(void (^)(NSDictionary*))callback {
    NSString* stringAppendedWithHotelId = [HOTEL_INFO_URL stringByAppendingFormat:@"%d", hotelId];
    NSURL* urlForRequest = [NSURL URLWithString:stringAppendedWithHotelId];
    [[[ConnectionStore alloc] init] getDataForConnectionWithURL:urlForRequest handler:^(NSData* data) {
        NSError* error;
        callback([NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error]);
    }];
}

+(void)getJsonForHotelsWithFilter:(NSDictionary*)filter  handler:(void (^)(NSDictionary*))callback {
    // append the city to the url
    NSString* stringAppendedWithFilters = [HOTEL_LIST_REQUEST_URL stringByAppendingFormat:@"%@", [filter valueForKey:@"city"]];
    
    // if there are any selected property categories, append them to the url
    if ([[filter valueForKey:PROPERTY_CATEGORIES] count] > 0) {
        stringAppendedWithFilters = [stringAppendedWithFilters stringByAppendingFormat:@"%@", @"&propertyCategory="];
        for (int i = 0; i < [[filter valueForKey:PROPERTY_CATEGORIES] count]; i++) {
            if (i == [[filter valueForKey:PROPERTY_CATEGORIES] count] - 1) {
               stringAppendedWithFilters = [stringAppendedWithFilters stringByAppendingFormat:@"%@", [[filter valueForKey:PROPERTY_CATEGORIES] objectAtIndex:i]]; 
            } else {
               stringAppendedWithFilters = [stringAppendedWithFilters stringByAppendingFormat:@"%@,", [[filter valueForKey:PROPERTY_CATEGORIES] objectAtIndex:i]]; 
            }
        }
    }
    
    // if there are any selected amenities, append them to the url
    if ([[filter valueForKey:AMENITIES] count] > 0) {
        stringAppendedWithFilters = [stringAppendedWithFilters stringByAppendingFormat:@"%@", @"&amenities="];
        for (int i = 0; i < [[filter valueForKey:AMENITIES] count]; i++) {
            if (i == [[filter valueForKey:AMENITIES] count] - 1) {
                stringAppendedWithFilters = [stringAppendedWithFilters stringByAppendingFormat:@"%@", [[filter valueForKey:AMENITIES] objectAtIndex:i]];
            } else {
                stringAppendedWithFilters = [stringAppendedWithFilters stringByAppendingFormat:@"%@,", [[filter valueForKey:AMENITIES] objectAtIndex:i]];
            }
        }
    }
    
    // append minRate to the url
    if ([[filter valueForKey:@"minRate"] length] > 0) {
        stringAppendedWithFilters = [stringAppendedWithFilters stringByAppendingFormat:@"&minRate=%@", [filter valueForKey:@"minRate"]];
    }
    
    // append maxRate to the url
    if ([[filter valueForKey:@"maxRate"] length] > 0) {
        stringAppendedWithFilters = [stringAppendedWithFilters stringByAppendingFormat:@"&maxRate=%@", [filter valueForKey:@"maxRate"]];
    }
    
    NSURL* urlForRequest = [NSURL URLWithString:stringAppendedWithFilters];
    [[[ConnectionStore alloc] init] getDataForConnectionWithURL:urlForRequest handler:^(NSData* data) {
        NSError* error;
        callback([NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error]);
    }];
}

@end
