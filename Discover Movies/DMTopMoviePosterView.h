//
//  TopMoviePosterView.h
//  Discover Movies
//
//  Created by Thomas Grant on 31/12/2011.
//  Copyright (c) 2011 Reading University. All rights reserved.
//
//  Loads DMPosterViews and handles layout. Loaded by DMTopMoviesViewController
//  
//
//

#import <UIKit/UIKit.h>
@protocol DMTopMoviePosterViewDelegate
- (void)posterViewTouched:(NSInteger)tag;
@end

@interface DMTopMoviePosterView : UIView <UIGestureRecognizerDelegate> {
    
    NSArray *images;
    
}

@property (nonatomic, strong) NSArray *images;
@property (nonatomic, weak) id <DMTopMoviePosterViewDelegate> delegate;

- (id) initViewWithImagesInPortrait:(NSArray *) _images;
- (id) initViewWithImagesInLandscape:(NSArray *) _images;
- (void)rotateToLandscape;
- (void)rotateToPortrait;

@end
