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
    
    // apply color theme methods
    [self applyiHotelsThemeWithPatternImageName:@"iphone_hotel_pattern"];
    [self configureSubviews];
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
    return cell;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Property amenities";
}

@end
