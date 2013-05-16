//
//  DPStyleShadow.m
//  TheQ
//
//  Created by Dan Pourhadi on 4/27/13.
//
//

#import "DYNShadowStyle.h"
#import "DYNDefines.h"
#import "DynUI.h"
@implementation DYNShadowStyle

- (id)init {
    self = [super init];
    if (self) {
        self.offset = CGSizeMake(0, 1);
        self.radius = 0;
        self.color = [UIColor blackColor];
        self.opacity = 1;
    }
    return self;
}

- (void)addShadowToView:(UIView *)view withPath:(UIBezierPath*)path {
    view.layer.shadowColor = self.color.CGColor;
    view.layer.shadowRadius = self.radius;
    view.layer.shadowOpacity = self.opacity;
    view.layer.shadowOffset = self.offset;
	view.layer.shadowPath = path.CGPath;
}

- (void)addShadowToView:(UIView *)view {
    view.layer.shadowColor = self.color.CGColor;
    view.layer.shadowRadius = self.radius;
    view.layer.shadowOpacity = self.opacity;
    view.layer.shadowOffset = self.offset;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:view.bounds];
    view.layer.shadowPath = path.CGPath;
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        CGFloat xOffset = [[dictionary objectForKey:kDYNXOffsetKey] floatValue];
        CGFloat yOffset = [[dictionary objectForKey:kDYNYOffsetKey] floatValue];
        
        self.offset = CGSizeMake(xOffset, yOffset);
        self.radius = [[dictionary objectForKey:kDYNRadiusKey] floatValue];
        self.opacity = [[dictionary objectForKey:kDYNOpacityKey] floatValue];
        CIColor *ciColor = [CIColor colorWithString:[dictionary objectForKey:kDYNColorKey]];
        self.color = [UIColor colorWithRed:ciColor.red green:ciColor.green blue:ciColor.blue alpha:ciColor.alpha];
        //self.color = [UIColor colorWithCIColor:ciColor];
    }
    return self;
}

- (UIImage*)getImageForWidth:(CGFloat)width
{
	CGFloat height = (self.radius * self.offset.height) + 100;
	
	UIImage *image = [UIImage imageWithSize:CGSizeMake(width, height) drawnWithBlock:^(CGContextRef context, CGSize size) {
		
		[[UIColor blackColor] setFill];
		UIRectFill(CGRectMake(0, 0, size.width, size.height));
		
		CGContextSetShadowWithColor(context, self.offset, self.radius, [UIColor whiteColor].CGColor);
		UIRectFill(CGRectMake(0, 0, size.width, 100));
	}];
	
	UIImage *masked = [image imageWithBlackMasked];
	image = [UIImage cropTransparencyFromImage:masked];
	image = [image imageOverlayedWithColor:self.color opacity:1];
	image = [image imageWithOpacity:self.opacity];
	return image;
}

- (void)drawAsInnerShadowInPath:(UIBezierPath*)path context:(CGContextRef)context
{
	//// Shadow Declarations
	UIColor *shadow = [self.color colorWithAlphaComponent:self.opacity];
	CGSize shadowOffset = CGSizeMake(oppositeSign(self.offset.width), oppositeSign(self.offset.height));
	CGFloat shadowBlurRadius = self.radius;
	
	////// Polygon Inner Shadow
	CGRect polygonBorderRect = CGRectInset([path bounds], -shadowBlurRadius, -shadowBlurRadius);
	polygonBorderRect = CGRectOffset(polygonBorderRect, -shadowOffset.width, -shadowOffset.height);
	polygonBorderRect = CGRectInset(CGRectUnion(polygonBorderRect, [path bounds]), -1, -1);
	
	UIBezierPath *polygonNegativePath = [UIBezierPath bezierPathWithRect:polygonBorderRect];
	[polygonNegativePath appendPath:path];
	polygonNegativePath.usesEvenOddFillRule = YES;
	
	CGContextSaveGState(context);
	{
		CGFloat xOffset = shadowOffset.width + round(polygonBorderRect.size.width);
		CGFloat yOffset = shadowOffset.height;
		CGContextSetShadowWithColor(context,
									CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)),
									shadowBlurRadius,
									shadow.CGColor);
		
		[path addClip];
		CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(polygonBorderRect.size.width), 0);
		[polygonNegativePath applyTransform:transform];
		[[UIColor grayColor] setFill];
		[polygonNegativePath fill];
	}
	CGContextRestoreGState(context);
}

- (UIImage*)applyShadowToImage:(UIImage*)image
{
	DYNShadowStyle *outerShadow = self;
	CGFloat newWidth = image.size.width + ((fabsf(outerShadow.radius) + fabsf(outerShadow.offset.width)) * 2);
	CGFloat newHeight = image.size.height + ((fabsf(outerShadow.radius) + fabsf(outerShadow.offset.height)) * 2);
	CGSize newSize = CGSizeMake(newWidth, newHeight);
	image = [UIImage imageWithSize:newSize drawnWithBlock:^(CGContextRef context, CGSize size) {
		CGContextTranslateCTM(context, 0.0f, size.height);
		CGContextScaleCTM(context, 1.0f, -1.0f);
		CGContextSetShadowWithColor(context, CGSizeMake(outerShadow.offset.width, oppositeSign(outerShadow.offset.height)), outerShadow.radius, [outerShadow.color colorWithAlphaComponent:outerShadow.opacity].CGColor);
		CGContextDrawImage(context, CGRectMake(floorf((size.width - image.size.width) / 2), floorf((size.height - image.size.height) / 2), image.size.width, image.size.height), image.CGImage);
	}];
	return image;
}

@end
