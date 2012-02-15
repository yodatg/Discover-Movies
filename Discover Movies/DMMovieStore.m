//
//  MovieStore.m
//  Discover Movies
//
//  Created by Thomas Grant on 14/12/2011.
//  Copyright (c) 2011 Reading University. All rights reserved.
//

#import "DMMovieStore.h"
#import "DMMovieParser.h"




static DMMovieStore *defaultStore = nil;

@implementation DMMovieStore

@synthesize topMovies, favoriteMovies, allMovies, recommendedMovies, youtubeURL, topMoviesDownloader, recommendedMoviesDownloader, searcher, searchResults;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 * Private interface definitions
 *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
@interface DMMovieStore(Private) 
- (void)downloadTopMovies;
- (void)entryListFetchTicket:(GDataServiceTicket *)ticket finishedWithFeed:(GDataFeedBase *)feed error:(NSError *)error;
- (GDataServiceGoogleYouTube *)youTubeService;

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
- (void)downloadTopMovies {
    
    self.topMoviesDownloader = [[DMTopMoviesDownloader alloc] init];
    self.topMoviesDownloader.delegate = self;
    [self.topMoviesDownloader downloadTopMovies];
    
}

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
- (void)downloadRecommendedMoviesForMovie:(DMMovie *)movie {
    
    self.recommendedMoviesDownloader = [[DMRecommendedMoviesDownloader alloc] init];
    self.recommendedMoviesDownloader.delegate = self;
    [self.recommendedMoviesDownloader fetchRecommendedMoviesForMovie:movie];
    isDownloadingRecommendedMovies = YES;
    
    
}
#pragma mark - Delegate Methods

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/

-(void)topMoviesDownloaded:(NSArray *)movies {
    
    self.topMovies = [movies copy];
   // NSLog(@"Number of top movies before posting notif = %d", [topMovies count]);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"topMoviesDownloaded" object:self];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/

- (void)cancelDownload {
    
    if(isDownloadingRecommendedMovies == YES){
        [self.recommendedMoviesDownloader cancelDownload];
    }
}
/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
- (void)recommendedMoviesDownloaded:(NSMutableArray *)movies forMovieID:(NSString *)movieID {
    if([self.recommendedMovies count] != 0){
        [self.recommendedMovies removeAllObjects];
    }
    [self.recommendedMovies addObjectsFromArray:movies];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"recommendedMoviesDownloaded" object:self];

    isDownloadingRecommendedMovies = NO;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
- (void)searchMovieDatabaseForMovieTitle:(NSString *)movieTitle {
    
    searcher = [[DMTMDBSearcher alloc] init];
    searcher.delegate = self;
    [searcher searchForMovie:movieTitle];
    
    
}
/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
- (GDataServiceGoogleYouTube *)youTubeService{
    
    static GDataServiceGoogleYouTube *service = nil;
    
    if (!service) {
        service = [[GDataServiceGoogleYouTube alloc] init];
        [service setUserAgent:@"Discover"];
        [service setShouldCacheResponseData:YES];
        
        [service setUserCredentialsWithUsername:nil password:nil];
    }
    
    return service;
}
/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
- (void)entryListFetchTicket:(GDataServiceTicket *)ticket finishedWithFeed:(GDataFeedBase *)feed error:(NSError *)error {
    NSLog(@"In entryList");
    GDataFeedYouTubeVideo *vfeed = (GDataFeedYouTubeVideo *)feed;
    
    if ([[vfeed entries] count] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Video Available" message:@"Sorry, there is no video available for this movie - check your network settings and try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    for (int i = 0; i < [[vfeed entries] count]; i++) {
        GDataEntryBase *entry = [[vfeed entries] objectAtIndex:i];
        GDataLink *videoLink = [entry HTMLLink];
        
        // grab the returned URL
        NSURL *urlToPlay = [videoLink URL];
        
        // create a string of the URL so we can extract the video UID
        NSString *stringToManip = [urlToPlay absoluteString];
        // extract the UID
        NSArray *arr = [stringToManip componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"=&"]];
        // create our new URL
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.youtube.com/v/%@&f=gdata_videos&c=ytapi-my-clientID&d=DiscoverMovies", [arr objectAtIndex:1]]];
        
        youtubeURL = url;
        NSLog(@"url = %@", urlToPlay);
        [[NSNotificationCenter defaultCenter] 
         postNotificationName:@"youtubeURLCreated" object:self];
        
    }
    
}

- (void)searcherFinishedSearchingWithMovies:(NSMutableArray *)parsedMovies {
    
    searchResults = [[NSMutableArray alloc] initWithArray:parsedMovies];
    NSLog(@"Search Results returned");
    NSLog(@"search results = %@", searchResults);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"searchFinished" object:self];
    
    
    
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
/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
// Prevent creation of additional instances
+ (id)allocWithZone:(NSZone *)zone
{
    return [self defaultStore];
}
/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
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
        recommendedMovies = [[NSMutableArray alloc] init];
        // Set the 2 arrays to hold our movie objects into the dictionary
        // Top Movies will be accessed with key "topMovies"
        // Favorite Movies will be accessed with key "favMovies"
        [allMovies setObject:topMovies forKey:@"topMovies"];
        [allMovies setObject:favoriteMovies forKey:@"favMovies"];
        
        [self downloadTopMovies];
    }
    return self;
}
/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
- (void)searchYouTubeForTrailer:(NSString *)title {
    
    NSLog(@"Grabbing");
    GDataServiceGoogleYouTube *service = [self youTubeService];
    GDataServiceTicket *ticket;
    
    NSString *feedName = [NSString stringWithFormat:@"http://gdata.youtube.com/feeds/api/videos/-/"];
    NSString *searchTerm = title;
    NSString *fixedSearchTerm = [searchTerm lowercaseString];
    fixedSearchTerm = [fixedSearchTerm stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    fixedSearchTerm = [fixedSearchTerm stringByReplacingOccurrencesOfString:@"(" withString:@""];
    fixedSearchTerm = [fixedSearchTerm stringByReplacingOccurrencesOfString:@")" withString:@""];
    fixedSearchTerm = [fixedSearchTerm stringByAppendingFormat:@"-movie-trailer?max-results=1"];
    
    feedName = [feedName stringByAppendingFormat:fixedSearchTerm];
    
    
    NSLog(@"Feed name: %@", feedName);
    GDataQueryYouTube *query = [GDataQueryYouTube youTubeQueryWithFeedURL:[NSURL URLWithString:feedName]];
    
    ticket = [service fetchFeedWithQuery:query delegate:self didFinishSelector:@selector(entryListFetchTicket:finishedWithFeed:error:)];

    
}

@end
