//
//  Movie.h
//  Discover Movies
//
//  Created by Thomas Grant on 08/12/2011.
//  Copyright (c) 2011 Reading University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movie : NSObject {
    
    NSString *title;
    NSString *year;
    NSString *synopsis;
    NSArray *abridgedCast;
    NSArray *suggestedMovieIDs;
    NSString *trailerLink;
    NSDictionary *ratings;
    NSDictionary *poster;
    
}

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *year;
@property (nonatomic, strong) NSString *synopsis;
@property (nonatomic, strong) NSArray *abridgedCast;
@property (nonatomic, strong) NSArray *suggestedMovieIDs;
@property (nonatomic, strong) NSString *trailerLink;
@property (nonatomic, strong) NSDictionary *ratings;
@property (nonatomic, strong) NSDictionary *poster;

- (id) initWithTitle: (NSString *)_title year: (NSString *)_year synopsis:(NSString *)_synopsis abridgedCast: (NSArray *)_abridgedCast suggestedMovieIDs: (NSArray *)_suggestedMovieIDs trailerLink:(NSString *)_trailerLink ratings:(NSDictionary *)_ratings poster: (NSDictionary *)_poster;

@end
