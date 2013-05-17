//
//  DPStyleBackground.m
//  TheQ
//
//  Created by Dan Pourhadi on 4/27/13.
//
//

#import "DYNBackgroundStyle.h"
#import "DYNDefines.h"
#import "DynUI.h"
#import "DYNGradient.h"
@implementation DYNBackgroundStyle

- (id)init {
    self = [super init];
    if (self) {
        self.gradientAngle = 180;
        self.locations = nil;
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        
        self.gradientAngle = [[dictionary objectForKey:kDYNGradientAngle] floatValue];
        self.locations = nil;
        NSArray *colors = [dictionary objectForKey:@"colors"];
        NSMutableArray *tmp = [NSMutableArray new];
        for (NSDictionary *color in colors) {
            DYNColor *dpColor = [[DYNColor alloc] initWithDictionary:color];
            [tmp addObject:dpColor];
        }
        
        self.colors = tmp;
    }
    return self;
}

- (NSArray*)colorArray
{
	return [self valueForKeyPath:@"colors.color"];
}

- (void)drawInFrame:(CGRect)frame clippedToPath:(UIBezierPath*)path parameters:(DYNStyleParameters*)parameters flippedGradient:(BOOL)flippedGradient
{
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSaveGState(context);
	[path addClip];
	
	if (self.colors.count > 1) {
		
		DYNGradient *gradient = [[DYNGradient alloc] initWithColors:self.colors];
		//[gradient drawInPath:path flipped:flippedGradient angle:self.gradientAngle parameters:parameters];
		[gradient drawInFrame:frame clippedToPath:path angle:self.gradientAngle flippedGradient:flippedGradient parameters:parameters];

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

- (void)drawInPath:(UIBezierPath*)path withContext:(CGContextRef)context parameters:(DYNStyleParameters*)parameters flippedGradient:(BOOL)flippedGradient
{
	[self drawInFrame:path.bounds clippedToPath:path parameters:parameters flippedGradient:flippedGradient];
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
