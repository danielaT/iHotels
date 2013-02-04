//
//  ReservationViewController.m
//  iHotels v1.0
//
//  Created by Desislava on 2/3/13.
//  Copyright (c) 2013 Student14. All rights reserved.
//

#import "ReservationViewController.h"
#import "AppDelegate.h"
#import "Reservation.h"
#import "ReservationViewController.h"
#import <Accounts/Accounts.h>
#import "Friend.h"
#import "HotelVisited.h"

@interface ReservationViewController ()

@end


@interface ReservationViewController ()

@property (strong, nonatomic) IBOutlet UITextView *selectedFriendsView;
@property (retain, nonatomic) FBFriendPickerViewController *friendPickerController;

@property (weak, nonatomic) IBOutlet UITextField *days;


- (void)fillTextBoxAndDismiss:(NSString *)text;

@end

@implementation ReservationViewController
{
    NSMutableArray *arrayWithFriends;
}
@synthesize selectedFriendsView = _friendResultText;
@synthesize friendPickerController = _friendPickerController;

- (void)viewDidLoad
{
    [self.hotelName setText: self.nameString];
    [self.hotelCity setText: self.cityString];
    [self.hotelImage loadRequest:[NSURLRequest requestWithURL:self.url]];
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    self.date.delegate =self;
    self.days.delegate =self;
    [self.selectedFriendsView setText:@"Friends:"];
    
    UITapGestureRecognizer *dateTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleChooseDate:)];
    [self.date addGestureRecognizer:dateTap];
    
   
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)handleChooseDate:(UIGestureRecognizer *)gestureRecognizer
{
    [self performSegueWithIdentifier:@"Select Date" sender:self];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
    
}
- (void)viewDidUnload {
    self.selectedFriendsView = nil;
    self.friendPickerController = nil;
    
    [super viewDidUnload];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)phoneFriends:(id)sender
{
    [self performSegueWithIdentifier:@"Phone Friends" sender:self];
}

- (IBAction)pickFriendsButtonClick:(id)sender
{
    if (self.friendPickerController == nil)
    {
        // Create friend picker, and get data loaded into it.
        self.friendPickerController = [[FBFriendPickerViewController alloc] init];
        self.friendPickerController.title = @"Pick Friends";
        self.friendPickerController.delegate = self;
    }
    
    [self.friendPickerController loadData];
    [self.friendPickerController clearSelection];
    
    // iOS 5.0+ apps should use [UIViewController presentViewController:animated:completion:]
    // rather than this deprecated method, but we want our samples to run on iOS 4.x as well.
    //[self presentModalViewController:self.friendPickerController animated:YES];
    [self presentViewController:self.friendPickerController animated:YES completion:nil];
}



- (void)facebookViewControllerDoneWasPressed:(id)sender
{
    NSMutableString *text = [[NSMutableString alloc] init];
    
    // we pick up the users from the selection, and create a string that we use to update the text view
    // at the bottom of the display; note that self.selection is a property inherited from our base class
    //Friend *current_friend = [[Friend alloc]init];
    for (id<FBGraphUser> user in self.friendPickerController.selection) {
        if ([text length]) {
            [text appendString:@", "];
        }
        [text appendString:user.name];
        
        [arrayWithFriends addObject:user.name];
        NSLog(@"friend: %@", user.name);
    }
    
    [self fillTextBoxAndDismiss:text.length > 0 ? text : @"<None>"];
}

- (void)facebookViewControllerCancelWasPressed:(id)sender
{
    [self fillTextBoxAndDismiss:@"<Cancelled>"];
}

- (void)fillTextBoxAndDismiss:(NSString *)text
{
    self.selectedFriendsView.text = text;

    [self dismissViewControllerAnimated:YES completion:nil];
}



- (IBAction)makeReservation:(id)sender
{
    
    
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    
    NSManagedObjectContext *context = delegate.managedObjectContext;
    Reservation *reservation = [ NSEntityDescription insertNewObjectForEntityForName:@"Reservation" inManagedObjectContext:context];
    reservation.hotelName = self.hotelName.text;
    reservation.startDate = [NSDate date];
    reservation.days = [NSNumber numberWithInt:(int)self.days.text.intValue];
    NSError *error;
    
    NSLog(@" masiv priqteli: %d", [arrayWithFriends count]);
    for(int i = 0; i < [arrayWithFriends count]; i++)
    {
        Friend *friend = [NSEntityDescription insertNewObjectForEntityForName:@"Friend" inManagedObjectContext:context];
        friend.name = [arrayWithFriends objectAtIndex:i];
        [reservation addFriendsObject:friend];
    }
    
    [context save:&error];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Successfull!" message:[NSString stringWithFormat:@"You make reservation for: %@", self.hotelName.text,nil] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) addFriend:(NSString*) name
{
    [arrayWithFriends addObject:name];
}
    

@end
