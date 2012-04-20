//
//  MovieStore.m
//  Discover Movies
//
//  Created by Thomas Grant on 14/12/2011.
//  Copyright (c) 2011 Reading University. All rights reserved.
//

#import "DMMovieStore.h"
#import "DMDetailedInfoParser.h"
#import "DMRTSearcher.h"
#import "DMMyDownloader.h"
#import "Constants.h"




static DMMovieStore *defaultStore = nil;

@implementation DMMovieStore

@synthesize topMovies, favoriteMovies, allMovies, recommendedMovies, youtubeURL, topMoviesDownloader, recommendedMoviesDownloader, searcher, searchResults, movie, itDownloader, iTunesURL, detailedMovies, cosineSimilarityResults, masterCosineMovie;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 * Private interface definitions
 *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
@interface DMMovieStore(Private) 
- (void)downloadTopMovies;
- (void)entryListFetchTicket:(GDataServiceTicket *)ticket finishedWithFeed:(GDataFeedBase *)feed error:(NSError *)error;
- (GDataServiceGoogleYouTube *)youTubeService;
- (void)detailedInfoDownloaded:(NSNotification *)n;

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
- (void)downloadRecommendedMoviesForMovie:(DMMovie *)_movie {
    
    self.recommendedMoviesDownloader = [[DMRecommendedMoviesDownloader alloc] init];
    self.recommendedMoviesDownloader.delegate = self;
    [self.recommendedMoviesDownloader fetchRecommendedMoviesForMovie:_movie];
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

    searcher = [[DMRTSearcher alloc] init];
    searcher.delegate = self;
    [searcher searchForMovieTitle:movieTitle];
    
    
    
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

-(void)DMRTSearcherFinishedSearchingAndReturnedMovies:(NSArray *)movies {
    
    searchResults = [[NSMutableArray alloc] initWithArray:movies];
    NSLog(@"Search Results returned");
    NSLog(@"search results count = %d", [searchResults count]);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"searchFinished" object:self];
    
    
    
}

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
-(void)searcherFinishedFindingYoutubeURL:(NSString *)_youtubeURL andActors:(NSArray *)_actors {
    
    [self.movie setYouTubeURL:_youtubeURL];
    [self.movie setAbridgedCast:_actors];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"youtubeURLFound" object:self];
    
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

- (void)addFavoriteMovie:(DMMovie *)favMovie {
    // calculate cosine similarity here
    
    
    
    [self.favoriteMovies addObject:favMovie];


}

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/

- (void)calculateCosineSimilarity {



NSArray *movieVectorToCompareTo = [[detailedMovies objectAtIndex:0] cosineVector];
cosineSimilarityResults = [[NSMutableArray alloc] init];

for(int i = 1; i < [[self detailedMovies] count]; i++){
    
    NSArray *movieVectorToCompare = [[detailedMovies objectAtIndex:i] cosineVector];
    int dotPorduct = [self calculateDotProductOf:movieVectorToCompareTo and:movieVectorToCompare];
    float magnitudeA = [self calculateMagnitudeOf:movieVectorToCompareTo];
    float magnitudeB = [self calculateMagnitudeOf:movieVectorToCompare];
    float cosineSim = [self calculateCosineSimilarityUsingDotProduct:dotPorduct andMagnitudeA:magnitudeA andMagnitudeB:magnitudeB];
    NSLog(@"COSINE SIM = %f of %@ to %@", cosineSim, [[[self detailedMovies] objectAtIndex:i] title], [[detailedMovies objectAtIndex:0] title]);
    
    NSNumber *cosineSimObj = [NSNumber numberWithFloat:cosineSim];
    NSString *favMovieComparedTo = [NSString stringWithFormat:[[[self detailedMovies] objectAtIndex:i] title]];
    NSString *masterMovie = [NSString stringWithFormat:[[detailedMovies objectAtIndex:0] title]];
    
    NSArray *arr = [NSArray arrayWithObjects:cosineSimObj, favMovieComparedTo, masterMovie, nil];
    [cosineSimilarityResults addObject:arr];
    
    
}
[[self detailedMovies] removeAllObjects];
[[NSNotificationCenter defaultCenter] postNotificationName:@"cosineResultsComplete" object:self];
}
/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
-(int)calculateDotProductOf:(NSArray *)movieToCompareTo and:(NSArray *)movieToCompare{

int sum = 0;
int i;

for (i = 0; i < [movieToCompare count]; i++){
    NSNumber *a = [movieToCompareTo objectAtIndex:i];
    NSNumber *b = [movieToCompare objectAtIndex:i];
    
    int aInt = [a intValue];
    int bInt = [b intValue];
    
    sum += aInt * bInt;
}
NSLog(@"Sum = %d", sum);
return sum;
}
/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
- (float)calculateMagnitudeOf:(NSArray *)vector{

int sum = 0;

for (int i = 0; i < [vector count]; i++) {
    NSNumber *a = [vector objectAtIndex:i];
    
    int aInt = [a intValue];
    
    int sqValue = aInt * aInt;
    sum += sqValue;
    
    
}
NSLog(@"magnitude = %f", sqrt(sum));
return sqrt(sum);
}

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
- (float)calculateCosineSimilarityUsingDotProduct:(int)dotProduct andMagnitudeA:(float)magnitudeA andMagnitudeB:(float)magnitudeB {

float totalMag = (magnitudeA) * (magnitudeB);
float cosineSim = dotProduct / totalMag;

NSLog(@"Cosine sim = %f", cosineSim);
return cosineSim;
}



