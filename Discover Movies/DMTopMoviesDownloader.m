//
//  DMTopMoviesDownloader.m
//  Discover Movies
//
//  Created by Thomas Grant on 08/02/2012.
//  Copyright (c) 2012 Reading University. All rights reserved.
//

#import "DMTopMoviesDownloader.h"
#import "DMMyDownloader.h"
#import "Constants.h"


// API key for Rotten Tomatoes

@implementation DMTopMoviesDownloader

@synthesize connections, topMovies, delegate, parser;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 * Private interface definitions
 *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
@interface DMTopMoviesDownloader(Private) 

- (void)parseMovieFeedWithData:(NSData *)data;
- (void)topMoviesDownloadFinished: (NSNotification *)notification;

@end

-(id)init {
    
    self = [super init];
    if(self) {
        
        connections = [[NSMutableArray alloc] init];
        topMovies = [[NSArray alloc] init];
        
    }
    return self;
}
/*-------------------------------------------------------------
 * Download Top Movie Feed from RT using API Key
 *------------------------------------------------------------*/

- (void)downloadTopMovies {
    
    
    // set the networking activity to visible
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSLog(@"Downloading top movies");
    
    // create our JSON feed URL
    NSString *topMoviesJSONURL = [NSString stringWithFormat:@"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?limit=25&country=uk&apikey=%@", kRTAPIKey];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:topMoviesJSONURL] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
    
    DMMyDownloader *downloader = [[DMMyDownloader alloc] initWithRequest:request];
    
    [self.connections addObject: downloader];
    
    // Registering with the notification center - will parse movies using DMMovieParser when 
    // "downloadFinished" notification is posted to the center from the downloader object
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(topMoviesDownloadFinished:) name:@"downloadFinished" object:downloader];
    
    
    // start the download
    NSLog(@"starting download");
    [downloader.connection start];
}

/*-------------------------------------------------------------
 * Called when "downloadFinished" notification posted to 
   Notification Centre
 *------------------------------------------------------------*/

- (void)topMoviesDownloadFinished: (NSNotification *)notification {
    
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
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        
    }
    
    
}

/*-------------------------------------------------------------
 * Called when download completed
 *------------------------------------------------------------*/
- (void)parseMovieFeedWithData:(NSData *)data {
    
    
    parser = [[DMMovieParser alloc] initWithData:data];
    parser.delegate = self;
    [parser parse];
    
}

#pragma mark - Delegate Methods

/*-------------------------------------------------------------
 * Called when parser finishes its parsing
 *------------------------------------------------------------*/

- (void)parserFinishedParsingWithMovies:(NSMutableArray *)parsedMovies {
    NSLog(@"Parser finished");
    self.topMovies = [parsedMovies copy];
    [[self delegate] topMoviesDownloaded:self.topMovies];
    
    // release our delegate
    parser.delegate = nil;
    
    
}
@end
