//
//  TopMoviePosterView.m
//  Discover Movies
//
//  Created by Thomas Grant on 31/12/2011.
//  Copyright (c) 2011 Reading University. All rights reserved.
//

#import "DMTopMoviePosterView.h"
#import "DMMoviePosterView.h"

typedef enum {
    
    // Portrait X
    kXPositionPortraitPageOne = 60,
    kXPositionPortraitPageTwo = 828,
    kXPositionPortraitPageThree = 1596,

    
    // Portrait Y
    kYPositionPortraitTopRow = 80,
    kYPositionPortraitMiddleRow = 370,
    kYPositionPortraitBottomRow = 660,
    
    // Gap
    kXGapPositionPortrait = 180 + 60,
    kYGapPositionPortrait = 370,
    
    // Landscape
    kYPositionLandscapeTopRow = 80,
    kYPositionLandscapeBottomRow = 400,
    
    // Landscape
    kXPositionLandscapePageOne = 70,
    kXPositionLandscapePageTwo = 1094,
    kXPositionLandscapePageThree = 2118
    

    
        
}CoordinatePosition; // defines positioning of columns and rows per page

@implementation DMTopMoviePosterView
@synthesize images;
@synthesize delegate;

/*-------------------------------------------------------------
 * Standard init
 *------------------------------------------------------------*/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // add gesture recogniser
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
        singleTap.numberOfTapsRequired = 1;
        singleTap.delegate = self;
        [self addGestureRecognizer:singleTap];
        
        
        // tag needed for gestures
        self.tag = 100;
        
    }
    return self;
}

/*-------------------------------------------------------------
 * Custom init for PORTRAIT - lays out views
 *------------------------------------------------------------*/

