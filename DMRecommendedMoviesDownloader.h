//
//  DMRecommendedMoviesDownloader.h
//  Discover Movies
//
//  Created by Thomas Grant on 08/02/2012.
//  Copyright (c) 2012 Reading University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DMMovieParser.h"
#import "DMMovie.h"

@protocol DMRecommendedMoviesDownloaderDelegate
- (void)recommendedMoviesDownloaded:(NSArray *)movies forMovieID:(NSString *)movieID;
@end
@interface DMRecommendedMoviesDownloader : NSObject <DMMovieParserDelegate> {
    
    @private
    NSMutableArray *connections;
    NSMutableArray *recommendedMovies;
    DMMovieParser *parser;
    DMMovie *movie;

}

@property (nonatomic, strong) NSMutableArray *connections;
@property (nonatomic, strong) NSMutableArray *recommendedMovies;
@property (nonatomic, weak) id <DMRecommendedMoviesDownloaderDelegate> delegate;
@property (nonatomic, strong) DMMovieParser *parser;
@property (nonatomic, strong) DMMovie *movie;


-(void)fetchRecommendedMoviesForMovie:(DMMovie *)m;
- (void)cancelDownload;

@end
