//
//  DMHeatMapViewController.m
//  Discover Movies
//
//  Created by Thomas Grant on 29/03/2012.
//  Copyright (c) 2012 Reading University. All rights reserved.
//

#import "DMHeatMapViewController.h"
#import "DMHeatMapView.h"

@interface DMHeatMapViewController ()

@end

@implementation DMHeatMapViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSLog(@"HEAT MAP VC INITIALISED");
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (id)initWithCosineData:(NSArray *)cosineData {
    
    self = [self initWithNibName:@"DMHeatMapViewController" bundle:nil];
    
    if(self){
        
        NSLog(@"cosine data = %@", cosineData);
        
        DMHeatMapView *hmView = [[DMHeatMapView alloc] initWithData:cosineData];
       
        [self.view addSubview:hmView];
        
    }
    
    return self;
}

@end
