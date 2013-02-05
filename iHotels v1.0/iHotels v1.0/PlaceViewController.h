//
//  PlaceViewController.h
//  iHotels v1.0
//
//  Created by Martin on 05-02-2013.
//  Copyright (c) 2013 Student14. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HotelVisited;

#define DEFAULT_IMAGE_NAME @"Default"

@interface PlaceViewController : UIViewController
@property (nonatomic, strong) HotelVisited* hotel;
@end
