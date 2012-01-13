//
//  TopMoviePosterView.h
//  Discover Movies
//
//  Created by Thomas Grant on 31/12/2011.
//  Copyright (c) 2011 Reading University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMTopMoviePosterViewPortrait : UIView {
    
    NSArray *images;
    
}

@property (nonatomic, strong) NSArray *images;

- (id) initViewWithImages:(NSArray *) _images;

@end
