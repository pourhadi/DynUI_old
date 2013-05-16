//
//  DYNGradient.m
//  DynUI-Example
//
//  Created by Daniel Pourhadi on 5/16/13.
//  Copyright (c) 2013 Dan Pourhadi. All rights reserved.
//

#import "DYNGradient.h"
#import "DYNColor.h"
#import "DYNStyleParameters.h"
@interface DYNGradient ()

@property (nonatomic, strong) NSArray *colors;

@end

@implementation DYNGradient

- (id)initWithColors:(NSArray *)colors
{
    self = [super init];
    if (self) {
        self.colors = colors;
    }
    
    return self;
}

- (void)drawInPath:(UIBezierPath *)path angle:(CGFloat)angle parameters:(DYNStyleParameters*)parameters
{
    [self drawInPath:path flipped:NO angle:angle parameters:parameters];
}

- (void)drawInPath:(UIBezierPath*)path flipped:(BOOL)flipped angle:(CGFloat)angle parameters:(DYNStyleParameters*)parameters
{
    CGRect bounds = path.bounds;
	CGSize size = bounds.size;
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSaveGState(context);
	[path addClip];
	
	if (self.colors.count > 1) {
		//      NSArray *theColors = self.colors;
		
		CGPoint startPoint;
		CGPoint endPoint;
		
        CGFloat degrees = angle - 90;
		if (degrees < 0) {
			degrees = 360 - fabs(degrees);
		}
        
        startPoint = [self radialIntersectionWithDegrees:degrees forFrame:bounds];
        
        //  endPoint = [self radialIntersectionWithDegrees:degrees];
        if (degrees >= 180) {
            endPoint.x = size.width - startPoint.x;
            endPoint.y = size.height - startPoint.y;
            
        } else {
            endPoint = [self radialIntersectionWithDegrees:degrees forFrame:bounds];
            
            startPoint.x = size.width - endPoint.x;
            startPoint.y = size.height - endPoint.y;
        }
        //
        
        
        startPoint.x /= size.width;
        startPoint.y /= size.height;
        endPoint.x /= size.width;
        endPoint.y /= size.height;
        
        //        NSLog(@"degrees: %f", self.gradientAngle);
        //        NSLog(@"startPoint: %@", NSStringFromCGPoint(startPoint));
        //        NSLog(@"endPoint: %@", NSStringFromCGPoint(endPoint));
        
		if (flipped) {
			//                NSMutableArray *tmp = [NSMutableArray new];
			//                for (int x = theColors.count-1; x >= 0; x--) {
			//                    [tmp addObject:theColors[x]];
			//                }
			
            CGPoint tmpStart = endPoint;
            CGPoint tmpEnd = startPoint;
            
            startPoint = tmpStart;
            endPoint = tmpEnd;
            
		}
		
		
		CGGradientRef gradient;
		
		NSMutableArray *colors = [NSMutableArray new];
		CGColorSpaceRef myColorspace;
		myColorspace = CGColorSpaceCreateDeviceRGB();
		
		for (DYNColor *color in self.colors) {
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
		float div = 1 / (float)(self.colors.count - 1);
		float current = 0;
		for (int x = 0; x < self.colors.count; x++) {
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
		DYNColor *DYNColor = self.colors[0];
		UIColor *color = DYNColor.color;
		if (DYNColor.definedAtRuntime) {
			UIColor *paramColor = [parameters valueForStyleParameter:DYNColor.variableName];
			if (paramColor) {
				color = paramColor;
			}
		}
		
		[color setFill];
		[path fill];
	}
    
	CGContextRestoreGState(context);

}

// gradient angle stuff

- (CGPoint)radialIntersectionWithDegrees:(CGFloat)degrees forFrame:(CGRect)frame {
    return [self radialIntersectionWithRadians:degrees * M_PI / 180 forFrame:frame];
}

- (CGPoint)radialIntersectionWithRadians:(CGFloat)radians forFrame:(CGRect)frame {
    radians = fmodf(radians, 2 * M_PI);
    if (radians < 0)
        radians += (CGFloat)(2 * M_PI);
    return [self radialIntersectionWithConstrainedRadians:radians forFrame:frame];
}

- (CGPoint)radialIntersectionWithConstrainedRadians:(CGFloat)radians forFrame:(CGRect)frame {
    // This method requires 0 <= radians < 2 * π.
    
    CGFloat xRadius = frame.size.width / 2;
    CGFloat yRadius = frame.size.height / 2;
    
    CGPoint pointRelativeToCenter;
    CGFloat tangent = tanf(radians);
    CGFloat y = xRadius * tangent;
    // An infinite line passing through the center at angle `radians`
    // intersects the right edge at Y coordinate `y` and the left edge
    // at Y coordinate `-y`.
    if (fabsf(y) <= yRadius) {
        // The line intersects the left and right edges before it intersects
        // the top and bottom edges.
        if (radians < (CGFloat)M_PI_2 || radians > (CGFloat)(M_PI + M_PI_2)) {
            // The ray at angle `radians` intersects the right edge.
            pointRelativeToCenter = CGPointMake(xRadius, y);
        } else {
            // The ray intersects the left edge.
            pointRelativeToCenter = CGPointMake(-xRadius, -y);
        }
    } else {
        // The line intersects the top and bottom edges before it intersects
        // the left and right edges.
        CGFloat x = yRadius / tangent;
        if (radians < (CGFloat)M_PI) {
            // The ray at angle `radians` intersects the bottom edge.
            pointRelativeToCenter = CGPointMake(x, yRadius);
        } else {
            // The ray intersects the top edge.
            pointRelativeToCenter = CGPointMake(-x, -yRadius);
        }
    }
    
    return CGPointMake(pointRelativeToCenter.x + CGRectGetMidX(frame),
                       pointRelativeToCenter.y + CGRectGetMidY(frame));
}

@end