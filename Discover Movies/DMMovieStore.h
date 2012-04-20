//
//  MovieStore.h
//  Discover Movies
//
//  Created by Thomas Grant on 14/12/2011.
//  Copyright (c) 2011 Reading University. All rights reserved.
//
//  Primary Model object - handles networking and storage. Designed to be a Singleton.
//  
//
//

#import <Foundation/Foundation.h>
#import "DMMovie.h"
#import "GData.h"
#import "DMTopMoviesDownloader.h"
#import "DMRecommendedMoviesDownloader.h"
#import "DMDetailedInfoParser.h"
#import "ITunesDownloader.h"
#import "DMRTSearcher.h"
#import "Constants.h"



extern NSString *const kAPIKey;

@interface DMMovieStore : NSObject  <DMTopMoviesDownloaderDelegate, DMRecommendedMoviesDownloaderDelegate, DMRTSearcherDelegate, iTunesSearcherDelegate, DMDetailedInfoParserDelegate>
{
    @public
    NSMutableDictionary *allMovies;
    NSMutableArray *topMovies;
    NSMutableArray *favoriteMovies;
    NSMutableArray *recommendedMovies;
    NSMutableArray *searchResults;
    NSURL *youtubeURL;
    DMMovie *movie;
    ITunesDownloader *itDownloader;
    NSMutableArray *detailedMovies;
    @private
    DMTopMoviesDownloader *topMoviesDownloader;
    DMRecommendedMoviesDownloader *recommendedMoviesDownloader;
    DMRTSearcher *searcher;
    BOOL isDownloadingRecommendedMovies;
    NSMutableArray *cosineSimilarityResults;
    NSString *masterCosineMovie;

    
}

@property (nonatomic, strong) NSMutableDictionary *allMovies;
@property (nonatomic, strong) NSMutableArray *topMovies;
@property (nonatomic, strong) NSMutableArray *favoriteMovies;
@property (nonatomic, strong) NSMutableArray *recommendedMovies;
@property (nonatomic, strong) NSURL *youtubeURL;
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic, strong) DMTopMoviesDownloader *topMoviesDownloader;
@property (nonatomic, strong) DMRecommendedMoviesDownloader *recommendedMoviesDownloader;
@property (nonatomic, strong) DMRTSearcher *searcher;
@property (nonatomic, strong) DMMovie *movie;
@property (nonatomic, strong) ITunesDownloader *itDownloader;
@property (nonatomic, strong) NSString *iTunesURL;
@property (nonatomic, strong) NSMutableArray *detailedMovies;
@property (nonatomic, strong) NSMutableArray *cosineSimilarityResults;
@property (nonatomic, strong) NSString *masterCosineMovie;

+ (DMMovieStore *)defaultStore;
- (void)searchYouTubeForTrailer:(NSString *)title;
- (void)downloadRecommendedMoviesForMovie:(DMMovie *)_movie;
- (void)cancelDownload;
- (void)searchMovieDatabaseForMovieTitle:(NSString *)movieTitle;
- (void)addFavoriteMovie:(DMMovie *)favMovie;
- (void)searchiTunesForMovie:(NSString *)movieTitle;
- (void)grabDetailedInfoForMovie:(DMMovie *)_movie;
- (void)calculateCosineSimilarity;


@end
