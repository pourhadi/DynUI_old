//
//  UIImage+DPStyle.h
//  TheQ
//
//  Created by Dan Pourhadi on 4/27/13.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
typedef void (^DPUIDrawImageBlock)(CGContextRef context, CGSize size);

@interface UIImage (DPUI)

+ (UIImage *)imageWithSize:(CGSize)size drawnWithBlock:(DPUIDrawImageBlock)block;

+ (UIImage *)tintImage:(UIImage *)uiImage withColor:(CIColor *)color;
+ (UIImage *)tintImage:(UIImage *)uiImage withUIColor:(UIColor *)color;


+ (CAGradientLayer *)gradientLayerWithTop:(id)topColor bottom:(id)bottomColor frame:(CGRect)frame;
+ (UIImage *)gradientImageWithTop:(id)topColor bottom:(id)bottomColor frame:(CGRect)frame;
+ (UIImage *)imageNamed:(NSString *)name withStyle:(NSString *)style;
+ (CGImageRef)createMaskFromAlphaChannel:(UIImage *)image;
+ (UIImage *)cropTransparencyFromImage:(UIImage *)img;
+ (UIImage*)blankOnePointImage;

- (UIImage *)imageOverlayedWithColor:(UIColor *)color opacity:(CGFloat)opacity;
- (UIImage *)imageTintedWithGradientTopColor:(UIColor *)topColor bottomColor:(UIColor *)bottomColor fraction:(CGFloat)fraction;
- (UIImage *)imageTintedWithGradientTopColor:(UIColor *)topColor bottomColor:(UIColor *)bottomColor innerShadowColor:(UIColor *)innerShadow fraction:(CGFloat)fraction;
- (UIImage *)imageWithOpacity:(CGFloat)opacity;
- (UIImage *)imageWithBlackMasked;
- (UIImage *)dpui_resizableImage;

@end
