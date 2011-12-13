//
//  DMAppDelegate.h
//  Discover Movies
//
//  Created by Thomas Grant on 30/11/2011.
//  Copyright (c) 2011 Reading University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMTopMoviesViewController.h"

@interface DMAppDelegate : UIResponder <UIApplicationDelegate> {
    
    DMTopMoviesViewController *topMoviesViewController;
    
    
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) DMTopMoviesViewController *topMoviesViewController;


@end
