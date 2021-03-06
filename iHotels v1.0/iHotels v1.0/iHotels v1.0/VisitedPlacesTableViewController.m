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

@interface VisitedPlacesTableViewController ()

@end

@implementation VisitedPlacesTableViewController
{
    NSArray* hotels;
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
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = delegate.managedObjectContext;
    NSError *error;
    NSFetchRequest *request1 = [[NSFetchRequest alloc] initWithEntityName:@"HotelVisited"];
    hotels = [context executeFetchRequest:request1 error:&error];
    
    // apply color theme methods
    [self configureSubviews];
    [self configureNavigationBar];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self reloadInformation];
    [self.tableView reloadData];
}

- (void) reloadInformation
{
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = delegate.managedObjectContext;
    NSError *error;
    NSFetchRequest *request1 = [[NSFetchRequest alloc] initWithEntityName:@"HotelVisited"];
    hotels = [context executeFetchRequest:request1 error:&error];
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
    
    return [hotels count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"VisitedHotelCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    HotelVisited *res = [hotels objectAtIndex:indexPath.row];
    //cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",(int)res.days];
    cell.textLabel.text = res.hotelName;
    cell.textLabel.font = [UIFont fontWithName:nil size:8];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.imageView.image = [UIImage imageNamed:@"hotel.jpg"];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}




-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"toPageViewSegue"])
    {
        PlacesPageViewController* controller = (PlacesPageViewController*)segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        controller.selectedHotel = [hotels objectAtIndex:indexPath.row];
    }
}


@end
