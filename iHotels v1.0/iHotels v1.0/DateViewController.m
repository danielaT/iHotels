//
//  DateViewController.m
//  iHotels v1.0
//
//  Created by Desislava on 2/3/13.
//  Copyright (c) 2013 Student14. All rights reserved.
//

#import "DateViewController.h"
#import "ReservationViewController.h"
#import "UIViewController+iHotelsColorTheme.h"

@interface DateViewController ()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation DateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    
    // apply color theme methods
    [self applyiHotelsThemeWithPatternImageName:@"iphone_hotel_pattern"];
    [self configureNavigationBar];
    [self configureSubviews];
}

- (void)viewWillAppear:(BOOL)animated
{
    // NSUserDefaults is a singleton instance and access to the store is provided
    // by the class method, +standardUserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // Let's pull the date out of our picker
    NSDate *selectedDate = [self.datePicker date];
    NSLog(@"date: %@", selectedDate);
    // Store the date object into the user defaults. The key argument expects a
    // string and should be unique. I usually prepend any key with the name
    // of the class it's being used in.
    // Savvy programmers would pull this string out into a constant so that
    // it could be accessed from other classes if necessary.
    [defaults setObject:selectedDate forKey:@"DatePickerViewController.selectedDate"];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)selectDate:(id)sender
{
    ReservationViewController *reservation =  [[[self navigationController] viewControllers]objectAtIndex:4];
    
    NSString *stringDate = [NSString stringWithFormat:@"%@",[self.datePicker date]];
    
    [reservation.date setText:[NSString stringWithFormat:@"%@",[stringDate substringToIndex:10]]];

    [[self navigationController] popToViewController:reservation animated:YES];

}

@end

