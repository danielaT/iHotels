//
//  MasterViewController.h
//  iHotels v1.0
//
//  Created by Student14 on 1/30/13.
//  Copyright (c) 2013 Student14. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

#import <CoreData/CoreData.h>

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (nonatomic) NSString* cityName;
@property (nonatomic) NSDictionary* searchFilters;

@end
