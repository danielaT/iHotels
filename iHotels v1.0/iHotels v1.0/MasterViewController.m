//
//  MasterViewController.m
//  iHotels v1.0
//
//  Created by Student14 on 1/30/13.
//  Copyright (c) 2013 Student14. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"

#import "HotelsInformation.h"

#import "HotelTableViewCell.h"

#import "HotelViewController.h"

NSString* const THUMB_NAIL_URL = @"http://images.travelnow.com";

@interface MasterViewController ()

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@property NSArray* hotelListArray;

@end

@implementation MasterViewController

@synthesize hotelListArray=_hotelListArray;
@synthesize cityName=_cityName;

// reload tableView with new hotels when new city is selected
-(void)setCityName:(NSString *)cityName {
    HotelsInformation* hotelsInfo = [[HotelsInformation alloc] init];
    self.hotelListArray = nil;
    self.navigationItem.title = cityName;
    [hotelsInfo getHotelsForCity:cityName handler:^(NSArray* hotels) {
        self.hotelListArray = hotels;
        [self.tableView reloadData];
    }];
}

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.cityName = @"Sofia";
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    self.hotelListArray = [[NSMutableArray alloc] init];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.hotelListArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HotelTableViewCell *hotelCell = [tableView dequeueReusableCellWithIdentifier:@"HotelCell" forIndexPath:indexPath];
    [self configureCell:hotelCell atIndexPath:indexPath];
    return hotelCell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
       // self.detailViewController.detailItem = object;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showHotelDetails"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary* currentHotel = [self.hotelListArray objectAtIndex:indexPath.row];
        int hotelId = [[currentHotel valueForKey:@"hotelId"] intValue];
        HotelViewController* hotelViewController = (HotelViewController*)segue.destinationViewController;
        hotelViewController.hotelId = hotelId;
    }
}

- (void)configureCell:(HotelTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* currentHotel = [self.hotelListArray objectAtIndex:indexPath.row];
    [cell.hotelName setText:[currentHotel valueForKey:@"name"]];
    [cell.hotelDescription setText:[currentHotel valueForKey:@"locationDescription"]];
    NSString* imageUrl = [THUMB_NAIL_URL stringByAppendingFormat:@"%@", [currentHotel valueForKey:@"thumbNailUrl"]];
    [cell.hotelImage loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl]]];
}

@end
