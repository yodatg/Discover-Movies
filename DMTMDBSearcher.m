//
//  DMTMDBSearcher.m
//  Discover Movies
//
//  Created by Thomas Grant on 13/02/2012.
//  Copyright (c) 2012 Reading University. All rights reserved.
//

#import "DMTMDBSearcher.h"
#import "DMMyDownloader.h"
#import "Constants.h"
#import "SBJSON.h"
#import "DMMovie.h"
#import "DMMyImageDownloader.h"


@implementation DMTMDBSearcher
@synthesize returnedMovies, connections, moviesToParse, delegate;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 * Private interface definitions
 *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
@interface DMTMDBSearcher(Private) 
- (void)recommendedMoviesDownloadFinished: (NSNotification *)n;
- (void)parseMovieFeedWithData:(NSData *)data;
- (void)parseReturnedMovies:(NSNotification *)notification;
@end


- (id)init {
    
    self = [super init];
    
    if(self){
        
        self.returnedMovies = [[NSMutableArray alloc] init];
        self.connections = [[NSMutableArray alloc] init];
        self.moviesToParse = [[NSMutableArray alloc] init];
    }
    
    return self;
}


- (void)searchForMovie:(NSString *)movieTitle {
    
    NSString *concatMovieTitle = [movieTitle stringByReplacingOccurrencesOfString:@" " withString:@"+"];   
    // create our JSON feed URL
    NSString *searchString = [NSString stringWithFormat:@"http://api.themoviedb.org/2.1/Movie.search/en/json/94e72d0d2d1d66f1401f716b9694bb5e/%@", concatMovieTitle];
    NSLog(@"Search string = %@", searchString);
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:searchString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
    
    DMMyDownloader *downloader = [[DMMyDownloader alloc] initWithRequest:request];
    
    [self.connections addObject: downloader];
    
    // Registering with the notification center - will parse movies using DMMovieParser when 
    // "downloadFinished" notification is posted to the center from the downloader object
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(parseReturnedMovies:) name:@"downloadFinished" object:downloader];
    
    
    // start the download
    NSLog(@"starting download");
    [downloader.connection start];

    
    
}

- (void)parseReturnedMovies: (NSNotification *)notification {
    
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
        
    }
    // else if notification name @"imageDownloaded"
    else if ([n name] == @"imageDownloaded") {
        
        DMMyImageDownloader *d = [n object];
        UIImage *im = [d image];
        
        // extract the correct movie for the corresponding poster 
        DMMovie *m = [self.moviesToParse objectAtIndex:[[d tag] intValue]];
        [m setPoster:im];
        
        numberOfImages--;
        NSLog(@"Number of movies = %d", numberOfMovies);
        if(numberOfImages == 0){
            
            [self.connections removeAllObjects];
            [self.delegate searcherFinishedSearchingWithMovies:self.moviesToParse];
            [self.moviesToParse removeAllObjects];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            [[NSNotificationCenter defaultCenter] removeObserver:self]; 
            
        }

        
    }

    
}

- (void)parseMovieFeedWithData:(NSData *)d {
    
    int counter = 0;
    // Create our JSON string from the data
    NSString *responseString = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
    
    // Parse the JSON string using SBJason
    NSMutableArray *results = [responseString JSONValue];
    numberOfMovies = [results count];
    
       
    if([[results objectAtIndex:0] respondsToSelector:@selector(isEqualToString:)]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Sorry - we couldn't find your movie" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    
    else{
    for(NSDictionary *dict in results){
        
                
        NSArray *images = [dict objectForKey:@"posters"];
        
        if ([images count]!= 0){
            numberOfImages = [images count];
            
            NSDictionary *thumbDict = [images objectAtIndex:0];
            NSDictionary *imageDict = [thumbDict objectForKey:@"image"];
            
            NSString *urlString = [NSString stringWithFormat:[imageDict objectForKey:@"url"]];
            NSURL *url = [NSURL URLWithString:urlString];
            
            NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
            
            
            DMMyImageDownloader *imageDownloader = [[DMMyImageDownloader alloc] initWithRequest:request andTag:[[NSNumber alloc] initWithInt:counter]];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(parseReturnedMovies:) name:@"imageDownloaded" object:imageDownloader];
            
           [imageDownloader.connection start];
            
            [self.connections addObject:imageDownloader];
            
             
            
            DMMovie *movie = [[DMMovie alloc] initWithID:[dict objectForKey:@"id"] title:[dict objectForKey:@"original_name"] year:[dict objectForKey:@"released"] synopsis:[dict objectForKey:@"overview"] abridgedCast:nil suggestedMovieIDs:nil ratings:nil poster:nil];
            [self.moviesToParse addObject:movie];
            
            
            
            counter++;
            NSLog(@"Counter = %d", counter);
            
        }
               
        
        
    }
        
    }
    
    
}


@end
