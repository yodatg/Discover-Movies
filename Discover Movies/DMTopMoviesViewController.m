//
//  JSONViewController.m
//  Discover Movies
//
//  Created by Thomas Grant on 30/11/2011.
//  Copyright (c) 2011 Reading University. All rights reserved.
//

#import "DMTopMoviesViewController.h"
#import "DMMoviePosterView.h"
#import "SBJson.h"
#import "Movie.h"

// API key for Rotten Tomatoes
static NSString * const kAPIKey = @"spre238u2unvqxhdpj2a7xg9";


@implementation DMTopMoviesViewController
@synthesize background, moviePosterArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"DMTopMoviesViewController" bundle:nil];
    if (self) {
        
        // Custom initialization
        moviePosterArray = [[NSMutableArray alloc] init];
        movieStore = [MovieStore defaultStore];
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect viewRect = self.background.bounds;
    movieScrollView = [[UIScrollView alloc] initWithFrame:viewRect];
    movieScrollView.delegate = self;
    
    // Set up the scroll view
    movieScrollView.contentSize = CGSizeMake((viewRect.size.width * 3), (viewRect.size.height));
    movieScrollView.pagingEnabled = YES;
    movieScrollView.bounces = YES;
    movieScrollView.showsHorizontalScrollIndicator = NO;
    movieScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:movieScrollView];
    
    
    
    //[self downloadTopMovieJSONFeed];
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationLandscapeLeft;
}

