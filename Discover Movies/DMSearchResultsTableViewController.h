//
//  SearchResultsTableViewViewController.h
//  Discover Movies
//
//  Created by Thomas Grant on 20/02/2012.
//  Copyright (c) 2012 Reading University. All rights reserved.
//
//  Manages interaction between Model and DMSearchResultsTableView
//  
//
//

#import <UIKit/UIKit.h>
#import "DMMovieStore.h"

@protocol DMSearchResultsTableViewControllerDelegate
- (void)doneButtonTouched;
@end


@interface DMSearchResultsTableViewController : UITableViewController {
    
    DMMovieStore *movieStore;
    
}
@property (nonatomic, weak) id <DMSearchResultsTableViewControllerDelegate> delegate;



@end
