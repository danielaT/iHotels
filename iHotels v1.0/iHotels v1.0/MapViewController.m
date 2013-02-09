//
//  MapViewController.m
//  iHotels v1.0
//
//  Created by Martin on 02-02-2013.
//  Copyright (c) 2013 Student14. All rights reserved.
//

#import "MapViewController.h"
#import "CityPickerViewController.h"
#import "UIViewController+iHotelsColorTheme.h"

@interface MapViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *mapImageView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIButton *browseCitiesButton;

@property NSString* selectedRegion;
@property NSString* searchString;

@end



@implementation MapViewController
@synthesize selectedRegion = _selectedRegion;
@synthesize searchString = _searchString;


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Cities&Hotels";
    
    self.mapImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"iphone_map_bulgaria" ofType:@"png"]];
       
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnImage:)];
    tap.numberOfTapsRequired = 1;

    [self.mapImageView addGestureRecognizer:tap];
    
    // apply color theme methods
    [self applyiHotelsThemeWithPatternImageName:@"iphone_hotel_pattern"];
    [self configureNavigationBar];
    [self configureSubviewsWithPatternImageName:@"iphone_hotel_pattern"];
}


-(void)viewDidAppear:(BOOL)animated
{
//    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    UIInterfaceOrientation orientation = [[UIDevice currentDevice] orientation];
    [self rearrangeViewsInOrientation:orientation];
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self rearrangeViewsInOrientation:toInterfaceOrientation];
}

-(void) rearrangeViewsInOrientation:(UIInterfaceOrientation) orientation
{
    [UIView animateWithDuration:0.3 animations:^{
        if (orientation == UIInterfaceOrientationLandscapeRight || orientation == UIInterfaceOrientationLandscapeLeft) {
            
            if([[UIScreen mainScreen] bounds].size.height == 568.0)
            {
                // iphone 4.0 inch screen
                self.searchTextField.frame = CGRectMake(338, 30, 200, self.searchTextField.frame.size.height);
                self.searchButton.frame = CGRectMake(363, 80, self.searchButton.frame.size.width, self.searchButton.frame.size.height);
                self.browseCitiesButton.frame = CGRectMake(363, 140, self.browseCitiesButton.frame.size.width, self.browseCitiesButton.frame.size.height);
                self.mapImageView.frame = CGRectMake(30, 20, self.mapImageView.frame.size.width, self.mapImageView.frame.size.height);
            }
            else
            {
                // iphone 3.5 inch screen
                self.searchTextField.frame = CGRectMake(310, 30, 150, self.searchTextField.frame.size.height);
                self.searchButton.frame = CGRectMake(310, 80, self.searchButton.frame.size.width, self.searchButton.frame.size.height);
                self.browseCitiesButton.frame = CGRectMake(310, 140, self.browseCitiesButton.frame.size.width, self.browseCitiesButton.frame.size.height);
                self.mapImageView.frame = CGRectMake(10, 20, self.mapImageView.frame.size.width, self.mapImageView.frame.size.height);
            }
            // TODO = code for iPad screen
        }
    }];
}


