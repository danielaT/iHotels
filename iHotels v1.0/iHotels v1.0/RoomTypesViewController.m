//
//  RoomTypesViewController.m
//  iHotels v1.0
//
//  Created by Student14 on 2/2/13.
//  Copyright (c) 2013 Student14. All rights reserved.
//

#import "RoomTypesViewController.h"

#import "RoomViewController.h"

#import "HotelsInformation.h"

NSString* const SHOW_ROOM_SEGUE = @"ShowRoom";

@interface RoomTypesViewController ()

@end

@implementation RoomTypesViewController

@synthesize roomTypes=_roomTypes;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.roomTypes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RoomType";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [[self.roomTypes objectAtIndex:indexPath.row] valueForKey:@"description"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - Table view delegate

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:SHOW_ROOM_SEGUE]) {
        RoomViewController* roomViewController = (RoomViewController*)segue.destinationViewController;
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        roomViewController.roomDictionary = [[[HotelsInformation alloc] init] getRoomAtIndex:selectedIndexPath.row fromRooms:self.roomTypes];
    }
}

@end
