//
//  DMMoviePosterView.m
//  Discover Movies
//
//  Created by Thomas Grant on 05/12/2011.
//  Copyright (c) 2011 Reading University. All rights reserved.
//

#import "DMMoviePosterView.h"
#import <QuartzCore/QuartzCore.h>

@implementation DMMoviePosterView




- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    return self;
}

- (id) initWithImage:(UIImage *)image
{
    self = [super init];
    
    
    if (self) {
        
        
        // assign the image
        moviePosterImage = [[UIImage alloc] init];
        moviePosterImage = image;
        
       
        moviePosterImageView = [[UIImageView alloc]init];
        // configure image view
        [moviePosterImageView setContentMode:UIViewContentModeScaleAspectFill];
        [moviePosterImageView setImage:image];
        
        
        
        // add the imageView to the view
        [self addSubview:moviePosterImageView];
        
        
        moviePosterImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        moviePosterImageView.layer.borderWidth = 6.0f;
    }
    
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
}
*/

@end
