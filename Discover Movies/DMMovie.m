//
//  Movie.m
//  Discover Movies
//
//  Created by Thomas Grant on 08/12/2011.
//  Copyright (c) 2011 Reading University. All rights reserved.
//

#import "DMMovie.h"

@implementation DMMovie 
@synthesize title, year, synopsis, abridgedCast, suggestedMovieIDs, trailerLink, ratings, poster, movieID;

- (id) initWithID: (NSString *)_movieID 
                title: (NSString *)_title 
                year: (NSString *)_year 
            synopsis:(NSString *)_synopsis 
        abridgedCast: (NSArray *)_abridgedCast 
   suggestedMovieIDs: (NSArray *)_suggestedMovieIDs
         trailerLink:(NSString *)_trailerLink 
             ratings:(NSDictionary *)_ratings 
              poster: (UIImage *)_poster
{
    
    self = [super init];
    
    if (self) {
        [self setMovieID: _movieID];
        [self setTitle: _title];
        [self setYear: _year];
        [self setSynopsis: _synopsis];
        [self setAbridgedCast: _abridgedCast];
        [self setSuggestedMovieIDs: _suggestedMovieIDs];
        [self setTrailerLink: _trailerLink];
        [self setRatings: _ratings];
        [self setPoster: _poster];
    }
    
    return self;
    
    
}


- (NSString *)description {
    
    
    return [NSString stringWithFormat:@"Title = %@ , Year = %@ , Synopsis = %@, Cast = %@, Rating = %@", title, year, synopsis, abridgedCast, ratings];
}

@end
