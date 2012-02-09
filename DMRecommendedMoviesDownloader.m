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
@synthesize connections, recommendedMovies, parser, delegate;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 * Private interface definitions
 *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
@interface DMRecommendedMoviesDownloader(Private) 
- (void)recommendedMoviesDownloadFinished: (NSNotification *)notification;
- (void)parseMovieFeedWithData:(NSData *)data;
@end

- (id)init {
    
    self = [super init];
    
    if(self) {
        
        self.recommendedMovies = [[NSMutableArray alloc] init];
    }
    return self;
}

/*-------------------------------------------------------------
 * Download Recommended Movie Feed from RT using API Key + movie ID
 *------------------------------------------------------------*/

-(void)fetchRecommendedMoviesForMovie:(DMMovie *)movie {
    
   // extract movie ID
    NSString *movieID = [movie movieID];
    // set the networking activity to visible
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSLog(@"Downloading Recommended movies");
    
    // create our JSON feed URL
    NSString *topMoviesJSONURL = [NSString stringWithFormat:@"http://api.rottentomatoes.com/api/public/v1.0/movies/%@/similar.json?limit=5&apikey=%@", movieID, kAPIKey];
    
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
- (void)recommendedMoviesDownloadFinished: (NSNotification *)notification {
    
    NSData *data = nil;
    NSNotification *n = notification;
    
    // if notification name @"connectionFailed"
    if ([n name] == @"connectionFailed" ) {
        
        NSLog(@"Error");
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
    // else if notification name @"downloadFinished"
    else if ([n name] == @"downloadFinished") {
        
        DMMyDownloader *d = [notification object];
        data = [d receivedData];
        NSLog(@"Data downloaded");
        [self parseMovieFeedWithData:data];
        [self.connections removeObject:d];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
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
    
    static int i;
    
    
    
    if(i >= 20){
        
        [[self delegate] recommendedMoviesDownloaded:recommendedMovies];
        // release our delegate
        self.parser.delegate = nil;
        
        
    }
    else {
        
        [self.recommendedMovies addObjectsFromArray:parsedMovies];
        [self fetchRecommendedMoviesForMovie:[recommendedMovies objectAtIndex:0]];
        i+= [parsedMovies count];
        
    }
       
    
}
        
    

@end
