//
//  UIImage+DPStyle.m
//  TheQ
//
//  Created by Dan Pourhadi on 4/27/13.
//
//

#import "UIImage+DynUI.h"
#import "DYNDefines.h"
#import "DynUI.h"
#import <objc/runtime.h>
#import <stdlib.h>

#define ROUND_UP(N, S) ((((N) + (S)-1) / (S)) * (S))
@implementation UIImage (DynUI)
GET_AND_SET_BOOL(hasBeenRendered_val);

- (void)setHasBeenRendered:(BOOL)rendered
{
    [self set_hasBeenRendered_val:rendered];
}

- (BOOL)hasBeenRendered
{
    return [self hasBeenRendered_val];
}

GET_AND_SET_ASSOCIATED_OBJ(imageURL_val, nil);

- (void)setImageURL:(NSURL *)imageURL
{
    [self set_imageURL_val:imageURL];
}

- (NSURL*)imageURL
{
    return [self imageURL_val];
}

+ (UIImage*)iconImage:(NSString*)iconKey constrainedToSize:(CGSize)size withColor:(UIColor*)color
{
    UIBezierPath *iconPath = [DYNIcons iconPathForKey:iconKey fitInSize:size];
    UIImage *image = [UIImage imageWithSize:iconPath.bounds.size drawnWithBlock:^(CGContextRef context, CGRect rect) {
		CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
        CGContextSetFlatness(context, iconPath.flatness);
		[color setFill];
		[iconPath fill];
		
	}];
    return image;
}

+ (UIImage*)iconImage:(NSString*)iconKey constrainedToSize:(CGSize)size withStyle:(NSString*)styleName
{
	UIBezierPath *iconPath = [DYNIcons iconPathForKey:iconKey fitInSize:size];
	DYNImageStyle *style = [DYNImageStyle imageStyleForName:styleName];
	UIImage *image = [style imageForStyleWithSize:size path:iconPath withOuterShadow:YES flippedGradient:NO parameters:nil];

	return image;
}

+ (UIImage*)iconImage:(NSString*)iconKey forWidth:(CGFloat)width withStyle:(NSString*)styleName
{
	UIBezierPath *iconPath = [DYNIcons iconPathForKey:iconKey forWidth:width];
	DYNImageStyle *style = [DYNImageStyle imageStyleForName:styleName];
	UIImage *image = [style imageForStyleWithSize:iconPath.bounds.size path:iconPath withOuterShadow:YES flippedGradient:NO parameters:nil];
	
	return image;
}

+ (UIImage*)iconImage:(NSString*)iconKey forHeight:(CGFloat)height withStyle:(NSString*)styleName
{
    @autoreleasepool {
        
    
	UIBezierPath *iconPath = [DYNIcons iconPathForKey:iconKey forHeight:height];
	DYNImageStyle *style = [DYNImageStyle imageStyleForName:styleName];
	UIImage *image = [style imageForStyleWithSize:iconPath.bounds.size path:iconPath withOuterShadow:YES flippedGradient:NO parameters:nil];
	
	return image;
    }

}

+ (UIImage*)iconImage:(NSString *)iconKey forHeight:(CGFloat)height color:(UIColor*)color
{
    @autoreleasepool {
        
    
	UIBezierPath *iconPath = [DYNIcons iconPathForKey:iconKey forHeight:height];
	UIImage *image = [UIImage imageWithSize:iconPath.bounds.size drawnWithBlock:^(CGContextRef context, CGRect rect) {
		CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
        CGContextSetFlatness(context, iconPath.flatness);
		[color setFill];
		[iconPath fill];
		
	}];
	return image;
    }
}

+ (UIImage*)iconImage:(NSString *)iconKey forWidth:(CGFloat)width color:(UIColor*)color
{
	UIBezierPath *iconPath = [DYNIcons iconPathForKey:iconKey forWidth:width];

	UIImage *image = [UIImage imageWithSize:iconPath.bounds.size drawnWithBlock:^(CGContextRef context, CGRect rect) {
		
		[color setFill];
		[iconPath fill];
		
	}];
	return image;
}

