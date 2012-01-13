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
@synthesize moviePosterImage, moviePosterImageView;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        //self.contentMode = UIViewContentModeScaleAspectFit;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 4.0f;
        
        
        //indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        //indicator.frame = CGRectMake(self.frame.origin.x / 2, self.frame.origin.x / 2, 40, 40);
        //[self addSubview:indicator];
        //[indicator startAnimating];
    }
    
    
    return self;
}

- (id)initWithImage: (UIImage *) _image andFrame: (CGRect)_frame 
{

    if ([self initWithFrame:_frame]) {
        
        self.moviePosterImage = _image;
        
        moviePosterImageView = [[UIImageView alloc] initWithImage:moviePosterImage];
        moviePosterImageView.frame = self.bounds;
        
        [self addSubview:moviePosterImageView];
        
        moviePosterImageView.contentMode = UIViewContentModeScaleToFill;
        
        
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
