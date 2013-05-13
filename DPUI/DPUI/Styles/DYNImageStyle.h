//
//  DPImageStyle.h
//  TheQ
//
//  Created by Daniel Pourhadi on 4/29/13.
//
//

#import <Foundation/Foundation.h>
#import "DYNStyle.h"
@class DYNShadowStyle;
@class DYNBackgroundStyle;
@interface DYNImageStyle : DYNStyle

@property (nonatomic, strong) DYNBackgroundStyle *overlay;

@property (nonatomic, strong) DYNShadowStyle *innerShadow;
@property (nonatomic, strong) DYNShadowStyle *outerShadow; // equal padding on all four sides of the image will be added to accomodate the shadow while keeping the image centered in the frame

- (UIImage *)applyToImage:(UIImage *)image;

@end
