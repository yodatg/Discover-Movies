//
//  DMTopMoviesViewControllerPortrait.m
//  Discover Movies
//
//  Created by Thomas Grant on 28/12/2011.
//  Copyright (c) 2011 Reading University. All rights reserved.
//

#import "DMTopMoviesViewController.h"
#import "DMMovie.h"

int static kScrollViewPage;

@implementation DMTopMoviesViewController
@synthesize scrollView, pageControl, searchBar;


/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* Private interface definitions
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

@interface DMTopMoviesViewController(Private)
- (void)addPosterView;
- (void)addDetailViewController:(NSNotification *)notification;
- (void)createAndConfigureDetailViewControllerForMovie:(DMMovie *)m;
- (void)presentSearchView;
@end

#pragma mark - Private Methods
/*-------------------------------------------------------------
 * Called when "postersDownloaded" notification is received
 * 
 * Checks device orientation and adds the correct view as per
 * orientation  (Landscape or Portrait)
 *------------------------------------------------------------*/

- (void)addPosterView {
    // copy the arrray of posters from the Movie Store to our local poster array
    //NSArray *moviePosters = [[NSArray alloc] initWithArray:[movieStore moviePosters]];
    NSMutableArray *moviePosters = [[NSMutableArray alloc] init];
    for(DMMovie *movie in movieStore.topMovies) {
    
        [moviePosters addObject:[movie poster]];
       
    }
    
    // if PORTRAIT
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        
        topMoviesView = [[DMTopMoviePosterView alloc] initViewWithImagesInPortrait:moviePosters];
        [topMoviesView setDelegate:self];
        [scrollView addSubview:topMoviesView];
        UIActivityIndicatorView *tmpimg = (UIActivityIndicatorView *)[self.view viewWithTag:200];
        [tmpimg removeFromSuperview];
        
    }
    
    // if LANDSCAPE
    else if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft ||[UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
        
        topMoviesView = [[DMTopMoviePosterView alloc] initViewWithImagesInLandscape:moviePosters];
        [topMoviesView setDelegate:self];
        [scrollView addSubview:topMoviesView];
        UIActivityIndicatorView *tmpimg = (UIActivityIndicatorView *)[self.view viewWithTag:200];
        [tmpimg removeFromSuperview];
        
        
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/

- (void)addDetailViewControllerWithMovie:(NSInteger)tag {
    
    
    DMMovie *movie = [[movieStore topMovies] objectAtIndex:tag];
    [self createAndConfigureDetailViewControllerForMovie:movie];
    
}

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/

- (void)createAndConfigureDetailViewControllerForMovie:(DMMovie *)m {
    // gather out movie info
    NSString *mTitle = [m title];
    NSString *mYear = [m year];
    NSString *mTitleWithYear = [NSString stringWithFormat:@"%@ (%@)", mTitle, mYear];
    UIImage *mPoster = [m poster];
    NSString *mCriticsRating = [NSString stringWithFormat:@"%@",[[m ratings] valueForKey:@"critics_score"]];
    NSString *mAudienceRating = [NSString stringWithFormat:@"%@", [[m ratings] valueForKey:@"audience_score"]];
    NSString *mSynopsis = [NSString stringWithFormat:@"%@", [m synopsis]];
    
    NSString *mActors = [m topActors];
    
    [movieStore downloadRecommendedMoviesForMovie:m];
    
    
    
    detailVC = [[DMDetailViewController alloc] init];
    [detailVC setTitle:mTitle];
    [detailVC setMovieTitle:mTitleWithYear];
    [detailVC setCriticsScore:[[NSString alloc] initWithFormat:@"%@%%", mCriticsRating]];
    [detailVC setAudienceScore:[[NSString alloc] initWithFormat:@"%@%%", mAudienceRating]];
    [detailVC setActors:[[NSString alloc] initWithFormat:@"Starring: %@", mActors]];
    [detailVC setSynopsis:mSynopsis];
    [detailVC setPoster:mPoster];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.7];
    
    [self.navigationController pushViewController:detailVC animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
    

}

/*-------------------------------------------------------------
 * Called when created - unpacks nib and configures VC
 *------------------------------------------------------------*/
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Custom initialization
        moviePosterViews = [[NSMutableArray alloc] init];
        movieStore = [DMMovieStore defaultStore]; // Access to our movie store
        
        // Application frame
        CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width, [UIScreen mainScreen].applicationFrame.size.height);
        
       // Configure scroll view
        scrollView = [[UIScrollView alloc] initWithFrame:rect]; 
        scrollView.pagingEnabled = YES;
        scrollView.alwaysBounceVertical = NO;
        scrollView.alwaysBounceHorizontal = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.delegate = self;
        
        // Sets title on Nav Controller
        self.navigationItem.title = @"Top Movies";
        
        // set the content size of our scroll view. 
        // The frame etc is set up in IB
        scrollView.contentSize = CGSizeMake(([UIScreen mainScreen].applicationFrame.size.width * 3), [UIScreen mainScreen].applicationFrame.size.height);     
        
        // Register to notification center
        // addPosterView will be called when the posters finish downloading
        // and the "topMoviesDownloaded" notification is posted to the center
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addPosterView) name:@"topMoviesDownloaded" object:movieStore];
        
        [self.view addSubview:scrollView];
        
        
        
    }
    return self;
}

