//
//  DMTopMoviePosterViewLandscape.m
//  Discover Movies
//
//  Created by Thomas Grant on 13/01/2012.
//  Copyright (c) 2012 Reading University. All rights reserved.
//

#import "DMTopMoviePosterViewLandscape.h"
#import "DMMoviePosterView.h"

typedef enum {
    
    // Landscape
    kYPositionLandscapeTopRow = 80,
    kYPositionLandscapeBottomRow = 400,
    
    // Landscape
    kXPositionLandscapePageOne = 70,
    kXPositionLandscapePageTwo = 1094,
    kXPositionLandscapePageThree = 2118,
    
    // Gap
    kXGapPositionPortrait = 180 + 60,
    kYGapPositionPortrait = 370
    
    
}CoordinatePosition; // defines positioning of columns and rows per page

@implementation DMTopMoviePosterViewLandscape
@synthesize images;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id) initViewWithImages:(NSArray *) _images {
    
    if ([self initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width * 3, [UIScreen mainScreen].applicationFrame.size.height)]) {
        
        
            NSLog(@"Main View Size W = %f H = %f", self.frame.size.width, self.frame.size.height);
        
        self.images = _images;
        
        /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
         * PAGE ONE
         *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
        
        // PAGE ONE
        // TOP ROW
        CGRect posterFrameA = CGRectMake(kXPositionLandscapePageOne, kYPositionLandscapeTopRow, 180, 267);
        CGRect posterFrameB = CGRectMake(kXPositionLandscapePageOne + kXGapPositionPortrait, kYPositionLandscapeTopRow, 180, 267);
        CGRect posterFrameC = CGRectMake(kXPositionLandscapePageOne + (kXGapPositionPortrait * 2), kYPositionLandscapeTopRow, 180, 267);
        CGRect posterFrameD = CGRectMake(kXPositionLandscapePageOne + (kXGapPositionPortrait * 3), kYPositionLandscapeTopRow, 180, 267);
        
        DMMoviePosterView *viewA = [[DMMoviePosterView alloc] initWithImage:[images objectAtIndex:0] andFrame:posterFrameA];
        DMMoviePosterView *viewB = [[DMMoviePosterView alloc] initWithImage:[images objectAtIndex:1] andFrame:posterFrameB];
        DMMoviePosterView *viewC = [[DMMoviePosterView alloc] initWithImage:[images objectAtIndex:2] andFrame:posterFrameC];
        DMMoviePosterView *viewD = [[DMMoviePosterView alloc] initWithImage:[images objectAtIndex:3] andFrame:posterFrameD];
    
        
        [self addSubview:viewA];
        [self addSubview:viewB];
        [self addSubview:viewC];
        [self addSubview:viewD];
        
        // PAGE ONE
        // BOTTOM ROW
        
        CGRect posterFrameE = CGRectMake(kXPositionLandscapePageOne, kYPositionLandscapeBottomRow, 180, 267);
        CGRect posterFrameF = CGRectMake(kXPositionLandscapePageOne + kXGapPositionPortrait, kYPositionLandscapeBottomRow, 180, 267);
        CGRect posterFrameG = CGRectMake(kXPositionLandscapePageOne + (kXGapPositionPortrait * 2), kYPositionLandscapeBottomRow, 180, 267);
        CGRect posterFrameH = CGRectMake(kXPositionLandscapePageOne + (kXGapPositionPortrait * 3), kYPositionLandscapeBottomRow, 180, 267);

        
        
        DMMoviePosterView *viewE = [[DMMoviePosterView alloc] initWithImage:[images objectAtIndex:4] andFrame:posterFrameE];
        DMMoviePosterView *viewF = [[DMMoviePosterView alloc] initWithImage:[images objectAtIndex:5] andFrame:posterFrameF];
        DMMoviePosterView *viewG = [[DMMoviePosterView alloc] initWithImage:[images objectAtIndex:6] andFrame:posterFrameG];
         DMMoviePosterView *viewH = [[DMMoviePosterView alloc] initWithImage:[images objectAtIndex:7] andFrame:posterFrameH];
        
        [self addSubview:viewE];
        [self addSubview:viewF];
        [self addSubview:viewG];
        [self addSubview:viewH];
        
        
        /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
         * PAGE 2
         *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
        
        // PAGE TWO
        // TOP ROW
        CGRect posterFrameA2 = CGRectMake(kXPositionLandscapePageTwo, kYPositionLandscapeTopRow, 180, 267);
        CGRect posterFrameB2 = CGRectMake(kXPositionLandscapePageTwo + kXGapPositionPortrait, kYPositionLandscapeTopRow, 180, 267);
        CGRect posterFrameC2 = CGRectMake(kXPositionLandscapePageTwo + (kXGapPositionPortrait * 2), kYPositionLandscapeTopRow, 180, 267);
        CGRect posterFrameD2 = CGRectMake(kXPositionLandscapePageTwo + (kXGapPositionPortrait * 3), kYPositionLandscapeTopRow, 180, 267);

        
        DMMoviePosterView *viewA2 = [[DMMoviePosterView alloc] initWithImage:[images objectAtIndex:8] andFrame:posterFrameA2];
        DMMoviePosterView *viewB2 = [[DMMoviePosterView alloc] initWithImage:[images objectAtIndex:9] andFrame:posterFrameB2];
        DMMoviePosterView *viewC2 = [[DMMoviePosterView alloc] initWithImage:[images objectAtIndex:10] andFrame:posterFrameC2];
         DMMoviePosterView *viewD2 = [[DMMoviePosterView alloc] initWithImage:[images objectAtIndex:11] andFrame:posterFrameD2];
        
        [self addSubview:viewA2];
        [self addSubview:viewB2];
        [self addSubview:viewC2];
        [self addSubview:viewD2];
        
        // PAGE TWO
        // BOTTOM ROW
        
        CGRect posterFrameE2 = CGRectMake(kXPositionLandscapePageTwo, kYPositionLandscapeBottomRow, 180, 267);
        CGRect posterFrameF2 = CGRectMake(kXPositionLandscapePageTwo + kXGapPositionPortrait , kYPositionLandscapeBottomRow, 180, 267);
        CGRect posterFrameG2 = CGRectMake(kXPositionLandscapePageTwo + (kXGapPositionPortrait * 2) , kYPositionLandscapeBottomRow, 180, 267);
        CGRect posterFrameH2 = CGRectMake(kXPositionLandscapePageTwo + (kXGapPositionPortrait * 3) , kYPositionLandscapeBottomRow, 180, 267);
        
        
        DMMoviePosterView *viewE2 = [[DMMoviePosterView alloc] initWithImage:[images objectAtIndex:12] andFrame:posterFrameE2];
        DMMoviePosterView *viewF2 = [[DMMoviePosterView alloc] initWithImage:[images objectAtIndex:13] andFrame:posterFrameF2];
        DMMoviePosterView *viewG2 = [[DMMoviePosterView alloc] initWithImage:[images objectAtIndex:14] andFrame:posterFrameG2];
        DMMoviePosterView *viewH2 = [[DMMoviePosterView alloc] initWithImage:[images objectAtIndex:15] andFrame:posterFrameH2];
        
        [self addSubview:viewE2];
        [self addSubview:viewF2];
        [self addSubview:viewG2];
        [self addSubview:viewH2];
                
        /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
         * PAGE 3
         *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
        
        // PAGE THREE
        // TOP ROW
        CGRect posterFrameA3 = CGRectMake(kXPositionLandscapePageThree, kYPositionLandscapeTopRow, 180, 267);
        CGRect posterFrameB3 = CGRectMake(kXPositionLandscapePageThree + kXGapPositionPortrait, kYPositionLandscapeTopRow, 180, 267);
        CGRect posterFrameC3 = CGRectMake(kXPositionLandscapePageThree + (kXGapPositionPortrait * 2), kYPositionLandscapeTopRow, 180, 267);
        CGRect posterFrameD3 = CGRectMake(kXPositionLandscapePageThree + (kXGapPositionPortrait * 3), kYPositionLandscapeTopRow, 180, 267);

        
        
        DMMoviePosterView *viewA3 = [[DMMoviePosterView alloc] initWithImage:[images objectAtIndex:16] andFrame:posterFrameA3];
        DMMoviePosterView *viewB3 = [[DMMoviePosterView alloc] initWithImage:[images objectAtIndex:17] andFrame:posterFrameB3];
        DMMoviePosterView *viewC3 = [[DMMoviePosterView alloc] initWithImage:[images objectAtIndex:18] andFrame:posterFrameC3];
        DMMoviePosterView *viewD3 = [[DMMoviePosterView alloc] initWithImage:[images objectAtIndex:19] andFrame:posterFrameD3];
        
        [self addSubview:viewA3];
        [self addSubview:viewB3];
        [self addSubview:viewC3];
        [self addSubview:viewD3];
        
        
        // PAGE THREE
        // BOTTOM ROW

        CGRect posterFrameE3 = CGRectMake(kXPositionLandscapePageThree , kYPositionLandscapeBottomRow, 180, 267);
        CGRect posterFrameF3 = CGRectMake(kXPositionLandscapePageThree + kXGapPositionPortrait, kYPositionLandscapeBottomRow, 180, 267);
        CGRect posterFrameG3 = CGRectMake(kXPositionLandscapePageThree + (kXGapPositionPortrait * 2), kYPositionLandscapeBottomRow, 180, 267);
        CGRect posterFrameH3 = CGRectMake(kXPositionLandscapePageThree + (kXGapPositionPortrait * 3), kYPositionLandscapeBottomRow, 180, 267);
        
        
        
        DMMoviePosterView *viewE3 = [[DMMoviePosterView alloc] initWithImage:[images objectAtIndex:20] andFrame:posterFrameE3];
        DMMoviePosterView *viewF3 = [[DMMoviePosterView alloc] initWithImage:[images objectAtIndex:21] andFrame:posterFrameF3];
        DMMoviePosterView *viewG3 = [[DMMoviePosterView alloc] initWithImage:[images objectAtIndex:22] andFrame:posterFrameG3];
         DMMoviePosterView *viewH3 = [[DMMoviePosterView alloc] initWithImage:[images objectAtIndex:23] andFrame:posterFrameH3];
        
        [self addSubview:viewE3];
        [self addSubview:viewF3];
        [self addSubview:viewG3];
        [self addSubview:viewH3];
        
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
