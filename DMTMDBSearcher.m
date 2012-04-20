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
#import "DMMovieStore.h"


@implementation DMTMDBSearcher
@synthesize returnedMovies, connections, moviesToParse, delegate, rtSearcher, cast, trailer;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 * Private interface definitions
 *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
@interface DMTMDBSearcher(Private) 
- (void)recommendedMoviesDownloadFinished: (NSNotification *)n;
- (void)parseMovieFeedWithData:(NSData *)data;
- (void)parseReturnedMovies:(NSNotification *)notification;
- (void)extractDetailedInfo:(NSNotification *)n;
- (NSArray *)extractActors:(NSDictionary *)dict;

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

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/

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
/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/

- (void)parseReturnedMovies: (NSNotification *)notification {
    
    NSData *data = nil;
    NSNotification *n = notification;
    
    // if notification name @"connectionFailed"
    if ([n name] == @"connectionFailed" ) {
        
        NSLog(@"Error");
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
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
 *
 *------------------------------------------------------------*/

- (void)parseMovieFeedWithData:(NSData *)d {
    
    
    // Create our JSON string from the data
    NSString *responseString = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
    
    // Parse the JSON string using SBJason
    NSMutableArray *results = [responseString JSONValue];
    
    
       
    if([[results objectAtIndex:0] respondsToSelector:@selector(isEqualToString:)]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Sorry - we couldn't find your movie" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    
    else{
        
        int counter = 0;
        
    for(NSDictionary *dict in results){
               
        NSArray *allImages = [dict objectForKey:@"posters"];
        NSString *movieID = [dict objectForKey:@"id"];
        NSString *movieTitle = [dict objectForKey:@"original_name"];
        
        NSString *year = [NSString stringWithFormat:@"%@",[dict objectForKey:@"released"]];
        NSString *parsedYear = [year substringToIndex:4];
        NSString *url;
        
        if([allImages count] != 0){
            
            NSDictionary *posterDict = [allImages objectAtIndex:2];
            NSDictionary *imageDict = [posterDict objectForKey:@"image"];
            
            NSString *urlString = [NSString stringWithFormat:[imageDict objectForKey:@"url"]];
    
            url = urlString;
            
        }

       
        
        NSString *synopsis = [dict objectForKey:@"overview"];
        
              
            
            
        DMMovie *movie = [[DMMovie alloc] initWithID:movieID title:movieTitle year:parsedYear synopsis:synopsis abridgedCast:nil suggestedMovieIDs:nil ratings:nil poster:nil];
        [movie setAllPosterURLs:allImages];
        [movie setMovieMidsizeImageURL:url];
        
        
            [self.moviesToParse addObject:movie];
            counter++;
            
            
           

            
        }
        
        
    }

[self.delegate searcherFinishedSearchingWithMovies:self.moviesToParse];
//[[NSNotificationCenter defaultCenter] removeObserver:self];

}

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
-(void)getDetailedMovieInfoForMovie:(DMMovie *)movie {

NSLog(@"other movie = %@", movie);

NSString *url = [NSString stringWithFormat:@"http://api.themoviedb.org/2.1/Movie.getInfo/en/json/%@/%@", kTMDBAPIKey, [movie movieID]];


NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];

DMMyDownloader *d = [[DMMyDownloader alloc] initWithRequest:request];

[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(extractDetailedInfo:) name:@"downloadFinished" object:d];

[self.connections addObject: d];

// Registering with the notification center - will parse movies using DMMovieParser when 
// "downloadFinished" notification is posted to the center from the downloader object

rtSearcher = [[DMRTSearcher alloc] init];
rtSearcher.delegate = self;
//[rtSearcher getRatingsForMovie:movie];
// start the download
NSLog(@"starting download");
[d.connection start];


}

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
- (void)extractDetailedInfo:(NSNotification *)n {

NSData *data = nil;

DMMyDownloader *d = [n object];
data = [d receivedData];
NSLog(@"Data downloaded");
[self.connections removeObject:d];

// Create our JSON string from the data
NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];



// Parse the JSON string using SBJason
NSMutableArray *results = [responseString JSONValue];

for(NSDictionary *dict in results){
    
    trailer = [dict objectForKey:@"trailer"];
    
    NSLog(@"trailer URL = %@", trailer);
    NSLog(@"notifying delegate");
    cast = [self extractActors:dict];
    
}

//[[NSNotificationCenter defaultCenter] removeObserver:self];

}

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/

- (NSArray *)extractActors:(NSDictionary *)dict {

    NSArray *actors = [dict objectForKey:@"cast"];
    NSMutableArray *castParsed = [[NSMutableArray alloc] init];
    int counter = 0;

for(NSDictionary *obj in actors){
    if(counter < 5){
        if([[obj valueForKey:@"job"] isEqualToString:@"Actor"]){
            
            [castParsed addObject:obj];
            
            
        }
        
    }
    
}

return castParsed;
}

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/

-(void)DMRTSearcherFinishedSearchingAndReturnedMovies:(NSArray *)movie {

if([movie count] != 0){
    DMMovie *m = [movie objectAtIndex:0];
    NSLog(@"m ratings = %@", [m ratings]);
    [[[DMMovieStore defaultStore]movie] setRatings:[m ratings]];
    

}
[self.delegate searcherFinishedFindingYoutubeURL:self.trailer andActors:self.cast];

}
@end
