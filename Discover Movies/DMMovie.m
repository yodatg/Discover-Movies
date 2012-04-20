//
//  Movie.m
//  Discover Movies
//
//  Created by Thomas Grant on 08/12/2011.
//  Copyright (c) 2011 Reading University. All rights reserved.
//

#import "DMMovie.h"

@implementation DMMovie 
@synthesize title, year, synopsis, abridgedCast, suggestedMovies, ratings, poster, movieID, youTubeURL, allPosterURLs, movieMidsizeImageURL, profileImageURL, alternativeURL, genre, cosineVector, movieStudio, leadActorA, leadActorB;

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
        allPosterURLs = [[NSArray alloc] init];
        movieMidsizeImageURL = [[NSString alloc] init];
        
        NSNumber *zero = [NSNumber numberWithInt:0];
        
        cosineVector = [[NSMutableArray alloc] initWithObjects:zero, zero, zero, zero, zero, zero, zero, zero, zero, nil];
    }
    
    return self;
    
    
}

/*-------------------------------------------------------------
 * 
 *------------------------------------------------------------*/

- (NSString *)description {
    
    return [NSString stringWithFormat:@"Title = %@ , Year = %@ , Synopsis = %@, Cast = %@, Rating = %@, Genres = %@", title, year, synopsis, abridgedCast, ratings, genre];
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

- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:movieID forKey:@"movieID"];
    [coder encodeObject:title forKey:@"title"];
    [coder encodeObject:year forKey:@"year"];
    [coder encodeObject:synopsis forKey:@"synopsis"];
    [coder encodeObject:abridgedCast forKey:@"abridgedCast"];
    [coder encodeObject:suggestedMovies forKey:@"suggestedMovies"];
    [coder encodeObject:ratings forKey:@"ratings"];
    [coder encodeObject:poster forKey:@"poster"];
}

- (id)initWithCoder:(NSCoder *)coder;
{
    self = [[DMMovie alloc] init];
    if (self != nil)
    {
        movieID = [coder decodeObjectForKey:@"movieID"];
         title = [coder decodeObjectForKey:@"title"];
         year = [coder decodeObjectForKey:@"year"];
         synopsis = [coder decodeObjectForKey:@"synopsis"];
         abridgedCast = [coder decodeObjectForKey:@"abridgedCast"];
         suggestedMovies = [coder decodeObjectForKey:@"suggestedMovies"];
         ratings = [coder decodeObjectForKey:@"ratings"];
         poster = [coder decodeObjectForKey:@"poster"];
        
        
    }   
    return self;
}
@end
