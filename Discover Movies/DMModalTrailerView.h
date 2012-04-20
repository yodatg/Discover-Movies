//
//  ModalView.h
//  Discover Movies
//
//  Created by Thomas Grant on 01/02/2012.
//  Copyright (c) 2012 Reading University. All rights reserved.
//
//  Custom View that presents a UIWebView that loads a YouTube trailer
//  
//
//

#import <UIKit/UIKit.h>
@protocol DMModelTrailerViewDelegate
- (void)doneButtonTouched;
@end

@interface DMModalTrailerView : UIView {
    UIWebView *webView;
    NSURL *url;
    NSString *htmlString;
    
}
@property (nonatomic, weak) id <DMModelTrailerViewDelegate> delegate;

-(id)initWithYoutubeVideo:(NSURL *)_url;

@end
