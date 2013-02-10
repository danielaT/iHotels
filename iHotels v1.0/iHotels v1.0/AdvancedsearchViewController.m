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
#import "CityPickerViewController.h"

@interface AdvancedsearchViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    NSArray* amenities;
    NSArray* propertyCategories;
    NSArray* citiesArray;
    NSDictionary* searchFilters;
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
    
    // the search must have selected city
    [self validateSearch];
    
    // selected city
    NSString* selectedCityName = [citiesArray objectAtIndex:self.cities.indexPathForSelectedRow.row];
    
    // selected property categoris
    NSMutableArray* selectedPropertyCategories = [[NSMutableArray alloc] init];
    for (NSIndexPath* indexPath in self.propertyCategories.indexPathsForSelectedRows) {
        [selectedPropertyCategories addObject:[propertyCategories objectAtIndex:indexPath.row]];
    }
    
    // selected amenities
    NSMutableArray* selectedAmenities = [[NSMutableArray alloc] init];
    for (NSIndexPath* indexPath in self.amenities.indexPathsForSelectedRows) {
        [selectedAmenities addObject:[amenities objectAtIndex:indexPath.row]];
    }
    
    [searchFilters setValue:selectedCityName forKey:@"city"];
    [searchFilters setValue:selectedAmenities forKey:@"amenities"];
    [searchFilters setValue:selectedPropertyCategories forKey:@"propertyCategories"];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showFilteredHotels"]) {
        CityPickerViewController* cityPicker = (CityPickerViewController*)segue.destinationViewController;
        cityPicker.searchFilters = searchFilters;
    }
}

-(void)validateSearch {
    if ([[citiesArray objectAtIndex:self.cities.indexPathForSelectedRow.row] length] <= 0) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:@"You have to select a city for searching." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
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
    citiesArray = [DataBaseHelper getAllCitiesFromPlist];
    citiesArray = [DataBaseHelper sortArray:citiesArray];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (tableView.tag) {
        case 0:
            return [citiesArray count];
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
            cell.textLabel.text = [citiesArray objectAtIndex: indexPath.row];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 0) {
        NSArray *visibleCells = [tableView visibleCells];
        for (UITableViewCell *cell in visibleCells) {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
    }

    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [textField resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
