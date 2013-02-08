//
//  UIViewController+iHotelsColorTheme.h
//  iHotels v1.0
//
//  Created by Martin on 06-02-2013.
//  Copyright (c) 2013 Student14. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (iHotelsColorTheme)

-(void)applyiHotelsThemeWithPatternImageName:(NSString*)patternImageName;
-(void)configureSubviewsWithPatternImageName:(NSString*)patternImageName;
-(void)configureNavigationBar;

@end
