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
#import "UIViewController+iHotelsColorTheme.h"

const int PICKER_TOOLBAR_HEIGTH = 44;
NSString* const DATE_FORMAT = @"yyyy-MM-dd";

@interface ReservationViewController ()
{
    NSMutableArray *arrayWithFriends;
    NSString* alertMessage;
    UIActionSheet *pickerViewPopup;
}
@property (strong, nonatomic) IBOutlet UITextView *selectedFriendsView;
@property (retain, nonatomic) FBFriendPickerViewController *friendPickerController;
@property (weak, nonatomic) IBOutlet UITextField *days;

- (void)fillTextBoxAndDismiss:(NSString *)text;

@end

@implementation ReservationViewController

@synthesize selectedFriendsView = _friendResultText;
@synthesize friendPickerController = _friendPickerController;

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    arrayWithFriends = [[NSMutableArray alloc]init];
    
    self.date.delegate = self;
    self.days.delegate = self;
    
    UITapGestureRecognizer *dateTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleChooseDate:)];
    [self.date addGestureRecognizer:dateTap];
    
    [self showInformation];
    [self applyTheme];
    
    pickerViewPopup = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
}

// apply color theme methods
-(void) applyTheme {
    [self applyiHotelsThemeWithPatternImageName:@"iphone_hotel_pattern"];
    [self configureNavigationBar];
    [self configureSubviewsWithPatternImageName:@"iphone_hotel_pattern"];
}

-(void) showInformation {
    [self.hotelName setText: self.nameString];
    [self.hotelCity setText: self.cityString];
    [self.hotelImage loadRequest:[NSURLRequest requestWithURL:self.url]];
    [self.selectedFriendsView setText:@"Friends:"];
    NSString* imageName = [NSString stringWithFormat:@"iphone_star%d", [self.hotelRating intValue]];
    self.starImage.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageName ofType:@"png"]];
}

- (void)handleChooseDate:(UIGestureRecognizer *)gestureRecognizer
{
    [self showDatePickerView];
}

-(void) showDatePickerView {
    
    UIDatePicker *pickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, PICKER_TOOLBAR_HEIGTH, 0, 0)];
    pickerView.datePickerMode = UIDatePickerModeDate;
    pickerView.hidden = NO;
    pickerView.date = [NSDate date];
    pickerView.minimumDate = [NSDate date];
    // about a yars
    double timeInterval = 365 * 24 * 60 * 60;
    pickerView.maximumDate = [[NSDate date] dateByAddingTimeInterval:timeInterval];
    
    UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, PICKER_TOOLBAR_HEIGTH)];
    pickerToolbar.barStyle = UIBarStyleBlackOpaque;
    [pickerToolbar sizeToFit];
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed:)];
    [barItems addObject:doneBtn];
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed:)];
    [barItems addObject:cancelBtn];
    [pickerToolbar setItems:barItems animated:YES];
    
    [pickerViewPopup addSubview:pickerView];
    [pickerViewPopup addSubview:pickerToolbar];
    [pickerViewPopup showFromTabBar:self.tabBarController.tabBar];
    [pickerViewPopup setBounds:CGRectMake(0, 0 , self.view.frame.size.width, self.view.frame.size.height)];
}

-(void)doneButtonPressed:(id)sender{
    for (UIView* view in pickerViewPopup.subviews) {
        if ([[view class] isSubclassOfClass:[UIDatePicker class]]) {
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:DATE_FORMAT];
            self.date.text = [dateFormat stringFromDate:[(UIDatePicker*)view date]];
        }
    }
    [pickerViewPopup dismissWithClickedButtonIndex:1 animated:YES];
}

-(void)cancelButtonPressed:(id)sender{
    [pickerViewPopup dismissWithClickedButtonIndex:1 animated:YES];
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

- (IBAction)phoneFriends:(id)sender
{
    [self performSegueWithIdentifier:@"Phone Friends" sender:self];
}

- (IBAction)pickFriendsButtonClick:(id)sender
{
    if (FBSession.activeSession.isOpen)
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
        [self presentViewController:self.friendPickerController animated:YES completion:nil];
    }
    else
        [self.tabBarController setSelectedIndex:3];

}

