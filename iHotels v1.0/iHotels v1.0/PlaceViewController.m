//
//  PlaceViewController.m
//  iHotels v1.0
//
//  Created by Martin on 05-02-2013.
//  Copyright (c) 2013 Student14. All rights reserved.
//
#import <MobileCoreServices/MobileCoreServices.h>

#import "AppDelegate.h"
#import "PlaceViewController.h"
#import "HotelVisited.h"

@interface PlaceViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *hotelNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImageView;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

- (IBAction)shareOnFacebookButtonTap:(id)sender;
- (IBAction)postOnTwitterButtonTap:(id)sender;

-(void)openImagePicker;
-(void)saveImageToDocumentsFolder:(UIImage*)image;

@end

@implementation PlaceViewController
@synthesize hotel = _hotel;

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
    
    // set the name of the hotel label
	self.hotelNameLabel.text = self.hotel.hotelName;
    
    // set the date label
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    self.dateLabel.text = [dateFormatter stringFromDate: self.hotel.startDate];
    
    // set the star number image
    NSString* imageName = [NSString stringWithFormat:@"iphone_star%d", [self.hotel.hotelRate integerValue]];
    self.ratingImageView.image = [UIImage imageNamed:imageName];
    
    // set the image from this place, if there is one
    if (self.hotel.photoPath == nil) {
        self.photoImageView.image = [UIImage imageNamed:DEFAULT_IMAGE_NAME];
    }
    else
    {
        NSData* imageData = [NSData dataWithContentsOfFile:self.hotel.photoPath];
        self.photoImageView.image = [UIImage imageWithData:imageData];
    }
    
    // add gesture recognizer for tap on photo
    UITapGestureRecognizer *tapOnImageView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openImagePicker)];
    [tapOnImageView setNumberOfTapsRequired:1];
    [self.photoImageView addGestureRecognizer:tapOnImageView];

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)openImagePicker
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.mediaTypes = [NSArray arrayWithObjects: (NSString *) kUTTypeImage, nil];
    
    [self presentViewController: imagePicker animated:YES completion:nil];
}



-(void)saveImageToDocumentsFolder:(UIImage*)image
{
    NSURL *documentsDirectoryURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
    // create a string for picture filename
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    NSString* fileName = [NSString stringWithFormat:@"visited_place_%@.jpg", [dateFormatter stringFromDate: self.hotel.startDate]];
    NSString* fullPath = [[documentsDirectoryURL path] stringByAppendingString:fileName];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSData* imageData = UIImageJPEGRepresentation(image, 1.0);
    
    if ([manager createFileAtPath:fullPath contents:imageData attributes:nil]) {
        
        // if file is saved successfully, update the entry in the database!
        self.hotel.photoPath = fullPath;
        // save the context
        AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
        NSError* error;
        if (![delegate.managedObjectContext save:&error])
        {
            NSLog(@"error updating photo path: %@", error.localizedDescription);
        }
    }
}



- (IBAction)shareOnFacebookButtonTap:(id)sender {

}



- (IBAction)postOnTwitterButtonTap:(id)sender {
}



#pragma mark - image picker delegate methods

-(void)imagePickerController: (UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // save image in documents folder and add its link to the VisitedHotel entity in the database
    // this would be nice to be done with threads!!! later.
    
    UIImage* selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self saveImageToDocumentsFolder:selectedImage];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:
(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