- (id) initViewWithImagesInPortrait:(NSArray *) _images {
    
    if (self = [self initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width * 3, [UIScreen mainScreen].applicationFrame.size.height)]) {
        
    
        self.images = _images;
        
        /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
         * PAGE ONE
         *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
        
        // PAGE ONE
        // TOP ROW
        CGRect posterFrameA = CGRectMake(kXPositionPortraitPageOne, kYPositionPortraitTopRow, 180, 267);
        CGRect posterFrameB = CGRectMake(kXPositionPortraitPageOne + kXGapPositionPortrait, kYPositionPortraitTopRow, 180, 267);
        CGRect posterFrameC = CGRectMake(kXPositionPortraitPageOne + (kXGapPositionPortrait * 2), kYPositionPortraitTopRow, 180, 267);

        
        DMMoviePosterView *viewA = [[DMMoviePosterView alloc] initWithImage:[images objectAtIndex:0] andFrame:posterFrameA];
        DMMoviePosterView *viewB = [[DMMoviePosterView alloc] initWithImage:[images objectAtIndex:1] andFrame:posterFrameB];
        DMMoviePosterView *viewC = [[DMMoviePosterView alloc] initWithImage:[images objectAtIndex:2] andFrame:posterFrameC];
        
        [viewA setTag:0];
        [viewB setTag:1];
        [viewC setTag:2];
        
        [self addSubview:viewA];
        [self addSubview:viewB];
        [self addSubview:viewC];
        
        // PAGE ONE
        // MIDDLE ROW
        CGRect posterFrameD = CGRectMake(kXPositionPortraitPageOne, kYPositionPortraitMiddleRow, 180, 267);
        CGRect posterFrameE = CGRectMake(kXPositionPortraitPageOne + kXGapPositionPortrait, kYPositionPortraitMiddleRow, 180, 267);
        CGRect posterFrameF = CGRectMake(kXPositionPortraitPageOne + (kXGapPositionPortrait * 2), kYPositionPortraitMiddleRow, 180, 267);
        
        
        DMMoviePosterView *viewD = [[DMMoviePosterView alloc] initWithImage:[images objectAtIndex:3] andFrame:posterFrameD];
        DMMoviePosterView *viewE = [[DMMoviePosterView alloc] initWithImage:[images objectAtIndex:4] andFrame:posterFrameE];
        DMMoviePosterView *viewF = [[DMMoviePosterView alloc] initWithImage:[images objectAtIndex:5] andFrame:posterFrameF];
        
        [viewD setTag:3];
        [viewE setTag:4];
        [viewF setTag:5];
        
        [self addSubview:viewD];
        [self addSubview:viewE];
        [self addSubview:viewF];
        
        // PAGE ONE
        // BOTTOM ROW
        CGRect posterFrameG = CGRectMake(kXPositionPortraitPageOne, kYPositionPortraitBottomRow, 180, 267);
        CGRect posterFrameH = CGRectMake(kXPositionPortraitPageOne + kXGapPositionPortrait, kYPositionPortraitBottomRow, 180, 267);
        CGRect posterFrameI = CGRectMake(kXPositionPortraitPageOne + (kXGapPositionPortrait * 2), kYPositionPortraitBottomRow, 180, 267);

        
        DMMoviePosterView *viewG = [[DMMoviePosterView alloc] initWithImage:[images objectAtIndex:6] andFrame:posterFrameG];
        DMMoviePosterView *viewH = [[DMMoviePosterView alloc] initWithImage:[images objectAtIndex:7] andFrame:posterFrameH];
        DMMoviePosterView *viewI = [[DMMoviePosterView alloc] initWithImage:[images objectAtIndex:8] andFrame:posterFrameI];
        
        [viewG setTag:6];
        [viewH setTag:7];
        [viewI setTag:8];
        
        [self addSubview:viewG];
        [self addSubview:viewH];
        [self addSubview:viewI];
        
        /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
         * PAGE 2
         *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
        
        // PAGE TWO
        // TOP ROW
        CGRect posterFrameA2 = CGRectMake(kXPositionPortraitPageTwo, kYPositionPortraitTopRow, 180, 267);
        CGRect posterFrameB2 = CGRectMake(kXPositionPortraitPageTwo + kXGapPositionPortrait, kYPositionPortraitTopRow, 180, 267);
        CGRect posterFrameC2 = CGRectMake(kXPositionPortraitPageTwo + (kXGapPositionPortrait * 2), kYPositionPortraitTopRow, 180, 267);
        
        
        DMMoviePosterView *viewA2 = [[DMMoviePosterView alloc] initWithImage:[images objectAtIndex:9] andFrame:posterFrameA2];
        DMMoviePosterView *viewB2 = [[DMMoviePosterView alloc] initWithImage:[images objectAtIndex:10] andFrame:posterFrameB2];
        DMMoviePosterView *viewC2 = [[DMMoviePosterView alloc] initWithImage:[images objectAtIndex:11] andFrame:posterFrameC2];
        
        [viewA2 setTag:9];
        [viewB2 setTag:10];
        [viewC2 setTag:11];
        
        [self addSubview:viewA2];
        [self addSubview:viewB2];
        [self addSubview:viewC2];
        
        // PAGE TWO
        // MIDDLE ROW
        CGRect posterFrameD2 = CGRectMake(kXPositionPortraitPageTwo, kYPositionPortraitMiddleRow, 180, 267);
        CGRect posterFrameE2 = CGRectMake(kXPositionPortraitPageTwo + kXGapPositionPortrait, kYPositionPortraitMiddleRow, 180, 267);
        CGRect posterFrameF2 = CGRectMake(kXPositionPortraitPageTwo + (kXGapPositionPortrait * 2), kYPositionPortraitMiddleRow, 180, 267);
        
        
        DMMoviePosterView *viewD2 = [[DMMoviePosterView alloc] initWithImage:[images objectAtIndex:12] andFrame:posterFrameD2];
        DMMoviePosterView *viewE2 = [[DMMoviePosterView alloc] initWithImage:[images objectAtIndex:13] andFrame:posterFrameE2];
        DMMoviePosterView *viewF2 = [[DMMoviePosterView alloc] initWithImage:[images objectAtIndex:14] andFrame:posterFrameF2];
        
        [viewD2 setTag:12];
        [viewE2 setTag:13];
        [viewF2 setTag:14];
        
        [self addSubview:viewD2];
        [self addSubview:viewE2];
        [self addSubview:viewF2];
        
        // PAGE TWO
        // BOTTOM ROW
        CGRect posterFrameG2 = CGRectMake(kXPositionPortraitPageTwo, kYPositionPortraitBottomRow, 180, 267);
        CGRect posterFrameH2 = CGRectMake(kXPositionPortraitPageTwo + kXGapPositionPortrait, kYPositionPortraitBottomRow, 180, 267);
        CGRect posterFrameI2 = CGRectMake(kXPositionPortraitPageTwo + (kXGapPositionPortrait * 2), kYPositionPortraitBottomRow, 180, 267);
        
        
        DMMoviePosterView *viewG2 = [[DMMoviePosterView alloc] initWithImage:[images objectAtIndex:15] andFrame:posterFrameG2];
        DMMoviePosterView *viewH2 = [[DMMoviePosterView alloc] initWithImage:[images objectAtIndex:16] andFrame:posterFrameH2];
        DMMoviePosterView *viewI2 = [[DMMoviePosterView alloc] initWithImage:[images objectAtIndex:17] andFrame:posterFrameI2];
        
        [viewG2 setTag:15];
        [viewH2 setTag:16];
        [viewI2 setTag:17];
        
        [self addSubview:viewG2];
        [self addSubview:viewH2];
        [self addSubview:viewI2];
        
        /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
         * PAGE 3
         *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
        
        // PAGE TWO
        // TOP ROW
        CGRect posterFrameA3 = CGRectMake(kXPositionPortraitPageThree, kYPositionPortraitTopRow, 180, 267);
        CGRect posterFrameB3 = CGRectMake(kXPositionPortraitPageThree + kXGapPositionPortrait, kYPositionPortraitTopRow, 180, 267);
        CGRect posterFrameC3 = CGRectMake(kXPositionPortraitPageThree + (kXGapPositionPortrait * 2), kYPositionPortraitTopRow, 180, 267);
        
        
        DMMoviePosterView *viewA3 = [[DMMoviePosterView alloc] initWithImage:[images objectAtIndex:18] andFrame:posterFrameA3];
        DMMoviePosterView *viewB3 = [[DMMoviePosterView alloc] initWithImage:[images objectAtIndex:19] andFrame:posterFrameB3];
        DMMoviePosterView *viewC3 = [[DMMoviePosterView alloc] initWithImage:[images objectAtIndex:20] andFrame:posterFrameC3];
        
        [viewA3 setTag:18];
        [viewB3 setTag:19];
        [viewC3 setTag:20];
        
        [self addSubview:viewA3];
        [self addSubview:viewB3];
        [self addSubview:viewC3];
        
        // PAGE TWO
        // MIDDLE ROW
        CGRect posterFrameD3 = CGRectMake(kXPositionPortraitPageThree, kYPositionPortraitMiddleRow, 180, 267);
        CGRect posterFrameE3 = CGRectMake(kXPositionPortraitPageThree + kXGapPositionPortrait, kYPositionPortraitMiddleRow, 180, 267);
        CGRect posterFrameF3 = CGRectMake(kXPositionPortraitPageThree + (kXGapPositionPortrait * 2), kYPositionPortraitMiddleRow, 180, 267);
        
        
        DMMoviePosterView *viewD3 = [[DMMoviePosterView alloc] initWithImage:[images objectAtIndex:21] andFrame:posterFrameD3];
        DMMoviePosterView *viewE3 = [[DMMoviePosterView alloc] initWithImage:[images objectAtIndex:22] andFrame:posterFrameE3];
        DMMoviePosterView *viewF3 = [[DMMoviePosterView alloc] initWithImage:[images objectAtIndex:23] andFrame:posterFrameF3];
        
        [viewD3 setTag:21];
        [viewE3 setTag:22];
        [viewF3 setTag:23];
        
        [self addSubview:viewD3];
        [self addSubview:viewE3];
        [self addSubview:viewF3];
        
        
    }
    
    return self;
}

