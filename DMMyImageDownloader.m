//
//  MyImageDownloader.m
//  Discover Movies
//
//  Created by Thomas Grant on 30/12/2011.
//  Copyright (c) 2011 Reading University. All rights reserved.
//

#import "DMMyImageDownloader.h"

@implementation DMMyImageDownloader
@synthesize image;

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/

- (UIImage *) image {
    
    if (image) {
        return image;
    }
    [self.connection start];
    return nil;   
    
}

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    self.connection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self startImmediately:NO];

}

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    UIImage* im = [UIImage imageWithData:self.receivedData];
    if (im) {
        self.image = im;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"imageDownloaded" object:self];
    }
}


@end
