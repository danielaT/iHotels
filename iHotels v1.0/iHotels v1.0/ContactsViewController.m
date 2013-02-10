//
//  ContactsViewController.m
//  iHotels v1.0
//
//  Created by Desislava on 2/3/13.
//  Copyright (c) 2013 Student14. All rights reserved.
//

#import "ContactsViewController.h"
#import "ReservationViewController.h"
#import "UIViewController+iHotelsColorTheme.h"
#import "Friend.h"

@interface ContactsViewController ()

@property NSArray* peopleArray;

@end

@implementation ContactsViewController
{
    int selectedRow;
    NSMutableArray *arrayWithContacts;
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
    arrayWithContacts = [[NSMutableArray alloc]init];
    
    self.navigationItem.hidesBackButton = YES;
    //[self.tableView reloadData];
    
    CFIndex ind;
    
	// Do any additional setup after loading the view, typically from a nib.
    CFErrorRef error;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    __block BOOL accessGranted = NO;
    if (ABAddressBookRequestAccessWithCompletion != NULL) { // we're on iOS 6
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        //dispatch_release(sema);
    }
    else { // we're on iOS 5 or older
        accessGranted = YES;
    }
    
    if (accessGranted) {
        //NSLog(@"granted");
        ind= ABAddressBookGetPersonCount(addressBook);
        //NSLog(@"%d",(int)ind);
        self.peopleArray = [(__bridge NSArray*)ABAddressBookCopyArrayOfAllPeople(addressBook) mutableCopy];
        
        
        // Do whatever you want here.
        
    }
    
    ABRecordRef person;
    for(int i = 0; i <ind;i++)
    {
        person = (__bridge ABRecordRef)([self.peopleArray objectAtIndex:i]);
        //ABRecordRef ref = CFArrayGetValueAtIndex((__bridge CFArrayRef)(self.peopleArray), i);
        
        // Get First name, Last name, Prefix, Suffix, Job title
        //NSString *firstName = (__bridge NSString *)ABRecordCopyValue(ref,kABPersonFirstNameProperty);
       //NSString *lastName = (__bridge NSString *)ABRecordCopyValue(ref,kABPersonLastNameProperty);
    }
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
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
    return [self.peopleArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    ABRecordRef person;

    person = (__bridge ABRecordRef)([self.peopleArray objectAtIndex:indexPath.row]);
    ABRecordRef ref = CFArrayGetValueAtIndex((__bridge CFArrayRef)(self.peopleArray), indexPath.row);
    
    // Get First name, Last name, Prefix, Suffix, Job title
    NSString *firstName = (__bridge NSString *)ABRecordCopyValue(ref,kABPersonFirstNameProperty);
    NSString *lastName = (__bridge NSString *)ABRecordCopyValue(ref,kABPersonLastNameProperty);
    NSString *name = [NSString stringWithFormat:@"%@ %@",firstName,lastName];
    
    cell.textLabel.text = name;
    
    NSData *data=nil;
    data = (__bridge NSData *) ABPersonCopyImageData(ref);
    cell.imageView.image = [UIImage imageWithData:data];

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
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (selectedCell.accessoryType == UITableViewCellAccessoryNone)
    {
        selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
        [arrayWithContacts addObject:selectedCell.textLabel.text];
        
    }
    else
        if (selectedCell.accessoryType == UITableViewCellAccessoryCheckmark)
        {
            selectedCell.accessoryType = UITableViewCellAccessoryNone;
            [arrayWithContacts removeObject:selectedCell.textLabel.text];
        }

}

- (IBAction)addContactsToReservation:(id)sender
{
    ReservationViewController *reservation =  [[[self navigationController] viewControllers]objectAtIndex:4];
    
    NSLog(@"%d fr2:", [arrayWithContacts count]);

    for(int i = 0; i < [arrayWithContacts count]; i++)
    {
                //NSLog(@"of: %@", [arrayWithContacts objectAtIndex:i]);
        //Friend *friend = [[Friend alloc]init];
        //friend. name = [arrayWithContacts objectAtIndex:i];
        [reservation addFriend:[arrayWithContacts objectAtIndex:i]];
    }

    [[self navigationController] popToViewController:reservation animated:YES];
}

@end
