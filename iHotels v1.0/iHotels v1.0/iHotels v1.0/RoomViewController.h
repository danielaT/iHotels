//
//  RoomViewController.h
//  iHotels v1.0
//
//  Created by Student14 on 2/2/13.
//  Copyright (c) 2013 Student14. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoomViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *roomAmenitiesTableView;
@property (nonatomic) NSDictionary* roomDictionary;

@end
