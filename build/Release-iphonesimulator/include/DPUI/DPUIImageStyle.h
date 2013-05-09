//
//  DPImageStyle.h
//  TheQ
//
//  Created by Daniel Pourhadi on 4/29/13.
//
//

#import <Foundation/Foundation.h>
#import "DPUIStyle.h"
@class DPUIShadowStyle;
@class DPUIBackgroundStyle;
@interface DPUIImageStyle : DPUIStyle

@property (nonatomic, strong) DPUIBackgroundStyle *overlay;

@property (nonatomic, strong) DPUIShadowStyle *innerShadow;
@property (nonatomic, strong) DPUIShadowStyle *outerShadow; // equal padding on all four sides of the image will be added to accomodate the shadow while keeping the image centered in the frame

- (UIImage *)applyToImage:(UIImage *)image;

@end
