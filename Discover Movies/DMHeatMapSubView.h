//
//  DMHeatMapSubView.h
//  Discover Movies
//
//  Created by Thomas Grant on 29/03/2012.
//  Copyright (c) 2012 Reading University. All rights reserved.
//
//  Instantiated by DMHeatMapView - presents coloured image and labels
//  
//
//

#import <UIKit/UIKit.h>

@interface DMHeatMapSubView : UIView {
    
    
    UILabel *cosineSimResultLbl;
    UILabel *movieNameLbl;
    UIImageView *backgroundView;
    
}

@property (nonatomic, strong) UILabel *cosineSimResultLbl;
@property (nonatomic, strong) UILabel *movieNameLbl;
@property (nonatomic, strong) UIImageView *backgroundView;


@end
