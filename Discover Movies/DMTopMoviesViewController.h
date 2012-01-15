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
#import "DMTopMoviePosterViewPortrait.h"
#import "DMTopMoviePosterViewLandscape.h"

@interface DMTopMoviesViewController : UIViewController <UIScrollViewDelegate> {
    
    
    DMMovieStore *movieStore;
    NSMutableArray *moviePosterViews;
    
    UIScrollView *scrollView;
    UIPageControl *pageControl;
    
    BOOL isShowingLandscapeView;
    
    // Landscape View
    DMTopMoviePosterViewPortrait *portraitView;
    DMTopMoviePosterViewLandscape *landscapeView;
    
    BOOL scrollingLocked;
    
    }


@property (nonatomic, strong) UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;




@end