- (void)facebookViewControllerDoneWasPressed:(id)sender
{
    NSMutableString *text = [[NSMutableString alloc] init];
    // we pick up the users from the selection, and create a string that we use to update the text view
    // at the bottom of the display; note that self.selection is a property inherited from our base class
    for (id<FBGraphUser> user in self.friendPickerController.selection)
    {
        if ([text length])
        {
            [text appendString:@", "];
        }
        [text appendString:user.name];
        [arrayWithFriends addObject:user.name];
    }
    
    [self fillTextBoxAndDismiss:text.length > 0 ? text : @"<None>"];
}

- (void)facebookViewControllerCancelWasPressed:(id)sender
{
    [self fillTextBoxAndDismiss:@"<Cancelled>"];
}

- (void)fillTextBoxAndDismiss:(NSString *)text
{
    if([self.selectedFriendsView.text isEqualToString:@"Friends:"])
        [self.selectedFriendsView setText:[NSString stringWithFormat:@"%@ %@", self.selectedFriendsView.text, text]];
    else
        [self.selectedFriendsView setText:[NSString stringWithFormat:@"%@, %@", self.selectedFriendsView.text, text]];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL) isValid
{
    NSString *trimmedDate = [self.date.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *trimmedDays = [self.days.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([trimmedDate length] <= 0) {
        alertMessage = @"Please, enter date.";
        return NO;}
    else if ([trimmedDays length] <= 0) {
        alertMessage = @"Please, enter days.";
        return NO;
    }
    return YES;
}

- (IBAction)makeReservation:(id)sender
{
    if ([self isValid])
    {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:DATE_FORMAT];
        [dateFormat setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        NSDate *date = [dateFormat dateFromString:self.date.text];
        
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = delegate.managedObjectContext;
        Reservation *reservation = [NSEntityDescription insertNewObjectForEntityForName:@"Reservation" inManagedObjectContext:context];
        reservation.hotelName = self.hotelName.text;
        reservation.startDate = date;
        reservation.days = [NSNumber numberWithInt:(int)self.days.text.intValue];
        reservation.hotelImage = self.imageURL;
        reservation.hotelRate = [NSNumber numberWithInt:[ self.hotelRating intValue]];
        
        for(int i = 0; i < [arrayWithFriends count]; i++)
        {
            Friend *friend = [NSEntityDescription insertNewObjectForEntityForName:@"Friend" inManagedObjectContext:context];
            friend.name = [arrayWithFriends objectAtIndex:i];
            [reservation addFriendsObject:friend];
        }
        
        NSError *error;
        [context save:&error];
        
        alertMessage = [NSString stringWithFormat:@"You made reservation for: %@", self.hotelName.text, nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
        [self createNotificationWithFireDate:date];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:alertMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

-(void) createNotificationWithFireDate:(NSDate*)fireDate {
    UILocalNotification *scheduledAlert;
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    scheduledAlert = [[UILocalNotification alloc] init];
    scheduledAlert.applicationIconBadgeNumber = 1;
    // one day before the reservation start date
    double oneDayBefore = -(24*60*60);
   // scheduledAlert.fireDate = [fireDate dateByAddingTimeInterval:oneDayBefore];
    scheduledAlert.fireDate = [NSDate dateWithTimeIntervalSinceNow:20];
    scheduledAlert.timeZone = [NSTimeZone localTimeZone];
    scheduledAlert.repeatInterval =  NSHourCalendarUnit;
    scheduledAlert.soundName = UILocalNotificationDefaultSoundName;
    scheduledAlert.alertBody = @"Reservation for hotel tomorrow!";
    
    [[UIApplication sharedApplication] scheduleLocalNotification:scheduledAlert];
}

- (void) addFriend:(NSString*) name
{
    [arrayWithFriends addObject:name];
    if([self.selectedFriendsView.text isEqualToString:@"Friends:"])
        [self.selectedFriendsView setText:[NSString stringWithFormat:@"%@ %@", self.selectedFriendsView.text, name]];
   
    else [self.selectedFriendsView setText:[NSString stringWithFormat:@"%@, %@", self.selectedFriendsView.text, name]];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


@end
