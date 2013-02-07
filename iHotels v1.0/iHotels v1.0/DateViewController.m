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

//@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITextField *year;
@property (weak, nonatomic) IBOutlet UITextField *month;
@property (weak, nonatomic) IBOutlet UITextField *day;

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
    self.year.delegate = self;
    self.month.delegate = self;
    self.day.delegate = self;
    
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
    //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // Let's pull the date out of our picker
    //NSDate *selectedDate = [self.datePicker date];
    //NSLog(@"date: %@", selectedDate);
    // Store the date object into the user defaults. The key argument expects a
    // string and should be unique. I usually prepend any key with the name
    // of the class it's being used in.
    // Savvy programmers would pull this string out into a constant so that
    // it could be accessed from other classes if necessary.
    //[defaults setObject:selectedDate forKey:@"DatePickerViewController.selectedDate"];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
    
}

- (IBAction)selectDate:(id)sender
{
    if([self.year.text intValue] < 2013 || [self.month.text intValue] < 0 || [self.month.text intValue] > 12 || [self.day.text intValue] < 0 || [self.day.text intValue] > 31)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please enter valid date!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        //NSLog(@"%@",self.month.text);
        ReservationViewController *reservation =  [[[self navigationController] viewControllers]objectAtIndex:4];
        
        NSString *stringDate = [NSString stringWithFormat:@"%@-%@-%@",self.year.text, self.month.text, self.day.text];
        
        [reservation.date setText:stringDate];
        
        //NSLog(@"%@", reservation.date);
        [[self navigationController] popToViewController:reservation animated:YES];

    }
   
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end

