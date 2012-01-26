//
//  UIView+Animation.h
//  Discover Movies
//
//  Created by Thomas Grant on 25/01/2012.
//  Copyright (c) 2012 Reading University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Animation)



- (void) moveTo:(CGRect)sizeAndDestination duration:(float)secs option:(UIViewAnimationOptions)option;
- (void) fadeOutWithDuration:(float)secs option:(UIViewAnimationOptions)option;
- (void) fadeInWithDuration:(float)secs option:(UIViewAnimationOptions)option;

@end
