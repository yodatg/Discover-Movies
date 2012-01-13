//
//  DMTopMoviePosterViewLandscape.h
//  Discover Movies
//
//  Created by Thomas Grant on 13/01/2012.
//  Copyright (c) 2012 Reading University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMTopMoviePosterViewLandscape : UIView {
    
    NSArray *images;
}

@property (nonatomic, strong) NSArray *images;

- (id) initViewWithImages:(NSArray *) _images;

@end
