//
//  TopMoviePosterView.m
//  Discover Movies
//
//  Created by Thomas Grant on 31/12/2011.
//  Copyright (c) 2011 Reading University. All rights reserved.
//

#import "DMTopMoviePosterViewPortrait.h"
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
    kYGapPositionPortrait = 370
    
        
}CoordinatePosition; // defines positioning of columns and rows per page

@implementation DMTopMoviePosterViewPortrait
@synthesize images;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        
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
        CGRect posterFrameA = CGRectMake(kXPositionPortraitPageOne, kYPositionPortraitTopRow, 180, 267);
        CGRect posterFrameB = CGRectMake(kXPositionPortraitPageOne + kXGapPositionPortrait, kYPositionPortraitTopRow, 180, 267);
        CGRect posterFrameC = CGRectMake(kXPositionPortraitPageOne + (kXGapPositionPortrait * 2), kYPositionPortraitTopRow, 180, 267);

        
        DMMoviePosterView *viewA = [[DMMoviePosterView alloc] initWithImage:[images objectAtIndex:0] andFrame:posterFrameA];
        DMMoviePosterView *viewB = [[DMMoviePosterView alloc] initWithImage:[images objectAtIndex:1] andFrame:posterFrameB];
        DMMoviePosterView *viewC = [[DMMoviePosterView alloc] initWithImage:[images objectAtIndex:2] andFrame:posterFrameC];
        
        
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
        
        [self addSubview:viewD3];
        [self addSubview:viewE3];
        [self addSubview:viewF3];
        
        
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
