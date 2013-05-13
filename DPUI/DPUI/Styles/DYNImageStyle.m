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

- (UIImage *)applyToImage:(UIImage *)image {
    DYNBackgroundStyle *background = self.overlay;
    if (background) {
        DYNShadowStyle *innerShadow = self.innerShadow;
        
        if (background.colors.count == 1) {
            if (innerShadow && innerShadow.color) {
                image = [image imageTintedWithGradientTopColor:background.colors[0] bottomColor:background.colors[0] innerShadowColor:innerShadow.color fraction:0];
            } else {
                image = [UIImage tintImage:image withColor:[UIColor uiColorToCIColor:background.colors[0]]];
            }
        } else {
            image = [UIImage imageWithSize:image.size drawnWithBlock:^(CGContextRef context, CGSize size) {
                CGGradientRef gradient;
                
                NSMutableArray *colors = [NSMutableArray new];
                NSMutableArray *locations = [background.locations mutableCopy];
                CGColorSpaceRef myColorspace;
                myColorspace = CGColorSpaceCreateDeviceRGB();
                
                for (UIColor *color in background.colors) {
                    [colors addObject:(id)color.CGColor];
                }
                
                CGFloat locArray[locations.count];
                for (int x = 0; x < locations.count; x++) {
                    locArray[x] = [(NSNumber *)locations[x] floatValue];
                }
                
                CFArrayRef components = (__bridge CFArrayRef)colors;
                gradient = CGGradientCreateWithColors(myColorspace, components, locArray);
                
                CGContextDrawLinearGradient(context, gradient, CGPointMake(floorf(size.width / 2), 0), CGPointMake(floorf(size.width / 2), size.height), 0);
                [image drawInRect:CGRectMake(0, 0, size.width, size.height) blendMode:kCGBlendModeDestinationIn alpha:1.0];
                CGContextTranslateCTM(context, 0.0f, size.height);
                CGContextScaleCTM(context, 1.0f, -1.0f);
                CGContextClipToMask(context, CGRectMake(0, 0, size.width, size.height), image.CGImage);
                
                CGContextSetShadowWithColor(context, innerShadow.offset, innerShadow.radius, innerShadow.color.CGColor);
                CGImageRef mask = [UIImage createMaskFromAlphaChannel:image];
                CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), mask);
                CGImageRelease(mask);
            }];
        }
        
        if (self.outerShadow) {
            DYNShadowStyle *outerShadow = self.outerShadow;
            
            CGSize newSize = CGSizeMake(image.size.width + ((fabsf(outerShadow.radius) + fabsf(outerShadow.offset.width)) * 2), image.size.height + ((fabsf(outerShadow.radius) + fabsf(outerShadow.offset.height)) * 2));
            image = [UIImage imageWithSize:newSize drawnWithBlock:^(CGContextRef context, CGSize size) {
                CGContextTranslateCTM(context, 0.0f, size.height);
                CGContextScaleCTM(context, 1.0f, -1.0f);
                CGContextSetShadowWithColor(context, outerShadow.offset, outerShadow.radius, [outerShadow.color colorWithAlphaComponent:outerShadow.opacity].CGColor);
                CGContextDrawImage(context, CGRectMake(floorf((size.width - image.size.width) / 2), floorf((size.height - image.size.height) / 2), image.size.width, image.size.height), image.CGImage);
            }];
        }
    }
    return image;
}

@end
