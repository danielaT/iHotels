//
//  JsonParser.h
//  iHotels v1.0
//
//  Created by Student14 on 1/31/13.
//  Copyright (c) 2013 Student14. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonParser : NSObject

-(void)getJsonForCity:(NSString*)cityName  handler:(void (^)(NSDictionary*))ch;
-(void)getJsonForHotel:(int)hotelId handler:(void (^)(NSDictionary*))ch;

@end
