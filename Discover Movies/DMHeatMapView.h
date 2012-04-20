//
//  DMHeatMapView.h
//  Discover Movies
//
//  Created by Thomas Grant on 28/03/2012.
//  Copyright (c) 2012 Reading University. All rights reserved.
//
//  View that presents a heat map based on cosine similarity
//  
//
//

#import <UIKit/UIKit.h>
#import "DMHeatMapSubView.h"

@interface DMHeatMapView : UIView {
    
    DMHeatMapSubView *v;
    
}
- (id)initWithData:(NSArray *)data;


@end
