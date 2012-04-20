//
//  Movie.h
//  Discover Movies
//
//  Created by Thomas Grant on 08/12/2011.
//  Copyright (c) 2011 Reading University. All rights reserved.
//
//  Custom object used to store movie data
//  
//
//

#import <Foundation/Foundation.h>

@interface DMMovie : NSObject {
    
    NSString *movieID;
    NSString *title;
    NSString *year;
    NSString *synopsis;
    NSArray *abridgedCast;
    NSMutableArray *suggestedMovies;
    NSDictionary *ratings;
    UIImage *poster;
    NSArray *genre;
    NSMutableArray *cosineVector;
    NSString *movieStudio;
    NSString *leadActorA;
    NSString *leadActorB;
    
}
@property (nonatomic, strong) NSString *movieID;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *year;
@property (nonatomic, strong) NSString *synopsis;
@property (nonatomic, strong) NSArray *abridgedCast;
@property (nonatomic, strong) NSMutableArray *suggestedMovies;
@property (nonatomic, strong) NSDictionary *ratings;
@property (nonatomic, strong) UIImage *poster;
@property (nonatomic, strong) NSArray *allPosterURLs;
@property (nonatomic, strong) NSString *movieMidsizeImageURL;
@property (nonatomic, strong) NSString *youTubeURL;
@property (nonatomic, strong) NSString *alternativeURL;
@property (nonatomic, strong) NSString *profileImageURL;
@property (nonatomic, strong) NSArray *genre;
@property (nonatomic, strong) NSMutableArray *cosineVector;
@property (nonatomic, strong) NSString *movieStudio;
@property (nonatomic, strong) NSString *leadActorA;
@property (nonatomic, strong) NSString *leadActorB;

- (id) initWithID: (NSString *)_movieID 
            title: (NSString *)_title 
             year: (NSString *)_year 
         synopsis:(NSString *)_synopsis 
     abridgedCast: (NSArray *)_abridgedCast 
suggestedMovieIDs: (NSMutableArray *)_suggestedMovies
          ratings:(NSDictionary *)_ratings 
           poster: (UIImage *)_poster;

- (NSString *)topActors;
@end
