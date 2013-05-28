//
//  UIImage+DPStyle.h
//  TheQ
//
//  Created by Dan Pourhadi on 4/27/13.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@class DYNStyleParameters;
typedef void (^DYNDrawImageBlock)(CGContextRef context, CGRect rect);

@interface UIImage (DynUI)


- (void)setValuesForStyleParameters:(NSDictionary *)valuesForParams;
- (void)setValue:(id)value forStyleParameter:(NSString *)parameterName;

@property (nonatomic, strong) DYNStyleParameters *styleParameters;

+ (UIImage*)iconImage:(NSString*)iconKey constrainedToSize:(CGSize)size withStyle:(NSString*)styleName;
+ (UIImage*)iconImage:(NSString*)iconKey forWidth:(CGFloat)width withStyle:(NSString*)styleName;
+ (UIImage*)iconImage:(NSString*)iconKey forHeight:(CGFloat)height withStyle:(NSString*)styleName;

+ (UIImage*)iconImage:(NSString *)iconKey forHeight:(CGFloat)height color:(UIColor*)color;
+ (UIImage*)iconImage:(NSString *)iconKey forWidth:(CGFloat)width color:(UIColor*)color;

+ (UIImage *)imageNamed:(NSString *)name withStyle:(NSString *)style;


+ (UIImage *)imageWithSize:(CGSize)size drawnWithBlock:(DYNDrawImageBlock)block;

+ (UIImage *)tintImage:(UIImage *)uiImage withColor:(CIColor *)color;
+ (UIImage *)tintImage:(UIImage *)uiImage withUIColor:(UIColor *)color;


+ (CAGradientLayer *)gradientLayerWithTop:(id)topColor bottom:(id)bottomColor frame:(CGRect)frame;
+ (UIImage *)gradientImageWithTop:(id)topColor bottom:(id)bottomColor frame:(CGRect)frame;

+ (CGImageRef)createMaskFromAlphaChannel:(UIImage *)image inverted:(BOOL)inverted;
+ (CGImageRef)createMaskFromAlphaChannel:(UIImage *)image; // inverted

+ (UIImage *)cropTransparencyFromImage:(UIImage *)img;
+ (UIImage *)blankOnePointImage;

- (UIImage *)imageScaledToSize:(CGSize)size cropTransparent:(BOOL)crop;
- (UIImage *)imageOverlayedWithColor:(UIColor *)color opacity:(CGFloat)opacity;
- (UIImage *)imageTintedWithGradientTopColor:(UIColor *)topColor bottomColor:(UIColor *)bottomColor fraction:(CGFloat)fraction;
- (UIImage *)imageTintedWithGradientTopColor:(UIColor *)topColor bottomColor:(UIColor *)bottomColor innerShadowColor:(UIColor *)innerShadow fraction:(CGFloat)fraction;
- (UIImage *)imageWithOpacity:(CGFloat)opacity;
- (UIImage *)imageWithBlackMasked;
- (UIImage *)dyn_resizableImage;

@end
