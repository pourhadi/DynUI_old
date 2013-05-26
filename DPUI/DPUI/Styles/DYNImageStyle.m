//
//  DPImageStyle.m
//  TheQ
//
//  Created by Daniel Pourhadi on 4/29/13.
//
//

#import "DYNImageStyle.h"
#import "DYNDefines.h"
#import "DynUI.h"

@implementation DYNImageStyle

+ (DYNImageStyle*)imageStyleForName:(NSString*)styleName
{
	return [[DYNManager sharedInstance] imageStyleForName:styleName];
}


- (UIImage *)applyToImage:(UIImage *)image {
    DYNBackgroundStyle *background = self.background;
    
    
    CGImageRef mask = [UIImage createMaskFromAlphaChannel:image];
    CGImageRef nonInvertedMask = [UIImage createMaskFromAlphaChannel:image inverted:NO];
    
    UIImage *newImage = [UIImage imageWithSize:CGSizeMake(image.size.width, image.size.height) drawnWithBlock:^(CGContextRef context, CGRect rect) {
		CGSize size = rect.size;
        CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, size.width, size.height)];
        CGContextSaveGState(context);
        
        CGContextClipToMask(context, path.bounds, mask);
        
        [background drawInPath:path withContext:context parameters:image.styleParameters flippedGradient:NO];
        
        DYNShadowStyle *innerShadow = self.innerShadow;
        
        if (innerShadow.opacity > 0) {
            CGContextSetShadowWithColor(context, CGSizeMake(innerShadow.offset.width, oppositeSign(innerShadow.offset.height)), innerShadow.radius, [innerShadow.color colorWithAlphaComponent:innerShadow.opacity].CGColor);
            
            CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), nonInvertedMask);
        }
        CGContextRestoreGState(context);
        
        if (self.strokeWidth > 0) {
            CGContextClipToMask(context, path.bounds, mask);
            
            CGRect insetRect = CGRectInset(path.bounds, self.strokeWidth, self.strokeWidth);
            
            UIImage *scaled = [image imageScaledToSize:insetRect.size cropTransparent:NO];
            CGImageRef scaledNonInverted = [UIImage createMaskFromAlphaChannel:scaled inverted:NO];
            
            CGContextClipToMask(context, path.bounds, scaledNonInverted);
            
            DYNColor *DYNColor = self.strokeColor;
            UIColor *color = DYNColor.color;
            if (DYNColor.definedAtRuntime) {
                UIColor *paramColor = [image.styleParameters valueForStyleParameter:DYNColor.variableName];
                if (paramColor) {
                    color = paramColor;
                }
            }
            
            [color setFill];
            CGContextFillRect(context, path.bounds);
        }
    }];
    
    
    if (self.shadow && self.shadow.opacity > 0) {
        DYNShadowStyle *outerShadow = self.shadow;
        
        CGSize newSize = CGSizeMake(image.size.width + ((fabsf(outerShadow.radius) + fabsf(outerShadow.offset.width)) * 2), image.size.height + ((fabsf(outerShadow.radius) + fabsf(outerShadow.offset.height)) * 2));
        newImage = [UIImage imageWithSize:newSize drawnWithBlock:^(CGContextRef context, CGRect rect) {
			CGSize size = rect.size;
            CGContextTranslateCTM(context, 0.0f, size.height);
            CGContextScaleCTM(context, 1.0f, -1.0f);
            CGContextSetShadowWithColor(context, outerShadow.offset, outerShadow.radius, [outerShadow.color colorWithAlphaComponent:outerShadow.opacity].CGColor);
            CGContextDrawImage(context, CGRectMake(floorf((size.width - newImage.size.width) / 2), floorf((size.height - newImage.size.height) / 2), newImage.size.width, newImage.size.height), newImage.CGImage);
        }];
    }
    return newImage;
}

@end
