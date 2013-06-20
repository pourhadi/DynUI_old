//
//  DYNSliderStyle.h
//  DPUI
//
//  Created by Dan Pourhadi on 5/12/13.
//  Copyright (c) 2013 Daniel Pourhadi. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DYNStyle.h"
@class DYNColor;
@class DYNShadowStyle;
@class DYNBackgroundStyle;
@class DYNViewStyle;
@interface DYNSliderStyle : DYNStyle

- (id)initWithDictionary:(NSDictionary *)dictionary;
+ (DYNSliderStyle *)sliderStyleForName:(NSString *)styleName;

/** The slider's track image stroke width. */
@property (nonatomic) CGFloat strokeWidth;

/** The slider's track image stroke color. */
@property (nonatomic, strong) DYNColor *strokeColor;

/** The slider track image's outer shadow. */
@property (nonatomic, strong) DYNShadowStyle *outerShadow;

/** The height of the slider's track image. */
@property (nonatomic) CGFloat trackHeight;

/** The height of the slider's thumb, expressed as a multiplier of the track height. The actual height of thumb is calculated as trackHeight * thumbHeight. default is 1.5 */
@property (nonatomic) CGFloat thumbHeight;

///---------------------------------------------------------------------------------------
/// @name Minimum Track Image
///---------------------------------------------------------------------------------------

/** The background style used to render the minimum track image background. */
@property (nonatomic, strong) DYNBackgroundStyle *minimumTrackBackground;

/** The background style used to render the minimum track image inner shadow. */
@property (nonatomic, strong) DYNShadowStyle *minimumTrackInnerShadow;

///---------------------------------------------------------------------------------------
/// @name Maximum Track Image
///---------------------------------------------------------------------------------------

/** The background style used to render the maximum track image background. */
@property (nonatomic, strong) DYNBackgroundStyle *maximumTrackBackground;

/** The background style used to render the maximum track image inner shadow. */
@property (nonatomic, strong) DYNShadowStyle *maximumTrackInnerShadow;

///---------------------------------------------------------------------------------------
/// @name Thumb Image
///---------------------------------------------------------------------------------------
/** The named of the DYNViewStyle object used to render the slider's thumb image. */
@property (nonatomic, strong) NSString *thumbStyleName;

///---------------------------------------------------------------------------------------
/// @name Slider Image Rendering
///---------------------------------------------------------------------------------------

/** Returns the rendered maximum track image.
 
 @param slider The UISlider that will use this image for its maximum track.
 */
- (UIImage *)maxTrackImageForSlider:(UISlider *)slider;

/** Returns the rendered minimum track image.
 
 @param slider The UISlider that will use this image for its minimum track.
 */
- (UIImage *)minTrackImageForSlider:(UISlider *)slider;

/** Returns the rendered thumb image.
 
 @param slider The UISlider that will use this image for its thumb.
 */
- (UIImage *)thumbImageForSlider:(UISlider *)slider;

@end
