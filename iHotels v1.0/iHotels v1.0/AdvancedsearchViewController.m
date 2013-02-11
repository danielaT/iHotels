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
#import "MasterViewController.h"

@interface AdvancedsearchViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    NSArray* amenities;
    NSArray* propertyCategories;
    NSArray* citiesArray;
    NSMutableDictionary* searchFilters;
    NSString* selectedCity;
    NSMutableArray* selectedPropertyCategories;
    NSMutableArray* selectedAmenities;
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
    
    // apply color theme methods
    [self applyiHotelsThemeWithPatternImageName:@"iphone_hotel_pattern"];
    [self configureSubviewsWithPatternImageName:@"iphone_hotel_pattern"];
    
    [self configureControls];
    
    // load information for filters
    [self loadInformationForAdvancedSearch];
}

-(void) search:(id)sender {
    
    // the search must have selected city
    if (![self isValid]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:@"You have to select a city for searching." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    else {
        NSString *minRate = [self.priceFrom.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *maxRate = [self.priceTo.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        [searchFilters setValue:minRate forKey:@"minRate"];
        [searchFilters setValue:maxRate forKey:@"maxRate"];
        [searchFilters setValue:selectedCity forKey:@"city"];
        [searchFilters setValue:selectedAmenities forKey:@"amenities"];
        [searchFilters setValue:selectedPropertyCategories forKey:@"propertyCategories"];
        [self performSegueWithIdentifier:@"showFilteredHotels" sender:sender];
    }
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showFilteredHotels"]) {
        MasterViewController* filteredHotels = (MasterViewController*)segue.destinationViewController;
        filteredHotels.searchFilters = searchFilters;
    }
}

-(BOOL) isValid {
    if ([selectedCity length] <= 0) {
        return NO;
    }
    return YES;
}

-(void) configureControls {
    self.navigationItem.title = @"Search";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStyleDone target:self action:@selector(search:)];
    
    self.amenities.dataSource = self;
    self.amenities.delegate = self;
    self.propertyCategories.delegate = self;
    self.propertyCategories.dataSource = self;
    self.cities.delegate = self;
    self.cities.dataSource = self;
    
    searchFilters = [[NSMutableDictionary alloc] init];
    selectedAmenities = [[NSMutableArray alloc] init];
    selectedPropertyCategories = [[NSMutableArray alloc] init];
    
    self.priceFrom.keyboardType = UIKeyboardTypeNumberPad;
    self.priceTo.keyboardType = UIKeyboardTypeNumberPad;
}

-(void) loadInformationForAdvancedSearch
{
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

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 0) {
        for (UITableViewCell* cell in [tableView visibleCells]) {
            if ([cell.textLabel.text isEqualToString:selectedCity]) {
                UIImageView* checkMark = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"iphone_checkmark" ofType:@"png"]]];
                [cell setAccessoryView:checkMark];
            }
            else {
                [cell setAccessoryView:nil];
            }
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // if the cell was checked, uncheck it
    UIImageView* checkMark = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"iphone_checkmark" ofType:@"png"]]];
    if ([tableView cellForRowAtIndexPath:indexPath].accessoryView != nil) {
        [[tableView cellForRowAtIndexPath:indexPath] setAccessoryView:nil];
        switch (tableView.tag) {
            case 0:
                selectedCity = nil;
                break;
            case 1:
                [selectedAmenities removeObject:[NSString stringWithFormat:@"%d", indexPath.row + 1]];
                break;
            case 2:
                [selectedPropertyCategories removeObject:[NSString stringWithFormat:@"%d", indexPath.row + 1]];
                break;
            default:
                break;
        }
    }
    
    else {
        switch (tableView.tag) {
            case 0:
            {
                selectedCity = [citiesArray objectAtIndex:indexPath.row];
                
                // select just one city at a time, so uncheck the other cities
                for (UITableViewCell* cell in [tableView visibleCells]) {
                     [cell setAccessoryView:nil];
                }
            }
                break;
            case 1:
                [selectedAmenities addObject:[NSString stringWithFormat:@"%d", indexPath.row + 1]];
                
                break;
            case 2:
                [selectedPropertyCategories addObject:[NSString stringWithFormat:@"%d", indexPath.row + 1]];
                break;
            default:
                break;
        }
        
        [[tableView cellForRowAtIndexPath:indexPath] setAccessoryView:checkMark];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [textField resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
