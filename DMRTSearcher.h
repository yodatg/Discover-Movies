//
//  DMRTSearcher.h
//  Discover Movies
//
//  Created by Thomas Grant on 26/02/2012.
//  Copyright (c) 2012 Reading University. All rights reserved.
//
//  Searches for a movie from Rotten Tomatoes using a string passed into the object
//  
//
//

#import <Foundation/Foundation.h>
#import "DMMovie.h"
#import "DMMovieParser.h"

@protocol DMRTSearcherDelegate
-(void)DMRTSearcherFinishedSearchingAndReturnedMovies:(NSArray *)movies;
@end

@interface DMRTSearcher : NSObject <DMMovieParserDelegate> {
    
    NSMutableArray *connections;
    NSMutableArray *returnedMovies;
    NSMutableArray *moviesToParse;
    
    NSData *data;
    
    DMMovieParser *parser;
    
    
}

@property (nonatomic, strong) NSMutableArray *connections;
@property (nonatomic, strong) NSMutableArray *returnedMovies;
@property (nonatomic, strong) NSMutableArray *moviesToParse;
@property (nonatomic, strong) NSData *data;
@property (nonatomic, strong) DMMovieParser *parser;
@property (nonatomic, weak) id <DMRTSearcherDelegate> delegate;


-(void)searchForMovieTitle:(NSString *)title;

@end
