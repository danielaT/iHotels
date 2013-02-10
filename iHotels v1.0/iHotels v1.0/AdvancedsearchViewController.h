//
//  AdvancedsearchViewController.h
//  iHotels v1.0
//
//  Created by Student14 on 2/10/13.
//  Copyright (c) 2013 Student14. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdvancedsearchViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *cities;
@property (weak, nonatomic) IBOutlet UITableView *amenities;
@property (weak, nonatomic) IBOutlet UITableView *propertyCategories;
@property (weak, nonatomic) IBOutlet UITextField *priceFrom;
@property (weak, nonatomic) IBOutlet UITextField *priceTo;

@end
