//
//  JSONViewController.h
//  Discover Movies
//
//  Created by Thomas Grant on 30/11/2011.
//  Copyright (c) 2011 Reading University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMTopMoviesViewController : UIViewController <UIScrollViewDelegate>
{
    
    UIScrollView *movieScrollView;
    NSMutableArray *moviePosterArray;
    
    // Data object to hold JSON Data
    NSMutableData *topMoviesData;
    NSMutableData *posterData;
    
    
}
@property (nonatomic, strong) IBOutlet UIImageView *background;
@property (nonatomic, strong) NSMutableArray *moviePosterArray;

- (void)downloadTopMovieJSONFeed;
- (void)parseMovieFeed;

@end
