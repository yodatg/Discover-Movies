//
//  DMMoviePosterView.h
//  Discover Movies
//
//  Created by Thomas Grant on 05/12/2011.
//  Copyright (c) 2011 Reading University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMMoviePosterView : UIView
{
    
    UIImage *moviePosterImage;
    UIImageView *moviePosterImageView;
}

- (id) initWithImage:(UIImage *)image andFrame:(CGRect)_frame;

@end
