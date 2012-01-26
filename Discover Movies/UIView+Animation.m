//
//  UIView+Animation.m
//  Discover Movies
//
//  Created by Thomas Grant on 25/01/2012.
//  Copyright (c) 2012 Reading University. All rights reserved.
//

#import "UIView+Animation.h"

@implementation UIView (Animation)


- (void) moveTo:(CGRect)sizeAndDestination duration:(float)secs option:(UIViewAnimationOptions)option
{
    [UIView animateWithDuration:secs delay:0.0 options:option
                     animations:^{
                         self.frame = CGRectMake(sizeAndDestination.origin.x,sizeAndDestination.origin.y, sizeAndDestination.size.width, sizeAndDestination.size.height);
                     }
                     completion:nil];
}

- (void) fadeOutWithDuration:(float)secs option:(UIViewAnimationOptions)option {
    
    [UIView animateWithDuration:secs delay:0.0 options:option
                     animations:^{
                         self.alpha = 0.0;
                     }
                     completion:nil];
}

- (void) fadeInWithDuration:(float)secs option:(UIViewAnimationOptions)option {
    
    [UIView animateWithDuration:secs delay:0.0 options:option
                     animations:^{
                         self.alpha = 1.0;
                     }
                     completion:nil];
}


@end