-(void)tapOnImage:(id)sender
{
    UITapGestureRecognizer *recognizer = (UITapGestureRecognizer*)sender;
    
    if (recognizer.view == self.mapImageView) {
        
        // get the tap location inside the image
        float x = [recognizer locationInView:self.mapImageView].x;
        float y = [recognizer locationInView:self.mapImageView].y;
        
        // get the corresponding mapping in control image coordinates
        float coefX = IMAGE_WIDTH/self.mapImageView.frame.size.width;
        float coefY = IMAGE_HEIGHT/self.mapImageView.frame.size.height;
        int xInImage = x*coefX;
        int yInImage = y*coefY;
        
        UIImage *controlImage = [UIImage imageNamed:@"map_control.png"];
        UIColor *tappedColor = [self colorOfPointAt:xInImage andY:yInImage inImage:controlImage];
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"RegionsAndCities" ofType:@"plist"];
        NSDictionary *regionsAndCities = [NSDictionary dictionaryWithContentsOfFile:plistPath];
        
        NSDictionary *regionsFromPlist = [regionsAndCities objectForKey:@"Regions"];
        
        // Find the correct region by comparing its color from the plist with the color from the tap on the map.
        for (NSString *regionName in regionsFromPlist) {
            NSDictionary* colorComponents = [[regionsFromPlist objectForKey:regionName] objectForKey:@"ColorForRegion"];
            NSNumber* hue           = [colorComponents objectForKey:@"Hue"];
            NSNumber* saturation    = [colorComponents objectForKey:@"Saturation"];
            NSNumber* brightness    = [colorComponents objectForKey:@"Brightness"];
            
            UIColor* regionColor = [UIColor colorWithHue:hue.floatValue saturation:saturation.floatValue brightness:brightness.floatValue alpha:1.0];
            
            if ([self compareColor:regionColor withColor:tappedColor]) {
                self.selectedRegion = regionName;
                [self performSegueWithIdentifier:@"toCityListSegue" sender:nil];
            }
        }        
    }
}



// A method to get the color components in RGBa from a point in image
-(UIColor*)colorOfPointAt:(CGFloat)x andY:(CGFloat)y inImage:(UIImage*)image
{
    CGImageRef imageRef = [image CGImage];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = (unsigned char*) calloc(IMAGE_HEIGHT * IMAGE_WIDTH * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * IMAGE_WIDTH;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, IMAGE_WIDTH, IMAGE_HEIGHT,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, IMAGE_WIDTH, IMAGE_HEIGHT), imageRef);
    CGContextRelease(context);
    
    int byteIndex = y * bytesPerRow + x * bytesPerPixel;
    
    CGFloat red   = (rawData[byteIndex]     * 1.0) / 255.0;
    CGFloat green = (rawData[byteIndex + 1] * 1.0) / 255.0;
    CGFloat blue  = (rawData[byteIndex + 2] * 1.0) / 255.0;
    CGFloat alpha = (rawData[byteIndex + 3] * 1.0) / 255.0;
    
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    return color;
}



// A separate method to determine how similar two colors are. This is needed because colors are defined with float numbers. If colors are similar within a given tolerance (distance in RGB color space), we consider them to be equal.
-(BOOL)compareColor:(UIColor*)firstColor withColor:(UIColor*)secondColor
{
    CGColorRef color1ref = [firstColor CGColor];
    CGColorRef color2ref = [secondColor CGColor];

    const CGFloat *components1 = CGColorGetComponents(color1ref);
    const CGFloat *components2 = CGColorGetComponents(color2ref);
    
    CGFloat red1    = components1[0];
    CGFloat green1  = components1[1];
    CGFloat blue1   = components1[2];
    
    CGFloat red2    = components2[0];
    CGFloat green2  = components2[1];
    CGFloat blue2   = components2[2];
    
    float result = sqrt(powf(red1 - red2, 2.0) + powf(green1 - green2, 2.0) + powf(blue1 - blue2, 2.0));
    
//    CFRelease(color1ref);
//    CFRelease(color2ref);    

    if (result<0.1) {
        return YES;
    }
    return NO;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toCityListSegue"]) {
        CityPickerViewController* cityPickerViewController = (CityPickerViewController*) segue.destinationViewController;
        [cityPickerViewController setRegion: self.selectedRegion];
        [cityPickerViewController setSearchString:self.searchString];
    }
}

- (IBAction)searchButtonTap:(id)sender {
    self.selectedRegion = nil;
    NSString *trimmedString = [self.searchTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([trimmedString length] > 0) {
        self.searchString = self.searchTextField.text;
        [self performSegueWithIdentifier:@"toCityListSegue" sender:self];
    }
}

- (IBAction)browseCitiesButtonTap:(id)sender {
    self.selectedRegion = nil;
    self.searchString = @"";
    [self performSegueWithIdentifier:@"toCityListSegue" sender:self];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
