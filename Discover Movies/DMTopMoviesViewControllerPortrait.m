//
//  DMTopMoviesViewControllerPortrait.m
//  Discover Movies
//
//  Created by Thomas Grant on 28/12/2011.
//  Copyright (c) 2011 Reading University. All rights reserved.
//

#import "DMTopMoviesViewControllerPortrait.h"

int static kScrollViewPage;

@implementation DMTopMoviesViewControllerPortrait
@synthesize scrollView, pageControl;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        moviePosterViews = [[NSMutableArray alloc] init];
        movieStore = [DMMovieStore defaultStore]; // Access to our movie store
        
        // Application frame
        CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width, [UIScreen mainScreen].applicationFrame.size.height);
        
       
        scrollView = [[UIScrollView alloc] initWithFrame:rect]; 
        scrollView.pagingEnabled = YES;
        scrollView.alwaysBounceVertical = NO;
        scrollView.alwaysBounceHorizontal = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.delegate = self;
        
        self.navigationItem.title = @"Top Movies";
        
        // set the content size of our scroll view. 
        // The frame etc is set up in IB
        scrollView.contentSize = CGSizeMake(([UIScreen mainScreen].applicationFrame.size.width * 3), [UIScreen mainScreen].applicationFrame.size.height);     
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addPosterView) name:@"postersDownloaded" object:movieStore];

        
        
        [self.view addSubview:scrollView];
        
    
        
        
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    
    return YES;
    

}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    scrollingLocked = YES;
    
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        [portraitView setAlpha:0.0];
        [portraitView removeFromSuperview];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.7];
        [portraitView setAlpha:1.0];
        [UIView commitAnimations];
        // set the content size of our scroll view. 
        // The frame etc is set up in IB
        
        // Application frame
        CGRect rect = CGRectMake(0, 0, 1024, 768);
        scrollView.frame = rect;
        
        kScrollViewPage = [pageControl currentPage];
        CGFloat xOffset = (kScrollViewPage * scrollView.frame.size.width);
        [scrollView setContentOffset:CGPointMake(xOffset,0)];
        
        scrollView.contentSize = CGSizeMake((1024 * 3), 768);
        [scrollView setContentOffset:CGPointMake(xOffset,0)];
        [landscapeView setAlpha:0.0];
        [scrollView addSubview:landscapeView];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.7];
        [landscapeView setAlpha:1.0];
        [UIView commitAnimations];
    }
    else if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        
        [landscapeView setAlpha:0.0];
        [landscapeView removeFromSuperview];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.7];
        [landscapeView setAlpha:1.0];
        [UIView commitAnimations];
        
        // set the content size of our scroll view. 
        // The frame etc is set up in IB
        CGRect rect = CGRectMake(0, 0, 768, 1024);
        scrollView.frame = rect;
        
        
        kScrollViewPage = [pageControl currentPage];
        CGFloat xOffset = (kScrollViewPage * scrollView.frame.size.width);
        [scrollView setContentOffset:CGPointMake(xOffset,0)];
        
        scrollView.contentSize = CGSizeMake((768 * 3), 1024);  
        
        
        [portraitView setAlpha:0.0];
        [scrollView addSubview:portraitView];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.7];
        [portraitView setAlpha:1.0];
        [UIView commitAnimations];
    }
    
}
        
        
- (void)addPosterView {
    
    NSArray *moviePosters = [[NSArray alloc] initWithArray:[movieStore moviePosters]];
    portraitView = [[DMTopMoviePosterViewPortrait alloc] initViewWithImages:moviePosters];
    landscapeView = [[DMTopMoviePosterViewLandscape alloc] initViewWithImages:moviePosters];
    
    [scrollView addSubview:portraitView];
    
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromOrientation
{
    scrollingLocked = NO;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewDidUnload
{
    [self setPageControl:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - Scroll View Delegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollingLocked == YES) {
        return;
    }
    else {
    
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
    }
   
}




@end
