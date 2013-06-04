//
//  DPViewStyle.m
//  TheQ
//
//  Created by Dan Pourhadi on 4/27/13.
//
//

#import "DYNViewStyle.h"
#import "DYNDefines.h"
#import "DynUI.h"
#import "DYNPassThroughView.h"

@implementation DYNViewStyle

- (id)init {
    self = [super init];
    if (self) {
        self.cornerRadii = CGSizeZero;
    }
    return self;
}

+ (DYNViewStyle *)styleForName:(NSString *)styleName {
    return [[DYNManager sharedInstance] styleForName:styleName];
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.name = [dictionary objectForKey:kDYNNameKey];
        NSDictionary *background = [dictionary objectForKey:kDYNBackgroundKey];
        self.background = [[DYNBackgroundStyle alloc] initWithDictionary:background];
		
        NSArray *top = [dictionary objectForKey:kDYNTopInnerBordersKey];
        NSMutableArray *tmp = [NSMutableArray new];
        for (NSDictionary *border in top) {
            [tmp addObject:[[DYNInnerBorderStyle alloc] initWithDictionary:border]];
        }
        self.topInnerBorders = tmp;
		
        NSArray *bottom = [dictionary objectForKey:kDYNBottomInnerBordersKey];
        tmp = [NSMutableArray new];
        for (NSDictionary *border in bottom) {
            [tmp addObject:[[DYNInnerBorderStyle alloc] initWithDictionary:border]];
        }
        self.bottomInnerBorders = tmp;
		
        NSArray *left = [dictionary objectForKey:kDYNLeftInnerBordersKey];
        tmp = [NSMutableArray new];
        for (NSDictionary *border in left) {
            [tmp addObject:[[DYNInnerBorderStyle alloc] initWithDictionary:border]];
        }
        self.leftInnerBorders = tmp;
		
        NSArray *right = [dictionary objectForKey:kDYNRightInnerBordersKey];
        tmp = [NSMutableArray new];
        for (NSDictionary *border in right) {
            [tmp addObject:[[DYNInnerBorderStyle alloc] initWithDictionary:border]];
        }
        self.rightInnerBorders = tmp;
		
        NSNumber *cornerRadius = [dictionary objectForKey:kDYNCornerRadiusKey];
        if (cornerRadius) {
            self.cornerRadii = CGSizeMake(cornerRadius.floatValue / 2, cornerRadius.floatValue / 2);
        }
		
        NSNumber *roundedCorners = [dictionary objectForKey:kDYNRoundedCornersKey];
        if (roundedCorners) {
            self.roundedCorners = [roundedCorners unsignedIntegerValue];
        }
		
        if ([dictionary objectForKey:kDYNShadowKey]) {
            self.shadow = [[DYNShadowStyle alloc] initWithDictionary:[dictionary objectForKey:kDYNShadowKey]];
        }
		
        if ([dictionary objectForKey:kDYNInnerShadowKey]) {
            self.innerShadow = [[DYNShadowStyle alloc] initWithDictionary:[dictionary objectForKey:kDYNInnerShadowKey]];
        }
		
        if ([dictionary objectForKey:kDYNCanvasBackgroundColorKey]) {
            self.canvasBackgroundColor = [UIColor colorFromCIString:[dictionary objectForKey:kDYNCanvasBackgroundColorKey]];
        }
        if ([dictionary objectForKey:kDYNTableCellTitleTextStyleKey]) {
            DYNTextStyle *textStyle = [DYNTextStyle textStyleForName:[dictionary objectForKey:kDYNTableCellTitleTextStyleKey]];
			self.tableCellTitleTextStyle = textStyle;
        }
        if ([dictionary objectForKey:kDYNTableCellDetailTextStyleKey]) {
           DYNTextStyle *textStyle = [DYNTextStyle textStyleForName:[dictionary objectForKey:kDYNTableCellDetailTextStyleKey]];
			self.tableCellDetailTextStyle = textStyle;
        }
		
		if ([dictionary objectForKey:kDYNTableCellSelectedStyleNameKey]) {
			self.tableCellSelectedStyleName = [dictionary objectForKey:kDYNTableCellSelectedStyleNameKey];
		}
        if ([dictionary objectForKey:kDYNNavBarTitleTextStyle]) {
			DYNTextStyle *textStyle = [DYNTextStyle textStyleForName:[dictionary objectForKey:kDYNNavBarTitleTextStyle]];
            self.navBarTitleTextStyle = textStyle;
        }
		
        if ([dictionary objectForKey:kDYNBarButtonItemStyleName]) {
            self.barButtonItemStyleName = [dictionary objectForKey:kDYNBarButtonItemStyleName];
        }
		
        if ([dictionary objectForKey:kDYNStrokeColor]) {
            self.strokeColor = [[DYNColor alloc] initWithDictionary:[dictionary objectForKey:kDYNStrokeColor]];
            self.strokeWidth = [[dictionary objectForKey:kDYNStrokeWidth] floatValue];
        }
		
        if ([dictionary objectForKey:kDYNControlStyle]) {
            self.controlStyle = [[DYNControlStyle alloc] initWithDictionary:[dictionary objectForKey:kDYNControlStyle]];
        }
        if ([dictionary objectForKey:kDYNMaskToCornersKey]) {
            self.maskToCorners = [[dictionary objectForKey:kDYNMaskToCornersKey] boolValue];
        }
		
        if ([dictionary objectForKey:kDYNDrawAsynchronouslyKey]) {
            self.drawAsynchronously = [[dictionary objectForKey:kDYNDrawAsynchronouslyKey] boolValue];
        }
		
        if ([dictionary objectForKey:kDYNCornerRadiusTypeKey]) {
            self.cornerRadiusType = [[dictionary objectForKey:kDYNCornerRadiusTypeKey] floatValue];
        }
		
        if ([dictionary objectForKey:kDYNSearchFieldStyleNameKey]) {
            self.searchFieldStyleName = [dictionary objectForKey:kDYNSearchFieldStyleNameKey];
        }
		
        if ([dictionary objectForKey:kDYNSearchFieldTextStyleNameKey]) {
            self.searchFieldTextStyleName = [dictionary objectForKey:kDYNSearchFieldTextStyleNameKey];
        }
		
        if ([dictionary objectForKey:kDYNTextFieldTextStyleNameKey]) {
            self.textFieldTextStyle = [[DYNManager sharedInstance] textStyleForName:[dictionary objectForKey:kDYNTextFieldTextStyleNameKey]];
        }
		
        if ([dictionary objectForKey:kDYNSegmentedControlStyleKey]) {
            self.segmentedControlStyle = [[DYNControlStyle alloc] initWithDictionary:[dictionary objectForKey:kDYNSegmentedControlStyleKey]];
        }
		
        if ([dictionary objectForKey:kDYNSegmentDividerWidthKey]) {
            self.segmentDividerWidth = [[dictionary objectForKey:kDYNSegmentDividerWidthKey] floatValue];
        }
		
        if ([dictionary objectForKey:kDYNSegmentDividerColorKey]) {
            self.segmentDividerColor = [[DYNColor alloc] initWithDictionary:[dictionary objectForKey:kDYNSegmentDividerColorKey]];
        }
		
        if ([dictionary objectForKey:kDYNGroupedTableTopCellKey]) {
            self.groupedTableTopCell = [dictionary objectForKey:kDYNGroupedTableTopCellKey];
        }
		
        if ([dictionary objectForKey:kDYNGroupedTableMiddleCellKey]) {
            self.groupedTableMiddleCell = [dictionary objectForKey:kDYNGroupedTableMiddleCellKey];
        }
		
        if ([dictionary objectForKey:kDYNGroupedTableBottomCellKey]) {
            self.groupedTableBottomCell = [dictionary objectForKey:kDYNGroupedTableBottomCellKey];
        }
		
        if ([dictionary objectForKey:kDYNGroupedTableSingleCellKey]) {
            self.groupedTableSingleCell = [dictionary objectForKey:kDYNGroupedTableSingleCellKey];
        }
		
		if ([dictionary objectForKey:kDYNCustomSettingsKey]) {
			
			NSMutableArray *tmpSettings = [NSMutableArray new];
			for (NSDictionary *setting in [dictionary objectForKey:kDYNCustomSettingsKey]) {
				[tmpSettings addObject:[[DYNCustomSetting alloc] initWithDictionary:setting]];
			}
			
			self.customSettings = tmpSettings;
		}
    }
    return self;
}

