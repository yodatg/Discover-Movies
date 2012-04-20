//
//  DMTMDBSearcher.h
//  Discover Movies
//
//  Created by Thomas Grant on 13/02/2012.
//  Copyright (c) 2012 Reading University. All rights reserved.
//
//  Manages interaction between Model and DMTopMoviePosterView
//  
//
//

#import <Foundation/Foundation.h>
#import "DMMovie.h"
#import "DMRTSearcher.h"

@protocol DMTMDBSearcherDelegate
- (void)searcherFinishedSearchingWithMovies:(NSMutableArray *)parsedMovies;
- (void)searcherFinishedFindingYoutubeURL:(NSString *)youtubeURL andActors:(NSArray *)actors;
@end

@interface DMTMDBSearcher : NSObject <DMRTSearcherDelegate> {
    
    NSMutableArray *connections;
    NSMutableArray *returnedMovies;
    NSMutableArray *moviesToParse;
    DMRTSearcher *rtSearcher;
    NSString *trailer;
    NSArray *cast;
    
    int numberOfImages;
    int numberOfMovies;

    
}
@property (nonatomic, strong) NSMutableArray *connections;
@property (nonatomic, strong) NSMutableArray *returnedMovies;
@property (nonatomic, strong) NSMutableArray *moviesToParse;
@property (nonatomic, strong) DMRTSearcher *rtSearcher;
@property (nonatomic, strong) NSString *trailer;
@property (nonatomic, strong) NSArray *cast;
@property (nonatomic, weak) id <DMTMDBSearcherDelegate> delegate;


-(void)searchForMovie:(NSString *)movieTitle;
-(void)getDetailedMovieInfoForMovie:(DMMovie *)movie;

@end
