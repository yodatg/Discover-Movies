//
//  DMTopMoviesViewControllerPortrait.m
//  Discover Movies
//
//  Created by Thomas Grant on 28/12/2011.
//  Copyright (c) 2011 Reading University. All rights reserved.
//

#import "DMTopMoviesViewController.h"
#import "DMMovie.h"
#import "DMSearchResultsTableViewController.h"

int static kScrollViewPage;

@implementation DMTopMoviesViewController
@synthesize scrollView, pageControl, searchBar, searchView, searchNavController, loadingLabel, favViewController, favPopoverController, favBarButton;


/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* Private interface definitions
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

@interface DMTopMoviesViewController(Private)
- (void)addPosterView;
- (void)addDetailViewController:(NSNotification *)notification;
- (void)createAndConfigureDetailViewControllerForMovie:(DMMovie *)m;
- (void)presentSearchView;
- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardWillBeHidden:(NSNotification *)notification;
- (void)openFavorites:(id)sender;
- (void)noMoviesFound;
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
        [topMoviesView setAlpha:0.0];
        [topMoviesView setDelegate:self];
        [scrollView addSubview:topMoviesView];
        [av removeFromSuperview];
         [loadingLabel removeFromSuperview];
        loadingLabel.hidden = YES;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:1.0];
        [topMoviesView setAlpha:1.0];
        [UIView commitAnimations];
        
    }
    
    // if LANDSCAPE
    else if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft ||[UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
        
        topMoviesView = [[DMTopMoviePosterView alloc] initViewWithImagesInLandscape:moviePosters];
        [topMoviesView setAlpha:0.0];
        [topMoviesView setDelegate:self];
        [scrollView addSubview:topMoviesView];
        [av removeFromSuperview];
        [loadingLabel removeFromSuperview];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:1.0];
        [topMoviesView setAlpha:1.0];
        [UIView commitAnimations];

        
        
    }
    
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
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
    //NSString *mYear = [m year];
    //NSString *mTitleWithYear = [NSString stringWithFormat:@"%@ (%@)", mTitle, mYear];
    UIImage *mPoster = [m poster];
    NSString *mCriticsRating = [NSString stringWithFormat:@"%@",[[m ratings] valueForKey:@"critics_score"]];
    NSString *mAudienceRating = [NSString stringWithFormat:@"%@", [[m ratings] valueForKey:@"audience_score"]];
    NSString *mSynopsis = [NSString stringWithFormat:@"%@", [m synopsis]];
    
    NSString *mActors = [m topActors];
    
    [movieStore downloadRecommendedMoviesForMovie:m];
    
    
    
    detailVC = [[DMDetailViewController alloc] init];
    [detailVC setTitle:mTitle];
    [detailVC setMovieTitle:mTitle];
    [detailVC setCriticsScore:[[NSString alloc] initWithFormat:@"%@%%", mCriticsRating]];
    [detailVC setAudienceScore:[[NSString alloc] initWithFormat:@"%@%%", mAudienceRating]];
    [detailVC setActors:[[NSString alloc] initWithFormat:@"Starring: %@", mActors]];
    [detailVC setSynopsis:mSynopsis];
    [detailVC setPoster:mPoster];
    [detailVC setMovieBeingDisplayed:m];
    
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
        
        
        // subscribe to keyboard notifications
        
        
                
        

              
        
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

av = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
av.frame = CGRectMake(round((self.view.bounds.size.width - 25) / 2), round((self.view.bounds.size.height - 25) / 2), 25, 25);
av.tag  = 200;


av.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);

loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 60)/2  , 515, 400, 40)];
[loadingLabel setFont:[UIFont fontWithName:@"Arial" size:20.0f]];
[loadingLabel setText:@"Loading..."];
[loadingLabel setBackgroundColor:[UIColor clearColor]];
[loadingLabel setTextColor:[UIColor whiteColor]];
loadingLabel.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
[self.view addSubview:av];
[self.view addSubview:loadingLabel];
[av startAnimating];



   
}

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
-(void)viewWillAppear:(BOOL)animated {
    
        
    CGRect searchRect = CGRectMake(0, 0, self.navigationController.toolbar.frame.size.width/3, self.navigationController.toolbar.frame.size.height);
    favBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"star.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(openFavorites:)];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:searchRect];
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithCustomView:self.searchBar];
    [self.navigationItem setRightBarButtonItem:bbi]; 
    [self.navigationItem setLeftBarButtonItem:favBarButton];
    self.searchBar.delegate = self;

[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];

    
    
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
- (void)viewDidDisappear:(BOOL)animated {

[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
 [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/

- (void)viewDidUnload
{
    [self setPageControl:nil];
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/

- (void)presentSearchView {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    searchView = [[DMSearchResultsTableViewController alloc] init];
    searchView.delegate = self;
    searchNavController = [[UINavigationController alloc] initWithRootViewController:searchView];
    [[searchNavController navigationBar] setBarStyle:UIBarStyleBlackTranslucent];
    [searchNavController setModalPresentationStyle:UIModalPresentationFullScreen];
   
    
    [self presentModalViewController:searchNavController animated:YES];
    [spinner removeSpinner];
    
    
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

    [self.searchBar resignFirstResponder];
    NSLog(@"search bar ended editiing");
    NSString *searchTerm = self.searchBar.text;
    searchTerm = [searchTerm stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    spinner = [SpinnerView loadSpinnerIntoView:self.view];

    
    [movieStore searchMovieDatabaseForMovieTitle:searchTerm];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noMoviesFound) name:@"noMoviesFound" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentSearchView) name:@"searchFinished" object:movieStore];
    

    
}

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    NSLog(@"Text being inserted");
}

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/

- (void)doneButtonTouched {
    
    
    [self.searchNavController dismissModalViewControllerAnimated:YES];
    [overlay removeFromSuperview];
    //self.searchView = nil;

}

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
- (void)keyboardWillBeHidden:(NSNotification *)notification {

overlay.alpha = 0.5f;

[UIView setAnimationDuration:0.5f];
[UIView beginAnimations:nil context:nil];
overlay.alpha = 0;
[UIView commitAnimations];
[overlay performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.5];
overlayPresent = NO;

NSLog(@"Keyboard hidden");
}

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
- (void)keyboardWillShow:(NSNotification *)notification {

overlay = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height)];
overlay.backgroundColor = [UIColor blackColor];
overlay.alpha = 0.0f;

[UIView setAnimationDuration:0.5f];
[UIView beginAnimations:nil context:nil];
overlay.alpha = 0.5f;
[self.view addSubview:overlay];
[UIView commitAnimations];
overlayPresent = YES;

NSLog(@"Keyboard shown");
}

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/

- (void)openFavorites:(id)sender {

NSLog(@"opening favorites");

if(self.favViewController == nil){
    self.favViewController = [[DMMovieFavoritesViewController alloc] initWithStyle:UITableViewStylePlain];
    favViewController.delegate = self;
    
    self.favPopoverController = [[UIPopoverController alloc] initWithContentViewController:favViewController];
}
    
[(UITableView *)favViewController.view reloadData];
[self.favPopoverController presentPopoverFromBarButtonItem:sender 
                                permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    


}


/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/

- (void)movieSelectedAtIndex:(NSInteger)index {

    DMMovie *m = [[movieStore favoriteMovies] objectAtIndex:index];
    [favPopoverController dismissPopoverAnimated:YES];

    [self createAndConfigureDetailViewControllerForMovie:m];


}

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
-(void)noMoviesFound {

[UIView setAnimationDuration:0.5f];
[UIView beginAnimations:nil context:nil];
[spinner removeSpinner];
[UIView commitAnimations];

UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"No movies could be found - please try another search term" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
[alert show];
[[NSNotificationCenter defaultCenter] removeObserver:self name:@"noMoviesFound" object:nil];

}
@end
