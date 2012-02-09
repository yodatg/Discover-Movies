//
//  DetailViewController.m
//  Discover Movies
//
//  Created by Thomas Grant on 16/01/2012.
//  Copyright (c) 2012 Reading University. All rights reserved.
//

#import "DMDetailViewController.h"
#import "DMModalTrailerView.h"

@implementation DMDetailViewController
@synthesize audienceScoreLabel;
@synthesize criticsScoreLabel;
@synthesize audienceImageView;
@synthesize criticsImageView;
@synthesize titleLabel;
@synthesize actorsLabel;
@synthesize synopsisTextView;
@synthesize recommendedMoviesScrollView;
@synthesize audienceScore, audienceImage, criticsImage, criticsScore, movieTitle, actors, synopsis, poster, recommendedMovies;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 * Private interface definitions
 *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

@interface DMDetailViewController(Private)
- (void) handleBack:(id)sender;
- (void) addPostersToRecommendedMovieScrollView;

@end

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
                    
        movieStore = [DMMovieStore defaultStore];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTrailer) name:@"youtubeURLCreated" object:movieStore];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addPostersToRecommendedMovieScrollView) name:@"recommendedMoviesDownloaded" object:movieStore];
        
        }
    return self;
}


/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // change the back button to cancel and add an event handler
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Top Movies" style:UIBarButtonItemStyleBordered target:self action:@selector(handleBack:)];
    
    self.navigationItem.leftBarButtonItem = backButton;
    
    if (self.criticsScore.integerValue >= 50) {
        [criticsScoreLabel setText:criticsScore];
        [criticsScoreLabel setTextColor:[UIColor colorWithRed:0.105 green:0.46 blue:0 alpha:1]];
        [criticsImageView setImage:[UIImage imageNamed:@"tomato.png"]];
    }
    else if (self.criticsScore.integerValue < 50) {
        
        [criticsScoreLabel setText:criticsScore];
        [criticsScoreLabel setTextColor:[UIColor colorWithRed:0.8 green:0. blue:0 alpha:1]];
        [criticsImageView setImage:[UIImage imageNamed:@"splat.png"]];
    }
    
    if (self.audienceScore.integerValue >= 50) {
        [audienceScoreLabel setText:audienceScore];
        [audienceScoreLabel setTextColor:[UIColor colorWithRed:0.105 green:0.46 blue:0 alpha:1]];
        [audienceImageView setImage:[UIImage imageNamed:@"popcorn.png"]];
    }
    else if (self.audienceScore.integerValue < 50) {
        
        [audienceScoreLabel setText:audienceScore];
        [audienceScoreLabel setTextColor:[UIColor colorWithRed:0.8 green:0. blue:0 alpha:1]];
        [audienceImageView setImage:[UIImage imageNamed:@"popcorn_over.png"]];
    }

    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
    
    posterView = [[DMMoviePosterView alloc] initWithImage:poster borderWidth:7.0 andFrame:CGRectMake(35, 95, 260, 388)];
        [recommendedMoviesScrollView setContentSize:CGSizeMake(recommendedMoviesScrollView.bounds.size.width * 5, 160)];
    }
    else if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight){
        
        posterView = [[DMMoviePosterView alloc] initWithImage:poster borderWidth:7.0 andFrame:CGRectMake(35, 70, 260, 388)];
        [recommendedMoviesScrollView setContentSize:CGSizeMake(recommendedMoviesScrollView.bounds.size.width * 5, 160)];
        
    }
    recommendedMoviesScrollView.showsHorizontalScrollIndicator = NO;
    recommendedMoviesScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:posterView];
    [titleLabel setText:movieTitle];
    [actorsLabel setText:actors];
    [synopsisTextView setText:synopsis];
}
/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
- (void)viewDidUnload
{
    [self setCriticsImageView:nil];
    [self setAudienceImageView:nil];
    [self setCriticsScoreLabel:nil];
    [self setAudienceScoreLabel:nil];
    [self setTitleLabel:nil];
    [self setActorsLabel:nil];
    [self setSynopsisTextView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}
/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
- (void) handleBack:(id)sender {   
   
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.7];
    
    [UIView 
     setAnimationTransition:UIViewAnimationTransitionFlipFromLeft 
     forView:self.navigationController.view 
     cache:NO];
    
    [self.navigationController 
     popViewControllerAnimated:NO];
    
    [UIView commitAnimations];

    
}
/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    if(toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        
        if(overlayPresent == YES) {
            self.view.hidden = YES;
        }
        
        posterView.frame = CGRectMake(35, 95, 260, 388);
        [recommendedMoviesScrollView setContentSize:CGSizeMake(recommendedMoviesScrollView.bounds.size.width * 5, recommendedMoviesScrollView.bounds.size.height)];
                
                
        
    }
    else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        
        if(overlayPresent == YES) {
            self.view.hidden = YES;
        }
        
        posterView.frame = CGRectMake(35, 70, 260, 388);
        [recommendedMoviesScrollView setContentSize:CGSizeMake(recommendedMoviesScrollView.bounds.size.width * 5, 160)];
        
        
    }
        
    
}