/*-------------------------------------------------------------
 * Custom init for LANDSCAPE - lays out images
 *------------------------------------------------------------*/

- (id) initViewWithImagesInLandscape:(NSArray *) _images {
    
    if (self = [self initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width * 3, [UIScreen mainScreen].applicationFrame.size.height)]) {
        
        
        
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
        
        [viewA setTag:0];
        [viewB setTag:1];
        [viewC setTag:2];
        [viewD setTag:3];
        
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
        
        [viewE setTag:4];
        [viewF setTag:5];
        [viewG setTag:6];
        [viewH setTag:7];
        
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
        
        [viewA2 setTag:8];
        [viewB2 setTag:9];
        [viewC2 setTag:10];
        [viewD2 setTag:11];
        
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
        
        [viewE2 setTag:12];
        [viewF2 setTag:13];
        [viewG2 setTag:14];
        [viewH2 setTag:15];
        
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
        
        [viewA3 setTag:16];
        [viewB3 setTag:17];
        [viewC3 setTag:18];
        [viewD3 setTag:19];
        
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
        
        [viewE3 setTag:20];
        [viewF3 setTag:21];
        [viewG3 setTag:22];
        [viewH3 setTag:23];
        
        [self addSubview:viewE3];
        [self addSubview:viewF3];
        [self addSubview:viewG3];
        [self addSubview:viewH3];
        
    }
    
    return self;
    
    
}

