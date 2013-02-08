//
//  HotelImageViewController.m
//  iHotels v1.0
//
//  Created by Student14 on 2/1/13.
//  Copyright (c) 2013 Student14. All rights reserved.
//

#import "HotelImageViewController.h"

@interface HotelImageViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *hotelImage;

@end

@implementation HotelImageViewController

@synthesize hotelImage=_hotelImage;
@synthesize image=_image;


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.hotelImage.image = self.image;
}

@end
