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

- (id) initWithImage:(UIImage *)image andFrame: (CGRect)_frame
{
    self = [super initWithFrame:_frame];
    
    
    if (self) {
        
        self.contentMode = UIViewContentModeScaleToFill;
        
        
       
        moviePosterImageView = [[UIImageView alloc] initWithFrame: _frame];
        [moviePosterImageView setImage:image];
        
        
        // add the imageView to the view
        [self addSubview:moviePosterImageView];
        
        
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 4.0f;
       
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
