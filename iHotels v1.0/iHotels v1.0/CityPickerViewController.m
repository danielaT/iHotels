//
//  CityPickerViewController.m
//  iHotels v1.0
//
//  Created by Martin on 02-02-2013.
//  Copyright (c) 2013 Student14. All rights reserved.
//

#import "CityPickerViewController.h"
#import "MasterViewController.h"
#import "UIViewController+iHotelsColorTheme.h"
#import "DataBaseHelper.h"

NSString* const BLANK_SPACE = @" ";
NSString* const BLANK_SPACE_REPLACEMENT = @"%20";

@interface CityPickerViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray* availableCitiesArray;
@property (nonatomic, strong) NSString* selectedRegionName;
@property (nonatomic, strong) NSString* selectedSearchString;

@end

@implementation CityPickerViewController

@synthesize availableCitiesArray = _availableCitiesArray;
@synthesize selectedSearchString = _selecredSearchString;
@synthesize selectedRegionName = _selectedRegionName;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // apply color theme methods
    [self applyiHotelsThemeWithPatternImageName:@"iphone_hotel_pattern"];
    [self configureSubviewsWithPatternImageName:@"iphone_hotel_pattern"];
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"RegionsAndCities" ofType:@"plist"];
    NSDictionary *regionsAndCities = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    // if region is nil, that means that the user has made a search or selected to see all cities
    if (self.selectedRegionName == nil) {
        
        [self searchCitiesInPlist:regionsAndCities thatMatchSearchString:self.selectedSearchString];
    }
    else
        // get the cities for the selected region
    {
        [self getCitiesInRegionFromPlist:regionsAndCities];
    }
}

-(void) searchCitiesInPlist:(NSDictionary*)plist thatMatchSearchString:(NSString*) string
{
    NSMutableArray* citiesArray = [[NSMutableArray alloc] init];
    NSDictionary *regionsFromPlist = [plist objectForKey:@"Regions"];
    
    // If search string is empty, just add every city.
    NSString *trimmedString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([trimmedString length] <= 0) {
        self.availableCitiesArray = [DataBaseHelper getAllCitiesFromPlist];
    }
    
    // Add all cities that contain the search string to the temporary "citiesArray"
    else {
        for (NSString* regionName in regionsFromPlist) {
            NSDictionary* region = [regionsFromPlist objectForKey:regionName];
            NSArray* citiesInRegion = [region objectForKey:@"Cities"];
            for (int i=0; i<[citiesInRegion count]; i++) {
                
                NSString* cityName = [citiesInRegion objectAtIndex:i];
                
                NSRange range = [cityName rangeOfString:string options:NSCaseInsensitiveSearch];
                
                if (!(range.location == NSNotFound) || ([string isEqualToString:@""]))
                {
                    [citiesArray addObject:[citiesInRegion objectAtIndex:i]];
                }
            }
        }
    }
    
    // Sort the citiesArray and place the result in the availableCitiesArray, which fills the tableview later.
    self.availableCitiesArray = (NSArray*) citiesArray;
    self.availableCitiesArray = [DataBaseHelper sortArray:self.availableCitiesArray];
    
    // set the title
    self.title = @"Available Cities";
}

-(void) getCitiesInRegionFromPlist:(NSDictionary*)plist
{
    // get the cities that are going to be displayed (from plist)
    NSDictionary *regionsFromPlist = [plist objectForKey:@"Regions"];
    NSDictionary *selectedRegion = [regionsFromPlist objectForKey:self.selectedRegionName];
    self.availableCitiesArray = [selectedRegion objectForKey:@"Cities"];
    self.availableCitiesArray = [DataBaseHelper sortArray:self.availableCitiesArray];
    
    // set the region name as title
    self.title = [NSString stringWithFormat:@"%@ Region", self.selectedRegionName];
    
}

-(void) setRegion:(NSString*)regionName
{
    self.selectedRegionName = regionName;
}

-(void) setSearchString:(NSString *)searchString
{
    self.selectedSearchString = searchString;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toHotelListSegue"]) {
        NSIndexPath *selectedRowIndexPath = [self.tableView indexPathForSelectedRow];
        MasterViewController *hotelListController = (MasterViewController*) segue.destinationViewController;
        
        // replace blank spaces with %02 for correct response
        [hotelListController setCityName: [[self.availableCitiesArray objectAtIndex:selectedRowIndexPath.row] stringByReplacingOccurrencesOfString:BLANK_SPACE withString:BLANK_SPACE_REPLACEMENT]];
    }
}

#pragma mark - table view delegate and data source methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.availableCitiesArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CityCell"];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSString* cityName = [self.availableCitiesArray objectAtIndex: indexPath.row];
    cell.textLabel.text = cityName;
    cell.textLabel.font = [UIFont fontWithName:@"Baar Philos" size:16.0];
    cell.textLabel.textColor = [UIColor colorWithHue:0.1417 saturation:0.21 brightness:0.9 alpha:1];
    cell.backgroundColor = [UIColor colorWithHue:0.63 saturation:0.17 brightness:0.4 alpha:1];
    UIImageView* accessory = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"iphone_disclosure_indicator" ofType:@"png"]]];
    [cell setAccessoryView:accessory];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:selectedIndexPath animated:NO];
}

@end
