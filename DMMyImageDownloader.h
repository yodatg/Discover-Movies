//
//  MyImageDownloader.h
//  Discover Movies
//
//  Created by Thomas Grant on 30/12/2011.
//  Copyright (c) 2011 Reading University. All rights reserved.
//

#import "DMMyDownloader.h"

@interface DMMyImageDownloader : DMMyDownloader {
    
    int imageType;
    
}
@property (nonatomic, strong) UIImage *image;

@end
