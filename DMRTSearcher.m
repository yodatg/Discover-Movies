//
//  DMRTSearcher.m
//  Discover Movies
//
//  Created by Thomas Grant on 26/02/2012.
//  Copyright (c) 2012 Reading University. All rights reserved.
//

#import "DMRTSearcher.h"
#import "Constants.h"
#import "DMMyDownloader.h"
#import "SBJSON.h"

@implementation DMRTSearcher
@synthesize connections, returnedMovies, moviesToParse, data, delegate, parser;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 * Private interface definitions
 *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
@interface DMRTSearcher(Private) 
- (void)parseReturnedMovies: (NSNotification *)notification;
-(void)parseMovies;


@end
/*-------------------------------------------------------------
 * 
 *------------------------------------------------------------*/

- (id)init {
    
    self = [super init];
    
    if(self){
        
        self.returnedMovies = [[NSMutableArray alloc] init];
        self.connections = [[NSMutableArray alloc] init];
        self.moviesToParse = [[NSMutableArray alloc] init];
        self.data = [[NSData alloc] init];
    }
    
    return self;
}

/*-------------------------------------------------------------
 * 
 *------------------------------------------------------------*/

-(void)searchForMovieTitle:(NSString *)title {
    
    NSLog(@"RT SEARCHER IS SEARCHING!");
    NSString *searchTerm = title;
    
    // set the networking activity to visible
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    
    // create our JSON feed URL


    NSString *movieSearchURL = [NSString stringWithFormat:@"http://api.rottentomatoes.com/api/public/v1.0/movies.json?q=%@&page_limit=24&page=1&apikey=%@", searchTerm, kRTAPIKey];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:movieSearchURL] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
    
    DMMyDownloader *downloader = [[DMMyDownloader alloc] initWithRequest:request];
    [downloader.connection start];
    [self.connections addObject: downloader];
    
    // Registering with the notification center - will parse movies using DMMovieParser when 
    // "downloadFinished" notification is posted to the center from the downloader object
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(parseReturnedMovies:) name:@"downloadFinished" object:downloader];
    
    
    // start the download
    NSLog(@"starting download");
    
}

    

/*-------------------------------------------------------------
 * 
 *------------------------------------------------------------*/
- (void)parseReturnedMovies: (NSNotification *)notification {
    
    NSNotification *n = notification;
    
    // if notification name @"connectionFailed"
    if ([n name] == @"connectionFailed" ) {
        
        NSLog(@"Error");
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    // else if notification name @"downloadFinished"
    else if ([n name] == @"downloadFinished") {
        NSLog(@"download finished");
        DMMyDownloader *d = [notification object];
        self.data = [d receivedData];
        NSLog(@"Data downloaded");
        parser = [[DMMovieParser alloc] initWithData:self.data];
        parser.delegate = self;
        [parser parse];
        [self.connections removeObject:d];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        
    }
    
    
    
    
}

/*-------------------------------------------------------------
 * 
 *------------------------------------------------------------*/

- (void)parserFinishedParsingWithMovies:(NSMutableArray *)parsedMovies {
NSLog(@"parser finished parsing");
    [self.delegate DMRTSearcherFinishedSearchingAndReturnedMovies:parsedMovies];

}

@end
