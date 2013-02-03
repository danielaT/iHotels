//
//  HotelViewController.m
//  iHotels v1.0
//
//  Created by Student14 on 1/31/13.
//  Copyright (c) 2013 Student14. All rights reserved.
//

#import "HotelViewController.h"

#import "HotelsInformation.h"

#import "GalleryViewController.h"

#import "HotelDescriptionViewController.h"

#import "RoomTypesViewController.h"

#import "PropertyAmenitiesViewController.h"

#import "ReservationViewController.h"

const float CELL_HEIGTH = 35.0;

@interface HotelViewController ()
{
    NSArray* menuItems;
    HotelsInformation* hotelInfo;
}

typedef enum {
    HotelDescription = 0,
    RoomTypes = 1,
    PropertyAmenities = 2,
    Gallery = 3,
    Reservation = 4
} Segues;

@property (nonatomic)  int hotelIdLoaded;
@property NSDictionary* hotel;
- (IBAction)findInMapTouched:(id)sender;
- (IBAction)makeReservationTouched:(id)sender;

@end

@implementation HotelViewController

@synthesize address=_address;
@synthesize hotelImage=_hotelImage;
@synthesize cityAndPostalCode=_cityAndPostalCode;
@synthesize locationDescription=_locationDescription;
@synthesize hotelId=_hotelId;
@synthesize hotel=_hotel;
@synthesize hotelIdLoaded=_hotelIdLoaded;
@synthesize hotelMenuTableView=_hotelMenuTableView;

-(void)setHotelIdLoaded:(int)hotelIdLoaded {
    
    //reload data when a new hotel is selected
    [hotelInfo getHotel:hotelIdLoaded handler:^(NSDictionary* dict) {
        self.hotel = dict;
        [self reloadData];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	hotelInfo = [[HotelsInformation alloc] init];
    self.hotelIdLoaded = self.hotelId;
    self.hotelMenuTableView.delegate = self;
    self.hotelMenuTableView.dataSource = self;
    menuItems = [[NSArray alloc] initWithObjects:@"Hotel description", @"Rooms", @"Property amenities", @"Gallery", nil];
}

-(void) reloadData {
    NSDictionary* hotelSummary = [hotelInfo getSummaryForHotel:self.hotel];
    self.navigationItem.title = [hotelSummary valueForKey:@"name"];
    [self.cityAndPostalCode setText:[NSString stringWithFormat:@"%@, %@", [hotelSummary valueForKey:@"city"], [hotelSummary valueForKey:@"postalCode"]]];
    [self.address setText:[hotelSummary valueForKey:@"address1"]];
    [self.locationDescription setText:[hotelSummary valueForKey:@"locationDescription"]];
    NSURL* url = [NSURL URLWithString:[hotelInfo getProfilePhotoForHotel:self.hotel]];
    [self.hotelImage loadRequest:[NSURLRequest requestWithURL:url]];
}

-(int)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [menuItems count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self performSegueWithIdentifier:[NSString stringWithFormat:@"%d", indexPath.row] sender:tableView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGTH;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CELL_HEIGTH;
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
    cell.textLabel.text = [menuItems objectAtIndex:indexPath.row];
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    switch ([segue.identifier intValue]) {
        case HotelDescription: {
            HotelDescriptionViewController* hotelDecription = (HotelDescriptionViewController*)segue.destinationViewController;
            NSDictionary* hotelDetails = [hotelInfo getHotelDetailsForHotel:self.hotel];
            hotelDecription.roomsCountStr = [[hotelDetails valueForKey:@"numberOfRooms"] intValue];
            hotelDecription.hotelPolicyStr = [hotelDetails valueForKey:@"hotelPolicy"];
            hotelDecription.floorsCountStr = [[hotelDetails valueForKey:@"numberOfFloors"] intValue];
            hotelDecription.propertyInformationStr = [hotelDetails valueForKey:@"propertyInformation"];
            hotelDecription.checkInStr = [hotelDetails valueForKey:@"checkInTime"];
            hotelDecription.checkOutStr = [hotelDetails valueForKey:@"checkOutTime"];
        }
            break;
        case RoomTypes: {
            RoomTypesViewController* roomTypes = (RoomTypesViewController*)segue.destinationViewController;
            roomTypes.roomTypes = [hotelInfo getRoomTypesForHotel:self.hotel];
        }
            break;
        case PropertyAmenities: {
            PropertyAmenitiesViewController* propertyAmenities = (PropertyAmenitiesViewController*) segue.destinationViewController;
            propertyAmenities.propertyAmenitiesArray = [hotelInfo getPropertyAmenitiesForHotel:self.hotel];
        }
            break;
        case Gallery: {
            GalleryViewController* galleryViewController = (GalleryViewController*)segue.destinationViewController;
            [hotelInfo getImagesForHotel:self.hotel handler:^(NSArray* arr) {
                galleryViewController.hotelImages = arr;
            }];
        }
            break;
        case Reservation: {
            ReservationViewController* reservation = (ReservationViewController*)segue.destinationViewController;
            NSDictionary* hotelSummary = [hotelInfo getSummaryForHotel:self.hotel];
            reservation.nameString = [hotelSummary valueForKey:@"name"];
            [reservation.hotelName setText:reservation.nameString];
            reservation.cityString = [hotelSummary valueForKey:@"city"];
            [reservation.hotelCity setText:reservation.cityString];
            
            reservation.url = [NSURL URLWithString:[hotelInfo getProfilePhotoForHotel:self.hotel]];
            [reservation.hotelImage loadRequest:[NSURLRequest requestWithURL:reservation.url]];
        }
        default:
            break;
    }
}

- (IBAction)findInMapTouched:(id)sender {
    
}

- (IBAction)makeReservationTouched:(id)sender {
    [self performSegueWithIdentifier:@"4" sender:self];
}

@end
