//
//  HotelsInformation.m
//  iHotels v1.0
//
//  Created by Student14 on 1/31/13.
//  Copyright (c) 2013 Student14. All rights reserved.
//

#import "HotelsInformation.h"

#import "JsonParser.h"

#import "ConnectionStore.h"

NSString* const HOTEL_SUMMARY = @"HotelSummary";
NSString* const HOTEL_IMAGES = @"HotelImages";
NSString* const HOTEL_IMAGE = @"HotelImage";
NSString* const HOTEL_DETAILS = @"HotelDetails";
NSString* const ROOM_TYPES = @"RoomTypes";
NSString* const ROOM_TYPE = @"RoomType";
NSString* const ROOM_AMENITY = @"RoomAmenity";
NSString* const PROPERTY_AMENITIES = @"PropertyAmenities";
NSString* const PROPERTY_AMENITY = @"PropertyAmenity";
NSString* const HOTEL_LIST_RESPONSE = @"HotelListResponse";
NSString* const HOTEL_INFORMATION_RESPONSE = @"HotelInformationResponse";
NSString* const HOTEL_LIST = @"HotelList";
const int HOTELS_DICTIONARY_CAPACITY = 3;

@interface HotelsInformation()

@property NSMutableDictionary* hotelsInCities;
@property NSMutableDictionary* hotelsDetails;
@property (nonatomic, copy) void (^callback)();

@end

@implementation HotelsInformation

@synthesize hotelsInCities=_hotelsInCities;
@synthesize callback=_callback;
@synthesize hotelsDetails=_hotelsDetails;

- (id)init
{
    self = [super init];
    if (self) {
        self.hotelsInCities = [[NSMutableDictionary alloc] initWithCapacity:HOTELS_DICTIONARY_CAPACITY];
        self.hotelsDetails = [[NSMutableDictionary alloc] initWithCapacity:HOTELS_DICTIONARY_CAPACITY];
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
        
        [JsonParser getJsonForCity:cityName handler:^(NSDictionary* dict) {
            [self.hotelsInCities setValue:dict forKey:cityName];
            [self callbackForCityName:cityName];
        }];
    }
    
    [self callbackForCityName:cityName];
}

-(void) callbackForCityName:(NSString*)name {
    NSDictionary* hotelsInCurrentCityDictionary = [self.hotelsInCities valueForKey:name];
    NSDictionary* hotelListResponseDictionary = [hotelsInCurrentCityDictionary objectForKey:HOTEL_LIST_RESPONSE];
    NSDictionary* hotelListDictionary = [hotelListResponseDictionary objectForKey:HOTEL_LIST];
    
    // if there is just one hotel in the selected city
    if ([[[hotelListDictionary objectForKey:HOTEL_SUMMARY] class] isSubclassOfClass:[NSDictionary class]]) {
        [self.hotelsInCities setValue:[[NSArray alloc] initWithObjects:[hotelListDictionary objectForKey:HOTEL_SUMMARY], nil] forKey:name];
        self.callback([self.hotelsInCities objectForKey:name]);
    }
    else {
        self.callback([hotelListDictionary objectForKey:HOTEL_SUMMARY]);
    }
}

-(void)getHotel:(int)index handler:(void (^)(NSDictionary*))callback {
    self.callback = callback;
    if (![[self.hotelsDetails allKeys] containsObject:[NSString stringWithFormat:@"%d", index]]) {
        if ([self.hotelsDetails count] >= HOTELS_DICTIONARY_CAPACITY) {
            [self.hotelsDetails removeObjectForKey:[[self.hotelsDetails allKeys] objectAtIndex:0]];
        }
        [JsonParser getJsonForHotel:index handler:^(NSDictionary* dict) {
            [self.hotelsDetails setValue:dict forKey:[NSString stringWithFormat:@"%d", index]];
            [self callbackForIndex:index];
        }];
    }
    [self callbackForIndex:index];
}

