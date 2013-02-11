//
//  PropertyAmenitiesViewController.m
//  iHotels v1.0
//
//  Created by Student14 on 2/2/13.
//  Copyright (c) 2013 Student14. All rights reserved.
//

#import "PropertyAmenitiesViewController.h"

#import "UIViewController+iHotelsColorTheme.h"

@interface PropertyAmenitiesViewController ()

@end

@implementation PropertyAmenitiesViewController

@synthesize propertyAmenitiesArray=_propertyAmenitiesArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Property amenities";
    // apply color theme methods
    [self applyiHotelsThemeWithPatternImageName:@"iphone_hotel_pattern"];
    [self configureSubviewsWithPatternImageName:@"iphone_hotel_pattern"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.propertyAmenitiesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PropertyAmenity";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [[self.propertyAmenitiesArray objectAtIndex:indexPath.row] valueForKey:@"amenity"];
    cell.textLabel.font = [UIFont fontWithName:@"Baar Philos" size:16.0];
    cell.textLabel.textColor = [UIColor colorWithHue:0.1417 saturation:0.21 brightness:0.9 alpha:1];
    cell.backgroundColor = [UIColor colorWithHue:0.63 saturation:0.17 brightness:0.4 alpha:1];
    UIImageView* accessory = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"iphone_disclosure_indicator" ofType:@"png"]]];
    [cell setAccessoryView:accessory];
    return cell;
}

@end
