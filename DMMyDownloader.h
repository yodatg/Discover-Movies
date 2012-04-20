//
//  MyDownloader.h
//  Discover Movies
//
//  Created by Thomas Grant on 30/12/2011.
//  Copyright (c) 2011 Reading University. All rights reserved.
//
//  Downloads data from the internet
//  
//
//

#import <Foundation/Foundation.h>

@interface DMMyDownloader : NSObject {
    
    NSURLConnection *connection;
    NSURLRequest *request;
    NSMutableData *receivedData;
    NSNumber *tag;
    
    
}
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, copy) NSURLRequest *request;
@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic, strong) NSNumber *tag;

-(id) initWithRequest:(NSURLRequest *)_request;
-(id)initWithRequest: (NSURLRequest *)_request andTag:(NSNumber *)_tag;
-(void)cancel;
@end