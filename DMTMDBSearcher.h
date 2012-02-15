//
//  DMTMDBSearcher.h
//  Discover Movies
//
//  Created by Thomas Grant on 13/02/2012.
//  Copyright (c) 2012 Reading University. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DMTMDBSearcherDelegate
- (void)searcherFinishedSearchingWithMovies:(NSMutableArray *)parsedMovies;
@end

@interface DMTMDBSearcher : NSObject {
    
    NSMutableArray *connections;
    NSMutableArray *returnedMovies;
    NSMutableArray *moviesToParse;
    
    int numberOfImages;
    int numberOfMovies;

    
}
@property (nonatomic, strong) NSMutableArray *connections;
@property (nonatomic, strong) NSMutableArray *returnedMovies;
@property (nonatomic, strong) NSMutableArray *moviesToParse;
@property (nonatomic, weak) id <DMTMDBSearcherDelegate> delegate;


-(void)searchForMovie:(NSString *)movieTitle;

@end
