//
//  SearchResultsTableViewViewController.h
//  Discover Movies
//
//  Created by Thomas Grant on 20/02/2012.
//  Copyright (c) 2012 Reading University. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DMSearchResultsTableViewControllerDelegate
- (void)doneButtonTouched;
@end


@interface DMSearchResultsTableViewController : UITableViewController {
    
}
@property (nonatomic, weak) id <DMSearchResultsTableViewControllerDelegate> delegate;


@end
