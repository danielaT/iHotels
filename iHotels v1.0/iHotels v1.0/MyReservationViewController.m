//
//  MyReservationViewController.m
//  iHotels v1.0
//
//  Created by Desislava on 2/3/13.
//  Copyright (c) 2013 Student14. All rights reserved.
//

#import "MyReservationViewController.h"
#import "HotelsInformation.h"
#import "UIViewController+iHotelsColorTheme.h"


@interface MyReservationViewController ()

@property NSArray* hotelListArray;

@end

@implementation MyReservationViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.reservationName setText:self.stringName];
    [self.reservationDays setText:self.stringDays];
    [self.reservationDate setText:[self.stringDate substringToIndex:10]];
    
    [UIView animateWithDuration:2.0
                          delay:0.0
                        options: UIViewAnimationCurveEaseInOut
                     animations:^{
                         [self.nameView setAlpha:1.0f];
                         
                     }
                     completion:^(BOOL finished){
                         if(finished)  NSLog(@"Finished !!!!!");
                                             // do any stuff here if you want
                                             }];


    // apply color theme methods
    [self applyiHotelsThemeWithPatternImageName:@"iphone_reservation_pattern"];
    [self configureSubviews];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
