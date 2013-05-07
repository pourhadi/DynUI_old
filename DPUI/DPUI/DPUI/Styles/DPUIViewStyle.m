//
//  DPViewStyle.m
//  TheQ
//
//  Created by Dan Pourhadi on 4/27/13.
//
//

#import "DPUIViewStyle.h"
#import "UIImage+DPUI.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+DPUI.h"
@implementation DPUIViewStyle

- (id)init
{
	self = [super init];
	if (self) {
		self.cornerRadii = CGSizeZero;
	}
	return self;
}

- (id)initWithDictionary:(NSDictionary*)dictionary
{
	self = [super init];
	if (self) {
	self.name = [dictionary objectForKey:@"name"];
	NSDictionary *background = [dictionary objectForKey:@"background"];
	self.background = [[DPUIBackgroundStyle alloc] initWithDictionary:background];
		
		NSArray *top = [dictionary objectForKey:@"topInnerBorders"];
		NSMutableArray *tmp = [NSMutableArray new];
		for (NSDictionary *border in top) {
			[tmp addObject:[[DPUIInnerBorderStyle alloc] initWithDictionary:border]];
		}
		self.topInnerBorders = tmp;
		
		NSArray *bottom = [dictionary objectForKey:@"bottomInnerBorders"];
		tmp = [NSMutableArray new];
		for (NSDictionary *border in bottom) {
			[tmp addObject:[[DPUIInnerBorderStyle alloc] initWithDictionary:border]];
		}
		self.bottomInnerBorders = tmp;
		
		NSNumber *cornerRadius = [dictionary objectForKey:@"cornerRadius"];
		if (cornerRadius) {
			self.cornerRadii = CGSizeMake(cornerRadius.floatValue/2, cornerRadius.floatValue/2);
		}
		
		NSNumber *roundedCorners = [dictionary objectForKey:@"roundedCorners"];
		if (roundedCorners) {
			self.roundedCorners = [roundedCorners unsignedIntegerValue];
		}
		
		if ([dictionary objectForKey:@"shadow"]) {
			self.shadow = [[DPUIShadowStyle alloc] initWithDictionary:[dictionary objectForKey:@"shadow"]];
		}
		
		if ([dictionary objectForKey:@"innerShadow"]) {
			self.innerShadow = [[DPUIShadowStyle alloc] initWithDictionary:[dictionary objectForKey:@"innerShadow"]];
		}
		
		if ([dictionary objectForKey:@"canvasBackgroundColor"]) {
			self.canvasBackgroundColor = [UIColor colorFromCIString:[dictionary objectForKey:@"canvasBackgroundColor"]];
		}
		if ([dictionary objectForKey:@"tableCellTitleTextStyle"]) {
			self.tableCellTitleTextStyle = [[DPUITextStyle alloc] initWithDictionary:[dictionary objectForKey:@"tableCellTitleTextStyle"]];
		}
		if ([dictionary objectForKey:@"tableCellDetailTextStyle"]){
			self.tableCellDetailTextStyle = [[DPUITextStyle alloc] initWithDictionary:[dictionary objectForKey:@"tableCellDetailTextStyle"]];
		}
		if ([dictionary objectForKey:@"navBarTitleTextStyle"]) {
			self.navBarTitleTextStyle = [[DPUITextStyle alloc] initWithDictionary:[dictionary objectForKey:@"navBarTitleTextStyle"]];
		}
		
		if ([dictionary objectForKey:@"barButtonItemTextStyle"]) {
			self.barButtonItemTextStyle	= [[DPUITextStyle alloc] initWithDictionary:[dictionary objectForKey:@"barButtonItemTextStyle"]];
		}

	if ([dictionary objectForKey:@"barButtonItemStyleName"]) {
		self.barButtonItemStyleName = [dictionary objectForKey:@"barButtonItemStyleName"];
	}
		
	}
	return self;
}