- (void)setUpUserInterface {
    
     NSLog(@"setting up UI");
    
    
    /*for (int i = 0; i < 25; i++) {
        CGRect posterRect =
    }*/
    
    //Hard coded poster views
    // PAGE 1 FRAMES
    CGRect posterRectA = CGRectMake(50, 100, 180, 267);
    CGRect posterRectB = CGRectMake(280, 100, 180, 267);
    CGRect posterRectC = CGRectMake(510, 100, 180, 267);
    CGRect posterRectD = CGRectMake(740, 100, 180, 267);
    CGRect posterRectE = CGRectMake(50, 467, 180, 267);
    CGRect posterRectF = CGRectMake(280, 467, 180, 267);
    CGRect posterRectG = CGRectMake(510, 467, 180, 267);
    CGRect posterRectH = CGRectMake(740, 467, 180, 267);
    
    // PAGE 2 FRAMES
    CGRect posterRectI = CGRectMake(50 + 1024, 100, 180, 267);
    CGRect posterRectJ = CGRectMake(280 + 1024, 100, 180, 267);
    CGRect posterRectK = CGRectMake(510 + 1024, 100, 180, 267);
    CGRect posterRectL = CGRectMake(740 + 1024, 100, 180, 267);
    CGRect posterRectM = CGRectMake(50 + 1024, 467, 180, 267);
    CGRect posterRectN = CGRectMake(280 + 1024, 467, 180, 267);
    CGRect posterRectO = CGRectMake(510 + 1024, 467, 180, 267);
    CGRect posterRectP = CGRectMake(740 + 1024, 467, 180, 267);
    
    // PAGE 3 FRAMES
    CGRect posterRectQ = CGRectMake(50 + 1024 * 2, 100, 180, 267);
    CGRect posterRectR = CGRectMake(280 + 1024 * 2, 100, 180, 267);
    CGRect posterRectS = CGRectMake(510 + 1024 * 2, 100, 180, 267);
    CGRect posterRectT = CGRectMake(740 + 1024 * 2, 100, 180, 267);
    CGRect posterRectU = CGRectMake(50 + 1024 * 2, 467, 180, 267);
    CGRect posterRectV = CGRectMake(280 + 1024 * 2, 467, 180, 267);
    CGRect posterRectW = CGRectMake(510 + 1024 * 2, 467, 180, 267);
    CGRect posterRectX = CGRectMake(740 + 1024 * 2, 467, 180, 267);
    
    // PAGE 1 IMAGES
    UIImage *posterA = [[[movieStore topMovies] objectAtIndex:0] poster];
    UIImage *posterB = [[[movieStore topMovies] objectAtIndex:1] poster];
    UIImage *posterC = [[[movieStore topMovies] objectAtIndex:2] poster];
    UIImage *posterD = [[[movieStore topMovies] objectAtIndex:3] poster];
    UIImage *posterE = [[[movieStore topMovies] objectAtIndex:4] poster];
    UIImage *posterF = [[[movieStore topMovies] objectAtIndex:5] poster];
    UIImage *posterG = [[[movieStore topMovies] objectAtIndex:6] poster];
    UIImage *posterH = [[[movieStore topMovies] objectAtIndex:7] poster];
    
    // PAGE 2 IMAGES
    UIImage *posterI = [[[movieStore topMovies] objectAtIndex:8] poster];
    UIImage *posterJ = [[[movieStore topMovies] objectAtIndex:9] poster];
    UIImage *posterK = [[[movieStore topMovies] objectAtIndex:10] poster];
    UIImage *posterL = [[[movieStore topMovies] objectAtIndex:11] poster];
    UIImage *posterM = [[[movieStore topMovies] objectAtIndex:12] poster];
    UIImage *posterN = [[[movieStore topMovies] objectAtIndex:13] poster];
    UIImage *posterO = [[[movieStore topMovies] objectAtIndex:14] poster];
    UIImage *posterP = [[[movieStore topMovies] objectAtIndex:15] poster];
    
    // PAGE 3 IMAGES
    UIImage *posterQ = [[[movieStore topMovies] objectAtIndex:16] poster];
    UIImage *posterR = [[[movieStore topMovies] objectAtIndex:17] poster];
    UIImage *posterS = [[[movieStore topMovies] objectAtIndex:18] poster];
    UIImage *posterT = [[[movieStore topMovies] objectAtIndex:19] poster];
    UIImage *posterU = [[[movieStore topMovies] objectAtIndex:20] poster];
    UIImage *posterV = [[[movieStore topMovies] objectAtIndex:21] poster];
    UIImage *posterW = [[[movieStore topMovies] objectAtIndex:22] poster];
    UIImage *posterX = [[[movieStore topMovies] objectAtIndex:23] poster];
    
    
    // PAGE 1 VIEWS
    UIImageView *posterAView = [[UIImageView alloc] initWithImage:posterA];
    UIImageView *posterBView = [[UIImageView alloc] initWithImage:posterB];
    UIImageView *posterCView = [[UIImageView alloc] initWithImage:posterC];
    UIImageView *posterDView = [[UIImageView alloc] initWithImage:posterD];
    UIImageView *posterEView = [[UIImageView alloc] initWithImage:posterE];
    UIImageView *posterFView = [[UIImageView alloc] initWithImage:posterF];
    UIImageView *posterGView = [[UIImageView alloc] initWithImage:posterG];
    UIImageView *posterHView = [[UIImageView alloc] initWithImage:posterH];
    
    // PAGE 2 VIEWS
    UIImageView *posterIView = [[UIImageView alloc] initWithImage:posterI];
    UIImageView *posterJView = [[UIImageView alloc] initWithImage:posterJ];
    UIImageView *posterKView = [[UIImageView alloc] initWithImage:posterK];
    UIImageView *posterLView = [[UIImageView alloc] initWithImage:posterL];
    UIImageView *posterMView = [[UIImageView alloc] initWithImage:posterM];
    UIImageView *posterNView = [[UIImageView alloc] initWithImage:posterN];
    UIImageView *posterOView = [[UIImageView alloc] initWithImage:posterO];
    UIImageView *posterPView = [[UIImageView alloc] initWithImage:posterP];
    
    // PAGE 3 VIEWS
    UIImageView *posterQView = [[UIImageView alloc] initWithImage:posterQ];
    UIImageView *posterRView = [[UIImageView alloc] initWithImage:posterR];
    UIImageView *posterSView = [[UIImageView alloc] initWithImage:posterS];
    UIImageView *posterTView = [[UIImageView alloc] initWithImage:posterT];
    UIImageView *posterUView = [[UIImageView alloc] initWithImage:posterU];
    UIImageView *posterVView = [[UIImageView alloc] initWithImage:posterV];
    UIImageView *posterWView = [[UIImageView alloc] initWithImage:posterW];
    UIImageView *posterXView = [[UIImageView alloc] initWithImage:posterX];
    
    // PAGE 1 CONFIG
    posterAView.frame = posterRectA;
    posterBView.frame = posterRectB;
    posterCView.frame = posterRectC;
    posterDView.frame = posterRectD;
    posterEView.frame = posterRectE;
    posterFView.frame = posterRectF;
    posterGView.frame = posterRectG;
    posterHView.frame = posterRectH;
    
    // PAGE 2 CONFIG
    posterIView.frame = posterRectI;
    posterJView.frame = posterRectJ;
    posterKView.frame = posterRectK;
    posterLView.frame = posterRectL;
    posterMView.frame = posterRectM;
    posterNView.frame = posterRectN;
    posterOView.frame = posterRectO;
    posterPView.frame = posterRectP;
    
    // PAGE 3 CONFIG
    posterQView.frame = posterRectQ;
    posterRView.frame = posterRectR;
    posterSView.frame = posterRectS;
    posterTView.frame = posterRectT;
    posterUView.frame = posterRectU;
    posterVView.frame = posterRectV;
    posterWView.frame = posterRectW;
    posterXView.frame = posterRectX;
    
    // PAGE 1 ADD SUBVIEWS
    [movieScrollView addSubview:posterAView];
    [movieScrollView addSubview:posterBView];
    [movieScrollView addSubview:posterCView];
    [movieScrollView addSubview:posterDView];
    [movieScrollView addSubview:posterEView];
    [movieScrollView addSubview:posterFView];
    [movieScrollView addSubview:posterGView];
    [movieScrollView addSubview:posterHView];
    
    // PAGE 2 ADD SUBVIEWS
    [movieScrollView addSubview:posterIView];
    [movieScrollView addSubview:posterJView];
    [movieScrollView addSubview:posterKView];
    [movieScrollView addSubview:posterLView];
    [movieScrollView addSubview:posterMView];
    [movieScrollView addSubview:posterNView];
    [movieScrollView addSubview:posterOView];
    [movieScrollView addSubview:posterPView];
    
    // PAGE 3 ADD SUBVIEWS
    [movieScrollView addSubview:posterQView];
    [movieScrollView addSubview:posterRView];
    [movieScrollView addSubview:posterSView];
    [movieScrollView addSubview:posterTView];
    [movieScrollView addSubview:posterUView];
    [movieScrollView addSubview:posterVView];
    [movieScrollView addSubview:posterWView];
    [movieScrollView addSubview:posterXView];

    
   
    
}

