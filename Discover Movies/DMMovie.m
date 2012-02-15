//
//  Movie.m
//  Discover Movies
//
//  Created by Thomas Grant on 08/12/2011.
//  Copyright (c) 2011 Reading University. All rights reserved.
//

#import "DMMovie.h"

@implementation DMMovie 
@synthesize title, year, synopsis, abridgedCast, suggestedMovies, ratings, poster, movieID, youTubeURL;

/*-------------------------------------------------------------
 * 
 *------------------------------------------------------------*/

- (id) initWithID: (NSString *)_movieID 
                title: (NSString *)_title 
                year: (NSString *)_year 
            synopsis:(NSString *)_synopsis 
        abridgedCast: (NSArray *)_abridgedCast 
   suggestedMovieIDs: (NSMutableArray *)_suggestedMovies
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
        self.suggestedMovies = [[NSMutableArray alloc] initWithArray:_suggestedMovies];
        [self setRatings: _ratings];
        [self setPoster: _poster];
    }
    
    return self;
    
    
}

/*-------------------------------------------------------------
 * 
 *------------------------------------------------------------*/

- (NSString *)description {
    
    return [NSString stringWithFormat:@"Title = %@ , Year = %@ , Synopsis = %@, Cast = %@, Rating = %@", title, year, synopsis, abridgedCast, ratings];
}

- (NSString *)topActors {
    
    NSMutableString *actorString = [[NSMutableString alloc] init];
    int numActors;
    
    if ([[self abridgedCast] count] < 5) {
        numActors = [[self abridgedCast] count];
    }
    else {
        numActors = 5;
    }
    
    for (int i = 0; i < numActors ; i++) {
        
        // take away the comma
        if (i == 4) {
            NSDictionary *castMember = [[self abridgedCast] objectAtIndex:i];
            NSString *memberName = [castMember objectForKey:@"name"];
            [actorString appendString:[NSString stringWithFormat:@"%@ ", memberName]];
        }
        else {
            NSDictionary *castMember = [[self abridgedCast] objectAtIndex:i];
            NSString *memberName = [castMember objectForKey:@"name"];
            [actorString appendString:[NSString stringWithFormat:@"%@, ", memberName]];
        }
    }
    return actorString;
}

@end
