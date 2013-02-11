//
//  ReservationsTableViewController.m
//  iHotels v1.0
//
//  Created by Desislava on 2/3/13.
//  Copyright (c) 2013 Student14. All rights reserved.
//

#import "ReservationsTableViewController.h"
#import "AppDelegate.h"
#import "Reservation.h"
#import "MyReservationViewController.h"
#import "UIViewController+iHotelsColorTheme.h"
#import "DataBaseHelper.h"

@interface ReservationsTableViewController ()

@end

@implementation ReservationsTableViewController
{
    NSArray* reservations;
    int selectedIndex;
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView reloadData];
    
    // apply color theme methods
    [self applyiHotelsThemeWithPatternImageName:@"iphone_reservation_pattern"];
    [self configureNavigationBar];
    [self configureSubviewsWithPatternImageName:@"iphone_reservation_pattern"];
}

-(void)viewWillAppear:(BOOL)animated
{
    reservations = [DataBaseHelper reloadReservations];;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [reservations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ReservationCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Reservation *res = [reservations objectAtIndex:indexPath.row];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    cell.detailTextLabel.text = res.hotelName;
    cell.textLabel.text = [dateFormatter stringFromDate:res.startDate];
    
    cell.backgroundColor = [UIColor colorWithHue:0.63 saturation:0.17 brightness:0.4 alpha:1];
    cell.textLabel.font = [UIFont fontWithName:@"Baar Philos" size:10.0];
    cell.textLabel.textColor = [UIColor colorWithHue:0.1417 saturation:0.21 brightness:0.9 alpha:1];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Baar Philos" size:14.0];
    cell.detailTextLabel.textColor = [UIColor colorWithHue:0.1417 saturation:0.21 brightness:0.9 alpha:1];
    UIImageView* accessory = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"iphone_disclosure_indicator" ofType:@"png"]]];
    [cell setAccessoryView:accessory];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedIndex = indexPath.row;
    [self performSegueWithIdentifier:@"View Reservation" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"View Reservation"])
    {
        MyReservationViewController* hotelDecription = (MyReservationViewController*)segue.destinationViewController;
        Reservation *res = [reservations objectAtIndex:selectedIndex];
        hotelDecription.stringName = res.hotelName;
        [hotelDecription.reservationName setText:hotelDecription.stringName];
        hotelDecription.stringDays = [NSString stringWithFormat:@"%@",res.days];
        [hotelDecription.reservationDays setText:hotelDecription.stringDays];
        hotelDecription.stringDate = [NSString stringWithFormat:@"%@",res.startDate];
        [hotelDecription.reservationDate setText:hotelDecription.stringDate];
        hotelDecription.urlString = res.hotelImage;
        NSURL *url = [NSURL URLWithString:res.hotelImage];
        [hotelDecription.webView loadRequest:[NSURLRequest requestWithURL:url]];
        hotelDecription.arrayWithFriends = [NSMutableArray arrayWithArray:[res.friends allObjects]];
        hotelDecription.arrayWithFriends = [[res.friends allObjects] mutableCopy];
        hotelDecription.hotelRating =  res.hotelRate;
        
    }
}

@end