- (UIBezierPath *)pathForStyleForRect:(CGRect)rect {
    CGSize size = rect.size;
    UIBezierPath *path;
    if (!CGSizeEqualToSize(self.cornerRadii, CGSizeZero) || (self.roundedCorners != 0 && self.cornerRadiusType != CornerRadiusTypeCustom)) {
        CGFloat cornerRadius = self.cornerRadii.width;
		
        if (self.cornerRadiusType > 0) {
            if (self.cornerRadiusType == CornerRadiusTypeHalfHeight) {
                cornerRadius = .5 * size.height;
            } else if (self.cornerRadiusType == CornerRadiusTypeHalfWidth) {
                cornerRadius = .5 * size.width;
            }
        }
        path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(rect.origin.x, rect.origin.y, size.width, size.height) byRoundingCorners:self.roundedCorners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    } else {
        path = [UIBezierPath bezierPathWithRect:CGRectMake(rect.origin.x, rect.origin.y, size.width, size.height)];
    }
	
    return path;
}

- (UIBezierPath *)strokePathForPath:(UIBezierPath *)path {

    CGFloat xScale = 1 / path.bounds.size.width;
    CGFloat yScale = 1 / path.bounds.size.height;
	
    xScale = 1 - ((self.strokeWidth) * xScale);
    yScale = 1 - ((self.strokeWidth) * yScale);
	
    CGAffineTransform transform = CGAffineTransformMakeScale(xScale, yScale);
	
    transform = CGAffineTransformTranslate(transform, self.strokeWidth/2, self.strokeWidth/2);
	
    UIBezierPath *newPath = [path copy];
    [newPath applyTransform:transform];
    return newPath;
}