#pragma mark - Scroll View Delegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSLog(@"Scroll View Did Scroll");
}


#pragma mark - Networking Methods

- (void)downloadTopMovieJSONFeed {
    
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


- (void)downloadPosterForMovie: (NSDictionary *)_posters {
    
    NSDictionary *posters = _posters;
    
    // Extract movie poster link
    NSString *moviePosterURL = [posters objectForKey:@"detailed"];
    NSLog(@"Movie Poster URL = %@", moviePosterURL);
    
    // Create URL Request
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:moviePosterURL]];
    
    // Create connection with request
   /* NSURLConnectionWithTag *connection = [[NSURLConnectionWithTag alloc] initWithRequest:request 
                                                                                delegate:self 
                                                                        startImmediately:YES 
                                                                                     tag:[NSNumber numberWithInt:TopMoviesPosterDownloadConnection]];*/
     
    
   
        
        // Create data object to store poster data
        NSData *posterData = [NSData data];
    
        posterData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        [moviePosterArray addObject:posterData];
   
    
    
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
            
            [topMoviesData setLength:0];
            
    
            
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [topMoviesData appendData:data];	
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    
	
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                         message:@"An error occured accessing the network resource" 
                                                        delegate:nil 
                                               cancelButtonTitle:@"OK" 
                                               otherButtonTitles:nil, nil];
    
    [errorAlert show];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    
         
    // Number of bytes downloaded for movie info
    NSLog(@"Succeeded downloading Top Movies! Received %d bytes of data", [topMoviesData length]);                                                                  
    [self parseMovieFeed];
            
	
}

#pragma mark - Parsing Methods

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
        // download the correct poster
        NSLog(@"About to download movie poster");
        [self downloadPosterForMovie:posters];
        
        // crate an image from the poster and set it to the movie
        UIImage *poster = [[UIImage alloc] initWithData:[moviePosterArray objectAtIndex:i]];
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
        
        //NSLog(@"Movie = %@", movie);
        
        
    }

    [self setUpUserInterface];
    
}

@end
