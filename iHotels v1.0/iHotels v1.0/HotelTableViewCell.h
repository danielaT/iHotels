//
//  HotelTableViewCell.h
//  iHotels v1.0
//
//  Created by Student14 on 1/31/13.
//  Copyright (c) 2013 Student14. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotelTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *hotelName;
@property (weak, nonatomic) IBOutlet UITextView *hotelDescription;
@property (weak, nonatomic) IBOutlet UIImageView *hotelRating;
@property (weak, nonatomic) IBOutlet UIWebView *hotelImage;

@end