-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    self.view.hidden = NO;
    
    
}
/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
- (IBAction)playMovieTrailer:(id)sender {
    
    NSLog(@"Playing Trailer for movie: %@", movieTitle);
    [movieStore searchYouTubeForTrailer:movieTitle];
    
}
/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
- (void)showTrailer {
    
    
    // if PORTRAIT
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        

        overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 1024)];
        overlay.backgroundColor = [UIColor blackColor];
        overlayPresent = YES;
        
        overlay.alpha = 0.0f;
        [self.navigationController.navigationBar addSubview:overlay];
        [UIView setAnimationDuration:0.5f];
        [UIView beginAnimations:nil context:nil];
        overlay.alpha = 0.6f;
        [UIView commitAnimations];
        
        
        modalView = [[DMModalTrailerView alloc] initWithYoutubeVideo:[movieStore youtubeURL]];
        modalView.frame = CGRectMake(self.view.center.x - 270, self.view.center.y - 315, 540, 630);
        modalView.delegate = self;
        
        [modalView setAlpha:0.0];
        [self.navigationController.view addSubview:modalView];
        [UIView setAnimationDuration:0.3f];
        [UIView beginAnimations:nil context:nil];
        [modalView setAlpha:1.0];
        [UIView commitAnimations];

        
    }
    // if LANDSCAPE
    else if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft ||[UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
        
        overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 1024)];
        overlay.backgroundColor = [UIColor blackColor];
        overlayPresent = YES;
        
        overlay.alpha = 0.0f;
        [self.navigationController.navigationBar addSubview:overlay];
        [UIView setAnimationDuration:0.5f];
        [UIView beginAnimations:nil context:nil];
        overlay.alpha = 0.6f;
        [UIView commitAnimations];
        
        
        modalView = [[DMModalTrailerView alloc] initWithYoutubeVideo:[movieStore youtubeURL]];
        modalView.frame = CGRectMake(self.view.center.x - 270, self.view.center.y - 315, 540, 630);
        modalView.delegate = self;
        
        [modalView setAlpha:0.0];
        [self.navigationController.view addSubview:modalView];
        [UIView setAnimationDuration:0.3f];
        [UIView beginAnimations:nil context:nil];
        [modalView setAlpha:1.0];
        [UIView commitAnimations];
        
    }
        
    
    
}

- (void) addPostersToRecommendedMovieScrollView {
    
    recommendedMovies = [[movieStore recommendedMovies] copy];
    int xOrigin = 30;
    
    for(DMMovie *movie in recommendedMovies) {
        
        DMMoviePosterView *pv = [[DMMoviePosterView alloc] initWithImage:[movie poster] andFrame:CGRectMake(recommendedMoviesScrollView.bounds.origin.x + xOrigin, recommendedMoviesScrollView.bounds.origin.y, 110, 160)];
        [recommendedMoviesScrollView addSubview:pv];
        xOrigin += 170;
    }
}

#pragma mark - DMTrailerViewController Delegate Methods
/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
- (void)didDismissModalView {
    
    //Dismiss modal view controller
    [self dismissModalViewControllerAnimated:YES];
}
/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
- (void)doneButtonTouched {
    
     //self.navigationItem.leftBarButtonItem.enabled = YES;
    
    overlay.alpha = 0.5f;
    
    [UIView setAnimationDuration:0.5f];
    [UIView beginAnimations:nil context:nil];
    overlay.alpha = 0;
    [UIView commitAnimations];
    [overlay performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.5];
    overlayPresent = NO;
    
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3f];
    modalView.alpha = 0;
    [UIView commitAnimations];
    [modalView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.5];
    overlayPresent = NO;
    

    
}
@end
