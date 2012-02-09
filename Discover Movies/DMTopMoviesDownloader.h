//
//  DMTopMoviesDownloader.h
//  Discover Movies
//
//  Created by Thomas Grant on 08/02/2012.
//  Copyright (c) 2012 Reading University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DMMovieParser.h"

@protocol DMTopMoviesDownloaderDelegate
-(void)topMoviesDownloaded:(NSArray *)movies;
@end

@interface DMTopMoviesDownloader : NSObject <DMMovieParserDelegate> {
    
    @private
    NSMutableArray *connections;
    NSArray *topMovies;
    DMMovieParser *parser;
    
}

@property (nonatomic, strong) NSMutableArray *connections;
@property (nonatomic, strong) NSArray *topMovies;
@property (nonatomic, weak) id <DMTopMoviesDownloaderDelegate> delegate;
@property (nonatomic, strong) DMMovieParser *parser;

// Public Methods
- (void)downloadTopMovies;

@end
