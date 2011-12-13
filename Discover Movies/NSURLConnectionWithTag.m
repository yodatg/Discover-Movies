//
//  NSURLConnectionWithTag.m
//  Discover Movies
//
//  Created by Thomas Grant on 13/12/2011.
//  Copyright (c) 2011 Reading University. All rights reserved.
//

#import "NSURLConnectionWithTag.h"

@implementation NSURLConnectionWithTag

@synthesize tag;

- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate startImmediately:(BOOL)startImmediately tag:(NSNumber *)_tag {
    
    
    self = [super initWithRequest:request delegate:delegate startImmediately:startImmediately];
    
    if (self) {
        self.tag = _tag;
    }
    
    return self;
    
}

@end
