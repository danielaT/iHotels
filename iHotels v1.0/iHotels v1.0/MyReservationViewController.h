//
//  MyReservationViewController.h
//  iHotels v1.0
//
//  Created by Desislava on 2/3/13.
//  Copyright (c) 2013 Student14. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyReservationViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet UILabel *reservationName;
@property NSString *stringName;
@property (weak, nonatomic) IBOutlet UILabel *reservationDate;
@property NSString *stringDate;
@property (weak, nonatomic) IBOutlet UILabel *reservationDays;
@property NSString *stringDays;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property NSString *urlString;
@end
