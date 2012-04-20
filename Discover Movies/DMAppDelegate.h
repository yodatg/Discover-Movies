//
//  DMAppDelegate.h
//  Discover Movies
//
//  Created by Thomas Grant on 30/11/2011.
//  Copyright (c) 2011 Reading University. All rights reserved.
//
//
//  Recieves and responds to delegate messages from UIApplicaition object
//
//
//

#import <UIKit/UIKit.h>
#import "DMMovieStore.h"
#import "DMTopMoviesViewController.h"
#import "FBConnect.h"

@interface DMAppDelegate : UIResponder <UIApplicationDelegate, FBSessionDelegate, FBDialogDelegate> {
    
    DMTopMoviesViewController *vc;
    DMMovieStore *movieStore;
    Facebook *facebook;

    
    
   
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) DMTopMoviesViewController *vc;
@property (nonatomic, retain) Facebook *facebook;


@end