- (UIBezierPath *)strokePathForStyleForRect:(CGRect)rect {
    CGRect strokeRect = CGRectMake(rect.origin.x + (self.strokeWidth / 2), rect.origin.y + (self.strokeWidth / 2), rect.size.width - self.strokeWidth, rect.size.height - self.strokeWidth);
    return [self pathForStyleForRect:strokeRect];
}

- (UIImage *)imageForStyleWithSize:(CGSize)size parameters:(DYNStyleParameters *)parameters {
    UIImage *image = [self imageForStyleWithSize:size withOuterShadow:NO parameters:parameters];
    return image;
}

- (UIImage *)imageForStyleWithSize:(CGSize)size withOuterShadow:(BOOL)withOuterShadow parameters:(DYNStyleParameters *)parameters {
    UIImage *image = [self imageForStyleWithSize:size withOuterShadow:withOuterShadow flippedGradient:NO parameters:parameters];
    return image;
}

- (UIImage *)imageForStyleWithSize:(CGSize)size withOuterShadow:(BOOL)withOuterShadow flippedGradient:(BOOL)flippedGradient parameters:(DYNStyleParameters *)parameters {
    UIBezierPath *path = [self pathForStyleForRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *image = [self imageForStyleWithSize:size path:path withOuterShadow:withOuterShadow flippedGradient:flippedGradient parameters:parameters];
    return image;
}

- (void)applyStyleToView:(UIView *)view {
    CGSize size = view.frame.size;
	
    UIBezierPath *path = [self pathForStyleForRect:CGRectMake(0, 0, size.width, size.height)];
	
    UIImage *image = [self imageForStyleWithSize:size path:path withOuterShadow:NO parameters:view.styleParameters];
	
    view.layer.contents = (id)image.CGImage;
	
    if (self.shadow) {
        [self.shadow addShadowToView:view];
    }
	
    if (self.maskToCorners && self.cornerRadii.height != 0) {
        CALayer *layerMask = [self layerMaskForStyleWithSize:view.frame.size];
        view.layer.mask = layerMask;
		
        if (!view.dyn_overlayView) {
            DYNPassThroughView *overlay = [[DYNPassThroughView alloc] initWithFrame:view.bounds];
            view.dyn_overlayView = overlay;
        }
		
        view.dyn_overlayView.frame = view.bounds;
        UIImage *borderImage = [self borderImageForSize:view.frame.size parameters:view.styleParameters];
		view.dyn_overlayView.layer.contents = (id)borderImage.CGImage;

		
    }
}

- (UIImage *)imageForStyleWithSize:(CGSize)size path:(UIBezierPath *)path withOuterShadow:(BOOL)withOuterShadow flippedGradient:(BOOL)flippedGradient parameters:(DYNStyleParameters *)parameters {
    UIImage *image = [UIImage imageWithSize:size drawnWithBlock:^(CGContextRef context, CGRect rect) {
		CGSize size = rect.size;
        CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
        path.miterLimit = -10;
		
        [self.canvasBackgroundColor setFill];
        UIRectFill(CGRectMake(0, 0, size.width, size.height));
		
        [self.background drawInFrame:CGRectMake(0, 0, size.width, size.height) clippedToPath:path parameters:parameters flippedGradient:flippedGradient];
		
        if (self.innerShadow && self.innerShadow.opacity > 0) {
            [self.innerShadow drawAsInnerShadowInPath:path context:context];
        }
		
		
        CGFloat currentY = 0;
        for (int x = 0; x < self.topInnerBorders.count; x++) {
            DYNInnerBorderStyle *innerBorder = self.topInnerBorders[x];
			
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
            polygonNegativePath.miterLimit = -10;
			
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
                DYNInnerBorderStyle *innerBorder = self.bottomInnerBorders[x];
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
				
                UIBezierPath *rectangle2NegativePath = [UIBezierPath bezierPathWithRect:rectangle2BorderRect];
                rectangle2NegativePath.miterLimit = -10;
				
                [rectangle2NegativePath appendPath:path];
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
                    [rectangle2NegativePath applyTransform:transform];
                    [[UIColor grayColor] setFill];
                    [rectangle2NegativePath fill];
                }
                CGContextRestoreGState(context);
            }
        }
		
        if (self.leftInnerBorders.count > 0) {
            currentY = size.height;
            for (int x = 0; x < self.leftInnerBorders.count; x++) {
                DYNInnerBorderStyle *innerBorder = self.leftInnerBorders[x];
                currentY -= innerBorder.height;
                UIColor *shadow = innerBorder.color.color;
                if (innerBorder.color.definedAtRuntime) {
                    UIColor *paramColor = [parameters valueForStyleParameter:innerBorder.color.variableName];
                    if (paramColor) {
                        shadow = paramColor;
                    }
                }
                CGSize shadowOffset = CGSizeMake(innerBorder.height, 0);
                CGFloat shadowBlurRadius = 0;
				
                ////// Rectangle 2 Inner Shadow
                CGRect rectangle2BorderRect = CGRectInset([path bounds], -shadowBlurRadius, -shadowBlurRadius);
                rectangle2BorderRect = CGRectOffset(rectangle2BorderRect, -shadowOffset.width, -shadowOffset.height);
                rectangle2BorderRect = CGRectInset(CGRectUnion(rectangle2BorderRect, [path bounds]), -1, -1);
				
                UIBezierPath *rectangle2NegativePath = [UIBezierPath bezierPathWithRect:rectangle2BorderRect];
                rectangle2NegativePath.miterLimit = -10;
				
                [rectangle2NegativePath appendPath:path];
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
                    [rectangle2NegativePath applyTransform:transform];
                    [[UIColor grayColor] setFill];
                    [rectangle2NegativePath fill];
                }
                CGContextRestoreGState(context);
            }
        }
		
        if (self.rightInnerBorders.count > 0) {
            currentY = size.height;
            for (int x = 0; x < self.rightInnerBorders.count; x++) {
                DYNInnerBorderStyle *innerBorder = self.rightInnerBorders[x];
                currentY -= innerBorder.height;
                UIColor *shadow = innerBorder.color.color;
                if (innerBorder.color.definedAtRuntime) {
                    UIColor *paramColor = [parameters valueForStyleParameter:innerBorder.color.variableName];
                    if (paramColor) {
                        shadow = paramColor;
                    }
                }
                CGSize shadowOffset = CGSizeMake(-innerBorder.height, 0);
                CGFloat shadowBlurRadius = 0;
				
                ////// Rectangle 2 Inner Shadow
                CGRect rectangle2BorderRect = CGRectInset([path bounds], -shadowBlurRadius, -shadowBlurRadius);
                rectangle2BorderRect = CGRectOffset(rectangle2BorderRect, -shadowOffset.width, -shadowOffset.height);
                rectangle2BorderRect = CGRectInset(CGRectUnion(rectangle2BorderRect, [path bounds]), -1, -1);
				
                UIBezierPath *rectangle2NegativePath = [UIBezierPath bezierPathWithRect:rectangle2BorderRect];
                rectangle2NegativePath.miterLimit = -10;
				
                [rectangle2NegativePath appendPath:path];
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
                    [rectangle2NegativePath applyTransform:transform];
                    [[UIColor grayColor] setFill];
                    [rectangle2NegativePath fill];
                }
                CGContextRestoreGState(context);
            }
        }
		
        CGContextSaveGState(context);
        // [path addClip];
		
        if (self.strokeWidth > 0) {
            UIColor *stroke = self.strokeColor.color;
            if (self.strokeColor.definedAtRuntime) {
                UIColor *paramColor = [parameters valueForStyleParameter:self.strokeColor.variableName];
                if (paramColor) {
                    stroke = paramColor;
                }
            }
			
            //		UIBezierPath *strokePath = [self strokePathForStyleForRect:path.bounds];
            UIBezierPath *strokePath = [self strokePathForPath:path];
			strokePath = path;
			[strokePath addClip];
			            [strokePath setLineWidth:self.strokeWidth*2];
            [stroke setStroke];
            [strokePath stroke];
            CGContextRestoreGState(context);
        }
    }];
	
	
    if (self.shadow && withOuterShadow && self.shadow.opacity > 0) {
        DYNShadowStyle *outerShadow = self.shadow;
		
        CGSize newSize = CGSizeMake(image.size.width + ((fabsf(outerShadow.radius) + fabsf(outerShadow.offset.width)) * 2), image.size.height + ((fabsf(outerShadow.radius) + fabsf(outerShadow.offset.height)) * 2));
        image = [UIImage imageWithSize:newSize drawnWithBlock:^(CGContextRef context, CGRect rect) {
			CGSize size = rect.size;
            CGContextTranslateCTM(context, 0.0f, size.height);
            CGContextScaleCTM(context, 1.0f, -1.0f);
            CGContextSetShadowWithColor(context, outerShadow.offset, outerShadow.radius, [outerShadow.color.color colorWithAlphaComponent:outerShadow.opacity].CGColor);
            CGContextDrawImage(context, CGRectMake(floorf((size.width - image.size.width) / 2), floorf((size.height - image.size.height) / 2), image.size.width, image.size.height), image.CGImage);
        }];
    }
	
    return image;
}

