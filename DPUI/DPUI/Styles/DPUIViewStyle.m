//
//  DPViewStyle.m
//  TheQ
//
//  Created by Dan Pourhadi on 4/27/13.
//
//

#import "DPUIViewStyle.h"
#import "DPUIDefines.h"
#import "DPUI.h"
@implementation DPUIViewStyle

- (id)init {
    self = [super init];
    if (self) {
        self.cornerRadii = CGSizeZero;
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.name = [dictionary objectForKey:kDPUINameKey];
        NSDictionary *background = [dictionary objectForKey:kDPUIBackgroundKey];
        self.background = [[DPUIBackgroundStyle alloc] initWithDictionary:background];
        
        NSArray *top = [dictionary objectForKey:kDPUITopInnerBordersKey];
        NSMutableArray *tmp = [NSMutableArray new];
        for (NSDictionary *border in top) {
            [tmp addObject:[[DPUIInnerBorderStyle alloc] initWithDictionary:border]];
        }
        self.topInnerBorders = tmp;
        
        NSArray *bottom = [dictionary objectForKey:kDPUIBottomInnerBordersKey];
        tmp = [NSMutableArray new];
        for (NSDictionary *border in bottom) {
            [tmp addObject:[[DPUIInnerBorderStyle alloc] initWithDictionary:border]];
        }
        self.bottomInnerBorders = tmp;
        
        NSNumber *cornerRadius = [dictionary objectForKey:kDPUICornerRadiusKey];
        if (cornerRadius) {
            self.cornerRadii = CGSizeMake(cornerRadius.floatValue / 2, cornerRadius.floatValue / 2);
        }
        
        NSNumber *roundedCorners = [dictionary objectForKey:kDPUIRoundedCornersKey];
        if (roundedCorners) {
            self.roundedCorners = [roundedCorners unsignedIntegerValue];
        }
        
        if ([dictionary objectForKey:kDPUIShadowKey]) {
            self.shadow = [[DPUIShadowStyle alloc] initWithDictionary:[dictionary objectForKey:kDPUIShadowKey]];
        }
        
        if ([dictionary objectForKey:kDPUIInnerShadowKey]) {
            self.innerShadow = [[DPUIShadowStyle alloc] initWithDictionary:[dictionary objectForKey:kDPUIInnerShadowKey]];
        }
        
        if ([dictionary objectForKey:kDPUICanvasBackgroundColorKey]) {
            self.canvasBackgroundColor = [UIColor colorFromCIString:[dictionary objectForKey:kDPUICanvasBackgroundColorKey]];
        }
        if ([dictionary objectForKey:kDPUITablCellTitleTextStyleKey]) {
            self.tableCellTitleTextStyle = [[DPUITextStyle alloc] initWithDictionary:[dictionary objectForKey:kDPUITablCellTitleTextStyleKey]];
        }
        if ([dictionary objectForKey:kDPUITableCellDetailTextStyleKey]) {
            self.tableCellDetailTextStyle = [[DPUITextStyle alloc] initWithDictionary:[dictionary objectForKey:kDPUITableCellDetailTextStyleKey]];
        }
        if ([dictionary objectForKey:kDPUINavBarTitleTextStyle]) {
            self.navBarTitleTextStyle = [[DPUITextStyle alloc] initWithDictionary:[dictionary objectForKey:kDPUINavBarTitleTextStyle]];
        }
    
        if ([dictionary objectForKey:kDPUIBarButtonItemStyleName]) {
            self.barButtonItemStyleName = [dictionary objectForKey:kDPUIBarButtonItemStyleName];
        }
		
		if ([dictionary objectForKey:kDPUIStrokeColor]) {
			self.strokeColor = [[DPUIColor alloc] initWithDictionary:[dictionary objectForKey:kDPUIStrokeColor]];
			self.strokeWidth = [[dictionary objectForKey:kDPUIStrokeWidth] floatValue];
		}
        
        if ([dictionary objectForKey:kDPUIControlStyle]) {
            self.controlStyle = [[DPUIControlStyle alloc] initWithDictionary:[dictionary objectForKey:kDPUIControlStyle]];
        }
        if ([dictionary objectForKey:kDPUIMaskToCornersKey]) {
            self.maskToCorners = [[dictionary objectForKey:kDPUIMaskToCornersKey] boolValue];
        }
    }
    return self;
}

