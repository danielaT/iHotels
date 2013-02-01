//
//  HotelsInformation.m
//  iHotels v1.0
//
//  Created by Student14 on 1/31/13.
//  Copyright (c) 2013 Student14. All rights reserved.
//

#import "HotelsInformation.h"

#import "JsonParser.h"

const int HOTELS_DICTIONARY_CAPACITY = 3;

@interface HotelsInformation()

@property NSMutableDictionary* hotelsInCities;
@property (nonatomic, copy) void (^callback)();
@property NSMutableDictionary* hotelsDetails;
@property JsonParser* jsonParser;

@end

@implementation HotelsInformation

@synthesize hotelsInCities=_hotelsInCities;
@synthesize callback=_callback;
@synthesize hotelsDetails=_hotelsDetails;
@synthesize jsonParser=_jsonParser;

- (id)init
{
    self = [super init];
    if (self) {
        self.hotelsInCities = [[NSMutableDictionary alloc] initWithCapacity:HOTELS_DICTIONARY_CAPACITY];
        self.hotelsDetails = [[NSMutableDictionary alloc] initWithCapacity:HOTELS_DICTIONARY_CAPACITY];
        self.jsonParser = [[JsonParser alloc] init];;
    }
    return self;
}

-(void)getHotelsForCity:(NSString*)cityName handler:(void (^)(NSArray*))callback
{
    self.callback = callback;
    if (![[self.hotelsInCities allKeys] containsObject:cityName]) {
        if ([self.hotelsInCities count] >= HOTELS_DICTIONARY_CAPACITY) {
            [self.hotelsInCities removeObjectForKey:[[self.hotelsInCities allKeys] objectAtIndex:0]];
        }
        [self.jsonParser getJsonForCity:cityName handler:^(NSDictionary* dict) {
            [self.hotelsInCities setValue:dict forKey:cityName];
            [self callbackForCityName:cityName];
        }];
    }
    
   [self callbackForCityName:cityName];
}

-(void) callbackForCityName:(NSString*)name {
    NSDictionary* hotelsInCurrentCityDictionary = [self.hotelsInCities valueForKey:name];
    NSDictionary* hotelListResponseDictionary = [hotelsInCurrentCityDictionary objectForKey:@"HotelListResponse"];
    NSDictionary* hotelListDictionary = [hotelListResponseDictionary objectForKey:@"HotelList"];
    self.callback([hotelListDictionary objectForKey:@"HotelSummary"]);
}

-(void)getHotel:(int)index handler:(void (^)(NSDictionary*))ch {
    self.callback = ch;
    if (![[self.hotelsDetails allKeys] containsObject:[NSString stringWithFormat:@"%d", index]]) {
        if ([self.hotelsDetails count] >= HOTELS_DICTIONARY_CAPACITY) {
            [self.hotelsDetails removeObjectForKey:[[self.hotelsDetails allKeys] objectAtIndex:0]];
        }
        [self.jsonParser getJsonForHotel:index handler:^(NSDictionary* dict) {
            [self.hotelsDetails setValue:dict forKey:[NSString stringWithFormat:@"%d", index]];
            [self callbackForIndex:index];
        }];
    }
    [self callbackForIndex:index];
}

-(void) callbackForIndex:(int)index {
    NSDictionary* hotelInfoResponse = [self.hotelsDetails valueForKey:[NSString stringWithFormat:@"%d", index]];
    NSDictionary* hotelInfo = [hotelInfoResponse objectForKey:@"HotelInformationResponse"];
    self.callback(hotelInfo);
}

@end