- (UIImage *)imageForStyleWithSize:(CGSize)size path:(UIBezierPath *)path withOuterShadow:(BOOL)withOuterShadow parameters:(DYNStyleParameters *)parameters {
    return [self imageForStyleWithSize:size path:path withOuterShadow:withOuterShadow flippedGradient:NO parameters:parameters];
}

- (CALayer *)layerMaskForStyleWithSize:(CGSize)size {
    UIBezierPath *path = [self pathForStyleForRect:CGRectMake(0, 0, size.width, size.height)];
    CAShapeLayer *shape = [CAShapeLayer layer];
    shape.path = path.CGPath;
    shape.fillColor = [[UIColor blackColor] CGColor];
    shape.shouldRasterize = YES;
    shape.rasterizationScale = [[UIScreen mainScreen] scale];
    return shape;
}

- (CALayer *)layerMaskForStyleWithSize:(CGSize)size withOuterShadow:(BOOL)withOuterShadow
{
	if (!withOuterShadow) {
		return [self layerMaskForStyleWithSize:size];
	}
	DYNShadowStyle *outerShadow = self.shadow;

	CGSize newSize = CGSizeMake(size.width - ((fabsf(outerShadow.radius) + fabsf(outerShadow.offset.width)) * 2), size.height - ((fabsf(outerShadow.radius) + fabsf(outerShadow.offset.height)) * 2));

	
	UIImage *maskImage = [UIImage imageWithSize:size drawnWithBlock:^(CGContextRef context, CGRect rect) {
		CGSize size = rect.size;
		CGRect newRect = CGRectMake((size.width-newSize.width)/2, (size.height-newSize.height)/2, newSize.width, newSize.height);
		UIBezierPath *path = [self pathForStyleForRect:newRect];
		[[UIColor blackColor] setFill];
		[path fill];
		
	}];
	
	CALayer *layerMask = [CALayer layer];
	layerMask.frame = CGRectMake(0, 0, size.width, size.height);
	layerMask.contents = (id)maskImage.CGImage;
	return layerMask;
}

