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
@implementation DYNBackgroundStyle

- (id)init {
    self = [super init];
    if (self) {
        self.startPoint = CGPointMake(0.5, 0);
        self.endPoint = CGPointMake(0.5, 1);
        self.locations = nil;
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.startPoint = CGPointMake(0.5, 0);
        self.endPoint = CGPointMake(0.5, 1);
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

- (void)drawInPath:(UIBezierPath*)path withContext:(CGContextRef)context parameters:(DYNStyleParameters*)parameters flippedGradient:(BOOL)flippedGradient
{
	CGRect bounds = path.bounds;
	CGSize size = bounds.size;
	
	CGContextSaveGState(context);
	[path addClip];
	
	if (self.colors.count > 1) {
		//      NSArray *theColors = self.colors;
		
		CGPoint startPoint = self.startPoint;
		CGPoint endPoint = self.endPoint;
		
		if (flippedGradient) {
			//                NSMutableArray *tmp = [NSMutableArray new];
			//                for (int x = theColors.count-1; x >= 0; x--) {
			//                    [tmp addObject:theColors[x]];
			//                }
			
			startPoint = self.endPoint;
			endPoint = self.startPoint;
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

@end
