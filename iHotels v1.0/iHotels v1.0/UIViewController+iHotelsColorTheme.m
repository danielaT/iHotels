//
//  UIViewController+iHotelsColorTheme.m
//  iHotels v1.0
//
//  Created by Martin on 06-02-2013.
//  Copyright (c) 2013 Student14. All rights reserved.
//

#import "UIViewController+iHotelsColorTheme.h"

NSString* const LIGHT_FONT = @"Baar Philos";
NSString* const HEAVY_FONT = @"BaarPhilosBold";

@implementation UIViewController (iHotelsColorTheme)

-(void)applyiHotelsThemeWithPatternImageName:(NSString*)patternImageName
{
    UIImage* pattern = [[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:patternImageName ofType:@"png"]]resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile];
    
    // view controller background
    self.view.backgroundColor = [UIColor colorWithPatternImage:pattern];
    
    // tableviewcontroller table background
    if ([[self class] isSubclassOfClass:[UITableViewController class]]) {
        UITableViewController* controller = (UITableViewController*)self;
        UIImageView* background = [[UIImageView alloc]initWithImage:pattern];
        controller.tableView.backgroundView = background;
    }
}


-(void)configureNavigationBar
{
    // some constant colors
    UIColor* const VERY_LIGHT_COLOR = [UIColor colorWithHue:0.1417 saturation:0.21 brightness:0.9 alpha:1];
    //UIColor* const LIGHT_COLOR = [UIColor colorWithHue:0.1417 saturation:0.27 brightness:0.79 alpha:1];
    UIColor* const DARK_COLOR = [UIColor colorWithHue:0.63 saturation:0.17 brightness:0.4 alpha:1];
    
    // navigation bar background and text style
    UIImage *image = [[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"iphone_navbar" ofType:@"png"]] resizableImageWithCapInsets:UIEdgeInsetsZero];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = DARK_COLOR;
    
    NSMutableDictionary *navBarTextAttributes = [[NSMutableDictionary alloc]initWithObjectsAndKeys: nil];
    [navBarTextAttributes setObject:[UIFont fontWithName:HEAVY_FONT size:20.0] forKey:UITextAttributeFont];
    [navBarTextAttributes setObject:DARK_COLOR forKey:UITextAttributeTextColor];
    [navBarTextAttributes setObject:VERY_LIGHT_COLOR forKey:UITextAttributeTextShadowColor];
    [navBarTextAttributes setObject:[NSValue valueWithUIOffset:UIOffsetMake(0, 1)] forKey:UITextAttributeTextShadowOffset];
    
    self.navigationController.navigationBar.titleTextAttributes = navBarTextAttributes;
    self.navigationController.navigationBar.tintColor = DARK_COLOR;
}

-(void)configureSubviewsWithPatternImageName:(NSString*) patternImageName
{
    // some constant colors
    UIColor* const VERY_LIGHT_COLOR = [UIColor colorWithHue:0.1417 saturation:0.21 brightness:0.9 alpha:1];
    UIColor* const LIGHT_COLOR = [UIColor colorWithHue:0.1417 saturation:0.27 brightness:0.79 alpha:1];
    UIColor* const DARK_COLOR = [UIColor colorWithHue:0.63 saturation:0.17 brightness:0.4 alpha:1];
    
    // now configure the subviews
    for (UIView* view in self.view.subviews) {
        // standard buttons
        if ([view class] == [UIButton class]) {
            UIButton* button = (UIButton*)view;
            [button setBackgroundImage:[[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"iphone_button" ofType:@"png"]]resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
            
            button.titleLabel.font = [UIFont fontWithName:HEAVY_FONT size:16];
            button.titleLabel.textColor = LIGHT_COLOR;
        }
        // textfields
        else if ([view class] == [UITextField class])
        {
            UITextField *textField = (UITextField*)view;
            [textField setBackgroundColor:VERY_LIGHT_COLOR];
            [textField setTextColor:DARK_COLOR];
            [textField setFont: [UIFont fontWithName:HEAVY_FONT size:16]];
        }
        // textViews
        else if ([view class] == [UITextView class])
        {
            UITextView *textView = (UITextView*)view;
            [textView setFont: [UIFont fontWithName:LIGHT_FONT size:14]];
            [textView setBackgroundColor:[UIColor clearColor]];
            [textView setTextColor:DARK_COLOR];
        }
        // labels
        else if ([view class] == [UILabel class])
        {
            UILabel *label = (UILabel*)view;
            [label setBackgroundColor: [UIColor clearColor]];
            [label setFont: [UIFont fontWithName:HEAVY_FONT size:16]];
            [label setTextColor:DARK_COLOR];
        }
        // tableviews
        else if ([view class] == [UITableView class])
        {
            UITableView* tableView = (UITableView*)view;
            UIImage* pattern = [[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:patternImageName ofType:@"png"]]resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile];
            UIImageView* background = [[UIImageView alloc]initWithImage:pattern];
            tableView.backgroundView = background;
        }
    }
}


@end
