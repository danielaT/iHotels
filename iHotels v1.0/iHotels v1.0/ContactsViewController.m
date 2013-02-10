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
        ind= ABAddressBookGetPersonCount(addressBook);
       
        self.peopleArray = [(__bridge NSArray*)ABAddressBookCopyArrayOfAllPeople(addressBook) mutableCopy];
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



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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

    for(int i = 0; i < [arrayWithContacts count]; i++)
        [reservation addFriend:[arrayWithContacts objectAtIndex:i]];

    [[self navigationController] popToViewController:reservation animated:YES];
}

@end
