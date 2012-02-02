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

/*-------------------------------------------------------------
 * Standard initialiser
 *------------------------------------------------------------*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 4.0f;

    }
    
    
    return self;
}

/*-------------------------------------------------------------
 * Custom init - sets image
 *------------------------------------------------------------*/

- (id)initWithImage: (UIImage *) _image andFrame: (CGRect)_frame 
{

    if (self = [self initWithFrame:_frame]) {
        
        self.moviePosterImage = _image;
        
        moviePosterImageView = [[UIImageView alloc] initWithImage:moviePosterImage];
        moviePosterImageView.contentMode = UIViewContentModeScaleToFill;
        moviePosterImageView.frame = self.bounds;
        
        [self addSubview:moviePosterImageView];
        
        
        
        
    }
    
    return self;
    
}
/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
- (id)initWithImage: (UIImage *) _image borderWidth: (CGFloat) _width andFrame: (CGRect)_frame 
{
    self = [self initWithImage:_image andFrame:_frame];
    
    if (self) {
        
        self.layer.borderWidth = _width;
    }
    
    return self;
}
/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/ 
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    NSLog(@"bummer");
}


@end
