//
//  ITunesDownloader.h
//  Discover Movies
//
//  Created by Thomas Grant on 06/03/2012.
//  Copyright (c) 2012 Reading University. All rights reserved.
//
//  Searches and parses data returned from the iTunes API
//  
//
//

#import <Foundation/Foundation.h>

@protocol iTunesSearcherDelegate
-(void)iTunesSearcherFinishedSearchingAndReturnedLink:(NSString *)url;
@end

@interface ITunesDownloader : NSObject {
    
    
    NSMutableArray *connections;
    NSMutableString *iTunesURL;
}
@property (nonatomic, strong) NSMutableArray *connections;
@property (nonatomic, strong) NSMutableString *iTunesURL;
@property (nonatomic, weak) id <iTunesSearcherDelegate> delegate;

- (void)searchiTunesWithURL:(NSURL *)url;

@end
