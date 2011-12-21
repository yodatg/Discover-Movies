//
//  MovieStore.h
//  Discover Movies
//
//  Created by Thomas Grant on 14/12/2011.
//  Copyright (c) 2011 Reading University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Movie.h"

@interface MovieStore : NSObject
{
    NSMutableDictionary *allMovies;
    NSMutableArray *topMovies;
    NSMutableArray *favoriteMovies;
}

+ (MovieStore *)defaultStore;

- (NSArray *)topMovies;
- (NSArray *)favoriteMovies;

- (void)addTopMovie: (Movie *)movie;
- (void)addFavoriteMovie: (Movie *)movie;

@end
