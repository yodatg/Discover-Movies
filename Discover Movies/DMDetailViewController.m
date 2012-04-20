//
//  DetailViewController.m
//  Discover Movies
//
//  Created by Thomas Grant on 16/01/2012.
//  Copyright (c) 2012 Reading University. All rights reserved.
//

#import "DMDetailViewController.h"
#import "DMModalTrailerView.h"
#import "DMTableViewDetailViewController.h"
#import "DMMovie.h"
#import "Constants.h"
#import "DMAppDelegate.h"
#import "DMHeatMapViewController.h"

@implementation DMDetailViewController
@synthesize favoritesButton;
@synthesize cosineSimilarityButton;
@synthesize audienceScoreLabel;
@synthesize criticsScoreLabel;
@synthesize audienceImageView;
@synthesize criticsImageView;
@synthesize titleLabel;
@synthesize actorsLabel;
@synthesize synopsisTextView;
@synthesize recommendedMoviesScrollView;
@synthesize audienceScore, audienceImage, criticsImage, criticsScore, movieTitle, actors, synopsis, poster, recommendedMovies, noRecommendedMoviesLabel, movieBeingDisplayed, movieYear;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 * Private interface definitions
 *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

@interface DMDetailViewController(Private)
- (void) handleBack:(id)sender;
- (void) addPostersToRecommendedMovieScrollView;
- (void) openiTunesApp;
- (void) showNoRecommendedMoviesLabel;
- (void)createAndConfigureDetailViewControllerForMovie:(DMMovie *)m;
- (void)createHeatMapView;

@end

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        movieStore = [DMMovieStore defaultStore];
        movieBeingDisplayed = [[DMMovie alloc] init];
        av = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
        
        
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
    
    
    [noRecommendedMoviesLabel setHidden:YES];
    
    
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
        self.recommendedMoviesScrollView.frame = CGRectMake(32, 782, 704, 230);
    av.frame = CGRectMake(self.recommendedMoviesScrollView.bounds.origin.x + 300, self.recommendedMoviesScrollView.bounds.origin.y + 50, 80, 80);
        
        
    }
    else if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight){
        
        posterView = [[DMMoviePosterView alloc] initWithImage:poster borderWidth:7.0 andFrame:CGRectMake(35, 70, 260, 388)];
        self.recommendedMoviesScrollView.frame = CGRectMake(72, 782, 624, 230);
         av.frame = CGRectMake(self.recommendedMoviesScrollView.bounds.origin.x + 400, self.recommendedMoviesScrollView.bounds.origin.y, 80, 80);

            
    }
    [av startAnimating];
    [recommendedMoviesScrollView addSubview:av];
    
    recommendedMoviesScrollView.showsHorizontalScrollIndicator = NO;
    recommendedMoviesScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:posterView];
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.minimumFontSize = 20.0;
    [titleLabel setText:movieTitle];
    [actorsLabel setText:actors];
    [synopsisTextView setText:synopsis];
}


/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/

-(void)viewDidAppear:(BOOL)animated {

NSLog(@"View did appear");
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addPostersToRecommendedMovieScrollView) name:@"recommendedMoviesDownloaded" object:movieStore];
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTrailer) name:@"youtubeURLCreated" object:movieStore];
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNoRecommendedMoviesLabel) name:@"noRecommendedMoviesFound" object:nil];