/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
- (void)searchYouTubeForTrailer:(NSString *)title {


/*if([self.searchResults count] != 0){
    
    for(DMMovie *m in searchResults) {
        NSLog(@"movie title = %@", [movie title]);
        if([[m title] isEqualToString:title]) {
            
            if ([[m youTubeURL] respondsToSelector:@selector(length)]){
                NSLog(@"movie trailer url = %@", [m youTubeURL]);
                self.youtubeURL = [NSURL URLWithString:[m youTubeURL]];
                [[NSNotificationCenter defaultCenter] 
                 postNotificationName:@"youtubeURLCreated" object:self];
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"No trailer can be found for this item" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
            
        }
    }
    
}*/

//else {
    NSLog(@"Grabbing");
    GDataServiceGoogleYouTube *service = [self youTubeService];
    GDataServiceTicket *ticket;
    
    NSString *feedName = [NSString stringWithFormat:@"http://gdata.youtube.com/feeds/api/videos/-/"];
    NSString *searchTerm = title;
    NSString *fixedSearchTerm = [searchTerm lowercaseString];
    fixedSearchTerm = [fixedSearchTerm stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    fixedSearchTerm = [fixedSearchTerm stringByReplacingOccurrencesOfString:@"(" withString:@""];
    fixedSearchTerm = [fixedSearchTerm stringByReplacingOccurrencesOfString:@")" withString:@""];
    fixedSearchTerm = [fixedSearchTerm stringByAppendingFormat:@"-official-movie-trailer-hd?max-results=1"];
    
    feedName = [feedName stringByAppendingFormat:fixedSearchTerm];
    
    
    NSLog(@"Feed name: %@", feedName);
    GDataQueryYouTube *query = [GDataQueryYouTube youTubeQueryWithFeedURL:[NSURL URLWithString:feedName]];
    
    ticket = [service fetchFeedWithQuery:query delegate:self didFinishSelector:@selector(entryListFetchTicket:finishedWithFeed:error:)];

//}
   
    
}

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/

- (void)searchiTunesForMovie:(NSString *)movieTitle {

NSString *movieTitleEncoded = [movieTitle stringByReplacingOccurrencesOfString:@" " withString:@"+"];
NSString *fullURL = [NSString stringWithFormat:@"http://itunes.apple.com/search?term=%@&country=gb&media=movie&attribute=movieTerm&limit=1", movieTitleEncoded];    



NSURL *url = [NSURL URLWithString:fullURL];

itDownloader = [[ITunesDownloader alloc] init];
itDownloader.delegate = self;
[itDownloader searchiTunesWithURL:url];

}
/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/

-(void)iTunesSearcherFinishedSearchingAndReturnedLink:(NSString *)url {

self.iTunesURL = url;

[[NSNotificationCenter defaultCenter] postNotificationName:@"iTunesURLFound" object:self];
    
}

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/

- (void)grabDetailedInfoForMovie:(DMMovie *)_movie{


NSString *movieID = [_movie movieID];

NSString *urlString = [NSString stringWithFormat:@"http://api.rottentomatoes.com/api/public/v1.0/movies/%@.json?apikey=%@", movieID, kRTAPIKey];
NSLog(@"urlString = %@", urlString);

NSURL *url = [NSURL URLWithString:urlString];
NSURLRequest *req = [NSURLRequest requestWithURL:url];

DMMyDownloader *d = [[DMMyDownloader alloc] initWithRequest:req];

[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detailedInfoDownloaded:) name:@"downloadFinished" object:d];


// start the download
NSLog(@"starting download");
[d.connection start];
    
}
/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/

- (void)detailedInfoDownloaded:(NSNotification *)n {

NSData *data = nil;
NSNotification *notif = n;

// if notification name @"connectionFailed"
if ([notif name] == @"connectionFailed" ) {
    
    NSLog(@"Error");
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
// else if notification name @"downloadFinished"
else if ([notif name] == @"downloadFinished") {
    
    DMMyDownloader *d = [n object];
    data = [d receivedData];
    NSLog(@"Data downloaded");
    DMDetailedInfoParser *parser = [[DMDetailedInfoParser alloc] initWithData:data];
    parser.delegate = self;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    [parser parse];
    
}

}
/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/

- (void)parserFinishedParsingWithMovies:(NSMutableArray *)parsedMovies {

NSLog(@"Parser finished");
    
if(detailedMovies != nil){
    
    [detailedMovies addObjectsFromArray:parsedMovies];
    [self keepCount];
}
else {
    detailedMovies = [[NSMutableArray alloc] initWithArray:parsedMovies];
    [self keepCount];

}
    
}

- (void)keepCount {
NSLog(@"master movie is: %@", masterCosineMovie);

if([detailedMovies count] == ([favoriteMovies count] + 1)){
       

    for(int i = 0; i < [detailedMovies count]; i++){
        
        NSLog(@"object is kind of class: %@", [[detailedMovies objectAtIndex:i] description]);
        if ([[[detailedMovies objectAtIndex:i] title] isEqualToString:masterCosineMovie]){
            
            DMMovie *mov = [detailedMovies objectAtIndex:i];
            [detailedMovies removeObjectAtIndex:i];
            [detailedMovies insertObject:mov atIndex:0];
        }
        
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"detailedInfoDownloaded" object:self];
}

else {
    return;
}
}

@end
