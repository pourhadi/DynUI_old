//
//  UIImage+DPStyle.h
//  TheQ
//
//  Created by Dan Pourhadi on 4/27/13.
//
//

#import <UIKit/UIKit.h>
typedef void (^DPUIDrawImageBlock)(CGContextRef context, CGSize size);
@interface UIImage (DPUI)

+ (UIImage*)imageWithSize:(CGSize)size drawnWithBlock:(DPUIDrawImageBlock)block;;

+ (UIImage*)tintImage:(UIImage*)uiImage withColor:(CIColor*)color;
- (UIImage*)imageTintedWithGradientTopColor:(UIColor*)topColor bottomColor:(UIColor*)bottomColor fraction:(CGFloat)fraction;
- (UIImage*)imageTintedWithGradientTopColor:(UIColor*)topColor bottomColor:(UIColor*)bottomColor innerShadowColor:(UIColor*)innerShadow fraction:(CGFloat)fraction;

+ (CAGradientLayer*)gradientLayerWithTop:(id)topColor bottom:(id)bottomColor frame:(CGRect)frame;
+ (UIImage*)gradientImageWithTop:(id)topColor bottom:(id)bottomColor frame:(CGRect)frame;


+ (UIImage*)imageNamed:(NSString*)name withStyle:(NSString*)style;

+ (CGImageRef)createMaskFromAlphaChannel:(UIImage *)image;
@end
