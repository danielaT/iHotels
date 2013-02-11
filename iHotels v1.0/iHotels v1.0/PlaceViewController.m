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
#import "UIViewController+iHotelsColorTheme.h"
#import "RatingFaceView.h"
#import "DataBaseHelper.h"
#import <Social/Social.h>

@interface PlaceViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *hotelNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImageView;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet RatingFaceView *ratingFaceView;

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
    self.ratingImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageName ofType:@"png"]];
    
    // set the image from this place, if there is one
    if (self.hotel.photoPath == nil) {
        self.photoImageView.image = [UIImage imageNamed:DEFAULT_IMAGE_NAME];
    }
    else
    {
        NSData* imageData = [NSData dataWithContentsOfFile:self.hotel.photoPath];
        self.photoImageView.image = [UIImage imageWithData:imageData];
    }
    
    // set the smiley face image if the hotel has user rating
    self.ratingFaceView.backgroundColor = [UIColor clearColor];
    if (self.hotel.userRating) {
        self.ratingFaceView.ratingValue = [self.hotel.userRating integerValue];
        [self.ratingFaceView setNeedsDisplay];
    }
    
    // add gesture recognizer for tap on photo
    UITapGestureRecognizer *tapOnImageView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openImagePicker)];
    [tapOnImageView setNumberOfTapsRequired:1];
    [self.photoImageView addGestureRecognizer:tapOnImageView];

    // apply color theme methods
    [self configureSubviewsWithPatternImageName:@"iphone_places_pattern"];
    [self setBackground];
}


-(void) setBackground
{
    UIImage *backgroundImage;
    if ([[UIScreen mainScreen] bounds].size.height > 600.0)
    {
        // ipad
        backgroundImage = [[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"iphone_page" ofType:@"png"]]resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
        
        float scaleFactorX = (670.0 /backgroundImage.size.width);
        float scaleFactorY = (740.0 / backgroundImage.size.height);
        
        CGSize newSize = CGSizeMake(backgroundImage.size.width * scaleFactorX, backgroundImage.size.height * scaleFactorY);
        
        UIGraphicsBeginImageContext(newSize);
        [backgroundImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
        UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        backgroundImage = newImage;
    }
    else
    {
        // iphone
        backgroundImage = [[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"iphone_page" ofType:@"png"]]resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile];
    }
    
    // view controller background
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
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
    
    NSString* fileName = [NSString stringWithFormat:@"visited_place_%@%@.jpg", [dateFormatter stringFromDate: self.hotel.startDate], self.hotel.hotelName];
    NSString* fullPath = [[documentsDirectoryURL path] stringByAppendingString:fileName];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSData* imageData = UIImageJPEGRepresentation(image, 1.0);
    
    if ([manager createFileAtPath:fullPath contents:imageData attributes:nil]) {
        
        // if file is saved successfully, update the entry in the database!
        self.hotel.photoPath = fullPath;

        // load the image in the imageview
        self.photoImageView.image = image;
    }
}



- (IBAction)shareOnFacebookButtonTap:(id)sender
{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *facebookSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        NSString* messageText;
        if ([self.hotel.userRating integerValue] != 0) {
            messageText = [NSString stringWithFormat:@"was at %@ on %@ and rated the experience %d/5!",  self.hotelNameLabel.text, self.dateLabel.text, [self.hotel.userRating integerValue]];
        }
        else {
            messageText = [NSString stringWithFormat:@"was at %@ on %@!",  self.hotelNameLabel.text, self.dateLabel.text];
        }
        [facebookSheet setInitialText:messageText];
        
        // add image if there is one
        if (self.hotel.photoPath) {
            [facebookSheet addImage:[UIImage imageWithContentsOfFile:self.hotel.photoPath]];
        }
        
        [facebookSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    // NSLog(@"Post Cancelled");
                    break;
                    
                case SLComposeViewControllerResultDone:
                {
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Post successful!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [alert show];
                    break;
                }
                    
                default:
                    break;
            }
        }];
        [self presentViewController:facebookSheet animated:YES completion:nil];
    }

}



- (IBAction)postOnTwitterButtonTap:(id)sender
{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *twitterSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        NSString* messageText;
        if (([self.hotel.userRating integerValue] != 0)) {
            messageText = [NSString stringWithFormat:@"was at %@ on %@ and rated the experience %d/5!",  self.hotelNameLabel.text, self.dateLabel.text, [self.hotel.userRating integerValue]];
        }
        else {
            messageText = [NSString stringWithFormat:@"was at %@ on %@!",  self.hotelNameLabel.text, self.dateLabel.text];
        }
        [twitterSheet setInitialText:messageText];
        
        // add image if there is one
        if (self.hotel.photoPath) {
            [twitterSheet addImage:[UIImage imageWithContentsOfFile:self.hotel.photoPath]];
        }
        
        [twitterSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    //NSLog(@"Post Cancelled");
                    break;
                    
                case SLComposeViewControllerResultDone:
                {
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Post successful!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [alert show];
                    break;
                }
                    
                default:
                    break;
            }
        }];
        [self presentViewController:twitterSheet animated:YES completion:nil];
    }
}


- (IBAction)plusButtonTap:(id)sender {
    if (self.ratingFaceView.ratingValue<5) {
        self.ratingFaceView.ratingValue++;
        [self.ratingFaceView setNeedsDisplay];
        
        self.hotel.userRating = [NSNumber numberWithInteger:self.ratingFaceView.ratingValue];
        [DataBaseHelper saveContext];
    }
    
}
- (IBAction)ipadPlusTap:(id)sender {
    [self plusButtonTap:sender];
}

- (IBAction)minusButtonTap:(id)sender {
    if (self.ratingFaceView.ratingValue>1) {
        self.ratingFaceView.ratingValue--;
        [self.ratingFaceView setNeedsDisplay];
        
        self.hotel.userRating = [NSNumber numberWithInteger:self.ratingFaceView.ratingValue];
        [DataBaseHelper saveContext];
    }
}

- (IBAction)ipadMinusTap:(id)sender {
    [self minusButtonTap:sender];
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
