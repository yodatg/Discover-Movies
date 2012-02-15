//
//  DMRecommendedMoviesDownloader.m
//  Discover Movies
//
//  Created by Thomas Grant on 08/02/2012.
//  Copyright (c) 2012 Reading University. All rights reserved.
//

#import "DMRecommendedMoviesDownloader.h"
#import "DMMyDownloader.h"
#import "Constants.h"

@implementation DMRecommendedMoviesDownloader
@synthesize connections, recommendedMovies, parser, delegate, movie;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 * Private interface definitions
 *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
@interface DMRecommendedMoviesDownloader(Private) 
- (void)recommendedMoviesDownloadFinished: (NSNotification *)n;
- (void)parseMovieFeedWithData:(NSData *)data;
@end

- (id)init {
    
    self = [super init];
    
    if(self) {
        
        self.recommendedMovies = [[NSMutableArray alloc] init];
        self.movie = [[DMMovie alloc] init];
        
    }
    return self;
}

/*-------------------------------------------------------------
 * Download Recommended Movie Feed from RT using API Key + movie ID
 *------------------------------------------------------------*/

-(void)fetchRecommendedMoviesForMovie:(DMMovie *)m {
    
    self.movie = m;
    NSLog(@"Movie for fetching is: %@", [self.movie title]);
   // extract movie ID
    NSString *movieID = [movie movieID];
    // set the networking activity to visible
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSLog(@"Downloading Recommended movies");
    
    // create our JSON feed URL
    NSString *topMoviesJSONURL = [NSString stringWithFormat:@"http://api.rottentomatoes.com/api/public/v1.0/movies/%@/similar.json?limit=5&apikey=%@", movieID, kRTAPIKey];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:topMoviesJSONURL] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
    
    DMMyDownloader *downloader = [[DMMyDownloader alloc] initWithRequest:request];
    
    [self.connections addObject: downloader];
    
    // Registering with the notification center - will parse movies using DMMovieParser when 
    // "downloadFinished" notification is posted to the center from the downloader object
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recommendedMoviesDownloadFinished:) name:@"downloadFinished" object:downloader];
    
    
    // start the download
    NSLog(@"starting download");
    [downloader.connection start];

    
}

/*-------------------------------------------------------------
 * Called when download finished
 *------------------------------------------------------------*/
- (void)recommendedMoviesDownloadFinished: (NSNotification *)n {
    
    NSData *data = nil;
    NSNotification *notif = n;
    
    // if notification name @"connectionFailed"
    if ([notif name] == @"connectionFailed" ) {
        
        NSLog(@"Error");
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
    // else if notification name @"downloadFinished"
    else if ([notif name] == @"downloadFinished") {
        
        DMMyDownloader *d = [n object];
        data = [d receivedData];
        NSLog(@"Data downloaded");
        [self.connections removeObject:d];
        [self parseMovieFeedWithData:data];
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    }

    
}

/*-------------------------------------------------------------
 * 
 *------------------------------------------------------------*/
- (void)cancelDownload {
    [self.parser cancelDownload];
    for(DMMyDownloader *d in self.connections){
        
        [d cancel];
        
    }

    
}

/*-------------------------------------------------------------
 * Called when download completed
 *------------------------------------------------------------*/
- (void)parseMovieFeedWithData:(NSData *)data {
    
    
    self.parser = [[DMMovieParser alloc] initWithData:data];
    self.parser.delegate = self;
    [self.parser parse];
    
}

#pragma mark - Delegate Methods

/*-------------------------------------------------------------
 * Called when parser finishes its parsing
 *------------------------------------------------------------*/

- (void)parserFinishedParsingWithMovies:(NSMutableArray *)parsedMovies {
    static NSString *movieToCutOut;
    
    static BOOL recursed = NO;
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:parsedMovies];

    
    if(recursed == NO & [arr count] > 0) {
        movieToCutOut = [NSString stringWithFormat:self.movie.movieID];
        NSLog(@"Movie to cut out = %@", movieToCutOut);
        [self.recommendedMovies addObjectsFromArray:arr];
        [self fetchRecommendedMoviesForMovie:[self.recommendedMovies objectAtIndex:0]];
        recursed = YES;
        
    }
    else if (recursed == YES) {
        if([arr count] != 0 ){
            for(int j = 0; j < [recommendedMovies count]; j++){ 
                for(int k = 0; k < [arr count]; k++){
                if([[(DMMovie *)[recommendedMovies objectAtIndex:j] movieID] isEqualToString:[(DMMovie *)[arr objectAtIndex:k] movieID]]){
                    [arr removeObjectAtIndex:k];
                }
                }
                    
            
            }
            for(int i = 0; i < [arr count]; i++){
            
                if([[(DMMovie *)[arr objectAtIndex:i] movieID] isEqualToString:movieToCutOut]){
                    [arr removeObjectAtIndex:i];
                }
            }
        
        [self.recommendedMovies addObjectsFromArray:arr];
        [[self delegate] recommendedMoviesDownloaded:self.recommendedMovies forMovieID:movieToCutOut];
        // release our delegate
        self.parser.delegate = nil;
        recursed = NO;
        [self.recommendedMovies removeAllObjects];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
                    
        
        
            
            
                
        
    }
}
    

@end
