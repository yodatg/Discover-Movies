//
//  DMTopMoviesViewController.m
//  Discover Movies
//
//  Created by Thomas Grant on 30/11/2011.
//  Copyright (c) 2011 Reading University. All rights reserved.
//

#import "DMTopMoviesViewController.h"
#import "DMMoviePosterView.h"
#import "SBJson.h"
#import "Movie.h"


typedef enum {
    
    // Landscape
    kYPositionLandscapeTopRow = 80,
    kYPositionLandscapeBottomRow = 400,
    
    // Portrait
    kYPositionPortraitTopRow = 80,
    kYPositionPortraitMiddleRow = 370,
    kYPositionPortraitBottomRow = 660,
    
    // Landscape
    kXPositionLandscapePageOne = 70,
    kXPositionLandscapePageTwo = 1094,
    kXPositionLandscapePageThree = 2118,
    
    // Portrait
    kXPositionPortraitPageOne = 60,
    kXPositionPortraitPageTwo = 828,
    kXPositionPortraitPageThree = 1596
    
}CoordinatePosition; // defines positioning of columns and rows per page

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 * Private interface definitions
 *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
@interface DMTopMoviesViewController(Private)

- (void)downloadTopMovieJSONFeed;
- (void)parseMovieFeed;
- (void)downloadPosterForMovie: (NSDictionary *)_posters;
- (void)configureUserInterface;
- (void)fadeInImage:(UIImageView *)imageView;

@end


// API key for Rotten Tomatoes
NSString *const kAPIKey = @"spre238u2unvqxhdpj2a7xg9";
int static kScrollViewPage;


@implementation DMTopMoviesViewController

@synthesize background, pageControl;

/**************************************************************************
 *
 * Private implementation section
 *
 **************************************************************************/

#pragma mark -
#pragma mark Private Methods

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/

- (void)downloadTopMovieJSONFeed {
    
    NSLog(@"Downloading Movie Feed");
    
    // create our JSON feed URL
    NSString *topMoviesJSONURL = [NSString stringWithFormat:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?limit=24&country=us&apikey=%@", kAPIKey];
    
    // Create our URL Request
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:topMoviesJSONURL]];
    
    
    // Create our connection with the request
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    // if all went well...
    if (connection) {
        
        // Create a data object to store our JSON data
        topMoviesData = [NSMutableData data];
    }
    
    
}

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
- (void)parseMovieFeed {
    
    
    // Create our JSON string from the data
    NSString *responseString = [[NSString alloc] initWithData:topMoviesData encoding:NSUTF8StringEncoding];
    
    
    // Parse the JSON string using SBJason
    NSDictionary *results = [responseString JSONValue];
    
    // Create an array of movies using key "movies"
    NSArray *movies = [results objectForKey:@"movies"];
    
    // Just to check we have the correct number of movies
    NSLog(@"Number of movies = %d", [movies count]);
    
    for (int i = 0; i < [movies count]; i++) {
        
        // Extract a movie from our movies array
        NSDictionary *aMovie = [movies objectAtIndex:i]; 
        
        // Create our movie variables from the key value
        // pairs in our dictionarys in the movies array
        
        NSString *movieTitle = (NSString *) [aMovie valueForKey:@"title"];
        NSString *movieYear = (NSString *) [aMovie valueForKey:@"year"];
        NSString *movieSynopsis = (NSString *) [aMovie valueForKey:@"synopsis"];
        NSArray *abridgedCast = (NSArray *)[aMovie valueForKey:@"abridged_cast"];
        NSDictionary *ratings = (NSDictionary *) [aMovie valueForKey:@"ratings"];
        
        // obtain the movie posters links
        NSDictionary *posters = (NSDictionary *)[aMovie valueForKey:@"posters"];
        NSString *moviePosterURL = [posters objectForKey:@"detailed"];
        // download the correct poster
        NSLog(@"About to download movie poster");
        [moviePosterImageData addObject:[NSData dataWithContentsOfURL:[NSURL URLWithString:moviePosterURL]]];
        
        //[self downloadPosterForMovie:posters];
        
        // crate an image from the poster and set it to the movie
        UIImage *poster = [[UIImage alloc] initWithData:[moviePosterImageData objectAtIndex:i]];
        DMMoviePosterView *imageView = [[DMMoviePosterView alloc] initWithImage:poster andFrame:CGRectMake(0, 0, 180, 267)];
        [moviePosterViews addObject:imageView];
        
        NSLog(@"i = %d", i);
        
        
        
        
        
        
        // Create movie object with info from data object
        Movie *movie = [[Movie alloc] initWithTitle:movieTitle 
                                               year:movieYear 
                                           synopsis:movieSynopsis 
                                       abridgedCast:abridgedCast 
                                  suggestedMovieIDs:nil 
                                        trailerLink:nil 
                                            ratings:ratings 
                                             poster:poster];
        
        
        [movieStore addTopMovie:movie];
        NSLog(@"Top Movie Store Size = %d", [[movieStore topMovies] count]);
        
        
        
        
    }
    
    [self configureUserInterface];
    
}

