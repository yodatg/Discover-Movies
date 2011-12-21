//
//  MovieStore.m
//  Discover Movies
//
//  Created by Thomas Grant on 14/12/2011.
//  Copyright (c) 2011 Reading University. All rights reserved.
//

#import "MovieStore.h"


static MovieStore *defaultStore = nil;

@implementation MovieStore

+ (MovieStore *)defaultStore
{
    
    if (defaultStore == nil) {
        // Create the singleton
        defaultStore = [[super allocWithZone:NULL] init];
    }
    return defaultStore;
}

// Prevent creation of addition instances
+ (id)allocWithZone:(NSZone *)zone
{
    return [self defaultStore];
}

- (id)init
{
    
    // If we already have an instance of MovieStore...
    if (defaultStore) {
        // return the old one
        return defaultStore;
    }
    
    self = [super init];
    if (self) {
        
        allMovies = [[NSMutableDictionary alloc] init];
        topMovies = [[NSMutableArray alloc] init];
        favoriteMovies = [[NSMutableArray alloc] init];
        
        // Set the 2 arrays to hold our movie objects into the dictionary
        // Top Movies will be accessed with key "topMovies"
        // Favorite Movies will be accessed with key "favMovies"
        [allMovies setObject:topMovies forKey:@"topMovies"];
        [allMovies setObject:favoriteMovies forKey:@"favMovies"];
    }
    return self;
}

- (NSArray *)topMovies {
    
    return [allMovies objectForKey:@"topMovies"];
    
}
- (NSArray *)favoriteMovies {
    
    return [allMovies objectForKey:@"favMovies"];
    
}

- (void)addTopMovie: (Movie *)movie {
    
    // add movie to Top Movie Array
    [[allMovies objectForKey:@"topMovies"] addObject:movie];
}

- (void)addFavoriteMovie: (Movie *)movie {
    
    // add movie to Favorite Movie Array
    [[allMovies objectForKey:@"favMovies"] addObject:movie];
    
}

@end
