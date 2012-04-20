//
//  DMHeatMapSubView.m
//  Discover Movies
//
//  Created by Thomas Grant on 29/03/2012.
//  Copyright (c) 2012 Reading University. All rights reserved.
//

#import "DMHeatMapSubView.h"
#import <QuartzCore/QuartzCore.h>

@implementation DMHeatMapSubView
@synthesize movieNameLbl, cosineSimResultLbl, backgroundView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        backgroundView = [[UIImageView alloc] init];
        backgroundView.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height);
         backgroundView.contentMode = UIViewContentModeScaleToFill;

        movieNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, 180, 80)];
        cosineSimResultLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y + 50, 180, 80)];
        movieNameLbl.backgroundColor = [UIColor clearColor];
        cosineSimResultLbl.backgroundColor = [UIColor clearColor];
        [movieNameLbl setTextAlignment:UITextAlignmentCenter];
        [cosineSimResultLbl setTextAlignment:UITextAlignmentCenter];
        
        [self addSubview:backgroundView];
        [self addSubview:movieNameLbl];
        [self addSubview:cosineSimResultLbl];
        

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
