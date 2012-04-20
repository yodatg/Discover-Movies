//
//  SearchResultsTableViewViewController.m
//  Discover Movies
//
//  Created by Thomas Grant on 20/02/2012.
//  Copyright (c) 2012 Reading University. All rights reserved.
//

#import "DMSearchResultsTableViewController.h"
#import "DMMovieStore.h"
//#import "UIImageView+WebCache.h"
#import "DMTableViewDetailViewController.h"
#import "DMTMDBSearcher.h"
#import "DMMovie.h"

const CGFloat LABEL_HEIGHT = 20;

@implementation DMSearchResultsTableViewController
@synthesize delegate;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 * Private interface definitions
 *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

@interface DMSearchResultsTableViewController(Private)
- (void)createAndConfigureDetailViewControllerForMovie:(DMMovie *)m;
@end

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        NSLog(@"Table view initialised");
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        movieStore = [DMMovieStore defaultStore];
        
                
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
     UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonTouched)];
    
    self.navigationItem.leftBarButtonItem = doneButton;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
     

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [[[DMMovieStore defaultStore] searchResults] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        
    }
    
    // Configure the cell...
    //int index = [indexPath indexAtPosition:1];
    DMMovie *movie = [[[DMMovieStore defaultStore] searchResults]objectAtIndex:indexPath.row];
                [cell.imageView setImage:[movie poster]];

            
    
    
    
    [[cell textLabel] setText:[movie title]];

    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger movieIndex = indexPath.row;
    DMMovie *movie = [[movieStore searchResults] objectAtIndex:movieIndex];
    [self createAndConfigureDetailViewControllerForMovie:movie];
     // Pass the selected object to the new view controller.
     
     
}

- (void)createAndConfigureDetailViewControllerForMovie:(DMMovie *)movie {
    
    DMMovie *m = movie;
    
        
    // gather out movie info
    NSString *mTitle = [m title];
    NSString *mYear = [m year];
    //NSString *mTitleWithYear = [NSString stringWithFormat:@"%@ (%@)", mTitle, mYear];
    UIImage *mPoster = [m poster];
    NSString *mCriticsRating = [NSString stringWithFormat:@"%@",[[m ratings] valueForKey:@"critics_score"]];
    NSString *mAudienceRating = [NSString stringWithFormat:@"%@", [[m ratings] valueForKey:@"audience_score"]];

    NSString *mSynopsis = [NSString stringWithFormat:@"%@", [m synopsis]];
    if([mSynopsis isEqualToString:@"(null)"]){
    mSynopsis = @"";
    }
    
    NSString *mActors = [m topActors];
    
    [movieStore downloadRecommendedMoviesForMovie:m];
    
    
    
    DMTableViewDetailViewController *detailVC = [[DMTableViewDetailViewController alloc] init];
    [detailVC setTitle:mTitle];
    [detailVC setMovieTitle:mTitle];
    [detailVC setCriticsScore:[[NSString alloc] initWithFormat:@"%@%%", mCriticsRating]];
    [detailVC setAudienceScore:[[NSString alloc] initWithFormat:@"%@%%", mAudienceRating]];
    [detailVC setActors:[[NSString alloc] initWithFormat:@"Starring: %@", mActors]];
    [detailVC setSynopsis:mSynopsis];
    [detailVC setPoster:mPoster];
    [detailVC setMovieBeingDisplayed:m];
    [detailVC setMovieYear:mYear];
    
    
    [self.navigationController pushViewController:detailVC animated:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}


- (void)doneButtonTouched {
    
    [self.delegate doneButtonTouched];
[movieStore.searchResults removeAllObjects];

}

@end
