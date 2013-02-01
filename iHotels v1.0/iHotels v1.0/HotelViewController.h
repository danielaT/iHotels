//
//  HotelViewController.h
//  iHotels v1.0
//
//  Created by Student14 on 1/31/13.
//  Copyright (c) 2013 Student14. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotelViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) int hotelId;

@property (weak, nonatomic) IBOutlet UILabel *cityAndPostalCode;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *locationDescription;
@property (weak, nonatomic) IBOutlet UIWebView *hotelImage;
@property (weak, nonatomic) IBOutlet UITableView *hotelMenuTableView;


@end
