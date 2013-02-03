//
//  ReservationViewController.h
//  iHotels v1.0
//
//  Created by Desislava on 2/3/13.
//  Copyright (c) 2013 Student14. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface ReservationViewController : UIViewController<FBFriendPickerDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *date;
@property (weak, nonatomic) IBOutlet UILabel *hotelName;
@property (weak, nonatomic) IBOutlet UILabel *hotelCity;
@property (weak, nonatomic) IBOutlet UIWebView *hotelImage;
@property NSString* nameString;
@property NSString* cityString;
@property NSURL* url;
- (void) addFriend:(NSString*) name;

@end
