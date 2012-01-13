//
//  MovieStore.h
//  Discover Movies
//
//  Created by Thomas Grant on 14/12/2011.
//  Copyright (c) 2011 Reading University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DMMovie.h"

@interface DMMovieStore : NSObject
{
    NSMutableDictionary *allMovies;
    NSMutableArray *topMovies;
    NSMutableArray *favoriteMovies;
    NSMutableArray *downloaders;
    NSMutableArray *moviePosters;
}

@property (nonatomic, strong) NSMutableDictionary *allMovies;
@property (nonatomic, strong) NSMutableArray *topMovies;
@property (nonatomic, strong) NSMutableArray *favoriteMovies;
@property (nonatomic, strong) NSMutableArray *connections;
@property (nonatomic, strong) NSMutableArray *moviePosters;

+ (DMMovieStore *)defaultStore;



@end
