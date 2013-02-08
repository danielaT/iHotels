//
//  DetailViewController.h
//  iHotels v1.0
// vcxvcxvxc
//  Created by Student14 on 1/30/13.
//  Copyright (c) 2013 Student14. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
