//
//  DPImageStyle.h
//  TheQ
//
//  Created by Daniel Pourhadi on 4/29/13.
//
//

#import <Foundation/Foundation.h>
#import "DYNViewStyle.h"
@class DYNShadowStyle;
@class DYNBackgroundStyle;
@interface DYNImageStyle : DYNViewStyle

- (UIImage *)applyToImage:(UIImage *)image;

+ (DYNImageStyle*)imageStyleForName:(NSString*)styleName;

@end
