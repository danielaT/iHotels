//
//  HotelsInformation.h
//  iHotels v1.0
//
//  Created by Student14 on 1/31/13.
//  Copyright (c) 2013 Student14. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotelsInformation : NSObject

-(void)getHotelsForCity:(NSString*)cityName handler:(void (^)(NSArray*))ch;
-(void)getHotel:(int)index handler:(void (^)(NSDictionary*))ch;

@end
