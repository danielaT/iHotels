//
//  RoomViewController.m
//  iHotels v1.0
//
//  Created by Student14 on 2/2/13.
//  Copyright (c) 2013 Student14. All rights reserved.
//

#import "RoomViewController.h"

#import "HotelsInformation.h"

#import "UIViewController+iHotelsColorTheme.h"

@interface RoomViewController ()

@end

@implementation RoomViewController

@synthesize roomDictionary=_roomDictionary;
@synthesize roomAmenitiesTableView=_roomAmenitiesTableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // apply color theme methods
    [self applyiHotelsThemeWithPatternImageName:@"iphone_hotel_pattern"];
    [self configureSubviews];
    
    self.roomAmenitiesTableView.delegate = self;
    self.roomAmenitiesTableView.dataSource = self;
    self.navigationItem.title = [self.roomDictionary valueForKey:@"description"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[[HotelsInformation alloc] init] getRoomAmenitiesForRoom:self.roomDictionary] count];
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Room amenities";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RoomAmenity";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSArray* roomAmenities = [[[HotelsInformation alloc] init] getRoomAmenitiesForRoom:self.roomDictionary];
    cell.textLabel.text = [[roomAmenities objectAtIndex:indexPath.row] valueForKey:@"amenity"];
    return cell;
}

@end
