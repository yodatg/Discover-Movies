//
//  MovieStore.h
//  Discover Movies
//
//  Created by Thomas Grant on 14/12/2011.
//  Copyright (c) 2011 Reading University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DMMovie.h"
#import "GData.h"
#import "DMTopMoviesDownloader.h"
#import "DMRecommendedMoviesDownloader.h"
#import "DMTMDBSearcher.h"

extern NSString *const kAPIKey;

@interface DMMovieStore : NSObject  <DMTopMoviesDownloaderDelegate, DMRecommendedMoviesDownloaderDelegate, DMTMDBSearcherDelegate>
{
    @public
    NSMutableDictionary *allMovies;
    NSMutableArray *topMovies;
    NSMutableArray *favoriteMovies;
    NSMutableArray *recommendedMovies;
    NSMutableArray *searchResults;
    NSURL *youtubeURL;
    
    @private
    DMTopMoviesDownloader *topMoviesDownloader;
    DMRecommendedMoviesDownloader *recommendedMoviesDownloader;
    DMTMDBSearcher *searcher;
    BOOL isDownloadingRecommendedMovies;
}

@property (nonatomic, strong) NSMutableDictionary *allMovies;
@property (nonatomic, strong) NSMutableArray *topMovies;
@property (nonatomic, strong) NSMutableArray *favoriteMovies;
@property (nonatomic, strong) NSMutableArray *recommendedMovies;
@property (nonatomic, strong) NSURL *youtubeURL;
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic, strong) DMTopMoviesDownloader *topMoviesDownloader;
@property (nonatomic, strong) DMRecommendedMoviesDownloader *recommendedMoviesDownloader;
@property (nonatomic, strong) DMTMDBSearcher *searcher;


+ (DMMovieStore *)defaultStore;
- (void)searchYouTubeForTrailer:(NSString *)title;
- (void)downloadRecommendedMoviesForMovie:(DMMovie *)movie;
- (void)cancelDownload;
- (void)searchMovieDatabaseForMovieTitle:(NSString *)movieTitle;


@end