NSLog(@"fav mov size = %d", [[movieStore favoriteMovies] count]);
for(int i = 0; i < [[movieStore favoriteMovies]count]; i++){
    if([[(DMMovie *)[[movieStore favoriteMovies] objectAtIndex:i]title] isEqualToString:self.movieBeingDisplayed.title]){
        
        
        [self.favoritesButton setImage:[UIImage imageNamed:@"star_yellow.png"] forState:UIControlStateNormal];
        favoriteEnabled = YES;
        
    }
    
}

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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidDisappear:(BOOL)animated {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [av removeFromSuperview];
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
- (IBAction)connectToFacebook:(id)sender {

NSMutableDictionary *params = 
[NSMutableDictionary dictionaryWithObjectsAndKeys:
 self.movieTitle, @"name",
 @"Discover Movies.", @"caption",
 [NSString stringWithFormat:@"Check out %@ - found using Discover Movies for iPad", movieTitle], @"description",
 self.movieBeingDisplayed.alternativeURL, @"link",
 self.movieBeingDisplayed.profileImageURL, @"picture",
 nil];  

DMAppDelegate *appDelegate = (DMAppDelegate *)[[UIApplication sharedApplication]delegate];
[appDelegate.facebook dialog:@"feed"
                   andParams:params
                 andDelegate:appDelegate];



}
/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/

- (IBAction)startCosineDownload:(id)sender {

if([[movieStore detailedMovies] count] > 0){
    NSLog(@"removing all detailed movies");
    [[movieStore detailedMovies] removeAllObjects];
}

[movieStore grabDetailedInfoForMovie:movieBeingDisplayed];
[movieStore setMasterCosineMovie:[movieBeingDisplayed title]];
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(calculateCosineSimilarity) name:@"detailedInfoDownloaded" object:movieStore];


for(id m in [movieStore favoriteMovies]){
    [movieStore grabDetailedInfoForMovie:m];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(calculateCosineSimilarity) name:@"detailedInfoDownloaded" object:movieStore];
}
// grab detailed movie info:





}

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
- (void)calculateCosineSimilarity {
NSLog(@"DETAILED INFO GOTTEN");

//NSNumber *zero = [NSNumber numberWithInt:0];
//NSNumber *one = [NSNumber numberWithInt:1]; 
//NSMutableArray *detailedMoviesGenres= [[NSMutableArray alloc] init];
NSMutableArray *currentMovieGenres = [[NSMutableArray alloc] init];

// set the vector to compare to.
//DMMovie *movieToCompareTo = movieBeingDisplayed;

// pull out genres


// extract movie genres to compare to
DMMovie *m = [[movieStore detailedMovies] objectAtIndex:0];

for(NSString *str in [m genre]){
    
    [currentMovieGenres addObject:str];

}
NSString *masterActorA = [m leadActorA];
NSLog(@"masterActorA = %@", masterActorA);
NSString *masterActorB = [m leadActorB];
NSLog(@"masterActorB = %@", masterActorB);
NSString *masterStudio = [m movieStudio];
NSLog(@"masterStudio = %@", masterStudio);

NSLog(@"current movie genres = %@", currentMovieGenres);
NSLog(@"number of movies in detailed movies = %@", [movieStore detailedMovies]);
// matching movie genres
for(id movie in [movieStore detailedMovies]){
    
    
    if([[movie leadActorA] isEqualToString:masterActorA] || [[movie leadActorA] isEqualToString:masterActorB]){
        
        NSNumber *one = [NSNumber numberWithInt:1];
        [[movie cosineVector] removeObjectAtIndex:4];
        [[movie cosineVector] insertObject:one atIndex:4];
    }
   if ([[movie leadActorB] isEqualToString:masterActorA] || [[movie leadActorB] isEqualToString:masterActorB]) {
        NSNumber *one = [NSNumber numberWithInt:1];
        [[movie cosineVector] removeObjectAtIndex:5];
        [[movie cosineVector] insertObject:one atIndex:5];
        
    }
    if ([[movie movieStudio] isEqualToString:masterStudio]){
        NSNumber *one = [NSNumber numberWithInt:1];
        [[movie cosineVector] removeObjectAtIndex:8];
        [[movie cosineVector] insertObject:one atIndex:8];
        
    }
    
    int count = 0;
    NSLog(@"IN LOOP 1 = %@", [movie genre]);
    for(NSString *detailedGenreString in [movie genre]){
        
    //NSLog(@"str = %@", str);
        
        for(NSString *str in currentMovieGenres){
            NSLog(@"currentMovieGenre = %@", str);
            NSLog(@"detailedGenreString  = %@", detailedGenreString);
            if([detailedGenreString isEqualToString:str]){
                NSLog(@"detail genre string = %@ and str = %@", detailedGenreString, str);
                
                NSNumber *one = [NSNumber numberWithInt:1];
                [[movie cosineVector] removeObjectAtIndex:count];
                [[movie cosineVector] insertObject:one atIndex:count];
                ;
            }
            
            
            }
    count++;
        }
    
    
    NSLog(@"movie cosine vec = %@ and title = %@", [movie cosineVector], [movie title]);
    
    // insert critics score
   NSString *criticsScoreA = [[movie ratings] objectForKey:@"critics_score"];
     
    float criticsScoreNumber = [criticsScoreA integerValue];
    float criticsScoreFloat = criticsScoreNumber / 100;
   
    NSNumber *criticsScorePercentage = [NSNumber numberWithFloat:criticsScoreFloat];
    [[movie cosineVector] removeObjectAtIndex:6];
    [[movie cosineVector] insertObject:criticsScorePercentage atIndex:6];
    NSLog(@"critics score (vector) = %@", [[movie cosineVector] objectAtIndex:6]);    
    
    // insert audience score
    NSString *audienceScoreA = [[movie ratings] objectForKey:@"audience_score"];
    
    float audienceScoreNumber = [audienceScoreA integerValue];
    float audienceScoreFloat = audienceScoreNumber / 100;
    
    NSNumber *audienceScorePercentage = [NSNumber numberWithFloat:audienceScoreFloat];
    [[movie cosineVector] removeObjectAtIndex:7];
    [[movie cosineVector] insertObject:audienceScorePercentage atIndex:7];
    NSLog(@"audience score (vector) = %@", [[movie cosineVector] objectAtIndex:7]);
    
    
    }
    
   
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createHeatMapView) name:@"cosineResultsComplete" object:movieStore];
[movieStore calculateCosineSimilarity];



}
/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/

