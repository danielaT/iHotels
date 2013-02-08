//
//  GalleryViewController.m
//  iHotels v1.0
//
//  Created by Student14 on 2/1/13.
//  Copyright (c) 2013 Student14. All rights reserved.
//

#import "GalleryViewController.h"

#import "ImageCollectionViewCell.h"

#import "HotelImageViewController.h"

@interface GalleryViewController () <UICollectionViewDelegateFlowLayout>

@property NSArray* receivedImages;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@end

@implementation GalleryViewController

@synthesize hotelImages=_hotelImages;
@synthesize receivedImages=_receivedImages;
@synthesize loadingIndicator=_loadingIndicator;

-(void)setHotelImages:(NSMutableArray *)hotelImages {
    self.receivedImages = hotelImages;
    [self.collectionView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.loadingIndicator startAnimating];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.receivedImages.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.loadingIndicator isAnimating]) {
        [self.loadingIndicator stopAnimating];
        [self.loadingIndicator setHidden:YES];
    }
    
    ImageCollectionViewCell *imageCell = [collectionView dequeueReusableCellWithReuseIdentifier: @"ImageCell" forIndexPath: indexPath];
    NSData *imageData = [NSData dataWithContentsOfFile:self.receivedImages[indexPath.row]];
    imageCell.hotelImage.image = [UIImage imageWithData: imageData];
    return imageCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showImage"])
    {
        NSIndexPath *selectedIndexPath = [[self.collectionView indexPathsForSelectedItems] objectAtIndex:0];
        HotelImageViewController *hotelImage = [segue destinationViewController];
        NSData *imageData = [NSData dataWithContentsOfFile:self.receivedImages[selectedIndexPath.row]];
        hotelImage.image = [UIImage imageWithData: imageData];
    }
}

@end
