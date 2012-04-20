//
//  ITunesDownloader.m
//  Discover Movies
//
//  Created by Thomas Grant on 06/03/2012.
//  Copyright (c) 2012 Reading University. All rights reserved.
//

#import "ITunesDownloader.h"
#import "DMMyDownloader.h"
#import "SBJSON.h"

@implementation ITunesDownloader
@synthesize connections, iTunesURL, delegate;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 * Private interface definitions
 *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
@interface ITunesDownloader(Private) 

-(void)downloadComplete:(NSNotification *)notification;
-(void)parseMovieFeedWithData:(NSData *)data;

@end

- (id)init {
    
    self = [super init];
    
    if(self){
        
        self.connections = [[NSMutableArray alloc] init];
        
    }
    
    return self;
}

- (void)searchiTunesWithURL:(NSURL *)url {
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
    
    DMMyDownloader *downloader = [[DMMyDownloader alloc] initWithRequest:request];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadComplete:) name:@"downloadFinished" object:downloader];
    
    
    // start the download
    NSLog(@"starting download");
    [downloader.connection start];
    

    
}

-(void)downloadComplete:(NSNotification *)notification {

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

-(void)parseMovieFeedWithData:(NSData *)data {

// Create our JSON string from the data
NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

// Parse the JSON string using SBJason
NSDictionary *results = [responseString JSONValue];
// Create an array of movies using key "movies"
NSArray *searchResults = [results objectForKey:@"results"];
int noOfResults = [searchResults count];
NSLog(@"no of results = %d", noOfResults);


if(noOfResults == 0){
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Sorry - we couldn't find your movie on iTunes" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    return;
}

else {
    // Extract a movie from our movies array
    NSDictionary *aMovie = [searchResults objectAtIndex:0];
    self.iTunesURL = [aMovie objectForKey:@"trackViewUrl"];
    [self.delegate iTunesSearcherFinishedSearchingAndReturnedLink:self.iTunesURL];
}


    
}
@end