/*-------------------------------------------------------------
 * Support all interface orientations
 *------------------------------------------------------------*/

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return YES;
}

/*-------------------------------------------------------------
 * Swaps out views - Landscape / Portrait based on 
 * device orientation
 *------------------------------------------------------------*/

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    // Lock scrolling so funny things don't happen when rotating!
    scrollingLocked = YES;
    
    // if LANDSCAPE
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        
        // set the content size of our scroll view. 
        // The frame etc is set up in IB
        CGRect rect = CGRectMake(0, 0, 1024, 768);
        scrollView.frame = rect;
        
        // stops scrollview offset being weird when rotating
        kScrollViewPage = [pageControl currentPage];
        CGFloat xOffset = (kScrollViewPage * scrollView.frame.size.width);
        [scrollView setContentOffset:CGPointMake(xOffset,0)];
        
        scrollView.contentSize = CGSizeMake((1024 * 3), 768);
        [scrollView setContentOffset:CGPointMake(xOffset,0)];
        
        [topMoviesView rotateToLandscape];
    
                
    }
    
    // if PORTRAIT
    else if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        
        
        
        // set the content size of our scroll view. 
        // The frame etc is set up in IB
        CGRect rect = CGRectMake(0, 0, 768, 1024);
        scrollView.frame = rect;
        
         // stops scrollview offset being weird when rotating
        kScrollViewPage = [pageControl currentPage];
        CGFloat xOffset = (kScrollViewPage * scrollView.frame.size.width);
        [scrollView setContentOffset:CGPointMake(xOffset,0)];
        
        scrollView.contentSize = CGSizeMake((768 * 3), 1024);
       
        

        [topMoviesView rotateToPortrait];
    }
    
}
        
/*-------------------------------------------------------------
 * Called when device low on memory
 *------------------------------------------------------------*/

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


/*-------------------------------------------------------------
 * Unlocks scrolling when interface rotated
 *------------------------------------------------------------*/

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromOrientation
{
    scrollingLocked = NO;
    
}

#pragma mark - View lifecycle

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIActivityIndicatorView  *av = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    av.frame = CGRectMake(round((self.view.frame.size.width - 25) / 2), round((self.view.frame.size.height - 25) / 2), 25, 25);
    av.tag  = 200;
    [self.view addSubview:av];
    [av startAnimating];

    
}

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
-(void)viewWillAppear:(BOOL)animated {
    
        
    CGRect searchRect = CGRectMake(0, 0, self.navigationController.toolbar.frame.size.width/3, self.navigationController.toolbar.frame.size.height);

    
    self.searchBar = [[UISearchBar alloc] initWithFrame:searchRect];
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithCustomView:self.searchBar];
    [self.navigationItem setRightBarButtonItem:bbi]; 
    self.searchBar.delegate = self;
    
    
    // if PORTRAIT
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        
        // set the content size of our scroll view. 
        // The frame etc is set up in IB
        CGRect rect = CGRectMake(0, 0, 768, 1024);
        scrollView.frame = rect;
        
        // stops scrollview offset being weird when rotating
        kScrollViewPage = [pageControl currentPage];
        CGFloat xOffset = (kScrollViewPage * scrollView.frame.size.width);
        [scrollView setContentOffset:CGPointMake(xOffset,0)];
        
        scrollView.contentSize = CGSizeMake((768 * 3), 1024);
        [scrollView setContentOffset:CGPointMake(xOffset,0)];
        
        
        [topMoviesView rotateToPortrait];
        
        
    }
    
    // if LANDSCAPE
    else if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft ||[UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
        
        
        
        // set the content size of our scroll view. 
        // The frame etc is set up in IB
        CGRect rect = CGRectMake(0, 0, 1024, 768);
        scrollView.frame = rect;
        
        // stops scrollview offset being weird when rotating
        kScrollViewPage = [pageControl currentPage];
        CGFloat xOffset = (kScrollViewPage * scrollView.frame.size.width);
        [scrollView setContentOffset:CGPointMake(xOffset,0)];
        
        scrollView.contentSize = CGSizeMake((1024 * 3), 768);  
        
        
        [topMoviesView rotateToLandscape];
    }

    
    

}

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/

- (void)viewDidUnload
{
    [self setPageControl:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/

- (void)presentSearchView {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Search Completed" message:@"YES!" delegate:nil cancelButtonTitle:@"GREAT!" otherButtonTitles:nil, nil];
    [alert show];
    
}

#pragma mark - Delegate Methods

/*-------------------------------------------------------------
 * Called when scroll view scrolls - changes pageControl
 *------------------------------------------------------------*/

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollingLocked == YES) {
        return;
    }
    else {
    
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
    }
   
}

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
- (void)posterViewTouched:(NSInteger)tag {
    
    
    [self addDetailViewControllerWithMovie:tag];
}

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"search bar ended editiing");
    NSString *searchTerm = self.searchBar.text;
    
    [movieStore searchMovieDatabaseForMovieTitle:searchTerm];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentSearchView) name:@"searchFinished" object:movieStore];
    
}

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    NSLog(@"Text being inserted");
}

@end