- (void)applyStyleToView:(UIView *)view
{
	CGSize size = view.frame.size;
	
	UIBezierPath *path;
	
	if (!CGSizeEqualToSize(self.cornerRadii, CGSizeZero)) {
		path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) byRoundingCorners:self.roundedCorners cornerRadii:self.cornerRadii];
	} else {
		path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, size.width, size.height)];
	}

	UIImage *image = [self imageForStyleWithSize:size];
    
    view.layer.contents = (id)image.CGImage;
    
    if (self.shadow) {
        
        [self.shadow addShadowToView:view];
        
    }
    
    if (self.clipCorners) {
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

- (UIImage*)imageForStyleWithSize:(CGSize)size
{
	UIImage *image = [UIImage imageWithSize:size drawnWithBlock:^(CGContextRef context, CGSize size) {
		
		
		[self.canvasBackgroundColor setFill];
		UIRectFill(CGRectMake(0, 0, size.width, size.height));
		
		UIBezierPath *path;
		
		
		
		if (!CGSizeEqualToSize(self.cornerRadii, CGSizeZero)) {
			path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) byRoundingCorners:self.roundedCorners cornerRadii:self.cornerRadii];
		} else {
			path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, size.width, size.height)];
		}
        [path addClip];
        
        if (self.background.colors.count > 1) {
            CGGradientRef gradient;
            
            NSMutableArray *colors = [NSMutableArray new];
            CGColorSpaceRef myColorspace;
            myColorspace = CGColorSpaceCreateDeviceRGB();
            
            for (UIColor *color in self.background.colors) {
                [colors addObject:(id)color.CGColor];
            }
            
			NSMutableArray *locs = [NSMutableArray new];
			float div = 1 / (float)(self.background.colors.count-1);
			float current = 0;
			for (int x = 0; x < self.background.colors.count; x++) {
				[locs addObject:@(current)];
				current += div;
			}
			NSMutableArray *locations = locs;
			
            CGFloat locArray[locations.count];
            for (int x = 0; x < locations.count; x++) {
                locArray[x] = [(NSNumber*)locations[x] floatValue];
            }
            
            CFArrayRef components = (__bridge CFArrayRef)colors;
            gradient = CGGradientCreateWithColors(myColorspace, components, locArray);
            
            CGContextDrawLinearGradient(context, gradient, CGPointMake(self.background.startPoint.x*size.width, self.background.startPoint.y*size.height), CGPointMake(self.background.endPoint.x*size.width, self.background.endPoint.y*size.height), 0);
		} else {
            UIColor *fill = self.background.colors[0];
            [fill setFill];
            [path fill];
        }
        
        if (self.innerShadow) {
            //// Shadow Declarations
            UIColor* shadow = self.innerShadow.color;
            CGSize shadowOffset = self.innerShadow.offset;
            CGFloat shadowBlurRadius = self.innerShadow.radius;
            
            ////// Polygon Inner Shadow
            CGRect polygonBorderRect = CGRectInset([path bounds], -shadowBlurRadius, -shadowBlurRadius);
            polygonBorderRect = CGRectOffset(polygonBorderRect, -shadowOffset.width, -shadowOffset.height);
            polygonBorderRect = CGRectInset(CGRectUnion(polygonBorderRect, [path bounds]), -1, -1);
            
            UIBezierPath* polygonNegativePath = [UIBezierPath bezierPathWithRect: polygonBorderRect];
            [polygonNegativePath appendPath: path];
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
                [polygonNegativePath applyTransform: transform];
                [[UIColor grayColor] setFill];
                [polygonNegativePath fill];
            }
            CGContextRestoreGState(context);
			
        }
        
        CGFloat currentY = 0;
        for (int x = 0; x < self.topInnerBorders.count; x++) {
            DPUIInnerBorderStyle *innerBorder = self.topInnerBorders[x];
            CGRect border = CGRectMake(0, currentY, size.width, innerBorder.height);
            [innerBorder.color setFill];
            UIRectFill(border);
            
            currentY += innerBorder.height;
        }
        
        if (self.bottomInnerBorders.count > 0) {
            currentY = size.height;
            for (int x = 0; x < self.bottomInnerBorders.count; x++) {
                DPUIInnerBorderStyle *innerBorder = self.bottomInnerBorders[x];
                currentY -= innerBorder.height;
                CGRect border = CGRectMake(0, currentY, size.width, innerBorder.height);
                [innerBorder.color setFill];
                UIRectFill(border);
            }
        }
        
        
	}];
	return image;
}

@end