-(void)createHeatMapView {

DMHeatMapViewController *hmViewController = [[DMHeatMapViewController alloc] initWithCosineData:[movieStore cosineSimilarityResults]];



[self.navigationController pushViewController:hmViewController animated:YES];
[[movieStore cosineSimilarityResults] removeAllObjects];
}
/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
- (void) handleBack:(id)sender {   
   
    [movieStore cancelDownload];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.7];
    
    [UIView 
     setAnimationTransition:UIViewAnimationTransitionFlipFromLeft 
     forView:self.navigationController.view 
     cache:NO];
    
    [self.navigationController 
     popViewControllerAnimated:NO];
    
    [UIView commitAnimations];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    
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
        self.recommendedMoviesScrollView.contentOffset = CGPointZero;     
        self.recommendedMoviesScrollView.frame = CGRectMake(self.recommendedMoviesScrollView.frame.origin.x - 40, self.recommendedMoviesScrollView.frame.origin.y, self.recommendedMoviesScrollView.frame.size.width + 80, self.recommendedMoviesScrollView.frame.size.height);
        av.frame = CGRectMake(self.recommendedMoviesScrollView.bounds.origin.x + 300, self.recommendedMoviesScrollView.bounds.origin.y + 50, 80, 80);
    }
    else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        
        if(overlayPresent == YES) {
            self.view.hidden = YES;
        }
        
        posterView.frame = CGRectMake(35, 70, 260, 388);
        self.recommendedMoviesScrollView.frame = CGRectMake(self.recommendedMoviesScrollView.frame.origin.x + 40, self.recommendedMoviesScrollView.frame.origin.y, self.recommendedMoviesScrollView.frame.size.width - 80, self.recommendedMoviesScrollView.frame.size.height);
        NSLog(@"frame = %f %f %f %f", self.recommendedMoviesScrollView.frame.origin.x, self.recommendedMoviesScrollView.frame.origin.y, self.recommendedMoviesScrollView.frame.size.width, self.recommendedMoviesScrollView.frame.size.height);
        av.frame = CGRectMake(self.recommendedMoviesScrollView.bounds.origin.x + 400, self.recommendedMoviesScrollView.bounds.origin.y, 80, 80);
        
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

- (IBAction)addToFavorites:(id)sender {

if(favoriteEnabled == YES){
    
    for(int i = 0; i < [[movieStore favoriteMovies] count]; i++){
        
        if([[[[movieStore favoriteMovies] objectAtIndex:i]title] isEqualToString:self.movieBeingDisplayed.title]){
            
            [[movieStore favoriteMovies] removeObjectAtIndex:i];
            
        }
    }
    
    [self.favoritesButton setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
    favoriteEnabled = NO;
}
else {
    [movieStore addFavoriteMovie:self.movieBeingDisplayed];
    [self.favoritesButton setImage:[UIImage imageNamed:@"star_yellow.png"] forState:UIControlStateNormal];
    favoriteEnabled = YES;
}

NSLog(@"number of favorite movies = %d", [[movieStore favoriteMovies] count]);

}

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
- (IBAction)openiTunes:(id)sender {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openiTunesApp) name:@"iTunesURLFound" object:movieStore];
    NSString *searchTerm = [NSString stringWithFormat:self.movieTitle];
    [movieStore searchiTunesForMovie:searchTerm];
    
}

