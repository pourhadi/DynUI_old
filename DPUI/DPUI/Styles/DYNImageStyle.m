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
    DYNBackgroundStyle *background = self.background;
        
		UIImage *newImage = [UIImage imageWithSize:CGSizeMake(image.size.width, image.size.height) drawnWithBlock:^(CGContextRef context, CGSize size) {
			
			UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, size.width, size.height)];
			
			[background drawInPath:path withContext:context parameters:image.styleParameters flippedGradient:NO];
			
			[image drawInRect:CGRectMake(0, 0, size.width, size.height) blendMode:kCGBlendModeDestinationIn alpha:1.0];
		}];
	
	newImage = [UIImage imageWithSize:CGSizeMake(newImage.size.width, newImage.size.height) drawnWithBlock:^(CGContextRef context, CGSize size) {
		CGRect imageRect = CGRectMake(0, 0, size.width, size.height);

		CGContextSaveGState(context);

		CGContextTranslateCTM(context, 0.0f, size.height);
		CGContextScaleCTM(context, 1.0f, -1.0f);
		CGContextDrawImage(context, imageRect, newImage.CGImage);

		CGContextClipToMask(context, CGRectMake(0, 0, size.width, size.height), image.CGImage);
		
		DYNShadowStyle *innerShadow = self.innerShadow;
		
		if (self.innerShadow.opacity > 0) {
			CGContextSaveGState(context);

		CGContextSetShadowWithColor(context, CGSizeMake(innerShadow.offset.width, oppositeSign(innerShadow.offset.height)), innerShadow.radius, [innerShadow.color colorWithAlphaComponent:innerShadow.opacity].CGColor);
		CGImageRef mask = [UIImage createMaskFromAlphaChannel:image];
		CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), mask);
		CGImageRelease(mask);
			CGContextRestoreGState(context);
		}
		CGContextRestoreGState(context);
		
//		if (self.strokeWidth > 0) {
//			CGContextSaveGState(context);
//
//			CGContextTranslateCTM(context, 0.0f, size.height);
//			CGContextScaleCTM(context, 1.0f, -1.0f);
//			CGContextDrawImage(context, imageRect, newImage.CGImage);
//			CGContextClipToMask(context, CGRectMake(0, 0, size.width, size.height), image.CGImage);
//			CGContextSetShadowWithColor(context, CGSizeMake(0, 0), self.strokeWidth, self.strokeColor.color.CGColor);
//
//			CGImageRef mask = [UIImage createMaskFromAlphaChannel:image];
//			CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), mask);
//			CGImageRelease(mask);
//			CGContextRestoreGState(context);
//
//		}

	}];
		
	
	if (self.strokeWidth > 0) {
		CGFloat stroke = self.strokeWidth/2;
		CGRect imageRect = CGRectMake(0, 0, newImage.size.width, newImage.size.height);
		imageRect = CGRectInset(imageRect, -stroke, -stroke);
		newImage = [UIImage imageWithSize:imageRect.size drawnWithBlock:^(CGContextRef context, CGSize size) {
			
			DYNColor *DYNColor = self.strokeColor;
			UIColor *color = DYNColor.color;
			if (DYNColor.definedAtRuntime) {
				UIColor *paramColor = [image.styleParameters valueForStyleParameter:DYNColor.variableName];
				if (paramColor) {
					color = paramColor;
				}
			}
			
			[color setFill];
			UIRectFill(imageRect);
			[image drawInRect:imageRect blendMode:kCGBlendModeDestinationIn alpha:1.0];
			CGRect insetRect = CGRectMake((image.size.width-newImage.size.width)/2, (image.size.height-newImage.size.height)/2, newImage.size.width, newImage.size.height);
			[newImage drawInRect:insetRect];
		}];
	}
	
	
	if (self.shadow) {
		DYNShadowStyle *outerShadow = self.shadow;
		
		CGSize newSize = CGSizeMake(image.size.width + ((fabsf(outerShadow.radius) + fabsf(outerShadow.offset.width)) * 2), image.size.height + ((fabsf(outerShadow.radius) + fabsf(outerShadow.offset.height)) * 2));
		newImage = [UIImage imageWithSize:newSize drawnWithBlock:^(CGContextRef context, CGSize size) {
			CGContextTranslateCTM(context, 0.0f, size.height);
			CGContextScaleCTM(context, 1.0f, -1.0f);
			CGContextSetShadowWithColor(context, outerShadow.offset, outerShadow.radius, [outerShadow.color colorWithAlphaComponent:outerShadow.opacity].CGColor);
			CGContextDrawImage(context, CGRectMake(floorf((size.width - newImage.size.width) / 2), floorf((size.height - newImage.size.height) / 2), newImage.size.width, newImage.size.height), newImage.CGImage);
		}];
	}
    return newImage;
}

@end
