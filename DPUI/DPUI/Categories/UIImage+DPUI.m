//
//  UIImage+DPStyle.m
//  TheQ
//
//  Created by Dan Pourhadi on 4/27/13.
//
//

#import "UIImage+DPUI.h"
#import "DPUIDefines.h"
#import "DPUI.h"
@implementation UIImage (DPUI)

+ (UIImage *)imageWithSize:(CGSize)size drawnWithBlock:(DPUIDrawImageBlock)block {
    UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    if (block) {
        block(c, size);
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)tintImage:(UIImage *)uiImage withColor:(CIColor *)color {
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *image = [CIImage imageWithCGImage:uiImage.CGImage];
    
    CIFilter *monochromeFilter = [CIFilter filterWithName:@"CIColorMonochrome"];
    CIImage *baseImage = image;
    
    [monochromeFilter setValue:baseImage forKey:@"inputImage"];
    [monochromeFilter setValue:[CIColor colorWithRed:0.75 green:0.75 blue:0.75] forKey:@"inputColor"];
    [monochromeFilter setValue:[NSNumber numberWithFloat:1.0] forKey:@"inputIntensity"];
    
    CIFilter *compositingFilter = [CIFilter filterWithName:@"CIMultiplyCompositing"];
    
    CIFilter *colorGenerator = [CIFilter filterWithName:@"CIConstantColorGenerator"];
    [colorGenerator setValue:color forKey:@"inputColor"];
    
    [compositingFilter setValue:[colorGenerator valueForKey:@"outputImage"] forKey:@"inputImage"];
    [compositingFilter setValue:[monochromeFilter valueForKey:@"outputImage"] forKey:@"inputBackgroundImage"];
    
    CIImage *outputImage = [compositingFilter valueForKey:@"outputImage"];
    CGImageRef outputRef = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    return [UIImage imageWithCGImage:outputRef];
}

+ (CAGradientLayer *)gradientLayerWithTop:(id)topColor bottom:(id)bottomColor frame:(CGRect)frame {
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = frame;
    layer.colors = [NSArray arrayWithObjects:
                    (id)[topColor CGColor],
                    (id)[bottomColor CGColor], nil];
    layer.startPoint = CGPointMake(0.5f, 0.0f);
    layer.endPoint = CGPointMake(0.5f, 1.0f);
    return layer;
}

+ (UIImage *)gradientImageWithTop:(id)topColor bottom:(id)bottomColor frame:(CGRect)frame {
    CAGradientLayer *layer = [self gradientLayerWithTop:topColor bottom:bottomColor frame:frame];
    UIGraphicsBeginImageContext([layer frame].size);
    
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)imageTintedWithGradientTopColor:(UIColor *)topColor bottomColor:(UIColor *)bottomColor innerShadowColor:(UIColor *)innerShadow fraction:(CGFloat)fraction {
    UIImage *image;
    UIGraphicsBeginImageContextWithOptions([self size], NO, 0.f);     // 0.f for scale means "scale for device's main screen".
    CGRect rect = CGRectZero;
    rect.size = [self size];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGGradientRef myGradient;
    CGColorSpaceRef myColorspace;
    CGFloat locations[3] = { 0.0, 0.0, 1.0 };
    CFArrayRef components = (__bridge CFArrayRef)@[(id)innerShadow.CGColor,
                                                   (id)[topColor CGColor], // Start color
                                                   (id)[bottomColor CGColor] ]; // End color
    
    myColorspace = CGColorSpaceCreateDeviceRGB();
    myGradient = CGGradientCreateWithColors(myColorspace, components, locations);
    CGSize size = self.size;
    CGContextDrawLinearGradient(context, myGradient, CGPointMake(size.width / 2, 0), CGPointMake(size.width / 2, size.height), 0);
    
    [self drawInRect:rect blendMode:kCGBlendModeDestinationIn alpha:1.0];
    if (fraction > 0.0) {
        // We want behaviour like NSCompositeSourceOver on Mac OS X.
        [self drawInRect:rect blendMode:kCGBlendModeSourceAtop alpha:fraction];
    }
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)imageTintedWithGradientTopColor:(UIColor *)topColor bottomColor:(UIColor *)bottomColor fraction:(CGFloat)fraction {
    UIImage *image;
    UIGraphicsBeginImageContextWithOptions([self size], NO, 0.f);     // 0.f for scale means "scale for device's main screen".
    CGRect rect = CGRectZero;
    rect.size = [self size];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGGradientRef myGradient;
    CGColorSpaceRef myColorspace;
    CGFloat locations[2] = { 0.0, 1.0 };
    CFArrayRef components = (__bridge CFArrayRef)@[ (id)[topColor CGColor],      // Start color
                                                    (id)[bottomColor CGColor] ];                                              // End color
    
    myColorspace = CGColorSpaceCreateDeviceRGB();
    myGradient = CGGradientCreateWithColors(myColorspace, components, locations);
    CGSize size = self.size;
    CGContextDrawLinearGradient(context, myGradient, CGPointMake(size.width / 2, 0), CGPointMake(size.width / 2, size.height), 0);
    
    [self drawInRect:rect blendMode:kCGBlendModeDestinationIn alpha:1.0];
    if (fraction > 0.0) {
        // We want behaviour like NSCompositeSourceOver on Mac OS X.
        [self drawInRect:rect blendMode:kCGBlendModeSourceAtop alpha:fraction];
    }
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageNamed:(NSString *)name withStyle:(NSString *)styleName {
    UIImage *image = [UIImage imageNamed:name];
    
    DPUIImageStyle *style = (DPUIImageStyle *)[[DPUIManager sharedInstance] styleForName:styleName];
    image = [style applyToImage:image];
    
    return image;
}

+ (CGImageRef)createMaskFromAlphaChannel:(UIImage *)image {
    size_t width = image.size.width;
    size_t height = image.size.height;
    
    NSMutableData *data = [NSMutableData dataWithLength:width * height];
    CGImageRef maskRef = image.CGImage;
    CGContextRef context = CGBitmapContextCreate(
                                                 [data mutableBytes], width, height, 8, width, NULL, kCGImageAlphaOnly);
    
    // Set the blend mode to copy to avoid any alteration of the source data
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    // Draw the image to extract the alpha channel
    CGContextDrawImage(context, CGRectMake(0.0, 0.0, width, height), image.CGImage);
    CGContextRelease(context);
    
    CGDataProviderRef dataProvider = CGDataProviderCreateWithCFData((__bridge CFMutableDataRef)data);
    
    CGImageRef maskingImage = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                                CGImageGetHeight(maskRef),
                                                8,
                                                CGImageGetBitsPerPixel(maskRef),
                                                width,
                                                CGImageGetDataProvider(maskRef), NULL, false);
    CGDataProviderRelease(dataProvider);
    
    return maskingImage;
}

- (UIImage*)imageWithBlackMasked
{
	CIFilter *filter = [CIFilter filterWithName:@"CIMaskToAlpha"];
	[filter setValue:[CIImage imageWithCGImage:self.CGImage] forKey:kCIInputImageKey];
	CIContext *context = [CIContext contextWithOptions:nil];
	CIImage *output = [filter valueForKey:kCIOutputImageKey];
	CGImageRef imageRef = [context createCGImage:output fromRect:output.extent];
	
	return [UIImage imageWithCGImage:imageRef];
}

- (UIImage*)dpui_resizableImage
{
	CGSize size = self.size;
	return [self resizableImageWithCapInsets:UIEdgeInsetsMake(size.height/2, size.width/2, (size.height/2)-1, (size.width/2)-1)];
}

- (UIImage*)imageWithOpacity:(CGFloat)opacity
{
    UIImage *img = [UIImage imageWithSize:self.size drawnWithBlock:^(CGContextRef context, CGSize size) {
        
        [self drawInRect:CGRectMake(0, 0, size.width, size.height) blendMode:kCGBlendModeNormal alpha:opacity];
        
    }];
    
    return img;
}

@end
