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
@property (weak, nonatomic) IBOutlet UILabel *propertyInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *hotelPolicyLabel;

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

-(void)viewDidAppear:(BOOL)animated
{
    UIInterfaceOrientation orientation = [[UIDevice currentDevice] orientation];
    [self rearrangeViewsInOrientation:orientation];
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self rearrangeViewsInOrientation:toInterfaceOrientation];
}

-(void) rearrangeViewsInOrientation:(UIInterfaceOrientation) orientation
{
    [UIView animateWithDuration:0.3 animations:^{
        if (orientation == UIInterfaceOrientationLandscapeRight || orientation == UIInterfaceOrientationLandscapeLeft) {
            
            if([[UIScreen mainScreen] bounds].size.height == 568.0)
            {
                // iphone 4.0 inch screen
                self.hotelPolicyLabel.frame = CGRectMake(280, 10, 280, self.hotelPolicyLabel.frame.size.height);
                self.hotelPolicy.frame = CGRectMake(280, 35, 280, self.hotelPolicy.frame.size.height);
                self.propertyInfoLabel.frame = CGRectMake(280, 115, 280, self.propertyInfoLabel.frame.size.height);
                self.propertyInformation.frame = CGRectMake(280, 140, 280, self.propertyInformation.frame.size.height);
            }
            else
            {
                // iphone 3.5 inch screen
                self.hotelPolicyLabel.frame = CGRectMake(260, 10, 220, self.hotelPolicyLabel.frame.size.height);
                self.hotelPolicy.frame = CGRectMake(260, 35, 220, self.hotelPolicy.frame.size.height);
                self.propertyInfoLabel.frame = CGRectMake(260, 115, 220, self.propertyInfoLabel.frame.size.height);
                self.propertyInformation.frame = CGRectMake(260, 140, 220, self.propertyInformation.frame.size.height);
            }
        }
    }];
}

@end