- (void) openiTunesApp {

    NSURL *url = [NSURL URLWithString:[movieStore iTunesURL]];
    [[UIApplication sharedApplication] openURL:url];
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
    [noRecommendedMoviesLabel setHidden:YES];
    
    UITapGestureRecognizer *g = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    g.numberOfTapsRequired = 1;
    [self.recommendedMoviesScrollView addGestureRecognizer:g];
    

if([self.recommendedMovies respondsToSelector:@selector(removeAllObjects)]){
    [self.recommendedMovies removeAllObjects];
}
    
    self.recommendedMovies = [[movieStore recommendedMovies] copy];

    
    int xOrigin = 30;
    
for(int i = 0; i < [self.recommendedMovies count]; i++) {
        
    DMMovie *movie = [self.recommendedMovies objectAtIndex:i];
        DMMoviePosterView *pv = [[DMMoviePosterView alloc] initWithImage:[movie poster] andFrame:CGRectMake(self.recommendedMoviesScrollView.bounds.origin.x + xOrigin, self.recommendedMoviesScrollView.bounds.origin.y, 110, 160)];
        
        pv.alpha = 0.0f;
        pv.tag = i;
        [self.recommendedMoviesScrollView addSubview:pv];
        [UIView setAnimationDuration:1.0f];
        [UIView beginAnimations:nil context:nil];
        pv.alpha = 1.0f;
        [UIView commitAnimations];

        
        xOrigin += 170;

    }
    
    self.recommendedMoviesScrollView.contentSize = CGSizeMake(recommendedMoviesScrollView.bounds.size.width * [self.recommendedMovies count] / 4, 160);
    
   [av setHidden:YES];
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

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/

- (void) showNoRecommendedMoviesLabel {
    
    [av setHidden:YES];
    
[   noRecommendedMoviesLabel setHidden:NO];

}


/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/

- (void)createAndConfigureDetailViewControllerForMovie:(DMMovie *)m {
// gather out movie info
NSString *mTitle = [m title];
//NSString *mYear = [m year];
//NSString *mTitleWithYear = [NSString stringWithFormat:@"%@ (%@)", mTitle, mYear];
UIImage *mPoster = [m poster];
NSString *mCriticsRating = [NSString stringWithFormat:@"%@",[[m ratings] valueForKey:@"critics_score"]];
NSString *mAudienceRating = [NSString stringWithFormat:@"%@", [[m ratings] valueForKey:@"audience_score"]];



NSString *mSynopsis = [NSString stringWithFormat:@"%@", [m synopsis]];
if ([mSynopsis isEqualToString:@"(null)"]){
    
    mSynopsis = @"";
}

NSString *mActors = [m topActors];

[movieStore downloadRecommendedMoviesForMovie:m];



DMTableViewDetailViewController *detailVC = [[DMTableViewDetailViewController alloc] init];
[detailVC setTitle:mTitle];
[detailVC setMovieTitle:mTitle];
[detailVC setCriticsScore:[[NSString alloc] initWithFormat:@"%@%%", mCriticsRating]];
[detailVC setAudienceScore:[[NSString alloc] initWithFormat:@"%@%%", mAudienceRating]];
[detailVC setActors:[[NSString alloc] initWithFormat:@"Starring: %@", mActors]];
[detailVC setSynopsis:mSynopsis];
[detailVC setPoster:mPoster];
[detailVC setMovieBeingDisplayed:m];



[self.navigationController pushViewController:detailVC animated:YES];



}

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
- (void)tapDetected:(UITapGestureRecognizer *)sender {

CGPoint p = [sender locationOfTouch:0 inView:self.recommendedMoviesScrollView];
UIView* v = [self.recommendedMoviesScrollView hitTest:p withEvent:nil];

if ([v tag] == 100) {
    return;
}
else {
    [self posterViewTouched:[v tag]];
}

}

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
- (void) posterViewTouched:(NSInteger) tag {
NSLog(@"tag = %d", tag);
DMMovie *m = [self.recommendedMovies objectAtIndex:tag];
NSLog(@"movie to push = %@", m);
[self createAndConfigureDetailViewControllerForMovie:m];

}


@end
