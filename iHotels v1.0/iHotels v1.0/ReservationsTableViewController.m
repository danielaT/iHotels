//
//  ReservationsTableViewController.m
//  iHotels v1.0
//
//  Created by Desislava on 2/3/13.
//  Copyright (c) 2013 Student14. All rights reserved.
//

#import "ReservationsTableViewController.h"
#import "AppDelegate.h"
#import "Reservation.h"
#import "MyReservationViewController.h"
#import "UIViewController+iHotelsColorTheme.h"

@interface ReservationsTableViewController ()

@end

@implementation ReservationsTableViewController
{
    NSArray* reservations;
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
    [self.tableView reloadData];
    
    [self reloadInformation];

    // apply color theme methods
    [self applyiHotelsThemeWithPatternImageName:@"iphone_reservation_pattern"];
    [self configureNavigationBar];
    [self configureSubviews];
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
    NSFetchRequest *request1 = [[NSFetchRequest alloc] initWithEntityName:@"Reservation"];
    reservations = [context executeFetchRequest:request1 error:&error];
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

    return [reservations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ReservationCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Reservation *res = [reservations objectAtIndex:indexPath.row];
    //cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",(int)res.days];
    cell.textLabel.text = res.hotelName;
    cell.textLabel.font = [UIFont fontWithName:nil size:8];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.imageView.image = [UIImage imageNamed:@"car.jpg"];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    selectedIndex = indexPath.row;
    [self performSegueWithIdentifier:@"View Reservation" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"View Reservation"])
    {
        MyReservationViewController* hotelDecription = (MyReservationViewController*)segue.destinationViewController;
        Reservation *res = [reservations objectAtIndex:selectedIndex];
        hotelDecription.stringName = res.hotelName;
        [hotelDecription.reservationName setText:hotelDecription.stringName];
        hotelDecription.stringDays = [NSString stringWithFormat:@"%@",res.days];
        [hotelDecription.reservationDays setText:hotelDecription.stringDays];
        hotelDecription.stringDate = [NSString stringWithFormat:@"%@",res.startDate];
        [hotelDecription.reservationDate setText:hotelDecription.stringDate];
        hotelDecription.urlString = res.hotelImage;
        NSURL *url = [NSURL URLWithString:res.hotelImage];
        [hotelDecription.webView loadRequest:[NSURLRequest requestWithURL:url]];
        hotelDecription.arrayWithFriends = [NSMutableArray arrayWithArray:[res.friends allObjects]];
        hotelDecription.hotelRating =  res.hotelRate;
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
@end
