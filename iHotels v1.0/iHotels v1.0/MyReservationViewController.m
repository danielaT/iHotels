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
#import "DataBaseHelper.h"
#import "Reservation.h"
#import "Friend.h"

@interface MyReservationViewController ()

@property NSArray* hotelListArray;
@property (weak, nonatomic) IBOutlet UITextView *textFieldWithFriends;
@property (weak, nonatomic) IBOutlet UILabel *friendsThatWillComeLabel;


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
    [self.reservationDays setText:[NSString stringWithFormat:@"%@ day(s)", self.stringDays]];
    [self.reservationDate setText:[self.stringDate substringToIndex:10]];
    NSURL *url = [NSURL URLWithString:self.urlString];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    NSString* imageName = [NSString stringWithFormat:@"iphone_star%@",self.hotelRating];
    self.starImage.image = [UIImage imageNamed:imageName];
    
    self.textFieldWithFriends.text = @"";
    
    if([self.arrayWithFriends count] == 0)
        self.textFieldWithFriends.text = @"Nobody!";
    else
    {
        for(int i = 0; i < [self.arrayWithFriends count]; i++)
        {
            Friend *friend = [self.arrayWithFriends objectAtIndex:i];
            NSString *name = friend.name;
            self.textFieldWithFriends.text = [NSString stringWithFormat:@"%@\n %@", self.textFieldWithFriends.text, name];
        }   
    }

    // apply color theme methods
    [self applyiHotelsThemeWithPatternImageName:@"iphone_reservation_pattern"];
    [self configureSubviewsWithPatternImageName:@"iphone_reservation_pattern"];
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
                self.friendsThatWillComeLabel.frame = CGRectMake(260, 10, self.friendsThatWillComeLabel.frame.size.width, self.friendsThatWillComeLabel.frame.size.height);
                self.textFieldWithFriends.frame = CGRectMake(260, 40, self.textFieldWithFriends.frame.size.width, self.textFieldWithFriends.frame.size.height);
            }
            else
            {
                // iphone 3.5 inch screen
                
            }
        }
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
