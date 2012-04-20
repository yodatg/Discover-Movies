//
//  DMHeatMapView.m
//  Discover Movies
//
//  Created by Thomas Grant on 28/03/2012.
//  Copyright (c) 2012 Reading University. All rights reserved.
//

#import "DMHeatMapView.h"
#import "DMHeatMapSubView.h"
#include <math.h>

@implementation DMHeatMapView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithData:(NSArray *)data {
    
    self = [self initWithFrame:CGRectMake(0, 0, 768, 1024)];
    
    if (self) {
        
        
        CGRect frame = CGRectMake(0, 40, 204.8, 256);
        int count = 1;       
        
        
        for (NSArray *arr in data) {
           
            DMHeatMapSubView *view = [[DMHeatMapSubView alloc] initWithFrame:frame];
            
           
            NSLog(@"array = %@", arr);
            
            [[view movieNameLbl] setText:[arr objectAtIndex:1]];
            if ([[[arr objectAtIndex:0] stringValue] isEqualToString:@"nan"]) {
                [[view cosineSimResultLbl] setText:@"-1"];
            }
            else {
            [[view cosineSimResultLbl] setText:[[arr objectAtIndex:0] stringValue]];
            }
            
            if([[arr objectAtIndex:0] floatValue] < 0.3){
                    
                [view.backgroundView setImage:[UIImage imageNamed:@"red.png"]];
                
                    //view.backgroundColor = [UIColor redColor];
                }
                else if ([[arr objectAtIndex:0] floatValue] > 0.3 && [[arr objectAtIndex:0] floatValue]< 0.6) {
                    //view.backgroundColor = [UIColor yellowColor];
                   [view.backgroundView setImage:[UIImage imageNamed:@"yellow.jpg"]];
                }
                else if ([[[view cosineSimResultLbl] text] isEqualToString:@"-1"] ){
                    
                    [view.backgroundView setImage:[UIImage imageNamed:@"red.png"]];
                }
                else {
                    [view.backgroundView setImage:[UIImage imageNamed:@"green.jpg"]];                }
            
            
            [self addSubview:view];
            
            
            if (count % 5 == 0) {
                frame.origin.y += 256;
                frame.origin.x = 0;
            }
            else {
                frame.origin.x += 204.8;

            }
            count++;
                        
        }

    }
        
    return self;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
