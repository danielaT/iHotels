//
//  HotelDescriptionViewController.m
//  iHotels v1.0
//
//  Created by Student14 on 2/1/13.
//  Copyright (c) 2013 Student14. All rights reserved.
//

#import "HotelDescriptionViewController.h"

#import "UIViewController+iHotelsColorTheme.h"

@interface HotelDescriptionViewController ()

@property (weak, nonatomic) IBOutlet UILabel *checkInTime;
@property (weak, nonatomic) IBOutlet UILabel *checkOutTime;
@property (weak, nonatomic) IBOutlet UILabel *floorsNumber;
@property (weak, nonatomic) IBOutlet UILabel *roomsNumber;
@property (weak, nonatomic) IBOutlet UITextView *hotelPolicy;
@property (weak, nonatomic) IBOutlet UITextView *propertyInformation;

@end

@implementation HotelDescriptionViewController

@synthesize roomsCountStr=_roomsCountStr;
@synthesize roomsNumber = _roomsNumber;
@synthesize hotelPolicy=_hotelPolicy;
@synthesize hotelPolicyStr=_hotelPolicyStr;
@synthesize checkInStr=_checkInStr;
@synthesize checkInTime=_checkInTime;
@synthesize checkOutStr=_checkOutStr;
@synthesize checkOutTime=_checkOutTime;
@synthesize floorsCountStr=_floorsCountStr;
@synthesize floorsNumber=_floorsNumber;
@synthesize propertyInformation=_propertyInformation;
@synthesize propertyInformationStr=_propertyInformationStr;

-(void)viewWillAppear:(BOOL)animated {
    self.roomsNumber.text = [NSString stringWithFormat:@"%d", self.roomsCountStr];
    self.floorsNumber.text = [NSString stringWithFormat:@"%d", self.floorsCountStr];
    self.hotelPolicy.text = self.hotelPolicyStr;
    self.checkInTime.text = self.checkInStr;
    self.checkOutTime.text = self.checkOutStr;
    self.propertyInformation.text = self.propertyInformationStr;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // apply color theme methods
    [self applyiHotelsThemeWithPatternImageName:@"iphone_hotel_pattern"];
    [self configureSubviewsWithPatternImageName:@"iphone_hotel_pattern"];
}

@end
