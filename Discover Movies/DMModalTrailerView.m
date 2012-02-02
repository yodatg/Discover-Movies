//
//  ModalView.m
//  Discover Movies
//
//  Created by Thomas Grant on 01/02/2012.
//  Copyright (c) 2012 Reading University. All rights reserved.
//

#import "DMModalTrailerView.h"
#import <QuartzCore/QuartzCore.h>

@implementation DMModalTrailerView
@synthesize delegate;
/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.frame = frame;
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 1.0;
        self.layer.cornerRadius = 5.0;
        [self.layer setMasksToBounds:YES];
        self.autoresizingMask = ( UIViewAutoresizingFlexibleBottomMargin|
                                   UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin);
        
        
        webView = [[UIWebView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height)];
        
        
        [webView setAllowsInlineMediaPlayback: YES];
        [webView setBackgroundColor:[UIColor blackColor]];
        [self addSubview:webView];
        
        
    }
    return self;
}

-(id)initWithYoutubeVideo:(NSURL *)_url {
    
    self = [self initWithFrame:CGRectMake(0, 0, 540, 620)];
    
    if (self) {
        NSString *urlString = [_url absoluteString];
        
        htmlString = [NSString stringWithFormat: @"<html><head><meta name = \"viewport\" content = \"initial-scale = 1.0, user-scalable = no, width = %d\"/></head><body style=\"background:#000;margin-top:44px;margin-left:0px\"><div><object width=\"%d\" height=\"%d\"><param name=\"movie\" value=\"%@\"></param><param name=\"wmode\" value=\"transparent\"></param><embed src=\"%@\"type=\"application/x-shockwave-flash\" wmode=\"transparent\" width=\"%d\" height=\"%d\"></embed></object></div></body></html>", 540, 540, 565, urlString, urlString, 540, 565];
        
        [webView loadHTMLString:htmlString baseURL:nil];
    }
    
    return self;
    
}

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    // Add navigation bar
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, 44)];
    [navBar setBarStyle:UIBarStyleBlackTranslucent];
    
    // add button to navBar
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonTouched)];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"Trailer"];
    item.leftBarButtonItem = doneButton;
    item.hidesBackButton = YES;
    [navBar pushNavigationItem:item animated:NO];
    [self addSubview:navBar];
}

#pragma mark - Delegate Methods
/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
- (void)doneButtonTouched {
    NSLog(@"Done button touched in view");
    [webView reload];
    [webView removeFromSuperview];
    [[self delegate]doneButtonTouched];
    
}


@end
