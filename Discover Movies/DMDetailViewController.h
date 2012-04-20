//
//  DetailViewController.h
//  Discover Movies
//
//  Created by Thomas Grant on 16/01/2012.
//  Copyright (c) 2012 Reading University. All rights reserved.
//
//  Manages interaction between Model and DMDetailView XIB
//  
//
//

#import <UIKit/UIKit.h>
#import "DMMoviePosterView.h"
#import "DMMovieStore.h"
#import "DMModalTrailerView.h"
#import "DMMovie.h"
//#import "FBConnect.h"


@interface DMDetailViewController : UIViewController <UINavigationControllerDelegate, UINavigationBarDelegate, DMModelTrailerViewDelegate> {
    
    DMMovie *movieBeingDisplayed;
    
    // Poster view to be added to detailVC
    DMMoviePosterView *posterView;
    DMMovieStore *movieStore;
    
    // View that is presented when user plays trailer
    DMModalTrailerView *modalView;
    
    // Dims background when modal view presented - this is a work around (see .m for more details)
    UIView *overlay;
    BOOL overlayPresent;
    BOOL favoriteEnabled;
    
    UIActivityIndicatorView *av;
    
    
    
    
    
}

@property (strong, nonatomic) NSString *audienceScore;
@property (strong, nonatomic) NSString *criticsScore;
@property (strong, nonatomic) NSString *audienceImage;
@property (strong, nonatomic) NSString *criticsImage;
@property (strong, nonatomic) NSString *movieTitle;
@property (strong, nonatomic) NSString *movieYear;
@property (strong, nonatomic) NSString *actors;
@property (strong, nonatomic) NSString *synopsis;
@property (strong, nonatomic) UIImage *poster;
@property (strong, nonatomic) NSMutableArray *recommendedMovies;
@property (strong, nonatomic) DMMovie *movieBeingDisplayed;


@property (strong, nonatomic) IBOutlet UILabel *audienceScoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *criticsScoreLabel;
@property (strong, nonatomic) IBOutlet UIImageView *audienceImageView;
@property (strong, nonatomic) IBOutlet UIImageView *criticsImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *actorsLabel;
@property (strong, nonatomic) IBOutlet UITextView *synopsisTextView;
@property (strong, nonatomic) IBOutlet UIScrollView *recommendedMoviesScrollView;
@property (strong, nonatomic) IBOutlet UILabel *noRecommendedMoviesLabel;
@property (strong, nonatomic) IBOutlet UIButton *favoritesButton;
@property (strong, nonatomic) IBOutlet UIButton *cosineSimilarityButton;



- (IBAction)playMovieTrailer:(id)sender;
- (IBAction)addToFavorites:(id)sender;
- (IBAction)openiTunes:(id)sender;
- (IBAction)connectToFacebook:(id)sender;
- (IBAction)startCosineDownload:(id)sender;





@end