- (UIImage *)borderImageForSize:(CGSize)size parameters:(DYNStyleParameters *)parameters {
    UIBezierPath *path = [self pathForStyleForRect:CGRectMake(0, 0, size.width, size.height)];
    return [UIImage imageWithSize:size drawnWithBlock:^(CGContextRef context, CGRect rect) {
		CGSize size = rect.size;
        if (self.innerShadow && self.innerShadow.opacity > 0) {
            [self.innerShadow drawAsInnerShadowInPath:path context:context];
        }
		
		
        CGFloat currentY = 0;
        for (int x = 0; x < self.topInnerBorders.count; x++) {
            DYNInnerBorderStyle *innerBorder = self.topInnerBorders[x];
			
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
            polygonNegativePath.miterLimit = -10;
			
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
                DYNInnerBorderStyle *innerBorder = self.bottomInnerBorders[x];
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
				
                UIBezierPath *rectangle2NegativePath = [UIBezierPath bezierPathWithRect:rectangle2BorderRect];
                rectangle2NegativePath.miterLimit = -10;
				
                [rectangle2NegativePath appendPath:path];
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
                    [rectangle2NegativePath applyTransform:transform];
                    [[UIColor grayColor] setFill];
                    [rectangle2NegativePath fill];
                }
                CGContextRestoreGState(context);
            }
        }
		
        if (self.leftInnerBorders.count > 0) {
            currentY = size.height;
            for (int x = 0; x < self.leftInnerBorders.count; x++) {
                DYNInnerBorderStyle *innerBorder = self.leftInnerBorders[x];
                currentY -= innerBorder.height;
                UIColor *shadow = innerBorder.color.color;
                if (innerBorder.color.definedAtRuntime) {
                    UIColor *paramColor = [parameters valueForStyleParameter:innerBorder.color.variableName];
                    if (paramColor) {
                        shadow = paramColor;
                    }
                }
                CGSize shadowOffset = CGSizeMake(innerBorder.height, 0);
                CGFloat shadowBlurRadius = 0;
				
                ////// Rectangle 2 Inner Shadow
                CGRect rectangle2BorderRect = CGRectInset([path bounds], -shadowBlurRadius, -shadowBlurRadius);
                rectangle2BorderRect = CGRectOffset(rectangle2BorderRect, -shadowOffset.width, -shadowOffset.height);
                rectangle2BorderRect = CGRectInset(CGRectUnion(rectangle2BorderRect, [path bounds]), -1, -1);
				
                UIBezierPath *rectangle2NegativePath = [UIBezierPath bezierPathWithRect:rectangle2BorderRect];
                rectangle2NegativePath.miterLimit = -10;
				
                [rectangle2NegativePath appendPath:path];
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
                    [rectangle2NegativePath applyTransform:transform];
                    [[UIColor grayColor] setFill];
                    [rectangle2NegativePath fill];
                }
                CGContextRestoreGState(context);
            }
        }
		
        if (self.rightInnerBorders.count > 0) {
            currentY = size.height;
            for (int x = 0; x < self.rightInnerBorders.count; x++) {
                DYNInnerBorderStyle *innerBorder = self.rightInnerBorders[x];
                currentY -= innerBorder.height;
                UIColor *shadow = innerBorder.color.color;
                if (innerBorder.color.definedAtRuntime) {
                    UIColor *paramColor = [parameters valueForStyleParameter:innerBorder.color.variableName];
                    if (paramColor) {
                        shadow = paramColor;
                    }
                }
                CGSize shadowOffset = CGSizeMake(-innerBorder.height, 0);
                CGFloat shadowBlurRadius = 0;
				
                ////// Rectangle 2 Inner Shadow
                CGRect rectangle2BorderRect = CGRectInset([path bounds], -shadowBlurRadius, -shadowBlurRadius);
                rectangle2BorderRect = CGRectOffset(rectangle2BorderRect, -shadowOffset.width, -shadowOffset.height);
                rectangle2BorderRect = CGRectInset(CGRectUnion(rectangle2BorderRect, [path bounds]), -1, -1);
				
                UIBezierPath *rectangle2NegativePath = [UIBezierPath bezierPathWithRect:rectangle2BorderRect];
                rectangle2NegativePath.miterLimit = -10;
				
                [rectangle2NegativePath appendPath:path];
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
                    [rectangle2NegativePath applyTransform:transform];
                    [[UIColor grayColor] setFill];
                    [rectangle2NegativePath fill];
                }
                CGContextRestoreGState(context);
            }
        }
		
        CGContextSaveGState(context);
        // [path addClip];
		
        if (self.strokeWidth > 0) {
            UIColor *stroke = self.strokeColor.color;
            if (self.strokeColor.definedAtRuntime) {
                UIColor *paramColor = [parameters valueForStyleParameter:self.strokeColor.variableName];
                if (paramColor) {
                    stroke = paramColor;
                }
            }
			
            //		UIBezierPath *strokePath = [self strokePathForStyleForRect:path.bounds];
            UIBezierPath *strokePath = [self strokePathForPath:path];
			strokePath = path;
            [strokePath setLineWidth:self.strokeWidth*2];
            [stroke setStroke];
            [strokePath stroke];
            CGContextRestoreGState(context);
        }
    }];
}

@end