/*-------------------------------------------------------------
 * Rotates image frames to portrait
 *------------------------------------------------------------*/

-(void)rotateToPortrait {
    
    self.frame = CGRectMake(0, 0, 768 * 3, 1024);
    
    // PAGE 1 - VIEW A, B, C, D, E, F, G, H, I
    
    [[[self subviews] objectAtIndex:0] setFrame:CGRectMake(kXPositionPortraitPageOne, kYPositionPortraitTopRow, 180, 267)];
    [[[self subviews] objectAtIndex:1] setFrame:CGRectMake(kXPositionPortraitPageOne + kXGapPositionPortrait, kYPositionPortraitTopRow, 180, 267)];
    [[[self subviews] objectAtIndex:2] setFrame:CGRectMake(kXPositionPortraitPageOne + (kXGapPositionPortrait * 2), kYPositionPortraitTopRow, 180, 267)];
    [[[self subviews] objectAtIndex:3] setFrame:CGRectMake(kXPositionPortraitPageOne, kYPositionPortraitMiddleRow, 180, 267)];
    [[[self subviews] objectAtIndex:4] setFrame:CGRectMake(kXPositionPortraitPageOne + kXGapPositionPortrait, kYPositionPortraitMiddleRow, 180, 267)];
    [[[self subviews] objectAtIndex:5] setFrame:CGRectMake(kXPositionPortraitPageOne + (kXGapPositionPortrait * 2), kYPositionPortraitMiddleRow, 180, 267)];
    [[[self subviews] objectAtIndex:6] setFrame:CGRectMake(kXPositionPortraitPageOne, kYPositionPortraitBottomRow, 180, 267)];
    [[[self subviews] objectAtIndex:7] setFrame:CGRectMake(kXPositionPortraitPageOne + kXGapPositionPortrait, kYPositionPortraitBottomRow, 180, 267)];
     [[[self subviews] objectAtIndex:8] setFrame:CGRectMake(kXPositionPortraitPageOne + (kXGapPositionPortrait * 2), kYPositionPortraitBottomRow, 180, 267)];
    
    // PAGE 2 - VIEW A2, B2, C2, D2, E2, F2, G2, H2, I2
    
    [[[self subviews] objectAtIndex:9] setFrame:CGRectMake(kXPositionPortraitPageTwo, kYPositionPortraitTopRow, 180, 267)];
    [[[self subviews] objectAtIndex:10] setFrame:CGRectMake(kXPositionPortraitPageTwo + kXGapPositionPortrait, kYPositionPortraitTopRow, 180, 267)];
    [[[self subviews] objectAtIndex:11] setFrame:CGRectMake(kXPositionPortraitPageTwo + (kXGapPositionPortrait * 2), kYPositionPortraitTopRow, 180, 267)];
    [[[self subviews] objectAtIndex:12] setFrame:CGRectMake(kXPositionPortraitPageTwo, kYPositionPortraitMiddleRow, 180, 267)];
    [[[self subviews] objectAtIndex:13] setFrame:CGRectMake(kXPositionPortraitPageTwo + kXGapPositionPortrait, kYPositionPortraitMiddleRow, 180, 267)];
    [[[self subviews] objectAtIndex:14] setFrame:CGRectMake(kXPositionPortraitPageTwo + (kXGapPositionPortrait * 2), kYPositionPortraitMiddleRow, 180, 267)];
    [[[self subviews] objectAtIndex:15] setFrame:CGRectMake(kXPositionPortraitPageTwo, kYPositionPortraitBottomRow, 180, 267)];
    [[[self subviews] objectAtIndex:16] setFrame:CGRectMake(kXPositionPortraitPageTwo + kXGapPositionPortrait, kYPositionPortraitBottomRow, 180, 267)];
    [[[self subviews] objectAtIndex:17] setFrame:CGRectMake(kXPositionPortraitPageTwo + (kXGapPositionPortrait * 2), kYPositionPortraitBottomRow, 180, 267)];

    
    // PAGE 3 - VIEW A3, B3, C3, D3, E3, F3, G3, H3, I3
    
    [[[self subviews] objectAtIndex:18] setFrame:CGRectMake(kXPositionPortraitPageThree, kYPositionPortraitTopRow, 180, 267)];
    [[[self subviews] objectAtIndex:19] setFrame:CGRectMake(kXPositionPortraitPageThree + kXGapPositionPortrait, kYPositionPortraitTopRow, 180, 267)];
    [[[self subviews] objectAtIndex:20] setFrame:CGRectMake(kXPositionPortraitPageThree + (kXGapPositionPortrait * 2), kYPositionPortraitTopRow, 180, 267)];
    [[[self subviews] objectAtIndex:21] setFrame:CGRectMake(kXPositionPortraitPageThree, kYPositionPortraitMiddleRow, 180, 267)];
    [[[self subviews] objectAtIndex:22] setFrame:CGRectMake(kXPositionPortraitPageThree + kXGapPositionPortrait, kYPositionPortraitMiddleRow, 180, 267)];
    [[[self subviews] objectAtIndex:23] setFrame:CGRectMake(kXPositionPortraitPageThree + (kXGapPositionPortrait * 2), kYPositionPortraitMiddleRow, 180, 267)];
    
    
}

