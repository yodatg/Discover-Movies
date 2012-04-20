//
//  DMAppDelegate.m
//  Discover Movies
//
//  Created by Thomas Grant on 30/11/2011.
//  Copyright (c) 2011 Reading University. All rights reserved.
//

#import "DMAppDelegate.h"
#import "Constants.h"



@implementation DMAppDelegate

@synthesize window = _window;
@synthesize vc, facebook;

// Called on application launch

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // create FB objecy
    facebook = [[Facebook alloc] initWithAppId:@"190765024365509" andDelegate:self];
    
    // extract any FB data/access tokens that may have been stored previously
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    else {
        if (![facebook isSessionValid]) {
            NSLog(@"FB SESSION NOT VALID");
            [facebook authorize:nil];
        }
    }
        
    
        
    movieStore = [DMMovieStore defaultStore];
    // read in users fav movies
    NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
    NSData *dataRepresentingSavedArray = [currentDefaults objectForKey:@"favMovies"];
    if (dataRepresentingSavedArray != nil)
    {
        NSArray *oldSavedArray = [NSKeyedUnarchiver unarchiveObjectWithData:dataRepresentingSavedArray];
        if (oldSavedArray != nil)
            movieStore.favoriteMovies = [[NSMutableArray alloc] initWithArray:oldSavedArray];
        else
            movieStore.favoriteMovies = [[NSMutableArray alloc] init];
    }
    
    
    
    vc = [[DMTopMoviesViewController alloc] init];
    // Create an instance of our DMTopMoviesViewController - this will be the root
    // in the UINavigation controller
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
    // Configure the navController to be black and transluscent
    [[navController navigationBar] setBarStyle:UIBarStyleBlackTranslucent];

    
    

    // Create our window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    // Place nav controllers view in the window hierarchy
    [[self window] setRootViewController:navController];
    [[self window] setBackgroundColor:[UIColor blackColor]];
    
    // Override point for customization after application launch.
    [self.window makeKeyAndVisible];

    
    return YES;
    
    
}

// Pre iOS 4.2 support for facebook
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [facebook handleOpenURL:url]; 
}

// For iOS 4.2+ support for facebook
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [facebook handleOpenURL:url]; 
}

// called when facebook logs in
- (void)fbDidLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    NSLog(@"FB LOGGED IN");
    
}

// called when application moves from active to inactive
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

// called when application enters the background
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    // save out the users favorite movies to NSUserDefaults
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:[movieStore favoriteMovies]] forKey:@"favMovies"];
    NSLog(@"saved fav movies");
}

// called when application enters the foreground
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    [facebook extendAccessTokenIfNeeded];

}

// called when application is about to terminate
- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    
    // save out the users favorite movies to NSUserDefaults
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:[movieStore favoriteMovies]] forKey:@"favMovies"];
    NSLog(@"saved fav movies");
    
}

// FBDialogDelegate
- (void)dialogDidComplete:(FBDialog *)dialog {
    NSLog(@"dialog completed successfully");
}

// called when facebook token is extended
-(void)fbDidExtendToken:(NSString *)accessToken expiresAt:(NSDate *)expiresAt {
    NSLog(@"token extended");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:accessToken forKey:@"FBAccessTokenKey"];
    [defaults setObject:expiresAt forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}

// called when facebook didn't log in
- (void)fbDidNotLogin:(BOOL)cancelled {
    NSLog(@"facebook didn't log in");
}

// called when facebook logs out
- (void)fbDidLogout {
    
    NSLog(@"facebook did log out");
}

// called when facebook session invalidated
- (void)fbSessionInvalidated {
    NSLog(@"facebook session invalidated");
}
@end
