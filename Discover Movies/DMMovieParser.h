//
//  DMMovieParser.h
//  Discover Movies
//
//  Created by Thomas Grant on 08/02/2012.
//  Copyright (c) 2012 Reading University. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DMMovieParserDelegate
- (void)parserFinishedParsingWithMovies:(NSMutableArray *)parsedMovies;
@end

@interface DMMovieParser : NSObject {
    
    @private
    NSData *data;
    NSMutableArray *connections;
    NSMutableArray *moviesToParse;
    int numberOfMovies;
    BOOL isDownloadingPosters;
}

@property (nonatomic, strong) NSData *data;
@property (nonatomic, strong) NSMutableArray *connections;
@property (nonatomic, strong) NSMutableArray *moviesToParse;
@property (nonatomic, weak) id <DMMovieParserDelegate> delegate;
- (void)parse;
- (id)initWithData:(NSData *)d;
- (void)cancelDownload;

@end