- (void)fadeInImage:(UIImageView *)imageView
{
    [UIView beginAnimations:@"fade in" context:nil];
    [UIView setAnimationDuration:1.0];
    imageView.alpha = 1.0;
    [UIView commitAnimations];
    
}
/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/

-(void)configureUserInterface {
    
   
    // If UI is in Landscape
    
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft ||
        [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
        
        // Configure our scroll view
        CGRect viewRect = CGRectMake(0, 0, 1024, 768); 
        movieScrollView.frame = viewRect;
        movieScrollView.contentSize = CGSizeMake((viewRect.size.width * 3), (viewRect.size.height));        
        movieScrollView.delegate = self;
        movieScrollView.pagingEnabled = YES;
        movieScrollView.bounces = YES;
        movieScrollView.showsHorizontalScrollIndicator = NO;
        movieScrollView.showsVerticalScrollIndicator = NO;
        
        // Create a view to put our posters onto
        moviePosterView.frame = CGRectMake(0, 0, (viewRect.size.width * 3), (viewRect.size.height));
        moviePosterView.opaque = FALSE;

        

        // Layout our image views
        int x = kXPositionLandscapePageOne;
        int y = kYPositionLandscapeTopRow;
        
        for (int i = 0; i < [moviePosterViews count]; i++) {
            
            if (i == 4) {
                x = kXPositionLandscapePageOne;
                y = kYPositionLandscapeBottomRow;
            }
            else if (i == 12) {
                x = kXPositionLandscapePageTwo;
                y = kYPositionLandscapeBottomRow;
            }
            else if (i == 20) {
                x = kXPositionLandscapePageThree;
                y = kYPositionLandscapeBottomRow;
            }
            else if (i == 8) {
                
                x = kXPositionLandscapePageTwo;
                y = kYPositionLandscapeTopRow;
            }
            else if (i == 16) {
                
                x = kXPositionLandscapePageThree;
                y = kYPositionLandscapeTopRow;
            }
            
            DMMoviePosterView *imageView = [moviePosterViews objectAtIndex:i];
            
            CGRect imageViewFrame = CGRectMake(x, y, 180, 267);
            imageView.frame = imageViewFrame;            
            x += 230;
            [moviePosterView addSubview:imageView];
                        
        }

        [movieScrollView addSubview:moviePosterView];
        [self.view addSubview:movieScrollView];
    }
    // end if
    
    // If UI is in Portrait 
    
    else if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait ||
             [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        
        
        // Configure scrollview
        CGRect viewRect = CGRectMake(0, 0, 768, 1024);
        movieScrollView.frame = viewRect;
        movieScrollView.contentSize = CGSizeMake((viewRect.size.width * 3), (viewRect.size.height));
        NSLog(@"viewRect size.width  = x %f  y %f", viewRect.size.width, viewRect.size.height);        
        movieScrollView.delegate = self;
        movieScrollView.pagingEnabled = YES;
        movieScrollView.bounces = YES;
        movieScrollView.showsHorizontalScrollIndicator = NO;
        movieScrollView.showsVerticalScrollIndicator = NO;
        movieScrollView.contentMode = UIViewContentModeScaleAspectFit;

        
        // Create a view to put our posters onto
        moviePosterView.frame = CGRectMake(0, 0, (viewRect.size.width * 3), (viewRect.size.height));
        moviePosterView.opaque = FALSE;
        
               
        // Layout our image views 
        int x = kXPositionPortraitPageOne;
        int y = kYPositionPortraitTopRow;
        
        for (int i = 0; i < [moviePosterViews count]; i++) {
            
            if (i == 3) {
                x = kXPositionPortraitPageOne;
                y = kYPositionPortraitMiddleRow;
            }
            else if (i == 6) {
                x = kXPositionPortraitPageOne;
                y = kYPositionPortraitBottomRow;
            }
            else if (i == 9) {
                x = kXPositionPortraitPageTwo;
                y = kYPositionPortraitTopRow;
            }
            else if (i == 12) {
                
                x = kXPositionPortraitPageTwo;
                y = kYPositionPortraitMiddleRow;
            }
            else if (i == 15) {
                
                x = kXPositionPortraitPageTwo;
                y = kYPositionPortraitBottomRow;
            }
            else if (i == 18) {
                
                x = kXPositionPortraitPageThree;
                y = kYPositionPortraitTopRow;
            }
            else if (i == 21) {
                
                x = kXPositionPortraitPageThree;
                y = kYPositionPortraitMiddleRow;
            }
            
            
            DMMoviePosterView *imageView = [moviePosterViews objectAtIndex:i];
            CGRect imageViewFrame = CGRectMake(x, y, 180, 267);
            imageView.frame = imageViewFrame;
           
            x += 230;
            [moviePosterView addSubview:imageView];
        }
        
        [movieScrollView addSubview:moviePosterView];
        [self.view addSubview:movieScrollView];
    }

    
    
}

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/