+ (UIImage *)imageWithSize:(CGSize)size opaque:(BOOL)opaque drawnWithBlock:(DYNDrawImageBlock)block {
    UIGraphicsBeginImageContextWithOptions(size, opaque, [[UIScreen mainScreen] scale]);
    CGContextRef c = UIGraphicsGetCurrentContext();
    if (!c) {
        return nil;
    }
    
    if (block) {
        block(c, CGRectMake(0, 0, size.width, size.height));
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


+ (UIImage *)imageWithSize:(CGSize)size drawnWithBlock:(DYNDrawImageBlock)block {
    return [self imageWithSize:size opaque:NO drawnWithBlock:block];
}

+ (UIImage *)tintImage:(UIImage *)uiImage withUIColor:(UIColor *)color {
    CIColor *ciColor = [CIColor colorWithCGColor:color.CGColor];
    if (!ciColor) {
        NSLog(@"FAILLLL");
    }
    return [UIImage tintImage:uiImage withColor:ciColor];
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
    // CGImageRelease(outputRef);
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

- (UIImage *)imageOverlayedWithColor:(UIColor *)color opacity:(CGFloat)opacity {
    __weak __typeof(&*self) weakSelf = self;
    UIImage *image = [UIImage imageWithSize:weakSelf.size drawnWithBlock:^(CGContextRef context, CGRect rect) {
        

        [weakSelf drawInRect:rect];
        [[color colorWithAlphaComponent:opacity] setFill];
        UIRectFillUsingBlendMode(rect, kCGBlendModeSourceAtop);
        /*
		CGSize size = rect.size;
        [color setFill];
        UIRectFill(CGRectMake(0, 0, size.width, size.height));
        
        [weakSelf drawInRect:CGRectMake(0, 0, size.width, size.height) blendMode:kCGBlendModeDestinationIn alpha:1.0];
        if (opacity < 1) {
            [weakSelf drawInRect:CGRectMake(0, 0, size.width, size.height) blendMode:kCGBlendModeSourceAtop alpha:1 - opacity];
        }
         */
    }];
    
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
    CGColorSpaceRelease(myColorspace);
    CGGradientRelease(myGradient);
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
    CGColorSpaceRelease(myColorspace);
    CGGradientRelease(myGradient);
    return image;
}

+ (UIImage *)imageNamed:(NSString *)name withStyle:(NSString *)styleName {
    UIImage *image = [UIImage imageNamed:name];
    
    DYNImageStyle *style = (DYNImageStyle *)[[DYNManager sharedInstance] imageStyleForName:styleName];
    image = [style applyToImage:image];
    
    return image;
}

+ (CGImageRef)newMaskFromAlphaChannel:(UIImage *)image inverted:(BOOL)inverted {
    if (!image) {
        return nil;
    }
    // Original RGBA image
    CGImageRef originalMaskImage = [image CGImage];
    float width = CGImageGetWidth(originalMaskImage) * image.scale;
    float height = CGImageGetHeight(originalMaskImage) * image.scale;
    
    // Make a bitmap context that's only 1 alpha channel
    // WARNING: the bytes per row probably needs to be a multiple of 4
    int strideLength = ROUND_UP(width * 1, 4);
    unsigned char *alphaData = calloc(strideLength * height, sizeof(unsigned char));
    CGContextRef alphaOnlyContext = CGBitmapContextCreate(alphaData,
                                                          width,
                                                          height,
                                                          8,
                                                          strideLength,
                                                          NULL,
                                                          kCGImageAlphaOnly);
    
    CGContextTranslateCTM(alphaOnlyContext, 0.0f, height);
    CGContextScaleCTM(alphaOnlyContext, 1.0f, -1.0f);
    
    // Draw the RGBA image into the alpha-only context.
    CGContextDrawImage(alphaOnlyContext, CGRectMake(0, 0, width, height), originalMaskImage);
    
    if (inverted) {
        for (int y = 0; y < height; y++) {
            for (int x = 0; x < width; x++) {
                unsigned char val = alphaData[y * strideLength + x];
                val = 255 - val;
                alphaData[y * strideLength + x] = val;
            }
        }
    }
    
    CGImageRef alphaMaskImage = CGBitmapContextCreateImage(alphaOnlyContext);
    CGContextRelease(alphaOnlyContext);
    free(alphaData);
    
    // Make a mask
    CGImageRef finalMaskImage = CGImageMaskCreate(CGImageGetWidth(alphaMaskImage),
                                                  CGImageGetHeight(alphaMaskImage),
                                                  CGImageGetBitsPerComponent(alphaMaskImage),
                                                  CGImageGetBitsPerPixel(alphaMaskImage),
                                                  CGImageGetBytesPerRow(alphaMaskImage),
                                                  CGImageGetDataProvider(alphaMaskImage), NULL, false);
    
    CGImageRelease(alphaMaskImage);
    return finalMaskImage;
}

+ (CGImageRef)createMaskFromAlphaChannel:(UIImage *)image {
    return [self newMaskFromAlphaChannel:image inverted:YES];
}

+ (UIImage *)cropTransparencyFromImage:(UIImage *)img {
    CGImageRef inImage = img.CGImage;
    CFDataRef m_DataRef;
    m_DataRef = CGDataProviderCopyData(CGImageGetDataProvider(inImage));
    UInt8 *m_PixelBuf = (UInt8 *)CFDataGetBytePtr(m_DataRef);
    
    int width = img.size.width;
    int height = img.size.height;
    
    CGPoint top, left, right, bottom;
    
    BOOL breakOut = NO;
    for (int x = 0; breakOut == NO && x < width; x++) {
        for (int y = 0; y < height; y++) {
            int loc = x + (y * width);
            loc *= 4;
            if (m_PixelBuf[loc + 3] != 0) {
                left = CGPointMake(x, y);
                breakOut = YES;
                break;
            }
        }
    }
    
    breakOut = NO;
    for (int y = 0; breakOut == NO && y < height; y++) {
        for (int x = 0; x < width; x++) {
            int loc = x + (y * width);
            loc *= 4;
            if (m_PixelBuf[loc + 3] != 0) {
                top = CGPointMake(x, y);
                breakOut = YES;
                break;
            }
        }
    }
    
    breakOut = NO;
    for (int y = height - 1; breakOut == NO && y >= 0; y--) {
        for (int x = width - 1; x >= 0; x--) {
            int loc = x + (y * width);
            loc *= 4;
            if (m_PixelBuf[loc + 3] != 0) {
                bottom = CGPointMake(x, y);
                breakOut = YES;
                break;
            }
        }
    }
    
    breakOut = NO;
    for (int x = width - 1; breakOut == NO && x >= 0; x--) {
        for (int y = height - 1; y >= 0; y--) {
            int loc = x + (y * width);
            loc *= 4;
            if (m_PixelBuf[loc + 3] != 0) {
                right = CGPointMake(x, y);
                breakOut = YES;
                break;
            }
        }
    }
    
    
    CGRect cropRect = CGRectMake(left.x, top.y, right.x - left.x, bottom.y - top.y);
    
    UIGraphicsBeginImageContextWithOptions(cropRect.size,
                                           NO,
                                           0.);
    [img drawAtPoint:CGPointMake(-cropRect.origin.x, -cropRect.origin.y)
           blendMode:kCGBlendModeCopy
               alpha:1.];
    UIImage *croppedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CFRelease(m_DataRef);
    return croppedImage;
}

+ (UIImage *)blankOnePointImage {
    return [UIImage imageWithSize:CGSizeMake(1, 1) drawnWithBlock:^(CGContextRef context, CGRect rect) {
		CGSize size = rect.size;
        [[UIColor clearColor] setFill];
        UIRectFill(CGRectMake(0, 0, size.width, size.height));
    }];
}

- (UIImage *)imageWithBlackMasked {
    CIFilter *filter = [CIFilter filterWithName:@"CIMaskToAlpha"];
    [filter setValue:[CIImage imageWithCGImage:self.CGImage] forKey:kCIInputImageKey];
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *output = [filter valueForKey:kCIOutputImageKey];
    CGImageRef imageRef = [context createCGImage:output fromRect:output.extent];

    UIImage *image =[UIImage imageWithCGImage:imageRef];
    CFRelease(imageRef);
    
    return image;
}

- (UIImage *)dyn_resizableImage {
    CGSize size = self.size;
    return [self resizableImageWithCapInsets:UIEdgeInsetsMake(size.height / 2, size.width / 2, (size.height / 2) - 1, (size.width / 2) - 1)];
}

- (UIImage *)imageWithOpacity:(CGFloat)opacity {
    __weak __typeof(&*self) weakSelf = self;
    UIImage *img = [UIImage imageWithSize:self.size drawnWithBlock:^(CGContextRef context, CGRect rect) {
		CGSize size = rect.size;
        [weakSelf drawInRect:CGRectMake(0, 0, size.width, size.height) blendMode:kCGBlendModeNormal alpha:opacity];
    }];
    
    return img;
}

- (UIImage *)imageScaledToSize:(CGSize)scaledSized cropTransparent:(BOOL)crop {
    
    
    
    CGSize imageSize = (crop ? scaledSized : self.size);
    __weak __typeof(&*self) weakSelf = self;
    
  
    
    return [UIImage imageWithSize:imageSize drawnWithBlock:^(CGContextRef context, CGRect rect) {

        CGSize size = rect.size;
        
        CGContextTranslateCTM(context, 0.0f, size.height);
        CGContextScaleCTM(context, 1.0f, -1.0f);
        
        CGRect resizedRect = CGRectMake(0, 0, size.width, size.height);
        
        if (!crop) {
            resizedRect = CGRectMake((size.width - scaledSized.width) / 2, (size.height - scaledSized.height) / 2, scaledSized.width, scaledSized.height);
        }
        
        CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
        CGContextDrawImage(context, resizedRect, weakSelf.CGImage);
        
    }];
}

- (UIImage *)imageCroppedToRect:(CGRect)newRect
{
    __weak __typeof(&*self) weakSelf = self;
	UIImage *new = [UIImage imageWithSize:newRect.size drawnWithBlock:^(CGContextRef context, CGRect rect) {
		
		CGRect drawRect = CGRectMake(-newRect.origin.x, -newRect.origin.y, weakSelf.size.width, weakSelf.size.height);
		[weakSelf drawInRect:drawRect];
		
	}];
	return new;
}

- (UIImage*)scaleToFill:(CGSize)size
{
    if (!self) return nil;
    if (CGSizeEqualToSize(size, CGSizeZero)) return nil;
    UIImage *image = self;
    CGSize finalImageSize = size;
    CGImageRef sourceImageRef = image.CGImage;
    CGFloat horizontalRatio = finalImageSize.width / CGImageGetWidth(sourceImageRef);
    CGFloat verticalRatio = finalImageSize.height / CGImageGetHeight(sourceImageRef);
    CGFloat ratio = MAX(horizontalRatio, verticalRatio); //AspectFill
    CGSize aspectFillSize = CGSizeMake(CGImageGetWidth(sourceImageRef) * ratio, CGImageGetHeight(sourceImageRef) * ratio);
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 finalImageSize.width,
                                                 finalImageSize.height,
                                                 CGImageGetBitsPerComponent(sourceImageRef),
                                                 0,
                                                 CGImageGetColorSpace(sourceImageRef),
                                                 CGImageGetBitmapInfo(sourceImageRef));
    //Draw our image centered vertically and horizontally in our context.
    CGContextDrawImage(context,
                       CGRectMake((finalImageSize.width-aspectFillSize.width)/2,
                                  (finalImageSize.height-aspectFillSize.height)/2,
                                  aspectFillSize.width,
                                  aspectFillSize.height),
                       sourceImageRef);
    //Start cleaning up..
    // CGImageRelease(sourceImageRef);
    CGImageRef finalImageRef = CGBitmapContextCreateImage(context);
    UIImage *finalImage = [UIImage imageWithCGImage:finalImageRef];
    CGContextRelease(context);
    CGImageRelease(finalImageRef);
    return finalImage;
}

- (UIImage*)imageRotatedBy:(CGFloat)degrees
{
    CIContext *context = [[DYNManager sharedInstance] sharedCIContext];
    CIImage *ci_image = [CIImage imageWithCGImage:self.CGImage];
    CGAffineTransform transform = CGAffineTransformMakeRotation(degrees);
    ci_image = [ci_image imageByApplyingTransform:transform];
    CGImageRef cg_image = [context createCGImage:ci_image fromRect:ci_image.extent];
    UIImage *final = [UIImage imageWithCGImage:cg_image];
    CFRelease(cg_image);
    return final;
}

// style parameters

#pragma mark - Parameters

- (void)setStyleParameters:(DYNStyleParameters *)styleParameters {
    objc_setAssociatedObject(self, kDYNStyleParameterKey, styleParameters, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (DYNStyleParameters *)styleParameters {
    DYNStyleParameters *parameters = objc_getAssociatedObject(self, kDYNStyleParameterKey);
    if (!parameters) {
        parameters = [[DYNStyleParameters alloc] init];
        self.styleParameters = parameters;
    }
    return parameters;
}

- (void)setValuesForStyleParameters:(NSDictionary *)valuesForParams {
    __weak __typeof(&*self) weakSelf = self;
    [valuesForParams enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [weakSelf.styleParameters setValue:obj forStyleParameter:key];
    }];
}

- (void)setValue:(id)value forStyleParameter:(NSString *)parameterName {
    [self.styleParameters setValue:value forStyleParameter:parameterName];
}

@end
