//
//  NSURLConnectionWithTag.h
//  Discover Movies
//
//  This class adds the "tag" property to the NSURLConnection class in order
//  to keep track of the connections in the TopMoviesViewController
//
//  Created by Thomas Grant on 13/12/2011.
//  Copyright (c) 2011 Reading University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLConnectionWithTag : NSURLConnection {
    
    
    NSNumber *tag;
    
}
@property (nonatomic, retain) NSNumber *tag;

- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate startImmediately:(BOOL)startImmediately tag:(NSNumber *)_tag;

@end
