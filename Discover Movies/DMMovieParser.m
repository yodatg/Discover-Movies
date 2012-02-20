//
//  DMMovieParser.m
//  Discover Movies
//
//  Created by Thomas Grant on 08/02/2012.
//  Copyright (c) 2012 Reading University. All rights reserved.
//

#import "DMMovieParser.h"
#import "SBJSON.h"
#import "DMMovie.h"
#import "DMMyImageDownloader.h"

@implementation DMMovieParser 

@synthesize data, connections, moviesToParse, delegate;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 * Private interface definitions
 *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
@interface DMMovieParser(Private) 

- (void)imageDownloaded: (NSNotification *)n;

@end


- (id)initWithData:(NSData *)d {
    
    self = [super init];
    if (self) {
        
        self.data = [[NSData alloc] initWithData:d];
        self.connections = [[NSMutableArray alloc] init];
        self.moviesToParse = [[NSMutableArray alloc] init];
         
    }
    
    return self;
    
}

- (void)parse {
    
    // Create our JSON string from the data
    NSString *responseString = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
    
    
    // Parse the JSON string using SBJason
    NSDictionary *results = [responseString JSONValue];
    
    // Create an array of movies using key "movies"
    NSArray *movies = [results objectForKey:@"movies"];
    numberOfMovies = [movies count];
    
    // Just to check we have the correct number of movies
    NSLog(@"Number of movies = %d", numberOfMovies);
   
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
        
        // Create movie object with info from data object
        DMMovie *movie = [[DMMovie alloc] initWithID:movieID title:movieTitle year:movieYear synopsis:movieSynopsis abridgedCast:abridgedCast suggestedMovieIDs:nil ratings:ratings poster:nil];
        
        // add movie to our array for further parsing (setting image etc)
        [self.moviesToParse addObject:movie];
        NSLog(@"Movie added for parsing");
        
        //NSLog(@"Movie id = %@", [[NSNumber alloc] initWithInt:[[movie movieID] integerValue]]);
        // tag an image downloader with the movieID
        DMMyImageDownloader *d = [[DMMyImageDownloader alloc] initWithRequest:req andTag:[[NSNumber alloc] initWithInt:i]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageDownloaded:) name:@"imageDownloaded" object:d];
        
        [d.connection start];
        [self.connections addObject:d];
        isDownloadingPosters = YES;
        
        

        

    }
        
}

- (void)imageDownloaded:(NSNotification *)n {
   
    NSNotification *notif = n;
    NSLog(@"Number of movies in movies to parse: %d", [moviesToParse count]);
    // if notification name @"connectionFailed"
    if ([notif name] == @"connectionFailed" ) {
        
        NSLog(@"Error");
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
         [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    // else if notification name @"downloadFinished"
    else if ([notif name] == @"imageDownloaded") {

        
        DMMyImageDownloader *d = [n object];
        UIImage *im = [d image];
        
        // extract the correct movie for the corresponding poster 
        DMMovie *m = [self.moviesToParse objectAtIndex:[[d tag] intValue]];
        [m setPoster:im];
        
        numberOfMovies--;
        
        
            
        if(numberOfMovies == 0) {
            [self.connections removeAllObjects];
            [self.delegate parserFinishedParsingWithMovies:moviesToParse];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            [[NSNotificationCenter defaultCenter] removeObserver:self]; 
             isDownloadingPosters = NO;
            
        }
        
}

    
    
}

- (void)cancelDownload {
    
        for(DMMyImageDownloader *d in self.connections){
            [d cancel];
        }

    
    
}

@end                    


