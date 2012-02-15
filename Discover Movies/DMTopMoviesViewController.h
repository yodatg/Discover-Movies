//
//  DMTopMoviesViewControllerPortrait.h
//  Discover Movies
//
//  Created by Thomas Grant on 28/12/2011.
//  Copyright (c) 2011 Reading University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMMovieStore.h"
#import "DMMoviePosterView.h"
#import "DMTopMoviePosterView.h"
#import "DMTopMoviePosterViewLandscape.h"
#import "DMDetailViewController.h"


@interface DMTopMoviesViewController : UIViewController <UIScrollViewDelegate, DMTopMoviePosterViewDelegate, UISearchBarDelegate> {
    
    // Access to the Model
    DMMovieStore *movieStore;
    // Local store of moviePosterViews, copied from the movieStore
    NSMutableArray *moviePosterViews;
    
    UIScrollView *scrollView;
    UIPageControl *pageControl;
    UISearchBar *searchBar;
    
    // detail VC
    DMDetailViewController *detailVC;
    // Alternate Views - Landscape & Portrait
    DMTopMoviePosterView *topMoviesView;
    
    // Locks scrollView during rotation
    BOOL scrollingLocked;
    
}


@property (nonatomic, strong) UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) UISearchBar *searchBar;




@end
