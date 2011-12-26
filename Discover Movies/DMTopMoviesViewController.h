//
//  JSONViewController.h
//  Discover Movies
//
//  Created by Thomas Grant on 30/11/2011.
//  Copyright (c) 2011 Reading University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieStore.h"
#import "DMMoviePosterView.h"

@class DMMoviePosterView;

@interface DMTopMoviesViewController : UIViewController <UIScrollViewDelegate>
{

    UIScrollView *movieScrollView; // ScrollView to add posters to
    UIView *moviePosterView; // View to place the posters
    
    NSMutableArray *moviePosterViews;
    NSMutableArray *moviePosterImageData; // Array to store movie posters
    NSMutableData *topMoviesData; // Data object to hold JSON Data
    
    
    MovieStore *movieStore; // Singleton Movie Store to store movies
    

    BOOL scrollingLocked; // Used to lock movieScrollView so that funny paging doesn't
                          // occur when rotating the device
    
}
@property (nonatomic, strong) IBOutlet UIImageView *background;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;

@end
