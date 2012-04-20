//
//  DMTopMoviesViewControllerPortrait.h
//  Discover Movies
//
//  Created by Thomas Grant on 28/12/2011.
//  Copyright (c) 2011 Reading University. All rights reserved.
//
//
//  Manages interaction between Model and DMTopMoviePosterView
//  
//
//
#import <UIKit/UIKit.h>
#import "DMMovieStore.h"
#import "DMMoviePosterView.h"
#import "DMTopMoviePosterView.h"
#import "DMTopMoviePosterViewLandscape.h"
#import "DMDetailViewController.h"
#import "DMSearchResultsTableViewController.h"
#import "DMMovieFavoritesViewController.h"
#import "SpinnerView.h"


@interface DMTopMoviesViewController : UIViewController <UIScrollViewDelegate, DMTopMoviePosterViewDelegate, UISearchBarDelegate, DMSearchResultsTableViewControllerDelegate, DMMovieFavoritesViewControllerDelegate> {
    
    // Access to the Model
    DMMovieStore *movieStore;
    // Local store of moviePosterViews, copied from the movieStore
    NSMutableArray *moviePosterViews;
    
    UIScrollView *scrollView;
    UIPageControl *pageControl;
    UISearchBar *searchBar;
    UILabel *loadingLabel;
    UIActivityIndicatorView *av;
    UIBarButtonItem *favBarButton;
    
    // detail VC
    DMDetailViewController *detailVC;
    // Alternate Views - Landscape & Portrait
    DMTopMoviePosterView *topMoviesView;
    DMSearchResultsTableViewController *searchView;
    UINavigationController *searchNavController;
    DMMovieFavoritesViewController *favViewController;
    UIPopoverController *favPopoverController;
    SpinnerView *spinner;
    
    // Locks scrollView during rotation
    BOOL scrollingLocked;
    
    // Dims background when user is searching
    UIView *overlay;
    BOOL overlayPresent;

    
}


@property (nonatomic, strong) UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) DMSearchResultsTableViewController *searchView;
@property (strong, nonatomic) UINavigationController *searchNavController;
@property (strong, nonatomic) UILabel *loadingLabel;
@property (strong, nonatomic) DMMovieFavoritesViewController *favViewController;
@property (strong, nonatomic) UIPopoverController *favPopoverController;
@property (strong, nonatomic) UIBarButtonItem *favBarButton;

@end
