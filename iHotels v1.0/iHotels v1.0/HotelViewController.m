//
//  HotelViewController.m
//  iHotels v1.0
//
//  Created by Student14 on 1/31/13.
//  Copyright (c) 2013 Student14. All rights reserved.
//

#import "HotelViewController.h"

#import "HotelsInformation.h"

NSString* const HOTEL_SUMMARY = @"HotelSummary";
NSString* const HOTEL_IMAGES = @"HotelImages";
NSString* const HOTEL_DETAILS = @"HotelDetails";
NSString* const ROOM_TYPES = @"RoomTypes";
NSString* const PROPERTY_AMENITIES = @"PropertyAmenities";
NSString* const HOTEL_IMAGE = @"HotelImage";

@interface HotelViewController ()

@property (nonatomic)  int hotelIdLoaded;
@property NSMutableDictionary* hotel;
@property HotelsInformation* hotelInfo;
@property NSArray* menuItems;

@end

@implementation HotelViewController

@synthesize address=_address;
@synthesize hotelImage=_hotelImage;
@synthesize cityAndPostalCode=_cityAndPostalCode;
@synthesize locationDescription=_locationDescription;
@synthesize hotelId=_hotelId;
@synthesize hotel=_hotel;
@synthesize hotelInfo=_hotelInfo;
@synthesize hotelIdLoaded=_hotelIdLoaded;
@synthesize hotelMenuTableView=_hotelMenuTableView;
@synthesize menuItems=_menuItems;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)setHotelIdLoaded:(int)hotelIdLoaded {
    
    //reload data when a new hotel is selected
    
    [self.hotelInfo getHotel:hotelIdLoaded handler:^(NSDictionary* dict) {
        self.hotel = nil;
        self.hotel = [NSDictionary dictionaryWithDictionary:dict];
        [self reloadData];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.hotelInfo = [[HotelsInformation alloc] init];
    self.hotel = [[NSMutableDictionary alloc] init];
    self.hotelIdLoaded = self.hotelId;
    self.hotelMenuTableView.delegate = self;
    self.hotelMenuTableView.dataSource = self;
    self.menuItems = [[NSArray alloc] initWithObjects:@"Hotel description", @"Rooms", @"Property amenities", @"Gallery", nil];
}

-(void) reloadData {
    NSDictionary* hotelSummary = [self.hotel valueForKey:HOTEL_SUMMARY];
    self.navigationItem.title = [hotelSummary valueForKey:@"name"];
    [self.cityAndPostalCode setText:[NSString stringWithFormat:@"%@, Postal code: %@", [hotelSummary valueForKey:@"city"], [hotelSummary valueForKey:@"postalCode"]]];
    [self.address setText:[hotelSummary valueForKey:@"address1"]];
    [self.locationDescription setText:[hotelSummary valueForKey:@"locationDescription"]];
    
    NSDictionary* hotelImages = [self.hotel valueForKey:HOTEL_IMAGES];
    NSArray* hotelImagesArray = [hotelImages valueForKey:HOTEL_IMAGE];
    if ([hotelImagesArray count] > 0) {
        NSDictionary* hotelImage = [hotelImagesArray objectAtIndex:0];
        NSURL* url = [NSURL URLWithString:[hotelImage valueForKey:@"thumbnailUrl"]];
        [self.hotelImage loadRequest:[NSURLRequest requestWithURL:url]];
    }
}

-(int)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Hotel information";
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* CellIdentifier = @"MenuItemCell";
    UITableViewCell* cell = [self.hotelMenuTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [self.menuItems objectAtIndex:indexPath.row];
    return cell;
}

@end