/*- (void)downloadPosterForMovie: (NSDictionary *)_posters {
    
    NSDictionary *posters = _posters;
    
    // Extract movie poster link
    
    NSLog(@"Movie Poster URL = %@", moviePosterURL);
    
    // Create URL Request
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:moviePosterURL]];
    
    // Create connection with request
     NSURLConnectionWithTag *connection = [[NSURLConnectionWithTag alloc] initWithRequest:request 
     delegate:self 
     startImmediately:YES 
     tag:[NSNumber numberWithInt:TopMoviesPosterDownloadConnection]];
    
    
    
    
    // Create data object to store poster data
    NSData *posterData = [NSData data];
    
    posterData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    [moviePosterImageData addObject:posterData];
    
    
    
}*/

/**************************************************************************
 *
 * Class implementation section
 *
 **************************************************************************/

#pragma mark -
#pragma mark Initialization

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"DMTopMoviesViewController" bundle:nil];
    if (self) {
        
        // Custom initialization
        moviePosterImageData = [[NSMutableArray alloc] init];
        movieStore = [MovieStore defaultStore];
        moviePosterViews = [[NSMutableArray alloc] init];
        movieScrollView = [[UIScrollView alloc] init];
        moviePosterView = [[UIView alloc] init];
        
        
        [self downloadTopMovieJSONFeed];
        
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark -
#pragma mark - View lifecycle

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   
}

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    // Locks the scrollview as a bug in iOS switches the page back to previous
    // page when rotating the last page in the view
    scrollingLocked = YES;
    
    // UI in Landscape
    
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
        toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        
        NSLog(@"In Landscape");
        CGRect viewRect = CGRectMake(0, 0, 1024, 768);
        
         // Configure scrollview & posterView as per the UI orientation change
        movieScrollView.frame = viewRect;
        moviePosterView.frame = CGRectMake(0, 0, (viewRect.size.width * 3), viewRect.size.height);
        kScrollViewPage = [pageControl currentPage];
        CGFloat xOffset = (kScrollViewPage * movieScrollView.frame.size.width);
        [movieScrollView setContentOffset:CGPointMake(xOffset,0)];
        movieScrollView.contentSize = CGSizeMake((viewRect.size.width * 3), (viewRect.size.height));
        
        int x = kXPositionLandscapePageOne;
        int y = kYPositionLandscapeTopRow;
        
        for (int i = 0; i < [moviePosterViews count]; i++) {
            
            if (i == 4) {
                x = kXPositionLandscapePageOne;
                y = kYPositionLandscapeBottomRow;
            }
            else if (i == 12) {
                x = kXPositionLandscapePageTwo;
                y = kYPositionLandscapeBottomRow;
            }
            else if (i == 20) {
                x = kXPositionLandscapePageThree;
                y = kYPositionLandscapeBottomRow;
            }
            else if (i == 8) {
                
                x = kXPositionLandscapePageTwo;
                y = kYPositionLandscapeTopRow;
            }
            else if (i == 16) {
                
                x = kXPositionLandscapePageThree;
                y = kYPositionLandscapeTopRow;
            }
            
            DMMoviePosterView *imageView = [moviePosterViews objectAtIndex:i];
            
            CGRect imageViewFrame = CGRectMake(x, y, 180, 267);
            imageView.frame = imageViewFrame;
            x += 230;
            
        }
        
                
    }
    // end if
    
    // If UI is in Portrait
    
    else if (toInterfaceOrientation == UIInterfaceOrientationPortrait ||
             toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
    
        // Configure the scrollView and posterView as per the UI orientation change
        CGRect viewRect = CGRectMake(0, 0, 768, 1024);
        moviePosterView.frame = CGRectMake(0, 0, (viewRect.size.width * 3), viewRect.size.height);
        movieScrollView.frame = viewRect;
        kScrollViewPage = [pageControl currentPage];
        CGFloat xOffset = (kScrollViewPage * movieScrollView.frame.size.width);
        [movieScrollView setContentOffset:CGPointMake(xOffset,0)];

        
        // Set up the scroll view
        movieScrollView.contentSize = CGSizeMake((viewRect.size.width * 3), (viewRect.size.height));
        NSLog(@"viewRect size.width  = x %f  y %f", viewRect.size.width, viewRect.size.height);        
        
        
        int x = kXPositionPortraitPageOne;
        int y = kYPositionPortraitTopRow;
        
        for (int i = 0; i < [moviePosterViews count]; i++) {
            
            if (i == 3) {
                x = kXPositionPortraitPageOne;
                y = kYPositionPortraitMiddleRow;
            }
            else if (i == 6) {
                x = kXPositionPortraitPageOne;
                y = kYPositionPortraitBottomRow;
            }
            else if (i == 9) {
                x = kXPositionPortraitPageTwo;
                y = kYPositionPortraitTopRow;
            }
            else if (i == 12) {
                
                x = kXPositionPortraitPageTwo;
                y = kYPositionPortraitMiddleRow;
            }
            else if (i == 15) {
                
                x = kXPositionPortraitPageTwo;
                y = kYPositionPortraitBottomRow;
            }
            else if (i == 18) {
                
                x = kXPositionPortraitPageThree;
                y = kYPositionPortraitTopRow;
            }
            else if (i == 21) {
                
                x = kXPositionPortraitPageThree;
                y = kYPositionPortraitMiddleRow;
            }
            
            
            DMMoviePosterView *imageView = [moviePosterViews objectAtIndex:i];
            CGRect imageViewFrame = CGRectMake(x, y, 180, 267);
            imageView.frame = imageViewFrame;
            x += 230;
        }
            
    }
    
}

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromOrientation
{
    scrollingLocked = NO;
}


#pragma mark -
#pragma mark - Scroll View Delegate Methods

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollingLocked == YES) {
        
        return;
    }
    else {
        
        CGFloat pageWidth = movieScrollView.frame.size.width;
        int page = floor((movieScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        self.pageControl.currentPage = page;
        NSLog(@"scrolled");
    }
}

#pragma mark -
#pragma mark - Networking Methods

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {

    [topMoviesData setLength:0];
}

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [topMoviesData appendData:data];	
}

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    
	
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                         message:@"An error occured accessing the network resource" 
                                                        delegate:nil 
                                               cancelButtonTitle:@"OK" 
                                               otherButtonTitles:nil, nil];
    
    [errorAlert show];
}

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    
         
    // Number of bytes downloaded for movie info
    NSLog(@"Succeeded downloading Top Movies! Received %d bytes of data", [topMoviesData length]);                                                                  
    [self parseMovieFeed];
            
	
}



@end
