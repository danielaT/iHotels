//
//  HotelTableViewCell.m
//  iHotels v1.0
//
//  Created by Student14 on 1/31/13.
//  Copyright (c) 2013 Student14. All rights reserved.
//

#import "HotelTableViewCell.h"

@implementation HotelTableViewCell

@synthesize hotelDescription=_hotelDescription;
@synthesize hotelName=_hotelName;
@synthesize hotelImage=_hotelImage;
@synthesize hotelRating=_hotelRating;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
