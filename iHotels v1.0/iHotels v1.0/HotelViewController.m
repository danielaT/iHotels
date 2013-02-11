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

#import "UIViewController+iHotelsColorTheme.h"

#import <MapKit/MapKit.h>

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
    
    // apply color theme methods
    [self applyiHotelsThemeWithPatternImageName:@"iphone_hotel_pattern"];
    [self configureSubviewsWithPatternImageName:@"iphone_hotel_pattern"];
    
	hotelInfo = [[HotelsInformation alloc] init];
    self.hotelIdLoaded = self.hotelId;
    self.hotelMenuTableView.delegate = self;
    self.hotelMenuTableView.dataSource = self;
    menuItems = [[NSArray alloc] initWithObjects:@"Hotel description", @"Rooms", @"Property amenities", @"Gallery", nil];
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
                self.hotelMenuTableView.frame = CGRectMake(268, 10, self.hotelMenuTableView.frame.size.width, self.hotelMenuTableView.frame.size.height);
            }
            else
            {
                // iphone 3.5 inch screen
                self.hotelMenuTableView.frame = CGRectMake(260, 10, 215, self.hotelMenuTableView.frame.size.height);
            }
        }
    }];
}

-(void) reloadData {
    NSDictionary* hotelSummary = [hotelInfo getSummaryForHotel:self.hotel];
    self.navigationItem.title = [hotelSummary valueForKey:@"name"];
    [self.cityAndPostalCode setText:[NSString stringWithFormat:@"%@, %@", [hotelSummary valueForKey:@"city"], [hotelSummary valueForKey:@"postalCode"]]];
    [self.address setText:[hotelSummary valueForKey:@"address1"]];
    NSURL* url = [NSURL URLWithString:[hotelInfo getProfilePhotoForHotel:self.hotel]];
    [self.hotelImage loadRequest:[NSURLRequest requestWithURL:url]];
    
    NSUInteger hotelRating = [[hotelSummary valueForKey:@"hotelRating"] integerValue]; // needed because some hotels have decimal rating (f. ex. 3.5)
    NSString* hotelRatingImageName = [NSString stringWithFormat:@"iphone_star%d", hotelRating];
    
    self.ratingImage.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:hotelRatingImageName ofType:@"png"]];
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

//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return @"Hotel information";
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* CellIdentifier = @"MenuItemCell";
    UITableViewCell* cell = [self.hotelMenuTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [menuItems objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"Baar Philos" size:18.0];
    cell.textLabel.textColor = [UIColor colorWithHue:0.1417 saturation:0.21 brightness:0.9 alpha:1];
    cell.backgroundColor = [UIColor colorWithHue:0.63 saturation:0.17 brightness:0.4 alpha:1];
    UIImageView* accessory = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"iphone_disclosure_indicator" ofType:@"png"]]];
    [cell setAccessoryView:accessory];
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *selectedIndexPath = [self.hotelMenuTableView indexPathForSelectedRow];
    [self.hotelMenuTableView deselectRowAtIndexPath:selectedIndexPath animated:NO];
    
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
            reservation.imageURL = [hotelInfo getProfilePhotoForHotel:self.hotel];
            [reservation.hotelImage loadRequest:[NSURLRequest requestWithURL:reservation.url]];
            reservation.hotelRating = [hotelSummary valueForKey:@"hotelRating"];
        }
        default:
            break;
    }
}

- (IBAction)findInMapTouched:(id)sender {
    
    // first get the full address of the hotel in a string...
    NSDictionary* hotelSummary = [hotelInfo getSummaryForHotel:self.hotel];
    [self.cityAndPostalCode setText:[NSString stringWithFormat:@"%@, %@", [hotelSummary valueForKey:@"city"], [hotelSummary valueForKey:@"postalCode"]]];
    [self.address setText:[hotelSummary valueForKey:@"address1"]];
    
    NSString* fullHotelAddress = [NSString stringWithFormat:@"%@, %@, %@", [hotelSummary valueForKey:@"city"], [hotelSummary valueForKey:@"postalCode"], [hotelSummary valueForKey:@"address1"]];
    
    // ... and then geocode it!
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:fullHotelAddress completionHandler:^(NSArray* placemarks, NSError* error)
     {
         // Check for returned placemarks and open the maps app
         if (placemarks && placemarks.count > 0)
         {
             CLPlacemark *topResult = [placemarks objectAtIndex:0];
             MKPlacemark *placemark = [[MKPlacemark alloc]initWithPlacemark:topResult];
             MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
             [mapItem setName: [NSString stringWithFormat:@"Hotel: '%@'", [hotelSummary valueForKey:@"name"]]];
             [mapItem openInMapsWithLaunchOptions:nil];
         }
         else {
             // if no placemarks are found - display error (this shouldn't happen, but just in case...)
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Error!" message:@"Address not found." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
             [alert show];
         }
     }];
}

- (IBAction)makeReservationTouched:(id)sender {
    [self performSegueWithIdentifier:[NSString stringWithFormat:@"%d", Reservation] sender:self];
}

@end
