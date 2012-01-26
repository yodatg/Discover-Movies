//
//  DetailViewController.h
//  Discover Movies
//
//  Created by Thomas Grant on 16/01/2012.
//  Copyright (c) 2012 Reading University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMMoviePosterView.h"

@interface DetailViewControllerPortrait : UIViewController <UINavigationControllerDelegate, UINavigationBarDelegate> {
    
    DMMoviePosterView *posterView;
    
    
}

@property (strong, nonatomic) NSString *audienceScore;
@property (strong, nonatomic) NSString *criticsScore;
@property (strong, nonatomic) NSString *audienceImage;
@property (strong, nonatomic) NSString *criticsImage;
@property (strong, nonatomic) NSString *movieTitle;
@property (strong, nonatomic) NSString *actors;
@property (strong, nonatomic) NSString *synopsis;
@property (strong, nonatomic) UIImage *poster;


@property (strong, nonatomic) IBOutlet UILabel *audienceScoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *criticsScoreLabel;
@property (strong, nonatomic) IBOutlet UIImageView *audienceImageView;
@property (strong, nonatomic) IBOutlet UIImageView *criticsImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *actorsLabel;
@property (strong, nonatomic) IBOutlet UITextView *synopsisTextView;



@end