-(void) callbackForIndex:(int)index {
    NSDictionary* hotelInfoResponse = [self.hotelsDetails valueForKey:[NSString stringWithFormat:@"%d", index]];
    NSDictionary* hotelInfo = [hotelInfoResponse objectForKey:HOTEL_INFORMATION_RESPONSE];
    self.callback(hotelInfo);
}

-(void) getImagesForHotel:(NSDictionary*)hotel handler:(void (^)(NSArray*))callback {
    NSArray* imageUrls = [self getImageUrlsForHotel:hotel];
    NSMutableArray* filePaths = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [imageUrls count]; i++) {
        NSURL* url = [NSURL URLWithString:[imageUrls objectAtIndex:i]];
        
        // download and save images in new queue
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            NSData* data = [NSData dataWithContentsOfURL:url];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSURL *cacheDirectoryURL = [[fileManager URLsForDirectory: NSCachesDirectory inDomains: NSUserDomainMask] lastObject];
            NSURL *newURL = [cacheDirectoryURL URLByAppendingPathComponent:[[imageUrls objectAtIndex:i] lastPathComponent]];
            [fileManager createFileAtPath:newURL.path contents:data attributes:nil];
            [filePaths addObject:newURL.path];
            
            // get back to the main queue
            dispatch_async(dispatch_get_main_queue(), ^{
                callback(filePaths);
            });
        });
    }
}

-(NSArray*)getImageUrlsForHotel:(NSDictionary*)hotel {
    NSDictionary* test = [hotel valueForKey:HOTEL_IMAGES];
    NSArray* hotelImagesArray = [test valueForKey:HOTEL_IMAGE];
    NSMutableArray* hotelImageUrls = [[NSMutableArray alloc] init];
    for (int i = 0; i < [hotelImagesArray count]; i++) {
        NSDictionary* dict = [hotelImagesArray objectAtIndex:i];
        [hotelImageUrls addObject:[dict valueForKey:@"url"]];
    }
    return hotelImageUrls;
}

-(NSString*) getProfilePhotoForHotel:(NSDictionary*)hotel {
    NSArray* hotelImagesArray = [[hotel valueForKey:HOTEL_IMAGES] valueForKey:HOTEL_IMAGE];
    if ([hotelImagesArray count] > 0) {
        NSDictionary* hotelImage = [hotelImagesArray objectAtIndex:0];
        return [hotelImage valueForKey:@"thumbnailUrl"];
    }
    return nil;
}

-(NSDictionary*)getSummaryForHotel:(NSDictionary*)hotel {
    return [hotel valueForKey:HOTEL_SUMMARY];
}

-(NSDictionary*) getHotelDetailsForHotel:(NSDictionary*)hotel {
    return [hotel valueForKey:HOTEL_DETAILS];
}

-(NSArray*) getRoomTypesForHotel:(NSDictionary*)hotel {
    NSDictionary* roomTypes = [hotel valueForKey:ROOM_TYPES];
    if (![[[roomTypes valueForKey:ROOM_TYPE] class] isSubclassOfClass:[NSDictionary class]]) {
        return [roomTypes valueForKey:ROOM_TYPE];
    }
    return [[NSArray alloc] init];
}

-(NSDictionary*) getRoomAtIndex:(int)index fromRooms:(NSArray*)rooms {
    return [rooms objectAtIndex:index];
}

-(NSArray*) getRoomAmenitiesForRoom:(NSDictionary*)room {
    
    if (![[[[room valueForKey:@"roomAmenities"] valueForKey:ROOM_AMENITY] class] isSubclassOfClass:[NSDictionary class]]) {
        return [[room valueForKey:@"roomAmenities"] valueForKey:ROOM_AMENITY];
    }
    return [[NSArray alloc] init];
}

-(NSArray*) getPropertyAmenitiesForHotel:(NSDictionary*)hotel {
    if (![[[[hotel valueForKey:PROPERTY_AMENITIES] valueForKey:PROPERTY_AMENITY] class] isSubclassOfClass:[NSDictionary class]]) {
        return [[hotel valueForKey:PROPERTY_AMENITIES] valueForKey:PROPERTY_AMENITY];
    }
    return [[NSArray alloc] init];
}

@end
