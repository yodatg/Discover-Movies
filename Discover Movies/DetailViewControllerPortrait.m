//
//  DetailViewController.m
//  Discover Movies
//
//  Created by Thomas Grant on 16/01/2012.
//  Copyright (c) 2012 Reading University. All rights reserved.
//

#import "DetailViewControllerPortrait.h"

@implementation DetailViewControllerPortrait
@synthesize audienceScoreLabel;
@synthesize criticsScoreLabel;
@synthesize audienceImageView;
@synthesize criticsImageView;
@synthesize titleLabel;
@synthesize actorsLabel;
@synthesize synopsisTextView;
@synthesize audienceScore, audienceImage, criticsImage, criticsScore, movieTitle, actors, synopsis, poster;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
        
            }
    return self;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //[audienceScoreLabel setText:audienceScore];
    
    if (self.criticsScore.integerValue >= 50) {
        [criticsScoreLabel setText:criticsScore];
        [criticsScoreLabel setTextColor:[UIColor colorWithRed:0.105 green:0.46 blue:0 alpha:1]];
        [criticsImageView setImage:[UIImage imageNamed:@"tomato.png"]];
    }
    else if (self.criticsScore.integerValue < 50) {
        
        [criticsScoreLabel setText:criticsScore];
        [criticsScoreLabel setTextColor:[UIColor colorWithRed:0.8 green:0. blue:0 alpha:1]];
        [criticsImageView setImage:[UIImage imageNamed:@"splat.png"]];
    }
    
    if (self.audienceScore.integerValue >= 50) {
        [audienceScoreLabel setText:audienceScore];
        [audienceScoreLabel setTextColor:[UIColor colorWithRed:0.105 green:0.46 blue:0 alpha:1]];
        [audienceImageView setImage:[UIImage imageNamed:@"popcorn.png"]];
    }
    else if (self.audienceScore.integerValue < 50) {
        
        [audienceScoreLabel setText:audienceScore];
        [audienceScoreLabel setTextColor:[UIColor colorWithRed:0.8 green:0. blue:0 alpha:1]];
        [audienceImageView setImage:[UIImage imageNamed:@"popcorn_over.png"]];
    }

    DMMoviePosterView *posterView = [[DMMoviePosterView alloc] initWithImage:poster borderWidth:7.0 andFrame:CGRectMake(35, 90, 260, 388)];
    [self.view addSubview:posterView];
        
    [titleLabel setText:movieTitle];
    [actorsLabel setText:actors];
    [synopsisTextView setText:synopsis];
}

- (void)viewDidUnload
{
    [self setCriticsImageView:nil];
    [self setAudienceImageView:nil];
    [self setCriticsScoreLabel:nil];
    [self setAudienceScoreLabel:nil];
    [self setTitleLabel:nil];
    [self setActorsLabel:nil];
    [self setSynopsisTextView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