/*-------------------------------------------------------------
 * Rotates image frames to landscape
 *------------------------------------------------------------*/

-(void)rotateToLandscape {
    
     self.frame = CGRectMake(0, 0, 1024 * 3, 768);
    
     // PAGE 1 - VIEW A, B, C, D, E, F, G, H
    [[[self subviews] objectAtIndex:0] setFrame:CGRectMake(kXPositionLandscapePageOne, kYPositionLandscapeTopRow, 180, 267)];
    [[[self subviews] objectAtIndex:1] setFrame:CGRectMake(kXPositionLandscapePageOne + kXGapPositionPortrait, kYPositionLandscapeTopRow, 180, 267)];
    [[[self subviews] objectAtIndex:2] setFrame:CGRectMake(kXPositionLandscapePageOne + (kXGapPositionPortrait * 2), kYPositionLandscapeTopRow, 180, 267)];
    [[[self subviews] objectAtIndex:3] setFrame:CGRectMake(kXPositionLandscapePageOne + (kXGapPositionPortrait * 3), kYPositionLandscapeTopRow, 180, 267)];
    [[[self subviews] objectAtIndex:4] setFrame:CGRectMake(kXPositionLandscapePageOne, kYPositionLandscapeBottomRow, 180, 267)];
    [[[self subviews] objectAtIndex:5] setFrame:CGRectMake(kXPositionLandscapePageOne + kXGapPositionPortrait, kYPositionLandscapeBottomRow, 180, 267)];
    [[[self subviews] objectAtIndex:6] setFrame:CGRectMake(kXPositionLandscapePageOne + (kXGapPositionPortrait * 2), kYPositionLandscapeBottomRow, 180, 267)];
    [[[self subviews] objectAtIndex:7] setFrame:CGRectMake(kXPositionLandscapePageOne + (kXGapPositionPortrait * 3), kYPositionLandscapeBottomRow, 180, 267)];
    
    
    

    // PAGE 2 - VIEW A2, B2, C2, D2, E2, F2, G2, H2
    
    
    [[[self subviews] objectAtIndex:8] setFrame:CGRectMake(kXPositionLandscapePageTwo, kYPositionLandscapeTopRow, 180, 267)];
    
    [[[self subviews] objectAtIndex:9] setFrame:CGRectMake(kXPositionLandscapePageTwo + kXGapPositionPortrait, kYPositionLandscapeTopRow, 180, 267)];
    [[[self subviews] objectAtIndex:10] setFrame:CGRectMake(kXPositionLandscapePageTwo + (kXGapPositionPortrait * 2), kYPositionLandscapeTopRow, 180, 267)];
    [[[self subviews] objectAtIndex:11] setFrame:CGRectMake(kXPositionLandscapePageTwo + (kXGapPositionPortrait * 3), kYPositionLandscapeTopRow, 180, 267)];
    
    [[[self subviews] objectAtIndex:12] setFrame:CGRectMake(kXPositionLandscapePageTwo, kYPositionLandscapeBottomRow, 180, 267)];
    [[[self subviews] objectAtIndex:13] setFrame:CGRectMake(kXPositionLandscapePageTwo + kXGapPositionPortrait , kYPositionLandscapeBottomRow, 180, 267)];
    [[[self subviews] objectAtIndex:14] setFrame:CGRectMake(kXPositionLandscapePageTwo + (kXGapPositionPortrait * 2) , kYPositionLandscapeBottomRow, 180, 267)];
    [[[self subviews] objectAtIndex:15] setFrame:CGRectMake(kXPositionLandscapePageTwo + (kXGapPositionPortrait * 3) , kYPositionLandscapeBottomRow, 180, 267)];
    
    

    // PAGE 3 - VIEW A3, B3, C3, D3, E3, F3, G3, H3, I3

    
    [[[self subviews] objectAtIndex:16] setFrame:CGRectMake(kXPositionLandscapePageThree, kYPositionLandscapeTopRow, 180, 267)];
    [[[self subviews] objectAtIndex:17] setFrame:CGRectMake(kXPositionLandscapePageThree + kXGapPositionPortrait, kYPositionLandscapeTopRow, 180, 267)];        
    [[[self subviews] objectAtIndex:18] setFrame:CGRectMake(kXPositionLandscapePageThree + (kXGapPositionPortrait * 2), kYPositionLandscapeTopRow, 180, 267)];
    [[[self subviews] objectAtIndex:19] setFrame:CGRectMake(kXPositionLandscapePageThree + (kXGapPositionPortrait * 3), kYPositionLandscapeTopRow, 180, 267)];
                                                            
    [[[self subviews] objectAtIndex:20] setFrame:CGRectMake(kXPositionLandscapePageThree , kYPositionLandscapeBottomRow, 180, 267)];
    [[[self subviews] objectAtIndex:21] setFrame:CGRectMake(kXPositionLandscapePageThree + kXGapPositionPortrait, kYPositionLandscapeBottomRow, 180, 267)];
    [[[self subviews] objectAtIndex:22] setFrame:CGRectMake(kXPositionLandscapePageThree + (kXGapPositionPortrait * 2), kYPositionLandscapeBottomRow, 180, 267)];
    [[[self subviews] objectAtIndex:23] setFrame:CGRectMake(kXPositionLandscapePageThree + (kXGapPositionPortrait * 3), kYPositionLandscapeBottomRow, 180, 267)];

    
    
    
}

#pragma mark - Touch Handling
/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
- (void)tapDetected:(UITapGestureRecognizer *)sender {
   
    CGPoint p = [sender locationOfTouch:0 inView:self];
    UIView* v = [self hitTest:p withEvent:nil];
    
    if ([v tag] == 100) {
       return;
    }
    else {
        [[self delegate] posterViewTouched:[v tag]];
    }
    
}

@end
