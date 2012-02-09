//
//  MyDownloader.m
//  Discover Movies
//
//  Created by Thomas Grant on 30/12/2011.
//  Copyright (c) 2011 Reading University. All rights reserved.
//

#import "DMMyDownloader.h"

@implementation DMMyDownloader
@synthesize connection, request, receivedData, tag;

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/

-(id) initWithRequest:(NSURLRequest *)_request {
        
    self = [self initWithRequest:_request andTag:nil];
    return self; 
    
}
/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/

-(id) initWithRequest:(NSURLRequest *)_request andTag:(NSNumber *)_tag {
    
    self = [super init];
    
    if (self) {
        self.request = [_request copy];
        self.connection = [[NSURLConnection alloc] initWithRequest:request
                                                         delegate:self 
                                                 startImmediately:NO];
        self.receivedData = [[NSMutableData alloc] init];
        self.tag = [_tag copy];
    }
    
    return self; 
}

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [receivedData setLength:0];
}

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [receivedData appendData:data];
}

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"connectionFailed" object:self];
}

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"downloadFinished" object:self];
}


@end