- (UIImage *)imageForStyleWithSize:(CGSize)size parameters:(DPUIStyleParameters *)parameters
{
   
    UIImage *image = [self imageForStyleWithSize:size withOuterShadow:NO parameters:parameters];
	return image;
}


- (UIImage *)imageForStyleWithSize:(CGSize)size withOuterShadow:(BOOL)withOuterShadow parameters:(DPUIStyleParameters *)parameters
{
    UIImage *image = [self imageForStyleWithSize:size withOuterShadow:withOuterShadow flippedGradient:NO parameters:parameters];
    return image;
}

- (UIImage *)imageForStyleWithSize:(CGSize)size withOuterShadow:(BOOL)withOuterShadow flippedGradient:(BOOL)flippedGradient parameters:(DPUIStyleParameters *)parameters
{
    UIBezierPath *path;
    if (!CGSizeEqualToSize(self.cornerRadii, CGSizeZero)) {
        path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) byRoundingCorners:self.roundedCorners cornerRadii:self.cornerRadii];
    } else {
        path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, size.width, size.height)];
    }
    
    UIImage *image = [self imageForStyleWithSize:size path:path withOuterShadow:withOuterShadow flippedGradient:flippedGradient parameters:parameters];
	return image;
}

- (void)applyStyleToView:(UIView *)view {
    CGSize size = view.frame.size;
    
    UIBezierPath *path;
    
    if (!CGSizeEqualToSize(self.cornerRadii, CGSizeZero)) {
        path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) byRoundingCorners:self.roundedCorners cornerRadii:self.cornerRadii];
    } else {
        path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, size.width, size.height)];
    }
    
    UIImage *image = [self imageForStyleWithSize:size path:path withOuterShadow:NO parameters:view.styleParameters];
    
    view.layer.contents = (id)image.CGImage;
    
    if (self.shadow) {
        [self.shadow addShadowToView:view];
    }
    
    if (self.maskToCorners) {
        UIImage *mask = [UIImage imageWithSize:size drawnWithBlock:^(CGContextRef context, CGSize size) {
            [path addClip];
            [[UIColor blackColor] setFill];
            [path fill];
        }];
        
        CALayer *layerMask = [CALayer layer];
        layerMask.frame = view.bounds;
        layerMask.contents = (id)mask.CGImage;
        view.layer.mask = layerMask;
    }
}
- (UIImage *)imageForStyleWithSize:(CGSize)size path:(UIBezierPath*)path withOuterShadow:(BOOL)withOuterShadow flippedGradient:(BOOL)flippedGradient parameters:(DPUIStyleParameters *)parameters
{
    UIImage *image = [UIImage imageWithSize:size drawnWithBlock:^(CGContextRef context, CGSize size) {
        [self.canvasBackgroundColor setFill];
        UIRectFill(CGRectMake(0, 0, size.width, size.height));
        
        //        UIBezierPath *path;
        //
        //        if (!CGSizeEqualToSize(self.cornerRadii, CGSizeZero)) {
        //            path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) byRoundingCorners:self.roundedCorners cornerRadii:self.cornerRadii];
        //        } else {
        //            path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, size.width, size.height)];
        //        }
		
		CGContextSaveGState(context);
        [path addClip];
        
        if (self.background.colors.count > 1) {
            
      //      NSArray *theColors = self.background.colors;
            
            CGPoint startPoint = self.background.startPoint;
            CGPoint endPoint = self.background.endPoint;
            
            if (flippedGradient) {
//                NSMutableArray *tmp = [NSMutableArray new];
//                for (int x = theColors.count-1; x >= 0; x--) {
//                    [tmp addObject:theColors[x]];
//                }
            
                startPoint = self.background.endPoint;
                endPoint = self.background.startPoint;
            }
            
            
            CGGradientRef gradient;
            
            NSMutableArray *colors = [NSMutableArray new];
            CGColorSpaceRef myColorspace;
            myColorspace = CGColorSpaceCreateDeviceRGB();
            
            for (DPUIColor *color in self.background.colors) {
                
                UIColor *theColor = color.color;
                if (color.definedAtRuntime) {
                    UIColor *paramColor = [parameters valueForStyleParameter:color.variableName];
                    if (paramColor) {
                        theColor = paramColor;
                    }
                }
                
                [colors addObject:(id)theColor.CGColor];
            }
            
            NSMutableArray *locs = [NSMutableArray new];
            float div = 1 / (float)(self.background.colors.count - 1);
            float current = 0;
            for (int x = 0; x < self.background.colors.count; x++) {
                [locs addObject:@(current)];
                current += div;
            }
            NSMutableArray *locations = locs;
            
            CGFloat locArray[locations.count];
            for (int x = 0; x < locations.count; x++) {
                locArray[x] = [(NSNumber *)locations[x] floatValue];
            }
            
            CFArrayRef components = (__bridge CFArrayRef)colors;
            gradient = CGGradientCreateWithColors(myColorspace, components, locArray);
            
            CGContextDrawLinearGradient(context, gradient, CGPointMake(startPoint.x * size.width, startPoint.y * size.height), CGPointMake(endPoint.x * size.width, endPoint.y * size.height), 0);
        } else {
            DPUIColor *dpuiColor = self.background.colors[0];
            UIColor *color = dpuiColor.color;
            if (dpuiColor.definedAtRuntime) {
                UIColor *paramColor = [parameters valueForStyleParameter:dpuiColor.variableName];
                if (paramColor) {
                    color = paramColor;
                }
            }
            
            [color setFill];
            [path fill];
        }
		
		
        
        if (self.innerShadow) {
            //// Shadow Declarations
            UIColor *shadow = [self.innerShadow.color colorWithAlphaComponent:self.innerShadow.opacity];
            CGSize shadowOffset = CGSizeMake(self.innerShadow.offset.width, oppositeSign(self.innerShadow.offset.height));
            CGFloat shadowBlurRadius = self.innerShadow.radius;
            
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
		
		CGContextRestoreGState(context);
        
        CGFloat currentY = 0;
        for (int x = 0; x < self.topInnerBorders.count; x++) {
            DPUIInnerBorderStyle *innerBorder = self.topInnerBorders[x];
			
            
			
			UIColor *shadow = innerBorder.color.color;
            if (innerBorder.color.definedAtRuntime) {
                UIColor *paramColor = [parameters valueForStyleParameter:innerBorder.color.variableName];
                if (paramColor) {
                    shadow = paramColor;
                }
            }
            CGSize shadowOffset = CGSizeMake(0, (innerBorder.height));
            CGFloat shadowBlurRadius = 0;
            
            ////// Polygon Inner Shadow
            CGRect polygonBorderRect = CGRectInset([path bounds], -shadowBlurRadius, -shadowBlurRadius);
            polygonBorderRect = CGRectOffset(polygonBorderRect, -shadowOffset.width, -shadowOffset.height);
            polygonBorderRect = CGRectInset(CGRectUnion(polygonBorderRect, [path bounds]), -1, -1);
            
            UIBezierPath *polygonNegativePath = [UIBezierPath bezierPathWithRect:polygonBorderRect];
            [polygonNegativePath appendPath:path];
            polygonNegativePath.usesEvenOddFillRule = YES;
            
            CGContextSaveGState(context);
            {
				CGContextSetBlendMode(context, innerBorder.blendMode);
                
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
            
            currentY += innerBorder.height;
        }
        
        if (self.bottomInnerBorders.count > 0) {
            currentY = size.height;
            for (int x = 0; x < self.bottomInnerBorders.count; x++) {
                DPUIInnerBorderStyle *innerBorder = self.bottomInnerBorders[x];
                currentY -= innerBorder.height;
                UIColor *shadow = innerBorder.color.color;
                if (innerBorder.color.definedAtRuntime) {
                    UIColor *paramColor = [parameters valueForStyleParameter:innerBorder.color.variableName];
                    if (paramColor) {
                        shadow = paramColor;
                    }
                }
                CGSize shadowOffset = CGSizeMake(0, -innerBorder.height);
				CGFloat shadowBlurRadius = 0;
				
				////// Rectangle 2 Inner Shadow
				CGRect rectangle2BorderRect = CGRectInset([path bounds], -shadowBlurRadius, -shadowBlurRadius);
				rectangle2BorderRect = CGRectOffset(rectangle2BorderRect, -shadowOffset.width, -shadowOffset.height);
				rectangle2BorderRect = CGRectInset(CGRectUnion(rectangle2BorderRect, [path bounds]), -1, -1);
				
				UIBezierPath* rectangle2NegativePath = [UIBezierPath bezierPathWithRect: rectangle2BorderRect];
				[rectangle2NegativePath appendPath: path];
				rectangle2NegativePath.usesEvenOddFillRule = YES;
				
				CGContextSaveGState(context);
				{
					CGContextSetBlendMode(context, innerBorder.blendMode);
                    
					CGFloat xOffset = shadowOffset.width + round(rectangle2BorderRect.size.width);
					CGFloat yOffset = shadowOffset.height;
					CGContextSetShadowWithColor(context,
												CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)),
												shadowBlurRadius,
												shadow.CGColor);
					
					[path addClip];
					CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(rectangle2BorderRect.size.width), 0);
					[rectangle2NegativePath applyTransform: transform];
					[[UIColor grayColor] setFill];
					[rectangle2NegativePath fill];
				}
				CGContextRestoreGState(context);
                
                
            }
        }
		
		CGContextSaveGState(context);
		[path addClip];
		[path setLineWidth:self.strokeWidth];
        
        UIColor *stroke = self.strokeColor.color;
        if (self.strokeColor.definedAtRuntime) {
            UIColor *paramColor = [parameters valueForStyleParameter:self.strokeColor.variableName];
            if (paramColor) {
                stroke = paramColor;
            }
        }
        [stroke setStroke];
		[path stroke];
		CGContextRestoreGState(context);
    }];
	
	
	if (self.shadow && withOuterShadow) {
		DPUIShadowStyle *outerShadow = self.shadow;
		
		CGSize newSize = CGSizeMake(image.size.width + ((fabsf(outerShadow.radius) + fabsf(outerShadow.offset.width)) * 2), image.size.height + ((fabsf(outerShadow.radius) + fabsf(outerShadow.offset.height)) * 2));
		image = [UIImage imageWithSize:newSize drawnWithBlock:^(CGContextRef context, CGSize size) {
			CGContextTranslateCTM(context, 0.0f, size.height);
			CGContextScaleCTM(context, 1.0f, -1.0f);
			CGContextSetShadowWithColor(context, outerShadow.offset, outerShadow.radius, [outerShadow.color colorWithAlphaComponent:outerShadow.opacity].CGColor);
			CGContextDrawImage(context, CGRectMake(floorf((size.width - image.size.width) / 2), floorf((size.height - image.size.height) / 2), image.size.width, image.size.height), image.CGImage);
		}];
	}
    
    return image;

}


- (UIImage *)imageForStyleWithSize:(CGSize)size path:(UIBezierPath*)path withOuterShadow:(BOOL)withOuterShadow parameters:(DPUIStyleParameters *)parameters {

    return [self imageForStyleWithSize:size path:path withOuterShadow:withOuterShadow flippedGradient:NO parameters:parameters];
}

@end
