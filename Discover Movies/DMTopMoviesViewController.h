//
//  JSONViewController.h
//  Discover Movies
//
//  Created by Thomas Grant on 30/11/2011.
//  Copyright (c) 2011 Reading University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieStore.h"

@class DMMoviePosterView;

@interface DMTopMoviesViewController : UIViewController <UIScrollViewDelegate>
{
    // View elements
    UIScrollView *movieScrollView;
    
    
    // Data elements
    NSMutableArray *moviePosterArray;
    
    // Data object to hold JSON Data
    NSMutableData *topMoviesData; 
    
    
    // Singleton Movie Store to store movies
    MovieStore *movieStore;
    
    
}
@property (nonatomic, strong) IBOutlet UIImageView *background;
@property (nonatomic, strong) NSMutableArray *moviePosterArray;

- (void)downloadTopMovieJSONFeed;
- (void)parseMovieFeed;
- (void)setUpUserInterface;

@end
