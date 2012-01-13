//
//  MovieStore.m
//  Discover Movies
//
//  Created by Thomas Grant on 14/12/2011.
//  Copyright (c) 2011 Reading University. All rights reserved.
//

#import "DMMovieStore.h"
#import "DMMyDownloader.h"
#import "DMMyImageDownloader.h"
#import "SBJson.h"


static DMMovieStore *defaultStore = nil;

// API key for Rotten Tomatoes
NSString *const kAPIKey = @"spre238u2unvqxhdpj2a7xg9";


@implementation DMMovieStore

@synthesize topMovies, favoriteMovies, allMovies, connections, moviePosters;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 * Private interface definitions
 *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
@interface DMMovieStore(Private)

- (void)addTopMovie: (DMMovie *) _movie;
- (void)addFavoriteMovie: (DMMovie *) _movie;
- (void)downloadTopMovies;
- (void)downloadFinished: (NSNotification *) _notification;
- (void)parseMovieFeedWithData: (NSData *) _data;

@end

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


- (void)addTopMovie: (DMMovie *) _movie {
    
    // add movie to Top Movie Array
    [[self topMovies] addObject:_movie];
}

- (void)addFavoriteMovie: (DMMovie *) _movie {
    
    // add movie to Favorite Movie Array
    [[self favoriteMovies] addObject:_movie];
    
}

- (void)downloadTopMovies {
    
    // set the networking activity to visible
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSLog(@"downloading top movies");
    // create our JSON feed URL
    NSString *topMoviesJSONURL = [NSString stringWithFormat:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?limit=24&country=us&apikey=%@", kAPIKey];
    
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:topMoviesJSONURL] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
        
        DMMyDownloader *downloader = [[DMMyDownloader alloc] initWithRequest:request];
        
        [self.connections addObject: downloader];
        
        // Registering with the notification center - will run method "parseMovies: when 
        // "downloadFinished" notification is posted to the center from the downloader object
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadFinished:) name:@"downloadFinished" object:downloader];

    
        // start the download
        NSLog(@"starting download");
        [downloader.connection start];
}

- (void) downloadFinished: (NSNotification *) _notification {
    
    NSData *data = nil;
    NSNotification *n = _notification;
    
    if ([n name] == @"connectionFailed" ) {
        
        NSLog(@"Error");
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
    else if ([n name] == @"downloadFinished") {
        
        DMMyDownloader *d = [_notification object];
        data = [d receivedData];
        NSLog(@"Data downloaded");
        [self parseMovieFeedWithData:data];
        [self.connections removeObject:d];
        
    }
    else if ([n name] == @"imageDownloaded") {
        
        static int i;
        
        DMMyImageDownloader *d = [_notification object];
        UIImage *im = [d image];
        
        NSLog(@"Image Downloaded");
        
        NSLog(@"Connection tag = %@", [d tag]);
        // extract the correct movie for the corresponding poster 
        DMMovie *m = [topMovies objectAtIndex:[[d tag] intValue]];
        [m setPoster:im];
        
        i++;
        
        
        if (i == 24) {
            
            for (int k = 0; k < [topMovies count]; k++){
                
                // Add the movie posters to the movie posters array - this ensures they are 
                // in the correct order as oppose to adding them right after they have been downloaded
                // since the connections are asynchronous
                
                [moviePosters addObject:[[topMovies objectAtIndex:k] poster]];
            }
            
            [connections removeAllObjects];
            NSLog(@"Poster Downloads Complete");
            NSLog(@"posters array size = %d", [self.moviePosters count]);
            [[NSNotificationCenter defaultCenter] 
             postNotificationName:@"postersDownloaded" object:self];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
        
    }

}

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
- (void)parseMovieFeedWithData: (NSData *) _data {
    
    NSData *data = _data;
    
    // Create our JSON string from the data
    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    
    // Parse the JSON string using SBJason
    NSDictionary *results = [responseString JSONValue];
    
    // Create an array of movies using key "movies"
    NSArray *movies = [results objectForKey:@"movies"];
    
    // Just to check we have the correct number of movies
    NSLog(@"Number of movies = %d", [movies count]);
    
    // Parse our movies
    for (int i = 0; i < [movies count]; i++) {
        
        // Extract a movie from our movies array
        NSDictionary *aMovie = [movies objectAtIndex:i]; 
        
        // Create our movie variables from the key value
        // pairs in our dictionarys in the movies array
        NSString *movieID = (NSString *) [aMovie valueForKey:@"id"];
        NSString *movieTitle = (NSString *) [aMovie valueForKey:@"title"];
        NSString *movieYear = (NSString *) [aMovie valueForKey:@"year"];
        NSString *movieSynopsis = (NSString *) [aMovie valueForKey:@"synopsis"];
        NSArray *abridgedCast = (NSArray *)[aMovie valueForKey:@"abridged_cast"];
        NSDictionary *ratings = (NSDictionary *) [aMovie valueForKey:@"ratings"];
        
        // obtain the movie posters links
        NSDictionary *posters = (NSDictionary *)[aMovie valueForKey:@"posters"];
        NSString *moviePosterURL = [posters objectForKey:@"detailed"];
        
        NSURL *url = [NSURL URLWithString:moviePosterURL];
        NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url];
        
        DMMyImageDownloader *d = [[DMMyImageDownloader alloc] initWithRequest:req andTag:[[NSNumber alloc] initWithInt:i]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadFinished:) name:@"imageDownloaded" object:d];
        [d.connection start];
        [self.connections addObject:d];
        
        
        
        
        // Create movie object with info from data object
        DMMovie *movie = [[DMMovie alloc] initWithID:movieID title:movieTitle year:movieYear synopsis:movieSynopsis abridgedCast:abridgedCast suggestedMovieIDs:nil trailerLink:nil ratings:ratings poster:nil];
        
        
        [self addTopMovie:movie];     
        
    }
}

#pragma mark -
#pragma mark Public Methods

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/

+ (DMMovieStore *)defaultStore
{
    
    if (defaultStore == nil) {
        // Create the singleton
        defaultStore = [[super allocWithZone:NULL] init];
    }
    return defaultStore;
}

// Prevent creation of additional instances
+ (id)allocWithZone:(NSZone *)zone
{
    return [self defaultStore];
}

- (id)init
{
    
    // If we already have an instance of MovieStore...
    if (defaultStore) {
        // return the old one
        return defaultStore;
    }
    
    self = [super init];
    if (self) {
        
        allMovies = [[NSMutableDictionary alloc] init];
        topMovies = [[NSMutableArray alloc] init];
        favoriteMovies = [[NSMutableArray alloc] init];
        moviePosters = [[NSMutableArray alloc] init];
        
        // Set the 2 arrays to hold our movie objects into the dictionary
        // Top Movies will be accessed with key "topMovies"
        // Favorite Movies will be accessed with key "favMovies"
        [allMovies setObject:topMovies forKey:@"topMovies"];
        [allMovies setObject:favoriteMovies forKey:@"favMovies"];
        
        [self downloadTopMovies];
    }
    return self;
}


@end
