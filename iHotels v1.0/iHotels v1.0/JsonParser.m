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

@interface JsonParser()

@property NSMutableDictionary* dict;
@property ConnectionStore* connection;

@end

@implementation JsonParser

@synthesize dict=_dict;
@synthesize connection=_connection;

- (id)init
{
    self = [super init];
    if (self) {
        self.connection = [[ConnectionStore alloc] init];
    }
    return self;
}

-(void)getJsonForCity:(NSString*)cityName  handler:(void (^)(NSDictionary*))ch{
    
    NSString* stringAppendedWithCityName = [HOTEL_LIST_REQUEST_URL stringByAppendingFormat:@"%@", cityName];
    NSURL* urlForRequest = [NSURL URLWithString:stringAppendedWithCityName];
    
    [self.connection getDataForConnectionWithURL:urlForRequest handler:^(NSData* data) {
        NSError* error;
        self.dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
      //  NSLog(@"%@", [self.dict description]);
        ch(self.dict);
    }];
}

-(void)getJsonForHotel:(int)hotelId handler:(void (^)(NSDictionary*))ch {
    NSString* stringAppendedWithHotelId = [HOTEL_INFO_URL stringByAppendingFormat:@"%d", hotelId];
    NSURL* urlForRequest = [NSURL URLWithString:stringAppendedWithHotelId];
    [self.connection getDataForConnectionWithURL:urlForRequest handler:^(NSData* data) {
        NSError* error;
        self.dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"%@", [self.dict description]);
        ch(self.dict);
    }];
}

@end
