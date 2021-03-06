//
//  VisitedPlacesTableViewController.m
//  iHotels v1.0
//
//  Created by Desislava on 2/3/13.
//  Copyright (c) 2013 Student14. All rights reserved.
//

#import "VisitedPlacesTableViewController.h"
#import "AppDelegate.h"
#import "HotelVisited.h"
#import "MyReservationViewController.h"
#import "PlacesPageViewController.h"
#import "UIViewController+iHotelsColorTheme.h"
#import "DataBaseHelper.h"

@interface VisitedPlacesTableViewController ()
@property NSArray* hotels;
@end

@implementation VisitedPlacesTableViewController
@synthesize hotels = _hotels;

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

    self.hotels = [DataBaseHelper getHotels];
    
    // apply color theme methods
    [self applyiHotelsThemeWithPatternImageName:@"iphone_places_pattern"];
    [self configureNavigationBar];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.hotels = [DataBaseHelper reloadVisitedPlaces];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.hotels count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"VisitedHotelCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    HotelVisited *hotel = [self.hotels objectAtIndex:indexPath.row];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    cell.detailTextLabel.text = hotel.hotelName;
    cell.textLabel.text = [dateFormatter stringFromDate:hotel.startDate];
    
    cell.backgroundColor = [UIColor colorWithHue:0.63 saturation:0.17 brightness:0.4 alpha:1];
    cell.textLabel.font = [UIFont fontWithName:@"Baar Philos" size:10.0];
    cell.textLabel.textColor = [UIColor colorWithHue:0.1417 saturation:0.21 brightness:0.9 alpha:1];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Baar Philos" size:14.0];
    cell.detailTextLabel.textColor = [UIColor colorWithHue:0.1417 saturation:0.21 brightness:0.9 alpha:1];
    
    UIImageView* accessory = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"iphone_disclosure_indicator" ofType:@"png"]]];
    [cell setAccessoryView:accessory];
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"toPageViewSegue"])
    {
        PlacesPageViewController* controller = (PlacesPageViewController*)segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        controller.selectedHotel = [self.hotels objectAtIndex:indexPath.row];
    }
}

@end
