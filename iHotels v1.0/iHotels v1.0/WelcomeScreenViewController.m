//
//  WelcomeScreenViewController.m
//  iHotels v1.0
//
//  Created by Martin on 02-02-2013.
//  Copyright (c) 2013 Student14. All rights reserved.
//

#import "WelcomeScreenViewController.h"

@interface WelcomeScreenViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

@end

@implementation WelcomeScreenViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	self.logoImageView.image = [UIImage imageNamed:@"ihotels_logo"];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self performSelector:@selector(goToTabBarController) withObject:nil afterDelay:3];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)goToTabBarController
{
    UIStoryboard *storyboard = self.storyboard;
    UITabBarController* tabBarController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
    [self presentViewController:tabBarController animated:YES completion:NULL];
}



@end
