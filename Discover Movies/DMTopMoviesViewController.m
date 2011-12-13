//
//  JSONViewController.m
//  Discover Movies
//
//  Created by Thomas Grant on 30/11/2011.
//  Copyright (c) 2011 Reading University. All rights reserved.
//

#import "DMTopMoviesViewController.h"
#import "DMMoviePosterView.h"
#import "NSURLConnectionWithTag.h"
#import "SBJson.h"
#import "Movie.h"

// API key for Rotten Tomatoes
static NSString * const kAPIKey = @"spre238u2unvqxhdpj2a7xg9";

// Mutable Dictionary keeps track of data retrieved by the 
// NSURLConnections
static NSMutableDictionary *dataFromConnectionsByTag;

// Enums used to keep track of NSURLConnection
typedef enum {
    
    TopMoviesDownloadConnection = 0,
    TopMoviesPosterDownloadConnection = 1
    
} DataConnectionSourceTypes;


@implementation DMTopMoviesViewController
@synthesize background, moviePosterArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"DMTopMoviesViewController" bundle:nil];
    if (self) {
        
        // Custom initialization
        moviePosterArray = [[NSMutableArray alloc] init];
        
        if (dataFromConnectionsByTag == nil) {
            dataFromConnectionsByTag = [[NSMutableDictionary alloc] init];
        }
        
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
    movieScrollView.bounces = NO;
    movieScrollView.showsHorizontalScrollIndicator = NO;
    movieScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:movieScrollView];
    
    /*// Hard coded poster views
    CGRect posterRectA = CGRectMake(50, 100, 180, 267);
    CGRect posterRectB = CGRectMake(280, 100, 180, 267);
    CGRect posterRectC = CGRectMake(510, 100, 180, 267);
    CGRect posterRectD = CGRectMake(740, 100, 180, 267);
    CGRect posterRectE = CGRectMake(50, 467, 180, 267);
    CGRect posterRectF = CGRectMake(280, 467, 180, 267);
    CGRect posterRectG = CGRectMake(510, 467, 180, 267);
    CGRect posterRectH = CGRectMake(740, 467, 180, 267);*/
    
    [self downloadTopMovieJSONFeed];
    
    
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


#pragma mark - Scroll View Delegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSLog(@"Scroll View Did Scroll");
}


#pragma mark - Networking Methods

- (void)downloadTopMovieJSONFeed {
    
    // create our JSON feed URL
    NSString *topMoviesJSONURL = [NSString stringWithFormat:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?limit=8&country=uk&apikey=%@", kAPIKey];
    
    // Create our URL Request
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:topMoviesJSONURL]];
    
    
    // Create our connection with the request
    NSURLConnectionWithTag *connection = [[NSURLConnectionWithTag alloc] initWithRequest:request 
                                                                                delegate:self 
                                                                        startImmediately:YES 
                                                                                     tag:[NSNumber numberWithInt:TopMoviesDownloadConnection]];
    // if all went well...
    if (connection) {
        
        // Create a data object to store our JSON data
        topMoviesData = [NSMutableData data];
    }
    
                             
}

- (void)downloadPosterForMovie: (Movie *)_movie {
    
   // Movie *movie = _movie;
    
    
    
}


- (void)connection:(NSURLConnectionWithTag *)connection didReceiveResponse:(NSURLResponse *)response {
    
    [topMoviesData setLength:0];
    [posterData setLength:0];
}

- (void)connection:(NSURLConnectionWithTag *)connection didReceiveData:(NSData *)data {
    
    if ([dataFromConnectionsByTag objectForKey:connection.tag] == nil) {
        
        NSMutableData *newData = [[NSMutableData alloc] initWithData:data];
        
        [dataFromConnectionsByTag setObject:newData forKey:connection.tag];
        
        return;
    }
    
    else {
        
        [[dataFromConnectionsByTag objectForKey:connection.tag] appendData:data];
    }
	
}

- (void)connection:(NSURLConnectionWithTag *)connection didFailWithError:(NSError *)error {
    
    [dataFromConnectionsByTag removeObjectForKey:connection.tag];
	
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                         message:@"An error occured accessing the network resource" 
                                                        delegate:nil 
                                               cancelButtonTitle:@"OK" 
                                               otherButtonTitles:nil, nil];
    
    [errorAlert show];
}

- (void)connectionDidFinishLoading:(NSURLConnectionWithTag *)connection {
    
    NSLog(@"Succeeded! Received %d bytes of data", [[dataFromConnectionsByTag objectForKey:[NSNumber numberWithInt:TopMoviesDownloadConnection]] length]);
    [self parseMovieFeed];
    
	
}

#pragma mark - Parsing Methods

- (void)parseMovieFeed {
    
    
    // Create our JSON string from the data
    NSString *responseString = [[NSString alloc] initWithData:[dataFromConnectionsByTag objectForKey:[NSNumber numberWithInt:TopMoviesDownloadConnection]] encoding:NSUTF8StringEncoding];
    
    
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
        NSDictionary *poster = (NSDictionary *)[aMovie valueForKey:@"posters"];
        
        
        
        
        // Create movie object with info from data object
        Movie *movie = [[Movie alloc] initWithTitle:movieTitle 
                                               year:movieYear 
                                           synopsis:movieSynopsis 
                                       abridgedCast:abridgedCast 
                                  suggestedMovieIDs:nil 
                                        trailerLink:nil 
                                            ratings:ratings 
                                             poster:poster];
        
        
        
        
        NSLog(@"Movie = %@", movie);
        
        
    }

    
    
}

@end
