//
//  AdvancedsearchViewController.m
//  iHotels v1.0
//
//  Created by Student14 on 2/10/13.
//  Copyright (c) 2013 Student14. All rights reserved.
//

#import "AdvancedsearchViewController.h"
#import "UIViewController+iHotelsColorTheme.h"
#import "DataBaseHelper.h"

@interface AdvancedsearchViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray* amenities;
    NSArray* propertyCategories;
    NSArray* cities;
}
@end

@implementation AdvancedsearchViewController

@synthesize amenities=_amenities;
@synthesize cities=_cities;
@synthesize propertyCategories=_propertyCategories;
@synthesize priceFrom=_priceFrom;
@synthesize priceTo=_priceTo;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(search:)];
    
    // apply color theme methods
    [self applyiHotelsThemeWithPatternImageName:@"iphone_hotel_pattern"];
    [self configureSubviewsWithPatternImageName:@"iphone_hotel_pattern"];
    
    // load information for filters
    [self loadInformationForAdvancedSearch];
}

-(void)search:(id)sender {
    // TODO: filter cities
}

-(void) loadInformationForAdvancedSearch
{
    self.amenities.dataSource = self;
    self.amenities.delegate = self;
    self.propertyCategories.delegate = self;
    self.propertyCategories.dataSource = self;
    self.cities.delegate = self;
    self.cities.dataSource = self;
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"AdvancedSearch" ofType:@"plist"];
    NSDictionary *advancedSearchSettings = [[NSDictionary dictionaryWithContentsOfFile:plistPath] valueForKey:@"AdvancedSearchSettings"];
    
    // get the amenities that are going to be displayed (from plist)
    amenities = [advancedSearchSettings objectForKey:@"Amenities"];
    
    // get the property categories that are going to be displayed (from plist)
    propertyCategories = [advancedSearchSettings objectForKey:@"PropertyCategories"];
    
    // get the cities that are going to be displayed (from plist)
    cities = [DataBaseHelper getAllCitiesFromPlist];
    cities = [DataBaseHelper sortArray:cities];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (tableView.tag) {
        case 0:
            return [cities count];
            break;
        case 1:
            return [amenities count];
            break;
        case 2:
            return [propertyCategories count];
            break;
        default:
            return 0;
            break;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (tableView.tag) {
        case 0: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CityCell"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CityCell"];
            }
            cell.textLabel.text = [cities objectAtIndex: indexPath.row];
            cell = [self configureCell:cell atIndexPath:indexPath];
            return cell;
        }
            break;
        case 1: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AmenityCell"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AmenityCell"];
            }
            
            cell.textLabel.text = [amenities objectAtIndex: indexPath.row];
            cell = [self configureCell:cell atIndexPath:indexPath];
            return cell;
        }
            break;
        case 2:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PropertyCategoryCell"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PropertyCategoryCell"];
            }
            cell.textLabel.text = [propertyCategories objectAtIndex: indexPath.row];
            cell = [self configureCell:cell atIndexPath:indexPath];
            return cell;
        }
            break;
        default: return [[UITableViewCell alloc] init];
            break;
    }
}

- (UITableViewCell*)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.font = [UIFont fontWithName:@"Baar Philos" size:14.0];
    cell.textLabel.textColor = [UIColor colorWithHue:0.1417 saturation:0.21 brightness:0.9 alpha:1];
    cell.backgroundColor = [UIColor colorWithHue:0.63 saturation:0.17 brightness:0.4 alpha:1];
    return cell;
}

@end
