//
//  PlacesPageViewController.m
//  iHotels v1.0
//
//  Created by Martin on 05-02-2013.
//  Copyright (c) 2013 Student14. All rights reserved.
//

#import "PlacesPageViewController.h"
#import "PlaceViewController.h"
#import "HotelVisited.h"
#import "AppDelegate.h"

@interface PlacesPageViewController () <UIPageViewControllerDataSource>
@property (nonatomic, strong) NSArray* visitedHotels;
@property (nonatomic, strong) UIPageViewController *pageController;
@end

@implementation PlacesPageViewController
@synthesize selectedHotel = _selectedHotel;
@synthesize pageController = _pageController;
@synthesize visitedHotels = _visitedHotels;

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
    [self populateHotels];
    [self setUpPageViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



-(void) populateHotels
{
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = delegate.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"HotelVisited"];
    NSSortDescriptor *descriptor =[[NSSortDescriptor alloc] initWithKey:@"startDate" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:descriptor];
    NSError *error;
    
    self.visitedHotels = [context executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"Error fetching: %@", error);
    }
    //NSLog(@"count: %d",[self.visitedHotels count]);
}



-(void)setUpPageViewController
{
//    NSDictionary *options =  [NSDictionary dictionaryWithObject: [NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin] forKey: UIPageViewControllerOptionSpineLocationKey];
    
    NSDictionary *options =  [NSDictionary dictionaryWithObject: @20.0 forKey: UIPageViewControllerOptionSpineLocationKey];
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options: options];
    
    self.pageController.dataSource = self;
    [[self.pageController view] setFrame:[[self view] bounds]];
    
    PlaceViewController *initialViewController = [self viewControllerAtIndex: [self.visitedHotels indexOfObject:self.selectedHotel]];
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageController];
    [[self view] addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];
}




#pragma mark - page view controller data source methods

- (PlaceViewController *)viewControllerAtIndex:(NSUInteger)index
{
    // Return the data view controller for the given index.
    if (([self.visitedHotels count] == 0) ||
        (index >= [self.visitedHotels count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    PlaceViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"PlaceViewController"];
    controller.hotel = [self.visitedHotels objectAtIndex:index];
    return controller;
}



- (NSUInteger)indexOfViewController:(PlaceViewController *)viewController
{
    return [self.visitedHotels indexOfObject: viewController.hotel];
}



- (UIViewController *)pageViewController: (UIPageViewController *)pageViewController viewControllerBeforeViewController: (UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController: (PlaceViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}



- (UIViewController *)pageViewController: (UIPageViewController *)pageViewController viewControllerAfterViewController: (UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController: (PlaceViewController*)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.visitedHotels count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}



@end
