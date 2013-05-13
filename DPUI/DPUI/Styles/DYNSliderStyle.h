//
//  DYNSliderStyle.h
//  DPUI
//
//  Created by Dan Pourhadi on 5/12/13.
//  Copyright (c) 2013 Daniel Pourhadi. All rights reserved.
//

#import "DYNStyle.h"
@class DYNColor;
@class DYNShadowStyle;
@class DYNBackgroundStyle;
@class DYNViewStyle;
@interface DYNSliderStyle : DYNStyle
@property (nonatomic) CGFloat strokeWidth;
@property (nonatomic, strong) DYNColor *strokeColor;
@property (nonatomic, strong) DYNShadowStyle *outerShadow;
@property (nonatomic) CGFloat trackHeight; // in points
@property (nonatomic) CGFloat thumbHeight; // multiplier value; actual height of thumb is calculated as trackHeight * thumbHeight. default is 1.5

// minimum track image

@property (nonatomic, strong) DYNBackgroundStyle *minimumTrackBackground;
@property (nonatomic, strong) DYNShadowStyle *minimumTrackInnerShadow;

// maximum track image

@property (nonatomic, strong) DYNBackgroundStyle *maximumTrackBackground;
@property (nonatomic, strong) DYNShadowStyle *maximumTrackInnerShadow;

// thumb

@property (nonatomic, strong) NSString *thumbStyleName;

- (id)initWithDictionary:(NSDictionary*)dictionary;

- (UIImage*)maxTrackImageForSlider:(UISlider*)slider;
- (UIImage*)minTrackImageForSlider:(UISlider*)slider;
- (UIImage*)thumbImageForSlider:(UISlider*)slider;

@end
