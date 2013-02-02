//
//  HotelDescriptionViewController.h
//  iHotels v1.0
//
//  Created by Student14 on 2/1/13.
//  Copyright (c) 2013 Student14. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotelDescriptionViewController : UIViewController

@property (nonatomic, weak) NSString* hotelPolicyStr;
@property (nonatomic, weak) NSString* propertyInformationStr;
@property (nonatomic, weak) NSString* checkInStr;
@property (nonatomic, weak) NSString* checkOutStr;
@property (nonatomic) int roomsCountStr;
@property (nonatomic) int floorsCountStr;

@end
