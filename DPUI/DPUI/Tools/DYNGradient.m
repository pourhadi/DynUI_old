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
#import "DynUI.h"
#import <QuartzCore/QuartzCore.h>
@interface DYNGradient ()

@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, strong) NSArray *locations;
@property (nonatomic, strong) NSNumber *gradientAngle;

@end

@implementation DYNGradient

- (id)initWithColors:(NSArray *)colors locations:(NSArray *)locations {
    self = [super init];
    if (self) {
        self.colors = colors;
		self.locations = locations;
    }
    
    return self;
}

- (id)initWithColors:(NSArray *)colors {
    self = [super init];
    if (self) {
        self.colors = colors;
    }
    
    return self;
}

- (id)initWithDictionary:(NSDictionary*)dictionary
{
	self = [self init];
	
	if (self) {
		NSMutableArray *tmpColors = [NSMutableArray new];
		for (NSDictionary *color in [dictionary objectForKey:@"colors"]) {
			[tmpColors addObject:[[DYNColor alloc] initWithDictionary:color]];
		}
		
		self.colors = tmpColors;
		self.locations = [dictionary objectForKey:@"locations"];
		self.gradientAngle = [dictionary objectForKey:@"gradientAngle"];
		
		if ([dictionary objectForKey:@"gradientName"]) {
			self.gradientName = [dictionary objectForKey:@"gradientName"];
		}
		
		if ([dictionary objectForKey:@"gradientVariableName"]) {
			self.gradientVariableName = [dictionary objectForKey:@"gradientVariableName"];
		}
	}
	return self;
}

+ (DYNGradient*)gradientForName:(NSString *)name
{
	return [[DYNManager sharedInstance] gradientForName:name];
}

- (void)drawInPath:(UIBezierPath *)path angle:(CGFloat)angle parameters:(DYNStyleParameters *)parameters {
    [self drawInPath:path flipped:NO angle:angle parameters:parameters];
}

- (void)drawInFrame:(CGRect)frame clippedToPath:(UIBezierPath *)path angle:(CGFloat)angle flippedGradient:(BOOL)flipped parameters:(DYNStyleParameters *)parameters {
    CGRect bounds = frame;
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
        
        startPoint.x /= size.width;
        startPoint.y /= size.height;
        endPoint.x /= size.width;
        endPoint.y /= size.height;
        
        
        if (flipped) {
            CGPoint tmpStart = endPoint;
            CGPoint tmpEnd = startPoint;
            
            startPoint = tmpStart;
            endPoint = tmpEnd;
        }
        
        
        
        NSMutableArray *colors = [NSMutableArray new];
        
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
        
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.colors = colors;
        gradient.startPoint = startPoint;
        gradient.endPoint = endPoint;
		
		if (self.locations) {
			gradient.locations = self.locations;
		}
        
        gradient.frame = bounds;
        [gradient renderInContext:context];
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

- (void)drawInPath:(UIBezierPath *)path flipped:(BOOL)flipped angle:(CGFloat)angle parameters:(DYNStyleParameters *)parameters {
    [self drawInFrame:path.bounds clippedToPath:path angle:angle flippedGradient:flipped parameters:parameters];
}

// gradient angle stuff

- (CGPoint)radialIntersectionWithDegrees:(CGFloat)degrees forFrame:(CGRect)frame {
    return [self radialIntersectionWithRadians:degrees * M_PI / 180 forFrame:frame];
}

- (CGPoint)radialIntersectionWithRadians:(CGFloat)radians forFrame:(CGRect)frame {
    radians = fmodf(radians, 2 * M_PI);
    if (radians < 0) radians += (CGFloat)(2 * M_PI);
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
